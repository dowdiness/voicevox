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

## CLI smoke test

The repository includes a small CLI in `cmd/synthesize`. It uses `moonbitlang/core/argparse` and `@voicevox.write_wav_file` to synthesize speech and write a WAV file:

```sh
moon run --target native cmd/synthesize -- \
  --core ./libvoicevox_core.so \
  --onnxruntime ./libonnxruntime.so \
  --dict ./open_jtalk_dic_utf_8-1.11 \
  --model ./model.vvm \
  --style-id 3 \
  --text 'こんにちは' \
  --out out.wav
```

Run the CLI help for the full option list:

```sh
moon run --target native cmd/synthesize -- --help
```

## Testing

Unit tests that do not require real VOICEVOX assets can be run with:

```sh
moon test --target native
```

The real synthesis smoke test is skipped unless all required environment variables are set:

```sh
VOICEVOX_CORE_LIB=./libvoicevox_core.so \
VOICEVOX_ONNXRUNTIME_LIB=./libonnxruntime.so \
VOICEVOX_OPENJTALK_DICT=./open_jtalk_dic_utf_8-1.11 \
VOICEVOX_VVM=./model.vvm \
VOICEVOX_STYLE_ID=3 \
moon test --target native
```

When enabled, the integration test synthesizes `こんにちは`, checks for a RIFF/WAVE header, and writes `_build/voicevox_smoke.wav`.

## Notes

- The public API is intentionally close to the VOICEVOX Core C API.
- JSON-returning VOICEVOX Core functions currently return JSON as `String`; callers can decode it with their preferred JSON package.
- Generated WAV bytes are returned as `Bytes`. Use `write_wav_file` or your own file I/O to persist them.
