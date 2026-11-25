import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import 'speech_activity_detector.dart';
import 'web_audio_level_source.dart';

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// The [WebRtcPlatformEvents] of the browser: speech activity while detection
/// runs; every other stream is empty.
@internal
class DartWebRtcPlatformEvents implements WebRtcPlatformEvents {
  DartWebRtcPlatformEvents._();

  static final DartWebRtcPlatformEvents instance = DartWebRtcPlatformEvents._();

  late final _speechDetector = SpeechActivityDetector(
    WebAudioLevelSource(),
  );

  @override
  Stream<AudioRoute> get onAudioRouteChanged => const Stream.empty();

  @override
  Stream<SpeechActivity> get onSpeechActivity => _speechDetector.activity;

  @override
  Future<void> startSpeechActivityDetection({String? deviceId}) {
    return _speechDetector.start(deviceId: deviceId);
  }

  @override
  Future<void> stopSpeechActivityDetection() => _speechDetector.stop();

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
