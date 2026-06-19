# voicevox_moonbit

[![CI](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml/badge.svg)](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml)

[English README](README.en.md)

[VOICEVOX Core](https://github.com/VOICEVOX/voicevox_core) を MoonBit から使うための native FFI バインディングです。

このリポジトリには以下が含まれます。

- [`voicevox_moonbit/`](voicevox_moonbit/): MoonBit パッケージ本体
- [`voicevox_moonbit/cmd/synthesize/`](voicevox_moonbit/cmd/synthesize/): WAV ファイルを生成する CLI
- [`tools/pi/`](tools/pi/): pi で VOICEVOX 読み上げを使うための拡張

VOICEVOX Core、VOICEVOX ONNX Runtime、OpenJTalk 辞書、音声モデルは同梱していません。
利用する場合は VOICEVOX Core Downloader で取得してください。

詳しくは以下を参照してください。

- MoonBit パッケージの使い方: [`voicevox_moonbit/README.mbt.md`](voicevox_moonbit/README.mbt.md)
- VOICEVOX 関連ファイルの取得: [`docs/assets.md`](docs/assets.md)
- pi 拡張の使い方: [`tools/pi/README.md`](tools/pi/README.md)
