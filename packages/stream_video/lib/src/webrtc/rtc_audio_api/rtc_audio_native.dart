import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

void startAudio(String id, rtc.MediaStreamTrack track) {
  // We don't need to do anything here, because the audio automatically starts
  // in native platforms.
}

void stopAudio(String id) {
  // We don't need to do anything here, because the audio automatically stops
  // in native platforms.
}

void setSinkId(String id, String deviceId) {
  // We don't need to do anything here, because sinkId is only supported in
  // web platforms.
}

bool checkIfAudioOutputChangeSupported() {
  // On native platforms, we assume audio output change is supported.
  return true;
}
