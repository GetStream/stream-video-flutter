import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// A [SpeechActivityDetector] that forwards the audio device module's speech
/// events while it runs.
@internal
class NativeSpeechActivityDetector implements SpeechActivityDetector {
  NativeSpeechActivityDetector(this._speech);

  /// The audio device module's speech events.
  final Stream<SpeechActivity> _speech;

  final _activity = StreamController<SpeechActivity>.broadcast();

  // ignore: cancel_subscriptions, cancelled in stop
  StreamSubscription<SpeechActivity>? _subscription;
  bool _isSpeaking = false;

  @override
  Stream<SpeechActivity> get activity => _activity.stream;

  @override
  Future<void> start({String? deviceId}) async {
    _subscription ??= _speech.listen((activity) {
      _isSpeaking = activity == SpeechActivity.started;
      _activity.add(activity);
    });
  }

  @override
  Future<void> stop() async {
    final subscription = _subscription;
    if (subscription == null) return;
    _subscription = null;

    await subscription.cancel();
    if (_isSpeaking) {
      _isSpeaking = false;
      _activity.add(SpeechActivity.ended);
    }
  }
}
