///|
#borrow(path, contents)
extern "c" fn ffi_write_wav_file(path : Bytes, contents : Bytes) -> Int = "moonbit_voicevox_write_wav_file"

///|
extern "c" fn ffi_write_wav_file_error() -> Bytes = "moonbit_voicevox_write_wav_file_error"

///|
fn write_file(path : String, contents : Bytes) -> Unit raise VoicevoxError {
  if ffi_write_wav_file(encode_utf8(path), contents) != 0 {
    raise WriteFileError(decode_utf8(ffi_write_wav_file_error()))
  }
}

///|
/// Write WAV bytes to `path`.
///
/// VOICEVOX Core synthesis APIs already return a complete WAV file, so this
/// function writes the bytes unchanged.
pub fn write_wav_file(path : String, wav : Bytes) -> Unit raise VoicevoxError {
  write_file(path, wav)
}
