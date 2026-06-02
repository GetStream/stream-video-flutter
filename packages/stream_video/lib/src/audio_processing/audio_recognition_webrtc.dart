import 'dart:async';

import '../../stream_video.dart';

/// [AudioRecognition] implementation backed by speech-activity events
/// from the per-call audio device module (delivered through
/// [RtcMediaDeviceNotifier.speechActivityStream]).
///
/// Events originate in the native fork:
/// - iOS: `RTCAudioDeviceModuleDelegate.audioDeviceModule:didReceiveSpeechActivityEvent:`
/// - Android: `JavaAudioDeviceModule.setSamplesReadyCallback` + RMS analysis
class AudioRecognitionWebRTC implements AudioRecognition {
  AudioRecognitionWebRTC({this.config = const AudioRecognitionConfig()});

  final AudioRecognitionConfig config;

  StreamSubscription<SpeechActivityEvent>? _subscription;
  Timer? _trailingSilenceTimer;
  bool _isSpeaking = false;

  @override
  Future<void> start({
    required SoundStateChangedCallback onSoundStateChanged,
  }) async {
    if (_subscription != null) return;

    _subscription = RtcMediaDeviceNotifier.instance.speechActivityStream.listen(
      (event) {
        switch (event) {
          case SpeechActivityStarted():
            _trailingSilenceTimer?.cancel();
            _trailingSilenceTimer = null;
            if (_isSpeaking) return;
            _isSpeaking = true;
            onSoundStateChanged(
              const SoundState(isSpeaking: true, audioLevel: 1),
            );
          case SpeechActivityEnded():
            // Native side may emit `ended` immediately on a brief pause.
            // Debounce to avoid flapping consumers.
            _trailingSilenceTimer?.cancel();
            _trailingSilenceTimer = Timer(config.speechTimeout, () {
              _trailingSilenceTimer = null;
              if (!_isSpeaking) return;
              _isSpeaking = false;
              onSoundStateChanged(
                const SoundState(isSpeaking: false, audioLevel: 0),
              );
            });
        }
      },
    );
  }

  @override
  Future<void> stop() async {
    _trailingSilenceTimer?.cancel();
    _trailingSilenceTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    _isSpeaking = false;
  }

  @override
  Future<void> dispose() async {
    await stop();
  }
}

class AudioRecognitionConfig {
  const AudioRecognitionConfig({
    this.speechTimeout = const Duration(milliseconds: 500),
  });

  /// Trailing silence duration before a `started`→`ended` transition is
  /// surfaced to the consumer. Mirrors the debounce of the previous
  /// stats-polling implementation so callers see a similar cadence.
  final Duration speechTimeout;
}
