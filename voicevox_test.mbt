///|
test "VoiceModelId validates length" {
  let bytes = Bytes::make(16, b'\x00')
  let id = try! @voicevox.VoiceModelId::from_bytes(bytes)
  assert_eq(id.to_bytes().length(), 16)
  try @voicevox.VoiceModelId::from_bytes(b"bad") catch {
    _ => ()
  } noraise {
    _ => fail("expected invalid VoiceModelId length")
  }
}

///|
test "Core::load reports missing dynamic library" {
  try @voicevox.Core::load("/definitely/not/here/libvoicevox_core.so") catch {
    _ => ()
  } noraise {
    _ => fail("expected missing dynamic library error")
  }
}

///|
test "option constructors are available without public record construction" {
  let init = @voicevox.InitializeOptions::new(
    acceleration_mode=Gpu,
    cpu_num_threads=2,
  )
  assert_eq(init.cpu_num_threads, 2)
  let load = @voicevox.LoadVoiceModelOptions::new(on_existing=Reload)
  assert_true(load.on_existing is Reload)
  let synthesis = @voicevox.SynthesisOptions::new(
    enable_interrogative_upspeak=false,
  )
  assert_eq(synthesis.enable_interrogative_upspeak, false)
  let tts = @voicevox.TtsOptions::new(enable_interrogative_upspeak=false)
  assert_eq(tts.enable_interrogative_upspeak, false)
}

///|
test "write_wav_file writes bytes" {
  try! @voicevox.write_wav_file(
    "_build/voicevox_write_wav_file_test.wav", b"RIFF\x04\x00\x00\x00WAVE",
  )
}

///|
test "write_wav_file reports IO errors" {
  try @voicevox.write_wav_file("/definitely/not/here/out.wav", b"RIFF") catch {
    WriteFileError(_) => ()
    _ => fail("expected WriteFileError")
  } noraise {
    _ => fail("expected write error")
  }
}
