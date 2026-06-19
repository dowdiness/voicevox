///|
fn decode_utf8(bytes : Bytes) -> String {
  @utf8.decode_lossy(bytes)
}

///|
fn encode_utf8(text : String) -> Bytes {
  @utf8.encode(text)
}

///|
fn check_core(core : Core, code : Int) -> Unit raise VoicevoxError {
  if code != 0 {
    raise ApiError(
      code~,
      message=decode_utf8(ffi_core_error_message(core, code)),
    )
  }
}

///|
fn check_onnxruntime(
  onnxruntime : Onnxruntime,
  code : Int,
) -> Unit raise VoicevoxError {
  if code != 0 {
    raise ApiError(
      code~,
      message=decode_utf8(ffi_onnxruntime_error_message(onnxruntime, code)),
    )
  }
}

///|
fn check_open_jtalk(
  open_jtalk : OpenJtalk,
  code : Int,
) -> Unit raise VoicevoxError {
  if code != 0 {
    raise ApiError(
      code~,
      message=decode_utf8(ffi_open_jtalk_error_message(open_jtalk, code)),
    )
  }
}

///|
fn check_voice_model(
  model : VoiceModelFile,
  code : Int,
) -> Unit raise VoicevoxError {
  if code != 0 {
    raise ApiError(
      code~,
      message=decode_utf8(ffi_voice_model_error_message(model, code)),
    )
  }
}

///|
fn check_synthesizer(
  synthesizer : Synthesizer,
  code : Int,
) -> Unit raise VoicevoxError {
  if code != 0 {
    raise ApiError(
      code~,
      message=decode_utf8(ffi_synthesizer_error_message(synthesizer, code)),
    )
  }
}
