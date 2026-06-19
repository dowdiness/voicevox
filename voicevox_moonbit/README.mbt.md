# dowdiness/voicevox_moonbit

[![CI](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml/badge.svg)](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml)

MoonBit native FFI bindings for [VOICEVOX Core](https://github.com/VOICEVOX/voicevox_core).

This package targets MoonBit's `native` backend. It loads `libvoicevox_core` dynamically at runtime, so building the MoonBit package does not require VOICEVOX Core headers or link-time libraries. Running synthesis still requires the VOICEVOX Core shared library, ONNX Runtime, an OpenJTalk dictionary, and `.vvm` voice model files.

## Requirements

- MoonBit toolchain
- VOICEVOX Core shared library, for example `libvoicevox_core.so`, `.dylib`, or `.dll`
- ONNX Runtime shared library compatible with the VOICEVOX Core build
- OpenJTalk dictionary directory
- VOICEVOX `.vvm` voice model file

If your `libvoicevox_core` does not export `voicevox_onnxruntime_load_once`, rebuild or download a VOICEVOX Core C API build with dynamic ONNX Runtime loading enabled.

## Compatibility

- MoonBit target: `native` only.
- CI currently runs `moon check --target native` and `moon test --target native` on GitHub Actions `ubuntu-latest` without real VOICEVOX assets.
- The native stub contains dynamic loader paths for Linux/Unix, macOS, and Windows. Linux is the primary tested environment; macOS and Windows support should be treated as experimental until real synthesis smoke tests are added for those platforms.
- Real synthesis has been smoke-tested on Linux with a VOICEVOX Core C API build around `0.16.4` (`0.16.4-48-gec003ed`) and ONNX Runtime loaded through `voicevox_onnxruntime_load_once`.
- Expected VOICEVOX Core C API surface includes the current `voicevox_synthesizer_*`, `voicevox_voice_model_file_*`, `voicevox_open_jtalk_rc_*`, `voicevox_json_free`, and `voicevox_wav_free` symbols used by the bindings. Older C API builds may fail at `Core::load` with a missing-symbol error.

## Import

Use an import alias if you want the shorter `@voicevox` package qualifier:

```moonbit nocheck
import {
  "dowdiness/voicevox_moonbit" @voicevox,
}
```

## Library example

```mbt nocheck
///|
import {
  "dowdiness/voicevox_moonbit" @voicevox,
}

///|
fn synthesize() -> Unit raise {
  let core = @voicevox.Core::load("./libvoicevox_core.so")
  let ort = core.load_onnxruntime(filename="./libonnxruntime.so")
  let open_jtalk = @voicevox.OpenJtalk(core, "./open_jtalk_dic_utf_8-1.11")
  let model = @voicevox.VoiceModelFile::open(core, "./model.vvm")
  let synth = @voicevox.Synthesizer(core, ort, open_jtalk)
  synth.load_voice_model(model)
  let wav = synth.tts("こんにちは", 3)
  @voicevox.write_wav_file("out.wav", wav)
}
```

Use option constructors when overriding defaults:

```mbt nocheck
///|
let options = @voicevox.InitializeOptions(
  acceleration_mode=Gpu,
  cpu_num_threads=2,
)

///|
let synth = @voicevox.Synthesizer(core, ort, open_jtalk, options~)
```

## Getting compatible VOICEVOX assets

Use the official VOICEVOX Core Downloader so the C API, VOICEVOX ONNX Runtime, OpenJTalk dictionary, and VVM model versions match. Do not vendor these downloaded artifacts in this repository; keep them in `_build/` or another local-only directory.

Linux x64 CPU example from the repository root:

```sh
mkdir -p _build/voicevox-core-download
cd _build/voicevox-core-download
curl -sSfL https://github.com/VOICEVOX/voicevox_core/releases/latest/download/download-linux-x64 -o download
chmod +x download
./download --devices cpu --only c-api onnxruntime dict models --models-pattern 0.vvm
```

The downloader shows the applicable terms for VOICEVOX ONNX Runtime and voice models. Read them and only answer yes if you agree. The model and generated voices also require the appropriate credit, for example `VOICEVOX:ずんだもん` when using ずんだもん.

With the default output directory, the useful paths are:

```text
_build/voicevox-core-download/voicevox_core/c_api/lib/libvoicevox_core.so
_build/voicevox-core-download/voicevox_core/onnxruntime/lib/libvoicevox_onnxruntime.so.1.17.3
_build/voicevox-core-download/voicevox_core/dict/open_jtalk_dic_utf_8-1.11
_build/voicevox-core-download/voicevox_core/models/vvms/0.vvm
```

The ONNX Runtime patch version in the filename may change; use the actual file under `voicevox_core/onnxruntime/lib/`. For `0.vvm`, `style-id 3` is ずんだもん ノーマル.

## CLI

The repository includes a small CLI in `cmd/synthesize`. It uses `moonbitlang/core/argparse` and `@voicevox.write_wav_file` to synthesize speech and write a WAV file:

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

Run the CLI help for the full option list:

```sh
moon run --target native cmd/synthesize -- --help
```

## Pi extension

This repository includes an optional pi extension at [`../tools/pi/voicevox-tts.ts`](../tools/pi/voicevox-tts.ts). It can read assistant responses aloud by calling `cmd/synthesize` and playing the generated WAV. It is not auto-loaded as a project-local extension; load it explicitly when you want it.

Setup:

1. Download compatible assets with the VOICEVOX Core Downloader as shown above. Keep them local and do not commit or redistribute them from this repository.
2. Copy `../tools/pi/voicevox-tts.example.json` to `../tools/pi/voicevox-tts.json` and edit the absolute paths, or keep your personal config at `~/.pi/agent/voicevox-tts.json`.
3. Start pi from the repository root with `pi -e tools/pi/voicevox-tts.ts`, or add that extension path to your own pi setup.
4. Check the extension with `/voicevox-tts status`.
5. Run `/voicevox-tts test 読み上げテスト`.

Commands:

```text
/voicevox-tts status
/voicevox-tts on
/voicevox-tts off
/voicevox-tts reload
/voicevox-tts test 読み上げテスト
```

The local `../tools/pi/voicevox-tts.json` file is ignored by Git because it contains machine-specific paths.

## Testing

Unit tests that do not require real VOICEVOX assets can be run with:

```sh
moon test --target native
```

The real synthesis smoke test is skipped unless all required environment variables are set:

```sh
VOICEVOX_CORE_LIB=../_build/voicevox-core-download/voicevox_core/c_api/lib/libvoicevox_core.so \
VOICEVOX_ONNXRUNTIME_LIB=../_build/voicevox-core-download/voicevox_core/onnxruntime/lib/libvoicevox_onnxruntime.so.1.17.3 \
VOICEVOX_OPENJTALK_DICT=../_build/voicevox-core-download/voicevox_core/dict/open_jtalk_dic_utf_8-1.11 \
VOICEVOX_VVM=../_build/voicevox-core-download/voicevox_core/models/vvms/0.vvm \
VOICEVOX_STYLE_ID=3 \
moon test --target native
```

When enabled, the integration test synthesizes `こんにちは`, checks for a RIFF/WAVE header, and writes `voicevox_smoke.wav` in the package working directory.

## Notes

- The public API is intentionally close to the VOICEVOX Core C API.
- JSON-returning VOICEVOX Core functions currently return JSON as `String`; callers can decode it with their preferred JSON package.
- Generated WAV bytes are returned as `Bytes`. Use `write_wav_file` or your own file I/O to persist them.
