///|
test "VoiceModelId validates length" {
  let bytes = Bytes::make(16, b'\x00')
  let id_result : Result[
    @voicevox_moonbit.VoiceModelId,
    @voicevox_moonbit.VoicevoxError,
  ] = Ok(@voicevox_moonbit.VoiceModelId::from_bytes(bytes)) catch {
    error => Err(error)
  }
  match id_result {
    Ok(id) => assert_eq(id.to_bytes().length(), 16)
    Err(_) => fail("expected valid VoiceModelId")
  }
  try @voicevox_moonbit.VoiceModelId::from_bytes(b"bad") catch {
    _ => ()
  } noraise {
    _ => fail("expected invalid VoiceModelId length")
  }
}

///|
test "Core::load reports missing dynamic library" {
  try
    @voicevox_moonbit.Core::load("/definitely/not/here/libvoicevox_core.so")
  catch {
    _ => ()
  } noraise {
    _ => fail("expected missing dynamic library error")
  }
}

///|
test "option constructors are available without public record construction" {
  let init = @voicevox_moonbit.InitializeOptions(
    acceleration_mode=Gpu,
    cpu_num_threads=2,
  )
  assert_eq(init.cpu_num_threads, 2)
  let load = @voicevox_moonbit.LoadVoiceModelOptions(on_existing=Reload)
  assert_true(load.on_existing is Reload)
  let synthesis = @voicevox_moonbit.SynthesisOptions(
    enable_interrogative_upspeak=false,
  )
  assert_eq(synthesis.enable_interrogative_upspeak, false)
  let tts = @voicevox_moonbit.TtsOptions(enable_interrogative_upspeak=false)
  assert_eq(tts.enable_interrogative_upspeak, false)
}

///|
test "write_wav_file writes bytes" {
  let result : Result[Unit, @voicevox_moonbit.VoicevoxError] = try {
    @voicevox_moonbit.write_wav_file(
      "_build/voicevox_write_wav_file_test.wav", b"RIFF\x04\x00\x00\x00WAVE",
    )
    Ok(())
  } catch {
    error => Err(error)
  }
  match result {
    Ok(_) => ()
    Err(_) => fail("expected write_wav_file to succeed")
  }
}

///|
test "write_wav_file reports IO errors" {
  try
    @voicevox_moonbit.write_wav_file("/definitely/not/here/out.wav", b"RIFF")
  catch {
    WriteFileError(_) => ()
    _ => fail("expected WriteFileError")
  } noraise {
    _ => fail("expected write error")
  }
}
