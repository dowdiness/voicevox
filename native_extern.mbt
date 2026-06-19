///|
#borrow(path)
extern "c" fn ffi_core_open(path : Bytes) -> Core = "moonbit_voicevox_core_open"

///|
#borrow(core)
extern "c" fn ffi_core_ok(core : Core) -> Bool = "moonbit_voicevox_core_ok"

///|
#borrow(core)
extern "c" fn ffi_core_status(core : Core) -> Int = "moonbit_voicevox_core_status"

///|
#borrow(core)
extern "c" fn ffi_core_error(core : Core) -> Bytes = "moonbit_voicevox_core_error"

///|
#borrow(core)
extern "c" fn ffi_core_error_message(core : Core, code : Int) -> Bytes = "moonbit_voicevox_core_error_message"

///|
#borrow(core)
extern "c" fn ffi_core_version(core : Core) -> Bytes = "moonbit_voicevox_core_version"

///|
#borrow(core)
extern "c" fn ffi_core_onnxruntime_versioned_filename(core : Core) -> Bytes = "moonbit_voicevox_core_onnxruntime_versioned_filename"

///|
#borrow(core)
extern "c" fn ffi_core_onnxruntime_unversioned_filename(core : Core) -> Bytes = "moonbit_voicevox_core_onnxruntime_unversioned_filename"

///|
#borrow(core, filename)
extern "c" fn ffi_onnxruntime_load_once(
  core : Core,
  filename : Bytes,
) -> Onnxruntime = "moonbit_voicevox_onnxruntime_load_once"

///|
#borrow(onnxruntime)
extern "c" fn ffi_onnxruntime_status(onnxruntime : Onnxruntime) -> Int = "moonbit_voicevox_onnxruntime_status"

///|
#borrow(onnxruntime)
extern "c" fn ffi_onnxruntime_error_message(
  onnxruntime : Onnxruntime,
  code : Int,
) -> Bytes = "moonbit_voicevox_onnxruntime_error_message"

///|
#borrow(onnxruntime)
extern "c" fn ffi_onnxruntime_supported_devices_json(
  onnxruntime : Onnxruntime,
) -> Bytes = "moonbit_voicevox_onnxruntime_supported_devices_json"

///|
#borrow(core, dict_dir)
extern "c" fn ffi_open_jtalk_new(core : Core, dict_dir : Bytes) -> OpenJtalk = "moonbit_voicevox_open_jtalk_new"

///|
#borrow(open_jtalk)
extern "c" fn ffi_open_jtalk_status(open_jtalk : OpenJtalk) -> Int = "moonbit_voicevox_open_jtalk_status"

///|
#borrow(open_jtalk)
extern "c" fn ffi_open_jtalk_error_message(
  open_jtalk : OpenJtalk,
  code : Int,
) -> Bytes = "moonbit_voicevox_open_jtalk_error_message"

///|
#borrow(open_jtalk, text)
extern "c" fn ffi_open_jtalk_analyze(
  open_jtalk : OpenJtalk,
  text : Bytes,
) -> Bytes = "moonbit_voicevox_open_jtalk_analyze"

///|
#borrow(core, path)
extern "c" fn ffi_voice_model_open(core : Core, path : Bytes) -> VoiceModelFile = "moonbit_voicevox_voice_model_open"

///|
#borrow(model)
extern "c" fn ffi_voice_model_status(model : VoiceModelFile) -> Int = "moonbit_voicevox_voice_model_status"

///|
#borrow(model)
extern "c" fn ffi_voice_model_error_message(
  model : VoiceModelFile,
  code : Int,
) -> Bytes = "moonbit_voicevox_voice_model_error_message"

///|
#borrow(model)
extern "c" fn ffi_voice_model_id(model : VoiceModelFile) -> Bytes = "moonbit_voicevox_voice_model_id"

///|
#borrow(model)
extern "c" fn ffi_voice_model_metas_json(model : VoiceModelFile) -> Bytes = "moonbit_voicevox_voice_model_metas_json"

///|
#borrow(core, onnxruntime, open_jtalk)
extern "c" fn ffi_synthesizer_new(
  core : Core,
  onnxruntime : Onnxruntime,
  open_jtalk : OpenJtalk,
  acceleration_mode : Int,
  cpu_num_threads : Int,
) -> Synthesizer = "moonbit_voicevox_synthesizer_new"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_status(synthesizer : Synthesizer) -> Int = "moonbit_voicevox_synthesizer_status"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_error_message(
  synthesizer : Synthesizer,
  code : Int,
) -> Bytes = "moonbit_voicevox_synthesizer_error_message"

///|
#borrow(synthesizer, model)
extern "c" fn ffi_synthesizer_load_voice_model(
  synthesizer : Synthesizer,
  model : VoiceModelFile,
  on_existing : Int,
) -> Int = "moonbit_voicevox_synthesizer_load_voice_model"

///|
#borrow(synthesizer, model_id)
extern "c" fn ffi_synthesizer_unload_voice_model(
  synthesizer : Synthesizer,
  model_id : Bytes,
) -> Int = "moonbit_voicevox_synthesizer_unload_voice_model"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_is_gpu_mode(synthesizer : Synthesizer) -> Bool = "moonbit_voicevox_synthesizer_is_gpu_mode"

///|
#borrow(synthesizer, model_id)
extern "c" fn ffi_synthesizer_is_loaded_voice_model(
  synthesizer : Synthesizer,
  model_id : Bytes,
) -> Bool = "moonbit_voicevox_synthesizer_is_loaded_voice_model"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_metas_json(synthesizer : Synthesizer) -> Bytes = "moonbit_voicevox_synthesizer_metas_json"

///|
#borrow(synthesizer, text)
extern "c" fn ffi_synthesizer_create_audio_query(
  synthesizer : Synthesizer,
  text : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_audio_query"

///|
#borrow(synthesizer, kana)
extern "c" fn ffi_synthesizer_create_audio_query_from_kana(
  synthesizer : Synthesizer,
  kana : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_audio_query_from_kana"

///|
#borrow(synthesizer, text)
extern "c" fn ffi_synthesizer_create_accent_phrases(
  synthesizer : Synthesizer,
  text : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_accent_phrases"

///|
#borrow(synthesizer, kana)
extern "c" fn ffi_synthesizer_create_accent_phrases_from_kana(
  synthesizer : Synthesizer,
  kana : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_accent_phrases_from_kana"

///|
#borrow(synthesizer, accent_phrases_json)
extern "c" fn ffi_synthesizer_replace_mora_data(
  synthesizer : Synthesizer,
  accent_phrases_json : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_replace_mora_data"

///|
#borrow(synthesizer, accent_phrases_json)
extern "c" fn ffi_synthesizer_replace_phoneme_length(
  synthesizer : Synthesizer,
  accent_phrases_json : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_replace_phoneme_length"

///|
#borrow(synthesizer, accent_phrases_json)
extern "c" fn ffi_synthesizer_replace_mora_pitch(
  synthesizer : Synthesizer,
  accent_phrases_json : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_replace_mora_pitch"

///|
#borrow(synthesizer, audio_query_json)
extern "c" fn ffi_synthesizer_synthesis(
  synthesizer : Synthesizer,
  audio_query_json : Bytes,
  style_id : UInt,
  enable_interrogative_upspeak : Bool,
) -> Bytes = "moonbit_voicevox_synthesizer_synthesis"

///|
#borrow(synthesizer, text)
extern "c" fn ffi_synthesizer_tts(
  synthesizer : Synthesizer,
  text : Bytes,
  style_id : UInt,
  enable_interrogative_upspeak : Bool,
) -> Bytes = "moonbit_voicevox_synthesizer_tts"

///|
#borrow(synthesizer, kana)
extern "c" fn ffi_synthesizer_tts_from_kana(
  synthesizer : Synthesizer,
  kana : Bytes,
  style_id : UInt,
  enable_interrogative_upspeak : Bool,
) -> Bytes = "moonbit_voicevox_synthesizer_tts_from_kana"

///|
#borrow(core, json)
extern "c" fn ffi_audio_query_validate(core : Core, json : Bytes) -> Int = "moonbit_voicevox_audio_query_validate"

///|
#borrow(core, json)
extern "c" fn ffi_accent_phrase_validate(core : Core, json : Bytes) -> Int = "moonbit_voicevox_accent_phrase_validate"

///|
#borrow(core, json)
extern "c" fn ffi_mora_validate(core : Core, json : Bytes) -> Int = "moonbit_voicevox_mora_validate"

///|
#borrow(core, json)
extern "c" fn ffi_score_validate(core : Core, json : Bytes) -> Int = "moonbit_voicevox_score_validate"

///|
#borrow(core, json)
extern "c" fn ffi_note_validate(core : Core, json : Bytes) -> Int = "moonbit_voicevox_note_validate"

///|
#borrow(core, json)
extern "c" fn ffi_frame_audio_query_validate(core : Core, json : Bytes) -> Int = "moonbit_voicevox_frame_audio_query_validate"

///|
#borrow(core, json)
extern "c" fn ffi_frame_phoneme_validate(core : Core, json : Bytes) -> Int = "moonbit_voicevox_frame_phoneme_validate"

///|
#borrow(core, accent_phrases_json)
extern "c" fn ffi_audio_query_create_from_accent_phrases(
  core : Core,
  accent_phrases_json : Bytes,
) -> Bytes = "moonbit_voicevox_audio_query_create_from_accent_phrases"
