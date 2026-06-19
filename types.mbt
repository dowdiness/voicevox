///|
pub(all) enum AccelerationMode {
  Auto
  Cpu
  Gpu
} derive(Debug, Eq)

///|
fn AccelerationMode::to_int(self : AccelerationMode) -> Int {
  match self {
    Auto => 0
    Cpu => 1
    Gpu => 2
  }
}

///|
pub(all) enum OnExistingVoiceModelId {
  ExistingError
  Reload
  Skip
} derive(Debug, Eq)

///|
fn OnExistingVoiceModelId::to_int(self : OnExistingVoiceModelId) -> Int {
  match self {
    ExistingError => 0
    Reload => 1
    Skip => 2
  }
}

///|
pub struct InitializeOptions {
  acceleration_mode : AccelerationMode
  cpu_num_threads : Int
} derive(Debug, Eq)

///|
pub fn InitializeOptions::InitializeOptions(
  acceleration_mode? : AccelerationMode = Auto,
  cpu_num_threads? : Int = 0,
) -> InitializeOptions {
  { acceleration_mode, cpu_num_threads }
}

///|
pub fn InitializeOptions::default() -> InitializeOptions {
  InitializeOptions()
}

///|
pub struct LoadVoiceModelOptions {
  on_existing : OnExistingVoiceModelId
} derive(Debug, Eq)

///|
pub fn LoadVoiceModelOptions::LoadVoiceModelOptions(
  on_existing? : OnExistingVoiceModelId = ExistingError,
) -> LoadVoiceModelOptions {
  { on_existing, }
}

///|
pub fn LoadVoiceModelOptions::default() -> LoadVoiceModelOptions {
  LoadVoiceModelOptions()
}

///|
pub struct SynthesisOptions {
  enable_interrogative_upspeak : Bool
} derive(Debug, Eq)

///|
pub fn SynthesisOptions::SynthesisOptions(
  enable_interrogative_upspeak? : Bool = true,
) -> SynthesisOptions {
  { enable_interrogative_upspeak, }
}

///|
pub fn SynthesisOptions::default() -> SynthesisOptions {
  SynthesisOptions()
}

///|
pub struct TtsOptions {
  enable_interrogative_upspeak : Bool
} derive(Debug, Eq)

///|
pub fn TtsOptions::TtsOptions(
  enable_interrogative_upspeak? : Bool = true,
) -> TtsOptions {
  { enable_interrogative_upspeak, }
}

///|
pub fn TtsOptions::default() -> TtsOptions {
  TtsOptions()
}

///|
pub struct VoiceModelId(Bytes) derive(Eq, Debug)

///|
pub(all) suberror VoicevoxError {
  LibraryLoadError(String)
  ApiError(code~ : Int, message~ : String)
  InvalidVoiceModelIdLength(Int)
  WriteFileError(String)
} derive(Debug, Eq)
