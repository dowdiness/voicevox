# dowdiness/voicevox_moonbit

[![CI](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml/badge.svg)](https://github.com/dowdiness/voicevox_moonbit/actions/workflows/ci.yml)

MoonBit native FFI bindings for [VOICEVOX Core](https://github.com/VOICEVOX/voicevox_core).

[日本語](README.mbt.md)

This package targets MoonBit's `native` backend. It loads `libvoicevox_core` dynamically at runtime, so building the MoonBit package does not require VOICEVOX Core headers or link-time libraries. Running synthesis requires compatible VOICEVOX Core, VOICEVOX ONNX Runtime, an OpenJTalk dictionary, and a `.vvm` voice model.

## Requirements

- MoonBit toolchain
- VOICEVOX Core C API shared library
- VOICEVOX-compatible ONNX Runtime shared library
- OpenJTalk dictionary directory
- VOICEVOX `.vvm` voice model file

Use the official VOICEVOX Core Downloader for matching assets. See [../docs/assets.en.md](../docs/assets.en.md). This repository does not vendor or redistribute VOICEVOX binaries, dictionaries, or voice models.

## Compatibility

- MoonBit target: `native` only.
- Linux is the primary tested environment.
- macOS and Windows dynamic-loader paths exist in the native stubs, but should be treated as experimental until real synthesis tests are added for those platforms.
- Expected C API surface includes the current `voicevox_synthesizer_*`, `voicevox_voice_model_file_*`, `voicevox_open_jtalk_rc_*`, `voicevox_json_free`, and `voicevox_wav_free` symbols used by the bindings.
- If your `libvoicevox_core` does not export `voicevox_onnxruntime_load_once`, use a VOICEVOX Core C API build with dynamic ONNX Runtime loading enabled.

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

## CLI

The repository includes a small CLI in `cmd/synthesize`:

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

## pi extension

An optional pi extension lives at [`../tools/pi/voicevox-tts.ts`](../tools/pi/voicevox-tts.ts). It is loaded explicitly, not as a project-local auto extension:

```sh
pi -e tools/pi/voicevox-tts.ts
```

See [../tools/pi/README.en.md](../tools/pi/README.en.md) for setup and commands.

## Testing

Unit tests that do not require real VOICEVOX assets:

```sh
moon test --target native
```

Real synthesis test with local assets:

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
- JSON-returning VOICEVOX Core functions return JSON as `String`; callers can decode it with their preferred JSON package.
- Generated WAV bytes are returned as `Bytes`. Use `write_wav_file` or your own file I/O to persist them.
