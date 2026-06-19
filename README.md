# voicevox_moonbit

[![CI](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml/badge.svg)](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml)

MoonBit native FFI bindings for [VOICEVOX Core](https://github.com/VOICEVOX/voicevox_core).

## What you will find here

- **Published MoonBit module:** [`voicevox_moonbit/`](voicevox_moonbit/)
  Source for the `dowdiness/voicevox_moonbit` package, native C stubs, tests, generated interfaces, and the detailed package README.
- **CLI:** [`voicevox_moonbit/cmd/synthesize/`](voicevox_moonbit/cmd/synthesize/)
  A small native CLI that synthesizes text to a WAV file through VOICEVOX Core.
- **Pi extension source:** [`tools/pi/voicevox-tts.ts`](tools/pi/voicevox-tts.ts)
  Optional pi extension that reads assistant responses aloud using this package. Load it explicitly with `pi -e tools/pi/voicevox-tts.ts`.

## VOICEVOX assets

The repository does **not** vendor or redistribute VOICEVOX Core binaries, VOICEVOX ONNX Runtime, OpenJTalk dictionaries, or `.vvm` voice models. Download them yourself with the official VOICEVOX Core Downloader and only proceed after reading and accepting the relevant terms.

Linux x64 CPU example from the repository root:

```sh
mkdir -p _build/voicevox-core-download
cd _build/voicevox-core-download
curl -sSfL https://github.com/VOICEVOX/voicevox_core/releases/latest/download/download-linux-x64 -o download
chmod +x download
./download --devices cpu --only c-api onnxruntime dict models --models-pattern 0.vvm
```

The downloader prints the terms that apply to the selected artifacts. The downloaded files stay under `_build/`, which is ignored by Git. For the downloaded `0.vvm`, `styleId: 3` is ずんだもん ノーマル.

## Quick commands

Run these from the repository root:

```sh
moon -C voicevox_moonbit check --target native
moon -C voicevox_moonbit test --target native
moon -C voicevox_moonbit fmt --check
moon -C voicevox_moonbit info
```

Run the CLI help:

```sh
moon -C voicevox_moonbit run --target native cmd/synthesize -- --help
```

## Start here

Read the package guide in [`voicevox_moonbit/README.mbt.md`](voicevox_moonbit/README.mbt.md) for requirements, compatibility notes, import examples, CLI usage, integration-test setup, and pi extension setup.
