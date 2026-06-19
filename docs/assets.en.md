# VOICEVOX assets

[日本語](assets.md)

`dowdiness/voicevox_moonbit` does not include VOICEVOX Core binaries, VOICEVOX ONNX Runtime, OpenJTalk dictionaries, or `.vvm` voice models. Download these files locally with the official VOICEVOX Core Downloader and keep them out of Git.

## Terms and redistribution

Voice models (VVM files) have their own terms of use. For details, see the README included in the downloaded files and the [VOICEVOX Core user guide](https://github.com/VOICEVOX/voicevox_core/blob/main/docs/guide/user/usage.md).

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

The ONNX Runtime patch version in the filename may change. Use the file that actually exists under:

```text
_build/voicevox-core-download/voicevox_core/onnxruntime/lib/
```

## Troubleshooting

### Cannot load a `.vvm` file

If you specify a `.vvm` file that is incompatible with the current VOICEVOX Core, you may see errors such as `vvm_format_version=1` or 「廃止された形式です」. Always use a `.vvm` file downloaded by the VOICEVOX Core Downloader.

### `This ONNX Runtime does not support "vv-bin" format`

Use VOICEVOX ONNX Runtime from the downloader, not a generic ONNX Runtime build. The library is usually named like:

```text
libvoicevox_onnxruntime.so.1.17.3
```
