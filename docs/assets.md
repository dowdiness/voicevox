# VOICEVOX 関連ファイル

[English](assets.en.md)

`dowdiness/voicevox_moonbit` は、VOICEVOX Core のバイナリ、VOICEVOX ONNX Runtime、OpenJTalk 辞書、`.vvm` 音声モデルを含みません。これらの関連ファイルは公式の VOICEVOX Core Downloader でローカルにダウンロードし、Git 管理外に置いてください。

## 利用規約と再配布

音声モデル（VVM ファイル）には利用規約が存在します。詳しくはダウンロードしたファイル内の README と[VOICEVOX コア ユーザーガイド](https://github.com/VOICEVOX/voicevox_core/blob/main/docs/guide/user/usage.md)を参照して下さい。


## Linux x64 CPU の例

リポジトリルートから実行します。

```sh
mkdir -p _build/voicevox-core-download
cd _build/voicevox-core-download
curl -sSfL https://github.com/VOICEVOX/voicevox_core/releases/latest/download/download-linux-x64 -o download
chmod +x download
./download --devices cpu --only c-api onnxruntime dict models --models-pattern 0.vvm
```

ファイルは Git 管理外の `_build/` 配下に置かれます。

## 想定されるパス

Downloader のデフォルト出力先を使う場合、主なパスは次の通りです。

```text
_build/voicevox-core-download/voicevox_core/c_api/lib/libvoicevox_core.so
_build/voicevox-core-download/voicevox_core/onnxruntime/lib/libvoicevox_onnxruntime.so.1.17.3
_build/voicevox-core-download/voicevox_core/dict/open_jtalk_dic_utf_8-1.11
_build/voicevox-core-download/voicevox_core/models/vvms/0.vvm
```

ONNX Runtime のパッチバージョンは変わる可能性があります。実際に存在するファイルを次のディレクトリから選んでください。

```text
_build/voicevox-core-download/voicevox_core/onnxruntime/lib/
```

## トラブルシューティング

### `.vvm` を読み込めない場合

現在の VOICEVOX Core と互換性のない `.vvm` を指定すると、`vvm_format_version=1` や「廃止された形式です」といったエラーが出ることがあります。必ず VOICEVOX Core Downloader でダウンロードした `.vvm` を使うようにしてください。

### `This ONNX Runtime does not support "vv-bin" format`

汎用 ONNX Runtime ではなく、Downloader で取得した VOICEVOX ONNX Runtime を使ってください。通常は次のような名前です。

```text
libvoicevox_onnxruntime.so.1.17.3
```
