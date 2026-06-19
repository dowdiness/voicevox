# VOICEVOX assets

`dowdiness/voicevox_moonbit` does not include VOICEVOX Core binaries, VOICEVOX ONNX Runtime, OpenJTalk dictionaries, or `.vvm` voice models. Download those assets locally with the official VOICEVOX Core Downloader and keep them out of Git.

## Terms and redistribution

The downloader displays the terms that apply to the selected artifacts. Read them and only proceed if you agree.

In particular:

- Do not commit downloaded binaries, dictionaries, or `.vvm` files to this repository.
- Do not redistribute downloaded voice models from this repository.
- Generated voices require the appropriate credit. For example, when using ずんだもん, use `VOICEVOX:ずんだもん`.

## Linux x64 CPU example

Run this from the repository root:

```sh
mkdir -p _build/voicevox-core-download
cd _build/voicevox-core-download
curl -sSfL https://github.com/VOICEVOX/voicevox_core/releases/latest/download/download-linux-x64 -o download
chmod +x download
./download --devices cpu --only c-api onnxruntime dict models --models-pattern 0.vvm
```

The files remain under `_build/`, which is ignored by Git.

## Expected paths

With the default downloader output directory, useful paths are:

```text
_build/voicevox-core-download/voicevox_core/c_api/lib/libvoicevox_core.so
_build/voicevox-core-download/voicevox_core/onnxruntime/lib/libvoicevox_onnxruntime.so.1.17.3
_build/voicevox-core-download/voicevox_core/dict/open_jtalk_dic_utf_8-1.11
_build/voicevox-core-download/voicevox_core/models/vvms/0.vvm
```

The ONNX Runtime patch version in the filename may change. Use the actual file under:

```text
_build/voicevox-core-download/voicevox_core/onnxruntime/lib/
```

For the downloaded `0.vvm`, `style-id 3` is ずんだもん ノーマル.

## Troubleshooting

### `vvm_format_version=1` / model format error

The VOICEVOX application may contain older `.vvm` files. If VOICEVOX Core reports that `vvm_format_version=1` is deprecated, use a `.vvm` downloaded by the VOICEVOX Core Downloader instead.

### `This ONNX Runtime does not support "vv-bin" format`

Use VOICEVOX ONNX Runtime from the downloader, not a generic ONNX Runtime build. The library is usually named like:

```text
libvoicevox_onnxruntime.so.1.17.3
```
