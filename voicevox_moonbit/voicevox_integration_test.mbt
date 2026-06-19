///|
fn all_integration_env() -> (String, String, String, String, String)? {
  match
    (
      @env.get_env_var("VOICEVOX_CORE_LIB"),
      @env.get_env_var("VOICEVOX_ONNXRUNTIME_LIB"),
      @env.get_env_var("VOICEVOX_OPENJTALK_DICT"),
      @env.get_env_var("VOICEVOX_VVM"),
      @env.get_env_var("VOICEVOX_STYLE_ID"),
    ) {
    (Some(core), Some(onnxruntime), Some(dict), Some(model), Some(style_id)) =>
      Some((core, onnxruntime, dict, model, style_id))
    _ => None
  }
}

///|
fn assert_wav_header(wav : Bytes) -> Unit raise {
  guard wav.length() > 44 else { fail("expected non-empty WAV data") }
  match wav {
    [b'R', b'I', b'F', b'F', _, _, _, _, b'W', b'A', b'V', b'E', ..] => ()
    _ => fail("expected RIFF/WAVE header")
  }
}

///|
fn run_real_synthesis_smoke(
  core_path : String,
  onnxruntime_path : String,
  dict_dir : String,
  model_path : String,
  style_id_text : String,
) -> Unit raise {
  let style_id : UInt = @strconv.from_str(style_id_text)
  let core = @voicevox_moonbit.Core::load(core_path)
  let onnxruntime = core.load_onnxruntime(filename=onnxruntime_path)
  let open_jtalk = @voicevox_moonbit.OpenJtalk(core, dict_dir)
  let model = @voicevox_moonbit.VoiceModelFile::open(core, model_path)
  let synthesizer = @voicevox_moonbit.Synthesizer(core, onnxruntime, open_jtalk)
  synthesizer.load_voice_model(model)
  let wav = synthesizer.tts("こんにちは", style_id)
  assert_wav_header(wav)
  @voicevox_moonbit.write_wav_file("_build/voicevox_smoke.wav", wav)
}

///|
test "VOICEVOX real synthesis smoke test" {
  match all_integration_env() {
    Some((core_path, onnxruntime_path, dict_dir, model_path, style_id_text)) => {
      let result : Result[Unit, Error] = Ok(
        run_real_synthesis_smoke(
          core_path, onnxruntime_path, dict_dir, model_path, style_id_text,
        ),
      ) catch {
        error => Err(error)
      }
      match result {
        Ok(_) => ()
        Err(error) => fail("VOICEVOX smoke test failed: \{to_repr(error)}")
      }
    }
    None => ()
  }
}
