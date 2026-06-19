///|
pub fn Synthesizer::Synthesizer(
  core : Core,
  onnxruntime : Onnxruntime,
  open_jtalk : OpenJtalk,
  options? : InitializeOptions,
) -> Synthesizer raise VoicevoxError {
  let opts = InitializeOptions::or_default(options)
  validate_cpu_num_threads(opts.cpu_num_threads)
  let handle = ffi_synthesizer_new(
    core.handle,
    onnxruntime.handle,
    open_jtalk.handle,
    opts.acceleration_mode.to_int(),
    opts.cpu_num_threads,
  )
  check_synthesizer(handle, ffi_synthesizer_status(handle))
  { handle, }
}

///|
pub fn Synthesizer::load_voice_model(
  self : Synthesizer,
  model : VoiceModelFile,
  options? : LoadVoiceModelOptions,
) -> Unit raise VoicevoxError {
  let opts = LoadVoiceModelOptions::or_default(options)
  check_synthesizer(
    self.handle,
    ffi_synthesizer_load_voice_model(
      self.handle,
      model.handle,
      opts.on_existing.to_int(),
    ),
  )
}

///|
pub fn Synthesizer::unload_voice_model(
  self : Synthesizer,
  model_id : VoiceModelId,
) -> Unit raise VoicevoxError {
  check_synthesizer(
    self.handle,
    ffi_synthesizer_unload_voice_model(self.handle, model_id.to_bytes()),
  )
}

///|
pub fn Synthesizer::is_gpu_mode(self : Synthesizer) -> Bool {
  ffi_synthesizer_is_gpu_mode(self.handle)
}

///|
pub fn Synthesizer::is_loaded_voice_model(
  self : Synthesizer,
  model_id : VoiceModelId,
) -> Bool {
  ffi_synthesizer_is_loaded_voice_model(self.handle, model_id.to_bytes())
}

///|
pub fn Synthesizer::metas_json(
  self : Synthesizer,
) -> String raise VoicevoxError {
  let json = ffi_synthesizer_metas_json(self.handle)
  check_synthesizer(self.handle, ffi_synthesizer_status(self.handle))
  decode_utf8(json)
}

///|
fn Synthesizer::synth_json(
  self : Synthesizer,
  text : String,
  style_id : UInt,
  run : (SynthesizerHandle, Bytes, UInt) -> Bytes,
) -> String raise VoicevoxError {
  let json = run(self.handle, encode_utf8(text), style_id)
  check_synthesizer(self.handle, ffi_synthesizer_status(self.handle))
  decode_utf8(json)
}

///|
pub fn Synthesizer::create_audio_query(
  self : Synthesizer,
  text : String,
  style_id : UInt,
) -> String raise VoicevoxError {
  self.synth_json(text, style_id, ffi_synthesizer_create_audio_query)
}

///|
pub fn Synthesizer::create_audio_query_from_kana(
  self : Synthesizer,
  kana : String,
  style_id : UInt,
) -> String raise VoicevoxError {
  self.synth_json(kana, style_id, ffi_synthesizer_create_audio_query_from_kana)
}

///|
pub fn Synthesizer::create_accent_phrases(
  self : Synthesizer,
  text : String,
  style_id : UInt,
) -> String raise VoicevoxError {
  self.synth_json(text, style_id, ffi_synthesizer_create_accent_phrases)
}

///|
pub fn Synthesizer::create_accent_phrases_from_kana(
  self : Synthesizer,
  kana : String,
  style_id : UInt,
) -> String raise VoicevoxError {
  self.synth_json(
    kana, style_id, ffi_synthesizer_create_accent_phrases_from_kana,
  )
}

///|
pub fn Synthesizer::replace_mora_data(
  self : Synthesizer,
  accent_phrases_json : String,
  style_id : UInt,
) -> String raise VoicevoxError {
  self.synth_json(
    accent_phrases_json, style_id, ffi_synthesizer_replace_mora_data,
  )
}

///|
pub fn Synthesizer::replace_phoneme_length(
  self : Synthesizer,
  accent_phrases_json : String,
  style_id : UInt,
) -> String raise VoicevoxError {
  self.synth_json(
    accent_phrases_json, style_id, ffi_synthesizer_replace_phoneme_length,
  )
}

///|
pub fn Synthesizer::replace_mora_pitch(
  self : Synthesizer,
  accent_phrases_json : String,
  style_id : UInt,
) -> String raise VoicevoxError {
  self.synth_json(
    accent_phrases_json, style_id, ffi_synthesizer_replace_mora_pitch,
  )
}

///|
fn Synthesizer::synth_wav(
  self : Synthesizer,
  text : String,
  style_id : UInt,
  enable_interrogative_upspeak : Bool,
  run : (SynthesizerHandle, Bytes, UInt, Bool) -> Bytes,
) -> Bytes raise VoicevoxError {
  let wav = run(
    self.handle,
    encode_utf8(text),
    style_id,
    enable_interrogative_upspeak,
  )
  check_synthesizer(self.handle, ffi_synthesizer_status(self.handle))
  wav
}

///|
pub fn Synthesizer::synthesis(
  self : Synthesizer,
  audio_query_json : String,
  style_id : UInt,
  options? : SynthesisOptions,
) -> Bytes raise VoicevoxError {
  let opts = SynthesisOptions::or_default(options)
  self.synth_wav(
    audio_query_json,
    style_id,
    opts.enable_interrogative_upspeak,
    ffi_synthesizer_synthesis,
  )
}

///|
pub fn Synthesizer::tts(
  self : Synthesizer,
  text : String,
  style_id : UInt,
  options? : TtsOptions,
) -> Bytes raise VoicevoxError {
  let opts = TtsOptions::or_default(options)
  self.synth_wav(
    text,
    style_id,
    opts.enable_interrogative_upspeak,
    ffi_synthesizer_tts,
  )
}

///|
pub fn Synthesizer::tts_from_kana(
  self : Synthesizer,
  kana : String,
  style_id : UInt,
  options? : TtsOptions,
) -> Bytes raise VoicevoxError {
  let opts = TtsOptions::or_default(options)
  self.synth_wav(
    kana,
    style_id,
    opts.enable_interrogative_upspeak,
    ffi_synthesizer_tts_from_kana,
  )
}
