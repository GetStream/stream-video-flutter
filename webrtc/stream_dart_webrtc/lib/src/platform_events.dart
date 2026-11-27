import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import 'speech_activity_detector.dart';
import 'web_audio_level_source.dart';

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// The [WebRtcPlatformEvents] of the browser: speech detectors on microphone
/// captures of their own; every stream is empty.
@internal
class DartWebRtcPlatformEvents implements WebRtcPlatformEvents {
  DartWebRtcPlatformEvents._();

  static final DartWebRtcPlatformEvents instance = DartWebRtcPlatformEvents._();

  @override
  Stream<AudioRoute> get onAudioRouteChanged => const Stream.empty();

  @override
  Stream<SpeechActivity> get onSpeechActivity => const Stream.empty();

  @override
  SpeechActivityDetector createSpeechActivityDetector() {
    return SampledSpeechActivityDetector(openWebAudioLevelCapture);
  }

  @override
  Stream<AudioProcessingState> get onAudioProcessingStateChanged =>
      const Stream.empty();

  @override
  Stream<void> get onScreenSharingStarted => const Stream.empty();

  @override
  Stream<ScreenSharingStopped> get onScreenSharingStopped =>
      const Stream.empty();

  @override
  Stream<AudioInterruption> get onInterruption => const Stream.empty();

  @override
  Future<void> enableInterruptionEvents() {
    throw UnimplementedError('Audio interruptions are not reported on web');
  }
}

/// The platform events of the browser.
WebRtcPlatformEvents get platformEvents => DartWebRtcPlatformEvents.instance;
