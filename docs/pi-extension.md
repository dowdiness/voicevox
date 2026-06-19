# Pi VOICEVOX TTS extension

The optional pi extension at [`../tools/pi/voicevox-tts.ts`](../tools/pi/voicevox-tts.ts) reads assistant responses aloud by calling `cmd/synthesize` and playing the generated WAV.

It is not auto-loaded as a project-local extension. Load it explicitly when you want speech output:

```sh
pi -e tools/pi/voicevox-tts.ts
```

## Setup

1. Download compatible VOICEVOX assets as described in [assets.md](assets.md). Keep them local and out of Git.
2. Copy the example config:

   ```sh
   cp tools/pi/voicevox-tts.example.json tools/pi/voicevox-tts.json
   ```

3. Edit `tools/pi/voicevox-tts.json` and replace the absolute paths for your machine.
4. Start pi from the repository root:

   ```sh
   pi -e tools/pi/voicevox-tts.ts
   ```

5. Check status and run a test:

   ```text
   /voicevox-tts status
   /voicevox-tts test 読み上げテスト
   ```

The local `tools/pi/voicevox-tts.json` file is ignored by Git because it contains machine-specific paths.

## Config lookup order

Later entries override earlier ones:

1. Defaults from `VOICEVOX_*` environment variables
2. `~/.pi/agent/voicevox-tts.json`
3. `<repo>/tools/pi/voicevox-tts.json`

## Commands

```text
/voicevox-tts status
/voicevox-tts on
/voicevox-tts off
/voicevox-tts reload
/voicevox-tts test 読み上げテスト
```

## Example voice

The example config uses downloader `0.vvm` with:

```json
"styleId": 3
```

That is ずんだもん ノーマル. Generated voices require appropriate credit such as `VOICEVOX:ずんだもん`.
