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
pub(all) struct InitializeOptions {
  priv acceleration_mode : AccelerationMode
  priv cpu_num_threads : Int
} derive(Debug, Eq)

///|
pub fn InitializeOptions::InitializeOptions(
  acceleration_mode? : AccelerationMode = Auto,
  cpu_num_threads? : Int = 0,
) -> InitializeOptions raise VoicevoxError {
  validate_cpu_num_threads(cpu_num_threads)
  { acceleration_mode, cpu_num_threads }
}

///|
pub fn InitializeOptions::default() -> InitializeOptions {
  { acceleration_mode: Auto, cpu_num_threads: 0 }
}

///|
pub fn InitializeOptions::acceleration_mode(
  self : InitializeOptions,
) -> AccelerationMode {
  self.acceleration_mode
}

///|
pub fn InitializeOptions::cpu_num_threads(self : InitializeOptions) -> Int {
  self.cpu_num_threads
}

///|
fn validate_cpu_num_threads(value : Int) -> Unit raise VoicevoxError {
  guard value >= 0 && value <= 65535 else { raise InvalidCpuNumThreads(value) }
}

///|
pub(all) struct LoadVoiceModelOptions {
  priv on_existing : OnExistingVoiceModelId
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
pub fn LoadVoiceModelOptions::on_existing(
  self : LoadVoiceModelOptions,
) -> OnExistingVoiceModelId {
  self.on_existing
}

///|
pub(all) struct SynthesisOptions {
  priv enable_interrogative_upspeak : Bool
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
pub fn SynthesisOptions::enable_interrogative_upspeak(
  self : SynthesisOptions,
) -> Bool {
  self.enable_interrogative_upspeak
}

///|
pub(all) struct TtsOptions {
  priv enable_interrogative_upspeak : Bool
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
pub fn TtsOptions::enable_interrogative_upspeak(self : TtsOptions) -> Bool {
  self.enable_interrogative_upspeak
}

///|
pub struct VoiceModelId(Bytes) derive(Eq, Debug)

///|
pub(all) suberror VoicevoxError {
  LibraryLoadError(String)
  ApiError(code~ : Int, message~ : String)
  InvalidVoiceModelIdLength(Int)
  InvalidCpuNumThreads(Int)
  WriteFileError(String)
} derive(Debug, Eq)
