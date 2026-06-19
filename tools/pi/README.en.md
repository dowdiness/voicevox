# pi VOICEVOX speech extension

[日本語](README.md)

This is a TTS extension for reading pi output aloud with VOICEVOX.

When [`voicevox-tts.ts`](voicevox-tts.ts) is loaded, it converts pi output to a WAV file through `cmd/synthesize`, then plays it with `paplay` or `ffplay`.

## Usage

1. Download VOICEVOX Core, VOICEVOX ONNX Runtime, an OpenJTalk dictionary, and a `.vvm` voice model by following [../../docs/assets.en.md](../../docs/assets.en.md).

Do not commit downloaded files to Git.

2. Copy the example config.

```sh
cp tools/pi/voicevox-tts.example.json tools/pi/voicevox-tts.json
```

3. Edit `tools/pi/voicevox-tts.json` and replace the paths for your environment.

- `enabled`: Whether speech output is enabled. Set it to `false` to disable automatic speech.
- `projectDir`: Absolute path to the `voicevox_moonbit` directory.
- `core`: Absolute path to `libvoicevox_core.so`.
- `onnxruntime`: Absolute path to `libvoicevox_onnxruntime.so...`.
- `dict`: Absolute path to the OpenJTalk dictionary directory.
- `model`: Absolute path to the `.vvm` file.
- `styleId`: Speaker style ID.
- `maxChars`: Maximum number of characters to speak at once. Longer responses are truncated at this length.
- `stripCodeBlocks`: If `true`, Markdown code blocks are not read aloud and are replaced with a short notice.
- `playerCommands`: Candidate commands used to play the WAV file. They are tried in order. Examples: `["paplay"]`, `["ffplay", "-autoexit", "-nodisp"]`.

`tools/pi/voicevox-tts.json` contains environment-specific paths, so it is ignored by Git.

4. Start pi from the repository root.

```sh
pi -e tools/pi/voicevox-tts.ts
```

5. In pi, check whether the extension is loaded and run a speech test.

```text
/voicevox-tts status
/voicevox-tts test 読み上げテスト
```

## Config lookup order

Config files are loaded in this order. Later entries override earlier ones.

1. `VOICEVOX_*` environment variables
2. `~/.pi/agent/voicevox-tts.json`
3. `<repo>/tools/pi/voicevox-tts.json`

## Commands available in pi

```text
/voicevox-tts status
```

Shows the current config, config sources, and any missing paths.

```text
/voicevox-tts on
/voicevox-tts off
```

Enables or disables speech output.

```text
/voicevox-tts reload
```

Reloads the config file.

```text
/voicevox-tts test 読み上げテスト
```

Tests speech output with the given text.

## Example: using ずんだもん

`tools/pi/voicevox-tts.example.json` is written for downloader `0.vvm`. With that model, this setting uses ずんだもん ノーマル.

```json
"styleId": 3
```

When using generated voices, follow the terms for each voice library. When using ずんだもん, credit such as `VOICEVOX:ずんだもん` is required.
