import 'package:meta/meta.dart';

import 'platform_events.dart';

/// Detects the local user's speech while the microphone is muted.
///
/// Every detector runs on its own: starting or stopping one leaves the others
/// running. Created by [WebRtcPlatformEvents.createSpeechActivityDetector].
///
/// Implemented by the WebRTC packages only.
@sealed
abstract class SpeechActivityDetector {
  /// The speech transitions while detection runs. A broadcast stream.
  Stream<SpeechActivity> get activity;

  /// Starts detecting speech on the microphone [deviceId], or the default
  /// microphone when it is null. Does nothing while detection runs. Throws
  /// when the microphone cannot be opened.
  ///
  /// In the browser this opens a microphone capture of its own, which keeps
  /// the browser's microphone indicator on. Android, iOS and macOS report
  /// speech from the audio device module and ignore [deviceId].
  Future<void> start({String? deviceId});

  /// Stops detecting and releases the capture [start] opened. Reports
  /// [SpeechActivity.ended] when speech was ongoing. Does nothing when
  /// detection is not running.
  Future<void> stop();
}
