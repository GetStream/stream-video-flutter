import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// A microphone capture whose loudness can be sampled.
@internal
abstract interface class AudioLevelSource {
  /// Opens a capture of the microphone [deviceId], or the default microphone
  /// when it is null.
  Future<void> open({String? deviceId});

  /// The loudest frequency bin of the capture right now, from 0 to 255.
  int sample();

  /// Releases the capture. Does nothing when none is open.
  Future<void> close();
}

/// Detects speech by sampling an [AudioLevelSource] on a timer.
///
/// Reports each transition once on [activity]: [SpeechActivity.started] on the
/// first sample at or above [audioLevelThreshold], [SpeechActivity.ended] on
/// the first one below it.
@internal
class SpeechActivityDetector {
  SpeechActivityDetector(
    this._source, {
    this.detectionInterval = const Duration(milliseconds: 500),
    this.audioLevelThreshold = 150,
  });

  final AudioLevelSource _source;

  /// How often the source is sampled.
  final Duration detectionInterval;

  /// A sample at or above this value (0 to 255) counts as speech.
  final int audioLevelThreshold;

  final _activity = StreamController<SpeechActivity>.broadcast();

  /// The speech transitions, while detection runs.
  Stream<SpeechActivity> get activity => _activity.stream;

  Timer? _detectionTimer;
  bool _isSpeaking = false;
  bool _started = false;
  bool _opened = false;

  /// Bumped on every [stop], so a [start] still opening the source can tell it
  /// was cancelled.
  int _generation = 0;

  /// Opens the source on [deviceId] and starts sampling it. Does nothing while
  /// detection runs. Throws when the source cannot be opened.
  Future<void> start({String? deviceId}) async {
    if (_started) return;
    _started = true;
    final generation = _generation;

    try {
      await _source.open(deviceId: deviceId);
    } catch (_) {
      if (generation == _generation) _started = false;
      rethrow;
    }

    if (generation != _generation) {
      // Stopped while the source was opening.
      await _source.close();
      return;
    }

    _opened = true;
    _detectionTimer = Timer.periodic(detectionInterval, (_) => _sample());
  }

  void _sample() {
    final speaking = _source.sample() >= audioLevelThreshold;
    if (speaking == _isSpeaking) return;

    _isSpeaking = speaking;
    _activity.add(speaking ? SpeechActivity.started : SpeechActivity.ended);
  }

  /// Stops sampling and closes the source. Reports [SpeechActivity.ended] when
  /// speech was ongoing.
  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    _generation++;

    _detectionTimer?.cancel();
    _detectionTimer = null;
    if (_isSpeaking) {
      _isSpeaking = false;
      _activity.add(SpeechActivity.ended);
    }

    if (!_opened) return;
    _opened = false;
    await _source.close();
  }
}
