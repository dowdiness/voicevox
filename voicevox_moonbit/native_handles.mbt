///|
type CoreHandle

///|
type OnnxruntimeHandle

///|
type OpenJtalkHandle

///|
type VoiceModelFileHandle

///|
type SynthesizerHandle

///|
pub(all) struct Core {
  priv handle : CoreHandle
}

///|
pub(all) struct Onnxruntime {
  priv handle : OnnxruntimeHandle
}

///|
pub(all) struct OpenJtalk {
  priv handle : OpenJtalkHandle
}

///|
pub(all) struct VoiceModelFile {
  priv handle : VoiceModelFileHandle
}

///|
pub(all) struct Synthesizer {
  priv handle : SynthesizerHandle
}
