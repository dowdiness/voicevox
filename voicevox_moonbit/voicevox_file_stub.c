#include <moonbit.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static char voicevox_write_file_error[512];

static moonbit_bytes_t voicevox_file_bytes_from_cstr(const char *s) {
  if (!s) {
    s = "";
  }
  int32_t len = (int32_t)strlen(s);
  moonbit_bytes_t out = moonbit_make_bytes(len, 0);
  memcpy(out, s, len);
  return out;
}

MOONBIT_FFI_EXPORT
int32_t moonbit_voicevox_write_wav_file(moonbit_bytes_t path, moonbit_bytes_t contents) {
  voicevox_write_file_error[0] = 0;
  FILE *file = fopen((const char *)path, "wb");
  if (!file) {
    snprintf(
      voicevox_write_file_error,
      sizeof(voicevox_write_file_error),
      "%s: %s",
      (const char *)path,
      strerror(errno)
    );
    return -1;
  }

  size_t len = (size_t)Moonbit_array_length(contents);
  size_t written = fwrite(contents, 1, len, file);
  if (written != len) {
    snprintf(
      voicevox_write_file_error,
      sizeof(voicevox_write_file_error),
      "%s: short write",
      (const char *)path
    );
    fclose(file);
    return -1;
  }

  if (fclose(file) != 0) {
    snprintf(
      voicevox_write_file_error,
      sizeof(voicevox_write_file_error),
      "%s: %s",
      (const char *)path,
      strerror(errno)
    );
    return -1;
  }
  return 0;
}

MOONBIT_FFI_EXPORT
moonbit_bytes_t moonbit_voicevox_write_wav_file_error(void) {
  return voicevox_file_bytes_from_cstr(voicevox_write_file_error);
}
