# dowdiness/voicevox

MoonBit native FFI bindings for [VOICEVOX Core](https://github.com/VOICEVOX/voicevox_core).

This is a native-target package. It loads `libvoicevox_core` dynamically at runtime, so building the MoonBit package does not require VOICEVOX Core headers or libraries. Runtime use still requires the VOICEVOX Core shared library, ONNX Runtime, an OpenJTalk dictionary, and `.vvm` voice model files.

## Library example

```mbt nocheck
///|
fn synthesize() -> Unit raise {
  let core = @voicevox.Core::load("./libvoicevox_core.so")
  let ort = core.load_onnxruntime(filename="./libonnxruntime.so")
  let open_jtalk = @voicevox.OpenJtalk::new(core, "./open_jtalk_dic_utf_8-1.11")
  let model = @voicevox.VoiceModelFile::open(core, "./model.vvm")
  let synth = @voicevox.Synthesizer::new(core, ort, open_jtalk)
  synth.load_voice_model(model)
  let wav = synth.tts("こんにちは", 3)
  @voicevox.write_wav_file("out.wav", wav)
}
```

Use option constructors when overriding defaults:

```mbt nocheck
///|
let options = @voicevox.InitializeOptions::new(
  acceleration_mode=Gpu,
  cpu_num_threads=2,
)

///|
let synth = @voicevox.Synthesizer::new(core, ort, open_jtalk, options~)
```

## CLI smoke test

`cmd/synthesize` uses `moonbitlang/core/argparse` and `@voicevox.write_wav_file` to write the synthesized WAV to disk:

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

Run `moon run --target native cmd/synthesize -- --help` to see all options.

### WSL/Linux local smoke command

In the development environment used for this repository, Linux `voicevox_core` artifacts are available from a sibling checkout of `VOICEVOX/voicevox_core`, and Windows-installed VOICEVOX model/dictionary files can be copied under `_build/voicevox-local/`.

A known-good command is:

```sh
moon run --target native cmd/synthesize -- \
  --core /home/antisatori/ghq/github.com/VOICEVOX/voicevox_core/target/debug/libvoicevox_core.so \
  --onnxruntime /home/antisatori/ghq/github.com/VOICEVOX/voicevox_core/target/debug/libonnxruntime.so \
  --dict /home/antisatori/ghq/github.com/VOICEVOX/voicevox_core/crates/test_util/data/open_jtalk_dic_utf_8-1.11 \
  --model /home/antisatori/ghq/github.com/VOICEVOX/voicevox_core/crates/test_util/data/model/sample.vvm \
  --style-id 0 \
  --text 'こんにちは' \
  --out _build/voicevox_cli_smoke.wav
```

If `voicevox_onnxruntime_load_once` is missing from `libvoicevox_core.so`, rebuild the C API with dynamic ONNX Runtime loading:

```sh
cd /home/antisatori/ghq/github.com/VOICEVOX/voicevox_core
cargo build -p voicevox_core_c_api --features load-onnxruntime
```

### Playing the generated WAV

On WSL/Linux, any of these can play the generated file if installed:

```sh
paplay _build/voicevox_cli_smoke.wav
ffplay -autoexit -nodisp _build/voicevox_cli_smoke.wav
aplay _build/voicevox_cli_smoke.wav
mpv _build/voicevox_cli_smoke.wav
```

On WSL2, you can also open the WAV with the Windows default player:

```sh
explorer.exe "$(wslpath -w _build/voicevox_cli_smoke.wav)"
```

## Integration test

The real VOICEVOX smoke test is enabled only when all required environment variables are set:

```sh
VOICEVOX_CORE_LIB=./libvoicevox_core.so \
VOICEVOX_ONNXRUNTIME_LIB=./libonnxruntime.so \
VOICEVOX_OPENJTALK_DICT=./open_jtalk_dic_utf_8-1.11 \
VOICEVOX_VVM=./model.vvm \
VOICEVOX_STYLE_ID=3 \
moon test --target native
```

When enabled, the test synthesizes `こんにちは`, checks for a RIFF/WAVE header, and writes `_build/voicevox_smoke.wav`.
