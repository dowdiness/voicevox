#include <moonbit.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#if defined(__unix__) || defined(__APPLE__)
#include <dlfcn.h>
#elif defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif

typedef struct VoicevoxOnnxruntime VoicevoxOnnxruntime;
typedef struct OpenJtalkRc OpenJtalkRc;
typedef struct VoicevoxSynthesizer VoicevoxSynthesizer;
typedef struct VoicevoxVoiceModelFile VoicevoxVoiceModelFile;
typedef struct VoicevoxUserDict VoicevoxUserDict;

typedef uint32_t VoicevoxStyleId;
typedef const uint8_t (*VoicevoxVoiceModelId)[16];

typedef struct { const char *filename; } VoicevoxLoadOnnxruntimeOptions;
typedef struct { int32_t acceleration_mode; uint16_t cpu_num_threads; } VoicevoxInitializeOptions;
typedef struct { int32_t on_existing; } VoicevoxLoadVoiceModelOptions;
typedef struct { bool enable_interrogative_upspeak; } VoicevoxSynthesisOptions;
typedef struct { bool enable_interrogative_upspeak; } VoicevoxTtsOptions;

typedef const char *(*fn_cstr_void)(void);
typedef const char *(*fn_error_message)(int32_t);
typedef void (*fn_json_free)(char *);
typedef void (*fn_wav_free)(uint8_t *);
typedef VoicevoxLoadOnnxruntimeOptions (*fn_default_load_ort)(void);
typedef int32_t (*fn_ort_load_once)(VoicevoxLoadOnnxruntimeOptions, const VoicevoxOnnxruntime **);
typedef int32_t (*fn_ort_init_once)(const VoicevoxOnnxruntime **);
typedef const VoicevoxOnnxruntime *(*fn_ort_get)(void);
typedef int32_t (*fn_ort_supported_devices)(const VoicevoxOnnxruntime *, char **);
typedef int32_t (*fn_open_jtalk_new)(const char *, OpenJtalkRc **);
typedef void (*fn_open_jtalk_delete)(OpenJtalkRc *);
typedef int32_t (*fn_open_jtalk_analyze)(const OpenJtalkRc *, const char *, char **);
typedef int32_t (*fn_model_open)(const char *, VoicevoxVoiceModelFile **);
typedef void (*fn_model_delete)(VoicevoxVoiceModelFile *);
typedef void (*fn_model_id)(const VoicevoxVoiceModelFile *, uint8_t (*)[16]);
typedef char *(*fn_model_metas)(const VoicevoxVoiceModelFile *);
typedef int32_t (*fn_synth_new)(const VoicevoxOnnxruntime *, const OpenJtalkRc *, VoicevoxInitializeOptions, VoicevoxSynthesizer **);
typedef void (*fn_synth_delete)(VoicevoxSynthesizer *);
typedef int32_t (*fn_synth_load_model)(const VoicevoxSynthesizer *, const VoicevoxVoiceModelFile *, VoicevoxLoadVoiceModelOptions);
typedef int32_t (*fn_synth_unload_model)(const VoicevoxSynthesizer *, VoicevoxVoiceModelId);
typedef bool (*fn_synth_bool)(const VoicevoxSynthesizer *);
typedef bool (*fn_synth_is_loaded)(const VoicevoxSynthesizer *, VoicevoxVoiceModelId);
typedef char *(*fn_synth_metas)(const VoicevoxSynthesizer *);
typedef int32_t (*fn_synth_json_style)(const VoicevoxSynthesizer *, const char *, VoicevoxStyleId, char **);
typedef int32_t (*fn_synth_replace)(const VoicevoxSynthesizer *, const char *, VoicevoxStyleId, char **);
typedef int32_t (*fn_synth_synthesis)(const VoicevoxSynthesizer *, const char *, VoicevoxStyleId, VoicevoxSynthesisOptions, uintptr_t *, uint8_t **);
typedef int32_t (*fn_synth_tts)(const VoicevoxSynthesizer *, const char *, VoicevoxStyleId, VoicevoxTtsOptions, uintptr_t *, uint8_t **);
typedef int32_t (*fn_validate)(const char *);
typedef int32_t (*fn_audio_query_from_accent)(const char *, char **);

typedef struct {
  void *lib;
  int32_t ok;
  int32_t last_status;
  char error[512];
  fn_error_message error_message;
  fn_json_free json_free;
  fn_wav_free wav_free;
  fn_cstr_void get_version;
  fn_cstr_void get_ort_versioned_filename;
  fn_cstr_void get_ort_unversioned_filename;
  fn_default_load_ort default_load_ort;
  fn_ort_load_once ort_load_once;
  fn_ort_init_once ort_init_once;
  fn_ort_get ort_get;
  fn_ort_supported_devices ort_supported_devices;
  fn_open_jtalk_new open_jtalk_new;
  fn_open_jtalk_delete open_jtalk_delete;
  fn_open_jtalk_analyze open_jtalk_analyze;
  fn_model_open model_open;
  fn_model_delete model_delete;
  fn_model_id model_id;
  fn_model_metas model_metas;
  fn_synth_new synth_new;
  fn_synth_delete synth_delete;
  fn_synth_load_model synth_load_model;
  fn_synth_unload_model synth_unload_model;
  fn_synth_bool synth_is_gpu;
  fn_synth_is_loaded synth_is_loaded;
  fn_synth_metas synth_metas;
  fn_ort_supported_devices supported_devices;
  fn_synth_json_style create_audio_query;
  fn_synth_json_style create_audio_query_from_kana;
  fn_synth_json_style create_accent_phrases;
  fn_synth_json_style create_accent_phrases_from_kana;
  fn_synth_replace replace_mora_data;
  fn_synth_replace replace_phoneme_length;
  fn_synth_replace replace_mora_pitch;
  fn_synth_synthesis synthesis;
  fn_synth_tts tts;
  fn_synth_tts tts_from_kana;
  fn_validate audio_query_validate;
  fn_validate accent_phrase_validate;
  fn_validate mora_validate;
  fn_validate score_validate;
  fn_validate note_validate;
  fn_validate frame_audio_query_validate;
  fn_validate frame_phoneme_validate;
  fn_audio_query_from_accent audio_query_from_accent_phrases;
} VVCore;

typedef struct { const VoicevoxOnnxruntime *ptr; int32_t status; fn_error_message error_message; fn_ort_supported_devices supported_devices; fn_json_free json_free; } VVOrt;
typedef struct { OpenJtalkRc *ptr; int32_t status; fn_error_message error_message; fn_open_jtalk_delete delete_fn; fn_open_jtalk_analyze analyze; fn_json_free json_free; } VVOpenJtalk;
typedef struct { VoicevoxVoiceModelFile *ptr; int32_t status; fn_error_message error_message; fn_model_delete delete_fn; fn_model_id id_fn; fn_model_metas metas_fn; fn_json_free json_free; } VVModel;
typedef struct {
  VoicevoxSynthesizer *ptr;
  int32_t status;
  fn_error_message error_message;
  fn_json_free json_free;
  fn_wav_free wav_free;
  fn_synth_delete delete_fn;
  fn_synth_load_model load_model;
  fn_synth_unload_model unload_model;
  fn_synth_bool is_gpu;
  fn_synth_is_loaded is_loaded;
  fn_synth_metas metas;
  fn_synth_json_style create_audio_query;
  fn_synth_json_style create_audio_query_from_kana;
  fn_synth_json_style create_accent_phrases;
  fn_synth_json_style create_accent_phrases_from_kana;
  fn_synth_replace replace_mora_data;
  fn_synth_replace replace_phoneme_length;
  fn_synth_replace replace_mora_pitch;
  fn_synth_synthesis synthesis;
  fn_synth_tts tts;
  fn_synth_tts tts_from_kana;
} VVSynth;

static void vv_core_finalize(void *p) {
  (void)p;
  /* Keep the dynamic library loaded for the lifetime of the process. Child
     objects store function pointers into it and may be finalized after Core. */
}
static void vv_open_jtalk_finalize(void *p) { VVOpenJtalk *x = (VVOpenJtalk *)p; if (x->ptr && x->delete_fn) x->delete_fn(x->ptr); }
static void vv_model_finalize(void *p) { VVModel *x = (VVModel *)p; if (x->ptr && x->delete_fn) x->delete_fn(x->ptr); }
static void vv_synth_finalize(void *p) { VVSynth *x = (VVSynth *)p; if (x->ptr && x->delete_fn) x->delete_fn(x->ptr); }
static void vv_ort_finalize(void *p) { (void)p; }

static moonbit_bytes_t vv_bytes_from_buf(const uint8_t *buf, size_t len) {
  if (len > INT32_MAX) len = INT32_MAX;
  moonbit_bytes_t out = moonbit_make_bytes((int32_t)len, 0);
  if (len > 0 && buf) memcpy(out, buf, len);
  return out;
}

static moonbit_bytes_t vv_bytes_from_cstr(const char *s) {
  if (!s) s = "";
  return vv_bytes_from_buf((const uint8_t *)s, strlen(s));
}

static moonbit_bytes_t vv_bytes_from_json(char *s, fn_json_free free_fn) {
  moonbit_bytes_t out = vv_bytes_from_cstr(s);
  if (s && free_fn) free_fn(s);
  return out;
}

static const char *vv_optional_cstr(moonbit_bytes_t bytes) {
  if (!bytes || Moonbit_array_length(bytes) == 0) return NULL;
  return (const char *)bytes;
}

static const char *vv_result_message(fn_error_message f, int32_t code) {
  if (code < 0) return "MoonBit VOICEVOX FFI error";
  if (!f) return "VOICEVOX error";
  const char *msg = f(code);
  return msg ? msg : "VOICEVOX error";
}

#if defined(__unix__) || defined(__APPLE__)
static void *vv_sym(VVCore *c, const char *name, int required) {
  dlerror();
  void *sym = dlsym(c->lib, name);
  const char *err = dlerror();
  if ((!sym || err) && required && c->ok) {
    c->ok = 0;
    snprintf(c->error, sizeof(c->error), "missing symbol %s: %s", name, err ? err : "not found");
  }
  return sym;
}
#define VV_LOAD(field, name, type) c->field = (type)vv_sym(c, name, 1)
#define VV_LOAD_OPT(field, name, type) c->field = (type)vv_sym(c, name, 0)
#elif defined(_WIN32)
static void vv_windows_error(char *buf, size_t buf_len, const char *prefix) {
  DWORD err = GetLastError();
  char msg[384] = {0};
  FormatMessageA(
    FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
    NULL,
    err,
    0,
    msg,
    (DWORD)sizeof(msg),
    NULL
  );
  snprintf(buf, buf_len, "%s: %s", prefix, msg[0] ? msg : "Windows API error");
}

static HMODULE vv_load_library_utf8(const char *path, char *error, size_t error_len) {
  int wlen = MultiByteToWideChar(CP_UTF8, 0, path, -1, NULL, 0);
  if (wlen <= 0) {
    vv_windows_error(error, error_len, "invalid UTF-8 library path");
    return NULL;
  }
  WCHAR *wpath = (WCHAR *)malloc(sizeof(WCHAR) * (size_t)wlen);
  if (!wpath) {
    snprintf(error, error_len, "out of memory");
    return NULL;
  }
  MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, wlen);
  HMODULE handle = LoadLibraryW(wpath);
  free(wpath);
  if (!handle) vv_windows_error(error, error_len, "LoadLibraryW failed");
  return handle;
}

static void *vv_sym(VVCore *c, const char *name, int required) {
  void *sym = (void *)GetProcAddress((HMODULE)c->lib, name);
  if (!sym && required && c->ok) {
    c->ok = 0;
    vv_windows_error(c->error, sizeof(c->error), name);
  }
  return sym;
}
#define VV_LOAD(field, name, type) c->field = (type)vv_sym(c, name, 1)
#define VV_LOAD_OPT(field, name, type) c->field = (type)vv_sym(c, name, 0)
#endif

MOONBIT_FFI_EXPORT
VVCore *moonbit_voicevox_core_open(moonbit_bytes_t path) {
  VVCore *c = (VVCore *)moonbit_make_external_object(vv_core_finalize, sizeof(VVCore));
  memset(c, 0, sizeof(VVCore));
#if defined(__unix__) || defined(__APPLE__)
  c->lib = dlopen((const char *)path, RTLD_NOW | RTLD_LOCAL);
  if (!c->lib) {
    const char *e = dlerror();
    snprintf(c->error, sizeof(c->error), "%s", e ? e : "dlopen failed");
    return c;
  }
  c->ok = 1;
#elif defined(_WIN32)
  c->lib = (void *)vv_load_library_utf8((const char *)path, c->error, sizeof(c->error));
  if (!c->lib) return c;
  c->ok = 1;
#endif
#if defined(__unix__) || defined(__APPLE__) || defined(_WIN32)
  VV_LOAD(error_message, "voicevox_error_result_to_message", fn_error_message);
  VV_LOAD(json_free, "voicevox_json_free", fn_json_free);
  VV_LOAD(wav_free, "voicevox_wav_free", fn_wav_free);
  VV_LOAD(get_version, "voicevox_get_version", fn_cstr_void);
  VV_LOAD_OPT(get_ort_versioned_filename, "voicevox_get_onnxruntime_lib_versioned_filename", fn_cstr_void);
  VV_LOAD_OPT(get_ort_unversioned_filename, "voicevox_get_onnxruntime_lib_unversioned_filename", fn_cstr_void);
  VV_LOAD_OPT(default_load_ort, "voicevox_make_default_load_onnxruntime_options", fn_default_load_ort);
  VV_LOAD_OPT(ort_load_once, "voicevox_onnxruntime_load_once", fn_ort_load_once);
  VV_LOAD_OPT(ort_init_once, "voicevox_onnxruntime_init_once", fn_ort_init_once);
  VV_LOAD_OPT(ort_get, "voicevox_onnxruntime_get", fn_ort_get);
  if (!c->ort_load_once && !c->ort_init_once && !c->ort_get && c->ok) {
    c->ok = 0;
    snprintf(c->error, sizeof(c->error), "missing symbol voicevox_onnxruntime_load_once, voicevox_onnxruntime_init_once, or voicevox_onnxruntime_get");
  }
  VV_LOAD(open_jtalk_new, "voicevox_open_jtalk_rc_new", fn_open_jtalk_new);
  VV_LOAD(open_jtalk_delete, "voicevox_open_jtalk_rc_delete", fn_open_jtalk_delete);
  VV_LOAD(open_jtalk_analyze, "voicevox_open_jtalk_rc_analyze", fn_open_jtalk_analyze);
  VV_LOAD(model_open, "voicevox_voice_model_file_open", fn_model_open);
  VV_LOAD(model_delete, "voicevox_voice_model_file_delete", fn_model_delete);
  VV_LOAD(model_id, "voicevox_voice_model_file_id", fn_model_id);
  VV_LOAD(model_metas, "voicevox_voice_model_file_create_metas_json", fn_model_metas);
  VV_LOAD(synth_new, "voicevox_synthesizer_new", fn_synth_new);
  VV_LOAD(synth_delete, "voicevox_synthesizer_delete", fn_synth_delete);
  VV_LOAD(synth_load_model, "voicevox_synthesizer_load_voice_model", fn_synth_load_model);
  VV_LOAD(synth_unload_model, "voicevox_synthesizer_unload_voice_model", fn_synth_unload_model);
  VV_LOAD(synth_is_gpu, "voicevox_synthesizer_is_gpu_mode", fn_synth_bool);
  VV_LOAD(synth_is_loaded, "voicevox_synthesizer_is_loaded_voice_model", fn_synth_is_loaded);
  VV_LOAD(synth_metas, "voicevox_synthesizer_create_metas_json", fn_synth_metas);
  VV_LOAD(ort_supported_devices, "voicevox_onnxruntime_create_supported_devices_json", fn_ort_supported_devices);
  VV_LOAD(create_audio_query, "voicevox_synthesizer_create_audio_query", fn_synth_json_style);
  VV_LOAD(create_audio_query_from_kana, "voicevox_synthesizer_create_audio_query_from_kana", fn_synth_json_style);
  VV_LOAD(create_accent_phrases, "voicevox_synthesizer_create_accent_phrases", fn_synth_json_style);
  VV_LOAD(create_accent_phrases_from_kana, "voicevox_synthesizer_create_accent_phrases_from_kana", fn_synth_json_style);
  VV_LOAD(replace_mora_data, "voicevox_synthesizer_replace_mora_data", fn_synth_replace);
  VV_LOAD(replace_phoneme_length, "voicevox_synthesizer_replace_phoneme_length", fn_synth_replace);
  VV_LOAD(replace_mora_pitch, "voicevox_synthesizer_replace_mora_pitch", fn_synth_replace);
  VV_LOAD(synthesis, "voicevox_synthesizer_synthesis", fn_synth_synthesis);
  VV_LOAD(tts, "voicevox_synthesizer_tts", fn_synth_tts);
  VV_LOAD(tts_from_kana, "voicevox_synthesizer_tts_from_kana", fn_synth_tts);
  VV_LOAD(audio_query_validate, "voicevox_audio_query_validate", fn_validate);
  VV_LOAD(accent_phrase_validate, "voicevox_accent_phrase_validate", fn_validate);
  VV_LOAD(mora_validate, "voicevox_mora_validate", fn_validate);
  VV_LOAD(score_validate, "voicevox_score_validate", fn_validate);
  VV_LOAD(note_validate, "voicevox_note_validate", fn_validate);
  VV_LOAD(frame_audio_query_validate, "voicevox_frame_audio_query_validate", fn_validate);
  VV_LOAD(frame_phoneme_validate, "voicevox_frame_phoneme_validate", fn_validate);
  VV_LOAD(audio_query_from_accent_phrases, "voicevox_audio_query_create_from_accent_phrases", fn_audio_query_from_accent);
#else
  snprintf(c->error, sizeof(c->error), "dynamic loading is not implemented for this platform");
#endif
  return c;
}

MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_core_ok(VVCore *c) { return c && c->ok; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_core_status(VVCore *c) { return c ? c->last_status : -1; }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_core_error(VVCore *c) { return vv_bytes_from_cstr(c ? c->error : "null Core"); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_core_error_message(VVCore *c, int32_t code) { return vv_bytes_from_cstr(vv_result_message(c ? c->error_message : NULL, code)); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_core_version(VVCore *c) { return vv_bytes_from_cstr(c && c->get_version ? c->get_version() : ""); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_core_onnxruntime_versioned_filename(VVCore *c) { return vv_bytes_from_cstr(c && c->get_ort_versioned_filename ? c->get_ort_versioned_filename() : ""); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_core_onnxruntime_unversioned_filename(VVCore *c) { return vv_bytes_from_cstr(c && c->get_ort_unversioned_filename ? c->get_ort_unversioned_filename() : ""); }

MOONBIT_FFI_EXPORT
VVOrt *moonbit_voicevox_onnxruntime_load_once(VVCore *c, moonbit_bytes_t filename) {
  VVOrt *o = (VVOrt *)moonbit_make_external_object(vv_ort_finalize, sizeof(VVOrt));
  memset(o, 0, sizeof(VVOrt));
  o->status = -1;
  if (!c || !c->ok) return o;
  o->error_message = c->error_message;
  o->supported_devices = c->ort_supported_devices;
  o->json_free = c->json_free;
  if (c->ort_load_once) {
    VoicevoxLoadOnnxruntimeOptions opt;
    if (c->default_load_ort) opt = c->default_load_ort(); else opt.filename = NULL;
    const char *custom = vv_optional_cstr(filename);
    if (custom) opt.filename = custom;
    o->status = c->ort_load_once(opt, &o->ptr);
  } else if (c->ort_init_once) {
    o->status = c->ort_init_once(&o->ptr);
  } else if (c->ort_get) {
    o->ptr = c->ort_get();
    o->status = o->ptr ? 0 : -1;
  }
  return o;
}

MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_onnxruntime_status(VVOrt *o) { return o ? o->status : -1; }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_onnxruntime_error_message(VVOrt *o, int32_t code) { return vv_bytes_from_cstr(vv_result_message(o ? o->error_message : NULL, code)); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_onnxruntime_supported_devices_json(VVOrt *o) {
  char *json = NULL;
  if (!o || !o->ptr || !o->supported_devices) { if (o) o->status = -1; return vv_bytes_from_cstr(""); }
  o->status = o->supported_devices(o->ptr, &json);
  return vv_bytes_from_json(json, o->json_free);
}

MOONBIT_FFI_EXPORT
VVOpenJtalk *moonbit_voicevox_open_jtalk_new(VVCore *c, moonbit_bytes_t dict_dir) {
  VVOpenJtalk *j = (VVOpenJtalk *)moonbit_make_external_object(vv_open_jtalk_finalize, sizeof(VVOpenJtalk));
  memset(j, 0, sizeof(VVOpenJtalk));
  j->status = -1;
  if (!c || !c->ok) return j;
  j->error_message = c->error_message;
  j->delete_fn = c->open_jtalk_delete;
  j->analyze = c->open_jtalk_analyze;
  j->json_free = c->json_free;
  j->status = c->open_jtalk_new((const char *)dict_dir, &j->ptr);
  return j;
}
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_open_jtalk_status(VVOpenJtalk *j) { return j ? j->status : -1; }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_open_jtalk_error_message(VVOpenJtalk *j, int32_t code) { return vv_bytes_from_cstr(vv_result_message(j ? j->error_message : NULL, code)); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_open_jtalk_analyze(VVOpenJtalk *j, moonbit_bytes_t text) {
  char *json = NULL;
  if (!j || !j->ptr || !j->analyze) { if (j) j->status = -1; return vv_bytes_from_cstr(""); }
  j->status = j->analyze(j->ptr, (const char *)text, &json);
  return vv_bytes_from_json(json, j->json_free);
}

MOONBIT_FFI_EXPORT
VVModel *moonbit_voicevox_voice_model_open(VVCore *c, moonbit_bytes_t path) {
  VVModel *m = (VVModel *)moonbit_make_external_object(vv_model_finalize, sizeof(VVModel));
  memset(m, 0, sizeof(VVModel));
  m->status = -1;
  if (!c || !c->ok) return m;
  m->error_message = c->error_message;
  m->delete_fn = c->model_delete;
  m->id_fn = c->model_id;
  m->metas_fn = c->model_metas;
  m->json_free = c->json_free;
  m->status = c->model_open((const char *)path, &m->ptr);
  return m;
}
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_voice_model_status(VVModel *m) { return m ? m->status : -1; }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_voice_model_error_message(VVModel *m, int32_t code) { return vv_bytes_from_cstr(vv_result_message(m ? m->error_message : NULL, code)); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_voice_model_id(VVModel *m) {
  uint8_t id[16] = {0};
  if (!m || !m->ptr || !m->id_fn) { if (m) m->status = -1; return vv_bytes_from_buf(id, 0); }
  m->id_fn(m->ptr, &id);
  m->status = 0;
  return vv_bytes_from_buf(id, 16);
}
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_voice_model_metas_json(VVModel *m) {
  if (!m || !m->ptr || !m->metas_fn) { if (m) m->status = -1; return vv_bytes_from_cstr(""); }
  char *json = m->metas_fn(m->ptr);
  m->status = json ? 0 : -1;
  return vv_bytes_from_json(json, m->json_free);
}

MOONBIT_FFI_EXPORT
VVSynth *moonbit_voicevox_synthesizer_new(VVCore *c, VVOrt *o, VVOpenJtalk *j, int32_t acceleration_mode, int32_t cpu_num_threads) {
  VVSynth *s = (VVSynth *)moonbit_make_external_object(vv_synth_finalize, sizeof(VVSynth));
  memset(s, 0, sizeof(VVSynth));
  s->status = -1;
  if (!c || !c->ok || !o || !o->ptr || !j || !j->ptr) return s;
  s->error_message = c->error_message;
  s->json_free = c->json_free;
  s->wav_free = c->wav_free;
  s->delete_fn = c->synth_delete;
  s->load_model = c->synth_load_model;
  s->unload_model = c->synth_unload_model;
  s->is_gpu = c->synth_is_gpu;
  s->is_loaded = c->synth_is_loaded;
  s->metas = c->synth_metas;
  s->create_audio_query = c->create_audio_query;
  s->create_audio_query_from_kana = c->create_audio_query_from_kana;
  s->create_accent_phrases = c->create_accent_phrases;
  s->create_accent_phrases_from_kana = c->create_accent_phrases_from_kana;
  s->replace_mora_data = c->replace_mora_data;
  s->replace_phoneme_length = c->replace_phoneme_length;
  s->replace_mora_pitch = c->replace_mora_pitch;
  s->synthesis = c->synthesis;
  s->tts = c->tts;
  s->tts_from_kana = c->tts_from_kana;
  VoicevoxInitializeOptions opt = { acceleration_mode, (uint16_t)cpu_num_threads };
  s->status = c->synth_new(o->ptr, j->ptr, opt, &s->ptr);
  return s;
}
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_synthesizer_status(VVSynth *s) { return s ? s->status : -1; }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_error_message(VVSynth *s, int32_t code) { return vv_bytes_from_cstr(vv_result_message(s ? s->error_message : NULL, code)); }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_synthesizer_load_voice_model(VVSynth *s, VVModel *m, int32_t on_existing) {
  if (!s || !s->ptr || !m || !m->ptr || !s->load_model) return -1;
  VoicevoxLoadVoiceModelOptions opt = { on_existing };
  return s->load_model(s->ptr, m->ptr, opt);
}
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_synthesizer_unload_voice_model(VVSynth *s, moonbit_bytes_t model_id) {
  if (!s || !s->ptr || !s->unload_model || !model_id || Moonbit_array_length(model_id) != 16) return -1;
  return s->unload_model(s->ptr, (VoicevoxVoiceModelId)model_id);
}
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_synthesizer_is_gpu_mode(VVSynth *s) { return s && s->ptr && s->is_gpu ? s->is_gpu(s->ptr) : 0; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_synthesizer_is_loaded_voice_model(VVSynth *s, moonbit_bytes_t model_id) {
  if (!s || !s->ptr || !s->is_loaded || !model_id || Moonbit_array_length(model_id) != 16) return 0;
  return s->is_loaded(s->ptr, (VoicevoxVoiceModelId)model_id);
}
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_metas_json(VVSynth *s) {
  if (!s || !s->ptr || !s->metas) { if (s) s->status = -1; return vv_bytes_from_cstr(""); }
  char *json = s->metas(s->ptr);
  s->status = json ? 0 : -1;
  return vv_bytes_from_json(json, s->json_free);
}

static moonbit_bytes_t vv_synth_json_call(VVSynth *s, fn_synth_json_style f, moonbit_bytes_t text, uint32_t style_id) {
  char *json = NULL;
  if (!s || !s->ptr || !f) { if (s) s->status = -1; return vv_bytes_from_cstr(""); }
  s->status = f(s->ptr, (const char *)text, style_id, &json);
  return vv_bytes_from_json(json, s->json_free);
}
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_create_audio_query(VVSynth *s, moonbit_bytes_t text, uint32_t style_id) { return vv_synth_json_call(s, s ? s->create_audio_query : NULL, text, style_id); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_create_audio_query_from_kana(VVSynth *s, moonbit_bytes_t kana, uint32_t style_id) { return vv_synth_json_call(s, s ? s->create_audio_query_from_kana : NULL, kana, style_id); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_create_accent_phrases(VVSynth *s, moonbit_bytes_t text, uint32_t style_id) { return vv_synth_json_call(s, s ? s->create_accent_phrases : NULL, text, style_id); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_create_accent_phrases_from_kana(VVSynth *s, moonbit_bytes_t kana, uint32_t style_id) { return vv_synth_json_call(s, s ? s->create_accent_phrases_from_kana : NULL, kana, style_id); }

static moonbit_bytes_t vv_synth_replace_call(VVSynth *s, fn_synth_replace f, moonbit_bytes_t json_in, uint32_t style_id) {
  char *json = NULL;
  if (!s || !s->ptr || !f) { if (s) s->status = -1; return vv_bytes_from_cstr(""); }
  s->status = f(s->ptr, (const char *)json_in, style_id, &json);
  return vv_bytes_from_json(json, s->json_free);
}
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_replace_mora_data(VVSynth *s, moonbit_bytes_t accent_json, uint32_t style_id) { return vv_synth_replace_call(s, s ? s->replace_mora_data : NULL, accent_json, style_id); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_replace_phoneme_length(VVSynth *s, moonbit_bytes_t accent_json, uint32_t style_id) { return vv_synth_replace_call(s, s ? s->replace_phoneme_length : NULL, accent_json, style_id); }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_replace_mora_pitch(VVSynth *s, moonbit_bytes_t accent_json, uint32_t style_id) { return vv_synth_replace_call(s, s ? s->replace_mora_pitch : NULL, accent_json, style_id); }

MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_synthesis(VVSynth *s, moonbit_bytes_t audio_query_json, uint32_t style_id, int32_t enable_interrogative_upspeak) {
  uintptr_t len = 0; uint8_t *wav = NULL;
  if (!s || !s->ptr || !s->synthesis) { if (s) s->status = -1; return vv_bytes_from_cstr(""); }
  VoicevoxSynthesisOptions opt = { enable_interrogative_upspeak != 0 };
  s->status = s->synthesis(s->ptr, (const char *)audio_query_json, style_id, opt, &len, &wav);
  moonbit_bytes_t out = s->status == 0 ? vv_bytes_from_buf(wav, len) : vv_bytes_from_cstr("");
  if (wav && s->wav_free) s->wav_free(wav);
  return out;
}
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_tts(VVSynth *s, moonbit_bytes_t text, uint32_t style_id, int32_t enable_interrogative_upspeak) {
  uintptr_t len = 0; uint8_t *wav = NULL;
  if (!s || !s->ptr || !s->tts) { if (s) s->status = -1; return vv_bytes_from_cstr(""); }
  VoicevoxTtsOptions opt = { enable_interrogative_upspeak != 0 };
  s->status = s->tts(s->ptr, (const char *)text, style_id, opt, &len, &wav);
  moonbit_bytes_t out = s->status == 0 ? vv_bytes_from_buf(wav, len) : vv_bytes_from_cstr("");
  if (wav && s->wav_free) s->wav_free(wav);
  return out;
}
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_synthesizer_tts_from_kana(VVSynth *s, moonbit_bytes_t kana, uint32_t style_id, int32_t enable_interrogative_upspeak) {
  uintptr_t len = 0; uint8_t *wav = NULL;
  if (!s || !s->ptr || !s->tts_from_kana) { if (s) s->status = -1; return vv_bytes_from_cstr(""); }
  VoicevoxTtsOptions opt = { enable_interrogative_upspeak != 0 };
  s->status = s->tts_from_kana(s->ptr, (const char *)kana, style_id, opt, &len, &wav);
  moonbit_bytes_t out = s->status == 0 ? vv_bytes_from_buf(wav, len) : vv_bytes_from_cstr("");
  if (wav && s->wav_free) s->wav_free(wav);
  return out;
}

MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_audio_query_validate(VVCore *c, moonbit_bytes_t json) { return c && c->audio_query_validate ? c->audio_query_validate((const char *)json) : -1; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_accent_phrase_validate(VVCore *c, moonbit_bytes_t json) { return c && c->accent_phrase_validate ? c->accent_phrase_validate((const char *)json) : -1; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_mora_validate(VVCore *c, moonbit_bytes_t json) { return c && c->mora_validate ? c->mora_validate((const char *)json) : -1; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_score_validate(VVCore *c, moonbit_bytes_t json) { return c && c->score_validate ? c->score_validate((const char *)json) : -1; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_note_validate(VVCore *c, moonbit_bytes_t json) { return c && c->note_validate ? c->note_validate((const char *)json) : -1; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_frame_audio_query_validate(VVCore *c, moonbit_bytes_t json) { return c && c->frame_audio_query_validate ? c->frame_audio_query_validate((const char *)json) : -1; }
MOONBIT_FFI_EXPORT int32_t moonbit_voicevox_frame_phoneme_validate(VVCore *c, moonbit_bytes_t json) { return c && c->frame_phoneme_validate ? c->frame_phoneme_validate((const char *)json) : -1; }
MOONBIT_FFI_EXPORT moonbit_bytes_t moonbit_voicevox_audio_query_create_from_accent_phrases(VVCore *c, moonbit_bytes_t accent_json) {
  char *json = NULL;
  if (!c || !c->audio_query_from_accent_phrases) {
    if (c) c->last_status = -1;
    return vv_bytes_from_cstr("");
  }
  c->last_status = c->audio_query_from_accent_phrases((const char *)accent_json, &json);
  return vv_bytes_from_json(json, c->json_free);
}
