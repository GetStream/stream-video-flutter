import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

final _logger = Logger('SpeechActivityDetector');

/// Opens a capture of the microphone [deviceId], or the default microphone
/// when it is null, whose loudness can be sampled. Releases whatever it opened
/// before throwing.
@internal
typedef AudioLevelSource =
    Future<AudioLevelCapture> Function({String? deviceId});

/// A microphone capture opened by an [AudioLevelSource].
@internal
abstract interface class AudioLevelCapture {
  /// The loudest frequency bin of the capture right now, from 0 to 255.
  int sample();

  /// Releases the capture.
  Future<void> close();
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// A [SpeechActivityDetector] that samples an [AudioLevelCapture] on a timer.
///
/// Reports each transition once on [activity]: [SpeechActivity.started] on the
/// first sample at or above [audioLevelThreshold], [SpeechActivity.ended] on
/// the first one below it. A sample that throws stops the sampling.
@internal
class SampledSpeechActivityDetector implements SpeechActivityDetector {
  SampledSpeechActivityDetector(
    this._openCapture, {
    this.detectionInterval = const Duration(milliseconds: 500),
    this.audioLevelThreshold = 150,
  });

  final AudioLevelSource _openCapture;

  /// How often the capture is sampled.
  final Duration detectionInterval;

  /// A sample at or above this value (0 to 255) counts as speech.
  final int audioLevelThreshold;

  final _activity = StreamController<SpeechActivity>.broadcast();

  @override
  Stream<SpeechActivity> get activity => _activity.stream;

  Timer? _detectionTimer;
  AudioLevelCapture? _capture;
  bool _isSpeaking = false;
  bool _started = false;

  /// Bumped on every [stop], so a [start] still opening its capture can tell
  /// it was cancelled.
  int _generation = 0;

  @override
  Future<void> start({String? deviceId}) async {
    if (_started) return;
    _started = true;
    final generation = _generation;

    final AudioLevelCapture capture;
    try {
      capture = await _openCapture(deviceId: deviceId);
    } catch (_) {
      if (generation == _generation) _started = false;
      rethrow;
    }

    if (generation != _generation) {
      // Stopped while the capture was opening.
      await capture.close();
      return;
    }

    _capture = capture;
    _detectionTimer = Timer.periodic(detectionInterval, (_) => _sample());
  }

  void _sample() {
    final capture = _capture;
    if (capture == null) return;

    final int level;
    try {
      level = capture.sample();
    } catch (e) {
      _logger.warning('Speech detection stopped sampling: $e');
      _detectionTimer?.cancel();
      _detectionTimer = null;
      _setSpeaking(false);
      return;
    }

    _setSpeaking(level >= audioLevelThreshold);
  }

  void _setSpeaking(bool speaking) {
    if (speaking == _isSpeaking) return;

    _isSpeaking = speaking;
    _activity.add(speaking ? SpeechActivity.started : SpeechActivity.ended);
  }

  @override
  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    _generation++;

    _detectionTimer?.cancel();
    _detectionTimer = null;
    _setSpeaking(false);

    final capture = _capture;
    _capture = null;
    await capture?.close();
  }
}
