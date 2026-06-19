# pi 用 VOICEVOX 読み上げ拡張

[English](README.en.md)

VOICEVOX で pi の出力を読み上げる TTS extension です。

[`voicevox-tts.ts`](voicevox-tts.ts) を読み込むとpi の出力を `cmd/synthesize` で WAV に変換し`paplay` や `ffplay` で再生します。

## 使い方

1. [../../docs/assets.md](../../docs/assets.md) の手順に従って、VOICEVOX Core、VOICEVOX ONNX Runtime、OpenJTalk 辞書、`.vvm` 音声モデルをダウンロードしてください。

ダウンロードしたファイルは Git に含めないでください。

2. 設定ファイルのひな形をコピーします。

```sh
cp tools/pi/voicevox-tts.example.json tools/pi/voicevox-tts.json
```

3. `tools/pi/voicevox-tts.json` を編集し、自分の環境に合わせてパスを書き換えます。

- `enabled`: 読み上げを有効にするかどうか。`false` にすると自動読み上げしません。
- `projectDir`: `voicevox_moonbit` ディレクトリの絶対パス。
- `core`: `libvoicevox_core.so` の絶対パス。
- `onnxruntime`: `libvoicevox_onnxruntime.so...` の絶対パス。
- `dict`: OpenJTalk 辞書ディレクトリの絶対パス。
- `model`: `.vvm` ファイルの絶対パス。
- `styleId`: 使用する話者スタイル ID。
- `maxChars`: 1 回に読み上げる最大文字数。長い応答はこの文字数で省略されます。
- `stripCodeBlocks`: `true` の場合、Markdown のコードブロックを読み上げず「コードブロックを省略します」と読み替えます。
- `playerCommands`: WAV ファイルの再生に使うコマンド候補です。上から順に試します。例: `["paplay"]`、`["ffplay", "-autoexit", "-nodisp"]`。

`tools/pi/voicevox-tts.json` には環境固有のパスが入るため、Git 管理外にしています。

4. リポジトリルートで pi を起動します。

```sh
pi -e tools/pi/voicevox-tts.ts
```

5. pi でextensionが読み込まれているか確認と読み上げテストをします。

```text
/voicevox-tts status
/voicevox-tts test 読み上げテスト
```

## 設定ファイルの読み込み順

設定は次の順番で読み込まれます。後に読み込まれた設定ほど優先されます。

1. `VOICEVOX_*` 環境変数
2. `~/.pi/agent/voicevox-tts.json`
3. `<repo>/tools/pi/voicevox-tts.json`

## pi 内で使えるコマンド

```text
/voicevox-tts status
```

現在の設定、読み込み元、足りないパスがないかを表示します。

```text
/voicevox-tts on
/voicevox-tts off
```

読み上げを有効化 / 無効化します。

```text
/voicevox-tts reload
```

設定ファイルを読み直します。

```text
/voicevox-tts test 読み上げテスト
```

指定した文章で読み上げをテスト出来ます。

## ずんだもんを使う例

`tools/pi/voicevox-tts.example.json` は、Downloader で取得した `0.vvm` を使う想定で書かれています。この場合、次の設定で ずんだもん ノーマルを使えます。

```json
"styleId": 3
```

生成した音声を利用する場合は、各音声ライブラリの利用規約に従ってください。ずんだもんを使う場合は、例えば `VOICEVOX:ずんだもん` のようなクレジット表記が必要です。
