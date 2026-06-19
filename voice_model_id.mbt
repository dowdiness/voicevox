///|
pub fn VoiceModelId::from_bytes(
  bytes : Bytes,
) -> VoiceModelId raise VoicevoxError {
  if bytes.length() == 16 {
    VoiceModelId(bytes)
  } else {
    raise InvalidVoiceModelIdLength(bytes.length())
  }
}

///|
pub fn VoiceModelId::to_bytes(self : VoiceModelId) -> Bytes {
  let VoiceModelId(bytes) = self
  bytes
}
