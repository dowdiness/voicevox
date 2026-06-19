///|
#borrow(path)
extern "c" fn ffi_core_open(path : Bytes) -> CoreHandle = "moonbit_voicevox_core_open"

///|
#borrow(core)
extern "c" fn ffi_core_ok(core : CoreHandle) -> Bool = "moonbit_voicevox_core_ok"

///|
#borrow(core)
extern "c" fn ffi_core_status(core : CoreHandle) -> Int = "moonbit_voicevox_core_status"

///|
#borrow(core)
extern "c" fn ffi_core_error(core : CoreHandle) -> Bytes = "moonbit_voicevox_core_error"

///|
#borrow(core)
extern "c" fn ffi_core_error_message(core : CoreHandle, code : Int) -> Bytes = "moonbit_voicevox_core_error_message"

///|
#borrow(core)
extern "c" fn ffi_core_version(core : CoreHandle) -> Bytes = "moonbit_voicevox_core_version"

///|
#borrow(core)
extern "c" fn ffi_core_onnxruntime_versioned_filename(
  core : CoreHandle,
) -> Bytes = "moonbit_voicevox_core_onnxruntime_versioned_filename"

///|
#borrow(core)
extern "c" fn ffi_core_onnxruntime_unversioned_filename(
  core : CoreHandle,
) -> Bytes = "moonbit_voicevox_core_onnxruntime_unversioned_filename"

///|
#borrow(core, filename)
extern "c" fn ffi_onnxruntime_load_once(
  core : CoreHandle,
  filename : Bytes,
) -> OnnxruntimeHandle = "moonbit_voicevox_onnxruntime_load_once"

///|
#borrow(onnxruntime)
extern "c" fn ffi_onnxruntime_status(onnxruntime : OnnxruntimeHandle) -> Int = "moonbit_voicevox_onnxruntime_status"

///|
#borrow(onnxruntime)
extern "c" fn ffi_onnxruntime_error_message(
  onnxruntime : OnnxruntimeHandle,
  code : Int,
) -> Bytes = "moonbit_voicevox_onnxruntime_error_message"

///|
#borrow(onnxruntime)
extern "c" fn ffi_onnxruntime_supported_devices_json(
  onnxruntime : OnnxruntimeHandle,
) -> Bytes = "moonbit_voicevox_onnxruntime_supported_devices_json"

///|
#borrow(core, dict_dir)
extern "c" fn ffi_open_jtalk_new(
  core : CoreHandle,
  dict_dir : Bytes,
) -> OpenJtalkHandle = "moonbit_voicevox_open_jtalk_new"

///|
#borrow(open_jtalk)
extern "c" fn ffi_open_jtalk_status(open_jtalk : OpenJtalkHandle) -> Int = "moonbit_voicevox_open_jtalk_status"

///|
#borrow(open_jtalk)
extern "c" fn ffi_open_jtalk_error_message(
  open_jtalk : OpenJtalkHandle,
  code : Int,
) -> Bytes = "moonbit_voicevox_open_jtalk_error_message"

///|
#borrow(open_jtalk, text)
extern "c" fn ffi_open_jtalk_analyze(
  open_jtalk : OpenJtalkHandle,
  text : Bytes,
) -> Bytes = "moonbit_voicevox_open_jtalk_analyze"

///|
#borrow(core, path)
extern "c" fn ffi_voice_model_open(
  core : CoreHandle,
  path : Bytes,
) -> VoiceModelFileHandle = "moonbit_voicevox_voice_model_open"

///|
#borrow(model)
extern "c" fn ffi_voice_model_status(model : VoiceModelFileHandle) -> Int = "moonbit_voicevox_voice_model_status"

///|
#borrow(model)
extern "c" fn ffi_voice_model_error_message(
  model : VoiceModelFileHandle,
  code : Int,
) -> Bytes = "moonbit_voicevox_voice_model_error_message"

///|
#borrow(model)
extern "c" fn ffi_voice_model_id(model : VoiceModelFileHandle) -> Bytes = "moonbit_voicevox_voice_model_id"

///|
#borrow(model)
extern "c" fn ffi_voice_model_metas_json(model : VoiceModelFileHandle) -> Bytes = "moonbit_voicevox_voice_model_metas_json"

///|
#borrow(core, onnxruntime, open_jtalk)
extern "c" fn ffi_synthesizer_new(
  core : CoreHandle,
  onnxruntime : OnnxruntimeHandle,
  open_jtalk : OpenJtalkHandle,
  acceleration_mode : Int,
  cpu_num_threads : Int,
) -> SynthesizerHandle = "moonbit_voicevox_synthesizer_new"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_status(synthesizer : SynthesizerHandle) -> Int = "moonbit_voicevox_synthesizer_status"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_error_message(
  synthesizer : SynthesizerHandle,
  code : Int,
) -> Bytes = "moonbit_voicevox_synthesizer_error_message"

///|
#borrow(synthesizer, model)
extern "c" fn ffi_synthesizer_load_voice_model(
  synthesizer : SynthesizerHandle,
  model : VoiceModelFileHandle,
  on_existing : Int,
) -> Int = "moonbit_voicevox_synthesizer_load_voice_model"

///|
#borrow(synthesizer, model_id)
extern "c" fn ffi_synthesizer_unload_voice_model(
  synthesizer : SynthesizerHandle,
  model_id : Bytes,
) -> Int = "moonbit_voicevox_synthesizer_unload_voice_model"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_is_gpu_mode(
  synthesizer : SynthesizerHandle,
) -> Bool = "moonbit_voicevox_synthesizer_is_gpu_mode"

///|
#borrow(synthesizer, model_id)
extern "c" fn ffi_synthesizer_is_loaded_voice_model(
  synthesizer : SynthesizerHandle,
  model_id : Bytes,
) -> Bool = "moonbit_voicevox_synthesizer_is_loaded_voice_model"

///|
#borrow(synthesizer)
extern "c" fn ffi_synthesizer_metas_json(
  synthesizer : SynthesizerHandle,
) -> Bytes = "moonbit_voicevox_synthesizer_metas_json"

///|
#borrow(synthesizer, text)
extern "c" fn ffi_synthesizer_create_audio_query(
  synthesizer : SynthesizerHandle,
  text : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_audio_query"

///|
#borrow(synthesizer, kana)
extern "c" fn ffi_synthesizer_create_audio_query_from_kana(
  synthesizer : SynthesizerHandle,
  kana : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_audio_query_from_kana"

///|
#borrow(synthesizer, text)
extern "c" fn ffi_synthesizer_create_accent_phrases(
  synthesizer : SynthesizerHandle,
  text : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_accent_phrases"

///|
#borrow(synthesizer, kana)
extern "c" fn ffi_synthesizer_create_accent_phrases_from_kana(
  synthesizer : SynthesizerHandle,
  kana : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_create_accent_phrases_from_kana"

///|
#borrow(synthesizer, accent_phrases_json)
extern "c" fn ffi_synthesizer_replace_mora_data(
  synthesizer : SynthesizerHandle,
  accent_phrases_json : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_replace_mora_data"

///|
#borrow(synthesizer, accent_phrases_json)
extern "c" fn ffi_synthesizer_replace_phoneme_length(
  synthesizer : SynthesizerHandle,
  accent_phrases_json : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_replace_phoneme_length"

///|
#borrow(synthesizer, accent_phrases_json)
extern "c" fn ffi_synthesizer_replace_mora_pitch(
  synthesizer : SynthesizerHandle,
  accent_phrases_json : Bytes,
  style_id : UInt,
) -> Bytes = "moonbit_voicevox_synthesizer_replace_mora_pitch"

///|
#borrow(synthesizer, audio_query_json)
extern "c" fn ffi_synthesizer_synthesis(
  synthesizer : SynthesizerHandle,
  audio_query_json : Bytes,
  style_id : UInt,
  enable_interrogative_upspeak : Bool,
) -> Bytes = "moonbit_voicevox_synthesizer_synthesis"

///|
#borrow(synthesizer, text)
extern "c" fn ffi_synthesizer_tts(
  synthesizer : SynthesizerHandle,
  text : Bytes,
  style_id : UInt,
  enable_interrogative_upspeak : Bool,
) -> Bytes = "moonbit_voicevox_synthesizer_tts"

///|
#borrow(synthesizer, kana)
extern "c" fn ffi_synthesizer_tts_from_kana(
  synthesizer : SynthesizerHandle,
  kana : Bytes,
  style_id : UInt,
  enable_interrogative_upspeak : Bool,
) -> Bytes = "moonbit_voicevox_synthesizer_tts_from_kana"

///|
#borrow(core, json)
extern "c" fn ffi_audio_query_validate(core : CoreHandle, json : Bytes) -> Int = "moonbit_voicevox_audio_query_validate"

///|
#borrow(core, json)
extern "c" fn ffi_accent_phrase_validate(
  core : CoreHandle,
  json : Bytes,
) -> Int = "moonbit_voicevox_accent_phrase_validate"

///|
#borrow(core, json)
extern "c" fn ffi_mora_validate(core : CoreHandle, json : Bytes) -> Int = "moonbit_voicevox_mora_validate"

///|
#borrow(core, json)
extern "c" fn ffi_score_validate(core : CoreHandle, json : Bytes) -> Int = "moonbit_voicevox_score_validate"

///|
#borrow(core, json)
extern "c" fn ffi_note_validate(core : CoreHandle, json : Bytes) -> Int = "moonbit_voicevox_note_validate"

///|
#borrow(core, json)
extern "c" fn ffi_frame_audio_query_validate(
  core : CoreHandle,
  json : Bytes,
) -> Int = "moonbit_voicevox_frame_audio_query_validate"

///|
#borrow(core, json)
extern "c" fn ffi_frame_phoneme_validate(
  core : CoreHandle,
  json : Bytes,
) -> Int = "moonbit_voicevox_frame_phoneme_validate"

///|
#borrow(core, accent_phrases_json)
extern "c" fn ffi_audio_query_create_from_accent_phrases(
  core : CoreHandle,
  accent_phrases_json : Bytes,
) -> Bytes = "moonbit_voicevox_audio_query_create_from_accent_phrases"
