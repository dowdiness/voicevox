# voicevox_moonbit

[![CI](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml/badge.svg)](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml)

[日本語 README](README.md)

Native FFI bindings for using [VOICEVOX Core](https://github.com/VOICEVOX/voicevox_core) from MoonBit.

This repository contains:

- [`voicevox_moonbit/`](voicevox_moonbit/): MoonBit package
- [`voicevox_moonbit/cmd/synthesize/`](voicevox_moonbit/cmd/synthesize/): CLI for generating WAV files
- [`tools/pi/`](tools/pi/): pi extension for VOICEVOX speech output

VOICEVOX Core, VOICEVOX ONNX Runtime, OpenJTalk dictionaries, and voice models are not included.
Use the VOICEVOX Core Downloader to obtain them.

See also:

- MoonBit package usage: [`voicevox_moonbit/README.en.mbt.md`](voicevox_moonbit/README.en.mbt.md)
- Getting VOICEVOX files: [`docs/assets.en.md`](docs/assets.en.md)
- pi extension usage: [`tools/pi/README.en.md`](tools/pi/README.en.md)
