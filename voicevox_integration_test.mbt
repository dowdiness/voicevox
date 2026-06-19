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
test "VOICEVOX real synthesis smoke test" {
  match all_integration_env() {
    Some((core_path, onnxruntime_path, dict_dir, model_path, style_id_text)) => {
      let style_id : UInt = try! @strconv.from_str(style_id_text)
      let core = try! @voicevox.Core::load(core_path)
      let onnxruntime = try! core.load_onnxruntime(filename=onnxruntime_path)
      let open_jtalk = try! @voicevox.OpenJtalk::new(core, dict_dir)
      let model = try! @voicevox.VoiceModelFile::open(core, model_path)
      let synthesizer = try! @voicevox.Synthesizer::new(
        core, onnxruntime, open_jtalk,
      )
      try! synthesizer.load_voice_model(model)
      let wav = try! synthesizer.tts("こんにちは", style_id)
      assert_wav_header(wav)
      try! @voicevox.write_wav_file("_build/voicevox_smoke.wav", wav)
    }
    None => ()
  }
}
