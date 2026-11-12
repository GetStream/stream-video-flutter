import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// The browser reports none of the [WebRtcPlatformEvents]: every stream is
/// empty.
class DartWebRtcPlatformEvents implements WebRtcPlatformEvents {
  DartWebRtcPlatformEvents._();

  static final DartWebRtcPlatformEvents instance = DartWebRtcPlatformEvents._();

  @override
  Stream<AudioRoute> get onAudioRouteChanged => const Stream.empty();

  @override
  Stream<SpeechActivity> get onSpeechActivity => const Stream.empty();

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
  Future<void> enableInterruptionEvents({
    AndroidInterruptionSource androidInterruptionSource =
        AndroidInterruptionSource.audioFocusAndTelephony,
  }) {
    throw UnimplementedError('Audio interruptions are not reported on web');
  }
}

/// The platform events of the browser.
WebRtcPlatformEvents get platformEvents => DartWebRtcPlatformEvents.instance;
