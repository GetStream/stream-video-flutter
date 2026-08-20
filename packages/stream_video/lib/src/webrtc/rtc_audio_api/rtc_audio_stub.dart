import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// Signature of the sink the web audio layer reports playback traces to.
typedef AudioTraceHandler = void Function(String tag, Object? data);

void setAudioTraceHandler(AudioTraceHandler? handler) {
  throw UnimplementedError();
}

void startAudio(String id, rtc.MediaStreamTrack track) {
  throw UnimplementedError();
}

void stopAudio(String id) {
  throw UnimplementedError();
}

Future<void> setSinkId(String id, String deviceId) {
  throw UnimplementedError();
}

Future<void> resumeAudioPlayback() {
  throw UnimplementedError();
}

bool get isAudioPlaybackBlocked => throw UnimplementedError();

bool get isAudioPlaybackStalled => throw UnimplementedError();

bool checkIfAudioOutputChangeSupported() {
  throw UnimplementedError();
}
