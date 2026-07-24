import 'audio_recognition.dart';
import 'audio_recognition_webrtc.dart';

/// Native platforms receive speech-activity events from the audio device
/// module through the webrtc plugin. The audio device module already captures
/// the selected input device, so [audioInputDeviceIdProvider] is unused here.
AudioRecognition createPlatformAudioRecognition({
  String? Function()? audioInputDeviceIdProvider,
}) => AudioRecognitionWebRTC();
