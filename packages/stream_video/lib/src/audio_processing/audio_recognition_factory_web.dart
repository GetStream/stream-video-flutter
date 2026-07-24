import 'audio_recognition.dart';
import 'audio_recognition_web_audio.dart';

/// Browsers deliver no audio-device-module speech-activity events, so web
/// falls back to a Web Audio API analyser over a dedicated microphone stream.
/// [audioInputDeviceIdProvider] resolves the microphone to monitor at each
/// detection start.
AudioRecognition createPlatformAudioRecognition({
  String? Function()? audioInputDeviceIdProvider,
}) => AudioRecognitionWebAudio(deviceIdProvider: audioInputDeviceIdProvider);
