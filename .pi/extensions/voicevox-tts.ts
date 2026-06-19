/**
 * VOICEVOX TTS extension for pi.
 *
 * Speaks the final assistant text after each agent run by calling this
 * repository's cmd/synthesize and then playing the generated WAV.
 *
 * Config lookup, later entries override earlier ones:
 *   1. ~/.pi/agent/voicevox-tts.json
 *   2. <cwd>/.pi/voicevox-tts.json
 *   3. VOICEVOX_* environment variables
 *
 * Commands:
 *   /voicevox-tts status
 *   /voicevox-tts on
 *   /voicevox-tts off
 *   /voicevox-tts reload
 *   /voicevox-tts test 読み上げテスト
 */

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { execFile } from "node:child_process";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { CONFIG_DIR_NAME, getAgentDir } from "@earendil-works/pi-coding-agent";

interface VoicevoxTtsConfig {
	enabled: boolean;
	projectDir: string;
	core: string;
	onnxruntime: string;
	dict: string;
	model: string;
	styleId: number;
	maxChars: number;
	stripCodeBlocks: boolean;
	playerCommands: string[][];
}

interface LoadedConfig {
	config: VoicevoxTtsConfig;
	sources: string[];
	savePath: string;
}

function defaultConfig(cwd: string): VoicevoxTtsConfig {
	return {
		enabled: true,
		projectDir: process.env.VOICEVOX_MOONBIT_PROJECT_DIR || cwd,
		core: process.env.VOICEVOX_CORE_LIB || "",
		onnxruntime: process.env.VOICEVOX_ONNXRUNTIME_LIB || "",
		dict: process.env.VOICEVOX_OPENJTALK_DICT || "",
		model: process.env.VOICEVOX_VVM || "",
		styleId: Number(process.env.VOICEVOX_STYLE_ID || 0),
		maxChars: 500,
		stripCodeBlocks: true,
		playerCommands: [["paplay"], ["ffplay", "-autoexit", "-nodisp"]],
	};
}

function globalConfigPath(): string {
	return join(getAgentDir(), "voicevox-tts.json");
}

function projectConfigPath(cwd: string): string {
	return join(cwd, CONFIG_DIR_NAME, "voicevox-tts.json");
}

function readConfigFile(path: string): Partial<VoicevoxTtsConfig> {
	return JSON.parse(readFileSync(path, "utf-8"));
}

function loadConfig(cwd: string): LoadedConfig {
	const globalPath = globalConfigPath();
	const projectPath = projectConfigPath(cwd);
	let config = defaultConfig(cwd);
	const sources: string[] = ["defaults/env"];
	let savePath = globalPath;

	if (existsSync(globalPath)) {
		config = { ...config, ...readConfigFile(globalPath) };
		sources.push(globalPath);
		savePath = globalPath;
	}
	if (existsSync(projectPath)) {
		config = { ...config, ...readConfigFile(projectPath) };
		sources.push(projectPath);
		savePath = projectPath;
	}
	return { config, sources, savePath };
}

function saveConfig(loaded: LoadedConfig): void {
	writeFileSync(loaded.savePath, `${JSON.stringify(loaded.config, null, 2)}\n`, "utf-8");
}

function execFileAsync(command: string, args: string[], options: { cwd?: string } = {}): Promise<void> {
	return new Promise((resolve, reject) => {
		execFile(command, args, { ...options, windowsHide: true }, (error, stdout, stderr) => {
			if (error) {
				const message = [String(error.message), stdout, stderr].filter(Boolean).join("\n");
				reject(new Error(message));
				return;
			}
			resolve();
		});
	});
}

function contentBlockText(block: any): string {
	if (!block || typeof block !== "object") return "";
	if (block.type === "text" && typeof block.text === "string") return block.text;
	return "";
}

function messageText(message: any): string {
	const content = message?.content;
	if (typeof content === "string") return content;
	if (Array.isArray(content)) return content.map(contentBlockText).filter(Boolean).join("\n");
	return "";
}

function latestAssistantText(messages: any[]): string {
	for (let i = messages.length - 1; i >= 0; i -= 1) {
		const message = messages[i];
		if (message?.role !== "assistant") continue;
		const text = messageText(message).trim();
		if (text) return text;
	}
	return "";
}

function prepareSpeechText(text: string, config: VoicevoxTtsConfig): string {
	let out = text;
	if (config.stripCodeBlocks) {
		out = out.replace(/```[\s\S]*?```/g, "コードブロックを省略します。 ");
	}
	out = out
		.replace(/`([^`]+)`/g, "$1")
		.replace(/https?:\/\/\S+/g, "URL")
		.replace(/\s+/g, " ")
		.trim();
	if (out.length > config.maxChars) {
		out = `${out.slice(0, config.maxChars)}。以下省略します。`;
	}
	return out;
}

function validateConfig(config: VoicevoxTtsConfig): string[] {
	const missing: string[] = [];
	for (const [label, path] of [
		["projectDir", config.projectDir],
		["core", config.core],
		["onnxruntime", config.onnxruntime],
		["dict", config.dict],
		["model", config.model],
	] as const) {
		if (!path || !existsSync(path)) missing.push(`${label}: ${path || "<unset>"}`);
	}
	return missing;
}

async function synthesize(config: VoicevoxTtsConfig, text: string): Promise<string> {
	const out = join(tmpdir(), `pi-voicevox-${process.pid}-${Date.now()}.wav`);
	await execFileAsync(
		"moon",
		[
			"run",
			"--target",
			"native",
			"cmd/synthesize",
			"--",
			"--core",
			config.core,
			"--onnxruntime",
			config.onnxruntime,
			"--dict",
			config.dict,
			"--model",
			config.model,
			"--style-id",
			String(config.styleId),
			"--text",
			text,
			"--out",
			out,
		],
		{ cwd: config.projectDir },
	);
	return out;
}

async function play(config: VoicevoxTtsConfig, wavPath: string): Promise<void> {
	let lastError: unknown;
	for (const [command, ...args] of config.playerCommands) {
		try {
			await execFileAsync(command, [...args, wavPath]);
			return;
		} catch (error) {
			lastError = error;
		}
	}
	throw lastError instanceof Error ? lastError : new Error(String(lastError));
}

export default function voicevoxTtsExtension(pi: ExtensionAPI) {
	let loaded: LoadedConfig | undefined;
	let queue: Promise<void> = Promise.resolve();

	function getLoaded(ctx: ExtensionContext): LoadedConfig {
		if (!loaded) loaded = loadConfig(ctx.cwd);
		return loaded;
	}

	async function speak(rawText: string, ctx: ExtensionContext): Promise<void> {
		const current = getLoaded(ctx);
		const text = prepareSpeechText(rawText, current.config);
		if (!current.config.enabled || !text) return;
		const missing = validateConfig(current.config);
		if (missing.length > 0) {
			ctx.ui.notify(`VOICEVOX TTS config has missing paths. See /voicevox-tts status`, "warning");
			return;
		}
		const wav = await synthesize(current.config, text);
		await play(current.config, wav);
	}

	pi.registerCommand("voicevox-tts", {
		description: "Control VOICEVOX speech output for assistant responses",
		getArgumentCompletions: (prefix) => {
			const commands = ["status", "on", "off", "reload", "test"];
			return commands.filter((name) => name.startsWith(prefix)).map((value) => ({ value, label: value }));
		},
		handler: async (args, ctx) => {
			if (!loaded) loaded = loadConfig(ctx.cwd);
			const [subcommand, ...rest] = args.trim().split(/\s+/).filter(Boolean);
			switch (subcommand || "status") {
				case "on":
					loaded.config.enabled = true;
					saveConfig(loaded);
					ctx.ui.notify("VOICEVOX TTS enabled", "info");
					return;
				case "off":
					loaded.config.enabled = false;
					saveConfig(loaded);
					ctx.ui.notify("VOICEVOX TTS disabled", "info");
					return;
				case "reload":
					loaded = loadConfig(ctx.cwd);
					ctx.ui.notify(`VOICEVOX TTS config reloaded from ${loaded.sources.join(", ")}`, "info");
					return;
				case "test": {
					const text = rest.join(" ") || "VOICEVOX の読み上げテストです。";
					await speak(text, ctx);
					return;
				}
				case "status": {
					const missing = validateConfig(loaded.config);
					ctx.ui.notify(
						[
							`VOICEVOX TTS: ${loaded.config.enabled ? "enabled" : "disabled"}`,
							`sources: ${loaded.sources.join(", ")}`,
							`savePath: ${loaded.savePath}`,
							`styleId: ${loaded.config.styleId}`,
							missing.length ? `missing:\n${missing.join("\n")}` : "paths: ok",
						].join("\n"),
						missing.length ? "warning" : "info",
					);
					return;
				}
				default:
					ctx.ui.notify("Usage: /voicevox-tts [status|on|off|reload|test <text>]", "warning");
			}
		},
	});

	pi.on("agent_end", async (event, ctx) => {
		const text = latestAssistantText((event as any).messages ?? []);
		if (!text) return;
		const current = getLoaded(ctx);
		if (!current.config.enabled) return;
		queue = queue
			.catch(() => undefined)
			.then(() => speak(text, ctx))
			.catch((error) => {
				ctx.ui.notify(`VOICEVOX TTS failed: ${error instanceof Error ? error.message : String(error)}`, "warning");
			});
		await queue;
	});
}
