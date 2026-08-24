import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

typedef AudioTraceHandler = void Function(String tag, Object? data);

/// Never emits: only browsers block playback via an autoplay policy.
Stream<bool> get audioPlaybackBlockedChanges => const Stream.empty();

void setAudioTraceHandler(AudioTraceHandler? handler) {
  // We don't need to do anything here, because there is no audio tracing on native platforms.
}

void startAudio(String id, rtc.MediaStreamTrack track) {
  // We don't need to do anything here, because the audio automatically starts
  // in native platforms.
}

void stopAudio(String id) {
  // We don't need to do anything here, because the audio automatically stops
  // in native platforms.
}

Future<void> setSinkId(String id, String deviceId) async {
  // We don't need to do anything here, because sinkId is only supported in
  // web platforms.
}

Future<void> resumeAudioPlayback() async {
  // We don't need to do anything here, because there is no autoplay policy
  // blocking playback on native platforms.
}

bool checkIfAudioOutputChangeSupported() {
  // On native platforms, we assume audio output change is supported.
  return true;
}
