///|
pub fn VoiceModelFile::open(
  core : Core,
  path : String,
) -> VoiceModelFile raise VoicevoxError {
  let model = ffi_voice_model_open(core, encode_utf8(path))
  check_voice_model(model, ffi_voice_model_status(model))
  model
}

///|
pub fn VoiceModelFile::id(
  self : VoiceModelFile,
) -> VoiceModelId raise VoicevoxError {
  let id = ffi_voice_model_id(self)
  check_voice_model(self, ffi_voice_model_status(self))
  VoiceModelId::from_bytes(id)
}

///|
pub fn VoiceModelFile::metas_json(
  self : VoiceModelFile,
) -> String raise VoicevoxError {
  let json = ffi_voice_model_metas_json(self)
  check_voice_model(self, ffi_voice_model_status(self))
  decode_utf8(json)
}
