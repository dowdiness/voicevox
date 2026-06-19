///|
pub fn VoiceModelFile::open(
  core : Core,
  path : String,
) -> VoiceModelFile raise VoicevoxError {
  let handle = ffi_voice_model_open(core.handle, encode_utf8(path))
  check_voice_model(handle, ffi_voice_model_status(handle))
  { handle, }
}

///|
pub fn VoiceModelFile::id(
  self : VoiceModelFile,
) -> VoiceModelId raise VoicevoxError {
  let id = ffi_voice_model_id(self.handle)
  check_voice_model(self.handle, ffi_voice_model_status(self.handle))
  VoiceModelId::from_bytes(id)
}

///|
pub fn VoiceModelFile::metas_json(
  self : VoiceModelFile,
) -> String raise VoicevoxError {
  let json = ffi_voice_model_metas_json(self.handle)
  check_voice_model(self.handle, ffi_voice_model_status(self.handle))
  decode_utf8(json)
}
