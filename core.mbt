///|
pub fn Core::load(path : String) -> Core raise VoicevoxError {
  let handle = ffi_core_open(encode_utf8(path))
  if ffi_core_ok(handle) {
    { handle, }
  } else {
    raise LibraryLoadError(decode_utf8(ffi_core_error(handle)))
  }
}

///|
pub fn Core::get_version(self : Core) -> String {
  decode_utf8(ffi_core_version(self.handle))
}

///|
pub fn Core::onnxruntime_versioned_filename(self : Core) -> String {
  decode_utf8(ffi_core_onnxruntime_versioned_filename(self.handle))
}

///|
pub fn Core::onnxruntime_unversioned_filename(self : Core) -> String {
  decode_utf8(ffi_core_onnxruntime_unversioned_filename(self.handle))
}

///|
pub fn Core::load_onnxruntime(
  self : Core,
  filename? : String,
) -> Onnxruntime raise VoicevoxError {
  let filename_bytes = match filename {
    Some(filename) => encode_utf8(filename)
    None => b""
  }
  let handle = ffi_onnxruntime_load_once(self.handle, filename_bytes)
  check_onnxruntime(handle, ffi_onnxruntime_status(handle))
  { handle, }
}

///|
pub fn Onnxruntime::supported_devices_json(
  self : Onnxruntime,
) -> String raise VoicevoxError {
  let json = ffi_onnxruntime_supported_devices_json(self.handle)
  check_onnxruntime(self.handle, ffi_onnxruntime_status(self.handle))
  decode_utf8(json)
}

///|
pub fn OpenJtalk::OpenJtalk(
  core : Core,
  dict_dir : String,
) -> OpenJtalk raise VoicevoxError {
  let handle = ffi_open_jtalk_new(core.handle, encode_utf8(dict_dir))
  check_open_jtalk(handle, ffi_open_jtalk_status(handle))
  { handle, }
}

///|
pub fn OpenJtalk::analyze(
  self : OpenJtalk,
  text : String,
) -> String raise VoicevoxError {
  let json = ffi_open_jtalk_analyze(self.handle, encode_utf8(text))
  check_open_jtalk(self.handle, ffi_open_jtalk_status(self.handle))
  decode_utf8(json)
}

///|
fn validate_json(
  core : Core,
  json : String,
  run : (CoreHandle, Bytes) -> Int,
) -> Unit raise VoicevoxError {
  check_core(core.handle, run(core.handle, encode_utf8(json)))
}

///|
pub fn Core::validate_audio_query(
  self : Core,
  json : String,
) -> Unit raise VoicevoxError {
  validate_json(self, json, ffi_audio_query_validate)
}

///|
pub fn Core::validate_accent_phrase(
  self : Core,
  json : String,
) -> Unit raise VoicevoxError {
  validate_json(self, json, ffi_accent_phrase_validate)
}

///|
pub fn Core::validate_mora(
  self : Core,
  json : String,
) -> Unit raise VoicevoxError {
  validate_json(self, json, ffi_mora_validate)
}

///|
pub fn Core::validate_score(
  self : Core,
  json : String,
) -> Unit raise VoicevoxError {
  validate_json(self, json, ffi_score_validate)
}

///|
pub fn Core::validate_note(
  self : Core,
  json : String,
) -> Unit raise VoicevoxError {
  validate_json(self, json, ffi_note_validate)
}

///|
pub fn Core::validate_frame_audio_query(
  self : Core,
  json : String,
) -> Unit raise VoicevoxError {
  validate_json(self, json, ffi_frame_audio_query_validate)
}

///|
pub fn Core::validate_frame_phoneme(
  self : Core,
  json : String,
) -> Unit raise VoicevoxError {
  validate_json(self, json, ffi_frame_phoneme_validate)
}

///|
pub fn Core::audio_query_from_accent_phrases(
  self : Core,
  accent_phrases_json : String,
) -> String raise VoicevoxError {
  let json = ffi_audio_query_create_from_accent_phrases(
    self.handle,
    encode_utf8(accent_phrases_json),
  )
  check_core(self.handle, ffi_core_status(self.handle))
  decode_utf8(json)
}
