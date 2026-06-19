///|
extern "c" fn ffi_exit(code : Int) = "exit"

///|
suberror CliError {
  MissingArgument(String)
  InvalidStyleId(String)
} derive(Debug, Eq)

///|
fn command() -> @argparse.Command {
  @argparse.Command(
    "voicevox-synthesize",
    about="Synthesize speech with VOICEVOX Core and write a WAV file.",
    options=[
      @argparse.OptionArg(
        "core",
        long="core",
        required=true,
        about="Path to libvoicevox_core (.so/.dylib/.dll)",
      ),
      @argparse.OptionArg(
        "onnxruntime",
        long="onnxruntime",
        required=true,
        about="Path to ONNX Runtime library used by VOICEVOX Core",
      ),
      @argparse.OptionArg(
        "dict",
        long="dict",
        required=true,
        about="Path to open_jtalk_dic_utf_8 directory",
      ),
      @argparse.OptionArg(
        "model",
        long="model",
        required=true,
        about="Path to a .vvm voice model",
      ),
      @argparse.OptionArg(
        "style-id",
        long="style-id",
        required=true,
        about="VOICEVOX style ID, for example 3",
      ),
      @argparse.OptionArg(
        "text",
        long="text",
        required=true,
        about="Text to synthesize",
      ),
      @argparse.OptionArg(
        "out",
        long="out",
        required=true,
        about="Output WAV path",
      ),
    ],
  )
}

///|
fn required_option(
  matches : @argparse.Matches,
  name : String,
) -> String raise CliError {
  match matches.values.get(name) {
    Some([value, ..]) => value
    _ => raise MissingArgument(name)
  }
}

///|
fn parse_style_id(text : String) -> UInt raise CliError {
  let id : UInt = @strconv.from_str(text) catch {
    _ => raise InvalidStyleId(text)
  }
  id
}

///|
fn run() -> Unit raise {
  let matches = command().parse()
  let core_path = required_option(matches, "core")
  let onnxruntime_path = required_option(matches, "onnxruntime")
  let dict_dir = required_option(matches, "dict")
  let model_path = required_option(matches, "model")
  let style_id = parse_style_id(required_option(matches, "style-id"))
  let text = required_option(matches, "text")
  let out = required_option(matches, "out")

  let core = @voicevox.Core::load(core_path)
  let onnxruntime = core.load_onnxruntime(filename=onnxruntime_path)
  let open_jtalk = @voicevox.OpenJtalk(core, dict_dir)
  let model = @voicevox.VoiceModelFile::open(core, model_path)
  let synthesizer = @voicevox.Synthesizer(core, onnxruntime, open_jtalk)
  synthesizer.load_voice_model(model)
  let wav = synthesizer.tts(text, style_id)
  @voicevox.write_wav_file(out, wav)
  println("Wrote \{wav.length()} bytes to \{out}")
}

///|
fn main {
  run() catch {
    error => {
      let message = to_repr(error)
      println("voicevox-synthesize failed: \{message}")
      ffi_exit(1)
    }
  }
}
