import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// Signature of the sink the web audio layer reports playback traces to.
typedef AudioTraceHandler = void Function(String tag, Object? data);

Stream<bool> get audioPlaybackBlockedChanges => throw UnimplementedError();

void setAudioTraceHandler(AudioTraceHandler? handler) {
  throw UnimplementedError();
}

void startAudio(String id, rtc.MediaStreamTrack track) {
  throw UnimplementedError();
}

void stopAudio(String id, rtc.MediaStreamTrack track) {
  throw UnimplementedError();
}

Future<void> setSinkId(String id, String deviceId) {
  throw UnimplementedError();
}

Future<void> resumeAudioPlayback() {
  throw UnimplementedError();
}

bool needsRemoteAudioReattach() {
  throw UnimplementedError();
}

Future<void> reattachRemoteAudio({required String reason}) {
  throw UnimplementedError();
}

bool checkIfAudioOutputChangeSupported() {
  throw UnimplementedError();
}

void setAudioPlayoutPaused({required bool paused}) {
  throw UnimplementedError();
}
