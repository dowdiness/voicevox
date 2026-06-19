# dowdiness/voicevox_moonbit

[![CI](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml/badge.svg)](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml)

[VOICEVOX Core](https://github.com/VOICEVOX/voicevox_core) 向けの MoonBit の native FFI バインディングです。

[English](README.en.mbt.md)

このパッケージは MoonBit の `native` backend 向けです。実行時に `libvoicevox_core` を動的ロードするため、MoonBit パッケージのビルド時には VOICEVOX Core のヘッダーやリンク時ライブラリは不要です。実際に音声合成を行うには、互換性のある VOICEVOX Core、VOICEVOX ONNX Runtime、OpenJTalk 辞書、`.vvm` 音声モデルが必要です。

## 必要なもの

- MoonBit toolchain
- VOICEVOX Core C API の共有ライブラリ
- VOICEVOX 対応 ONNX Runtime の共有ライブラリ
- OpenJTalk 辞書ディレクトリ
- VOICEVOX `.vvm` 音声モデルファイル

必要な VOICEVOX 関連ファイルは、公式の VOICEVOX Core Downloader で揃えてください。詳しくは [../docs/assets.md](../docs/assets.md) を参照してください。このリポジトリでは、VOICEVOX のバイナリ、辞書、音声モデルを同梱・再配布しません。

## 互換性

- MoonBit target は `native` のみです。
- 主に Linux でテストしています。
- native stub には Linux/Unix、macOS、Windows 向けの動的ロード処理があります。ただし、macOS と Windows は実際の動作確認はしていません。
- この bindings は、現在の `voicevox_synthesizer_*`、`voicevox_voice_model_file_*`、`voicevox_open_jtalk_rc_*`、`voicevox_json_free`、`voicevox_wav_free` などの C API symbol を想定しています。
- `libvoicevox_core` が `voicevox_onnxruntime_load_once` を export していない場合は、動的 ONNX Runtime loading が有効な VOICEVOX Core C API build を使ってください。

## ライブラリの例

```mbt nocheck
///|
import {
  "dowdiness/voicevox_moonbit" @voicevox,
}

///|
fn synthesize() -> Unit raise {
  let core = @voicevox.Core::load("./libvoicevox_core.so")
  let ort = core.load_onnxruntime(
    filename="./libvoicevox_onnxruntime.so.1.17.3",
  )
  let open_jtalk = @voicevox.OpenJtalk(core, "./open_jtalk_dic_utf_8-1.11")
  let model = @voicevox.VoiceModelFile::open(core, "./0.vvm")
  let synth = @voicevox.Synthesizer(core, ort, open_jtalk)
  synth.load_voice_model(model)
  let wav = synth.tts("こんにちは", 3)
  @voicevox.write_wav_file("out.wav", wav)
}
```

デフォルト値を変更したい場合は option constructor を使います。

```mbt nocheck
///|
let options = @voicevox.InitializeOptions(
  acceleration_mode=Gpu,
  cpu_num_threads=2,
)

///|
let synth = @voicevox.Synthesizer(core, ort, open_jtalk, options~)
```

## CLI

`cmd/synthesize` に小さな CLI があります。

```sh
moon run --target native cmd/synthesize -- \
  --core ../_build/voicevox-core-download/voicevox_core/c_api/lib/libvoicevox_core.so \
  --onnxruntime ../_build/voicevox-core-download/voicevox_core/onnxruntime/lib/libvoicevox_onnxruntime.so.1.17.3 \
  --dict ../_build/voicevox-core-download/voicevox_core/dict/open_jtalk_dic_utf_8-1.11 \
  --model ../_build/voicevox-core-download/voicevox_core/models/vvms/0.vvm \
  --style-id 3 \
  --text 'こんにちは' \
  --out out.wav
```

利用できる option は CLI の help で確認できます。

```sh
moon run --target native cmd/synthesize -- --help
```

## pi extension

pi extension が [`../tools/pi/voicevox-tts.ts`](../tools/pi/voicevox-tts.ts) にあります。使う場合は下記のコマンドで読み込んでください。

```sh
pi -e tools/pi/voicevox-tts.ts
```

設定とコマンドについては [../tools/pi/README.md](../tools/pi/README.md) を参照してください。

## テスト

実際の VOICEVOX 関連ファイルを必要としない unit test は次のコマンドで実行できます。

```sh
moon test --target native
```

ローカルにダウンロードした VOICEVOX 関連ファイルを使って実際の音声合成テストを行う場合は、次の環境変数を設定します。

```sh
VOICEVOX_CORE_LIB=../_build/voicevox-core-download/voicevox_core/c_api/lib/libvoicevox_core.so \
VOICEVOX_ONNXRUNTIME_LIB=../_build/voicevox-core-download/voicevox_core/onnxruntime/lib/libvoicevox_onnxruntime.so.1.17.3 \
VOICEVOX_OPENJTALK_DICT=../_build/voicevox-core-download/voicevox_core/dict/open_jtalk_dic_utf_8-1.11 \
VOICEVOX_VVM=../_build/voicevox-core-download/voicevox_core/models/vvms/0.vvm \
VOICEVOX_STYLE_ID=3 \
moon test --target native
```

有効化された場合、integration test は `こんにちは` を合成し、RIFF/WAVE header を確認して、パッケージの作業ディレクトリに `voicevox_smoke.wav` を書き出します。

## 補足

- Public API は意図的に VOICEVOX Core C API に近い形にしています。
- JSON を返す VOICEVOX Core 関数は `String` として JSON を返します。必要に応じて好きな JSON package で decode してください。
- 生成された WAV は `Bytes` として返されます。保存する場合は `write_wav_file` か、任意の file I/O を使ってください。
