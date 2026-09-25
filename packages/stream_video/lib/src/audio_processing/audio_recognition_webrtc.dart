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
  AudioRecognitionWebRTC({
    this.config = const AudioRecognitionConfig(),
    Stream<SpeechActivityEvent>? speechActivityStream,
  }) : _speechActivityStream = speechActivityStream;

  final AudioRecognitionConfig config;

  /// Overrides the event source. Defaults to the per-call audio device
  /// module's events.
  final Stream<SpeechActivityEvent>? _speechActivityStream;

  Stream<SpeechActivityEvent> get _events =>
      _speechActivityStream ??
      RtcMediaDeviceNotifier.instance.speechActivityStream;

  StreamSubscription<SpeechActivityEvent>? _subscription;
  Timer? _silenceTimer;
  bool _isSpeaking = false;

  @override
  Future<void> start({
    required SoundStateChangedCallback onSoundStateChanged,
  }) async {
    if (_subscription != null) return;

    _subscription = _events.listen(
      (event) {
        switch (event) {
          case SpeechActivityStarted():
            if (!_isSpeaking) {
              _isSpeaking = true;
              onSoundStateChanged(
                const SoundState(isSpeaking: true, audioLevel: 1),
              );
            }

            // Every `started` re-arms the fallback. The platforms deliver a
            // matching `ended` (which arms a much shorter timer below), but
            // not reliably: a `started` without one would otherwise latch the
            // speaking state for the rest of the mute, and consumers that
            // react to the transition — a banner, a snackbar — would never
            // fire again until the user unmuted and muted once more.
            _armSilence(config.maxSpeechDuration, onSoundStateChanged);

          case SpeechActivityEnded():
            // Native side may emit `ended` immediately on a brief pause.
            // Debounce to avoid flapping consumers.
            _armSilence(config.speechTimeout, onSoundStateChanged);
        }
      },
    );
  }

  /// (Re)arms the single timer that ends the speaking state after [delay].
  void _armSilence(Duration delay, SoundStateChangedCallback onChanged) {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(delay, () {
      _silenceTimer = null;
      if (!_isSpeaking) return;
      _isSpeaking = false;
      onChanged(const SoundState(isSpeaking: false, audioLevel: 0));
    });
  }

  @override
  Future<void> stop() async {
    _silenceTimer?.cancel();
    _silenceTimer = null;
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
    this.maxSpeechDuration = const Duration(seconds: 4),
  });

  /// Trailing silence duration before a `started`→`ended` transition is
  /// surfaced to the consumer. Mirrors the debounce of the previous
  /// stats-polling implementation so callers see a similar cadence.
  final Duration speechTimeout;

  /// How long a `started` with no matching `ended` keeps the speaking state
  /// before it is ended anyway.
  ///
  /// A safety net, not the primary mechanism: the platforms report speech in
  /// transitions (one `started`, one `ended` per utterance), so this only ever
  /// fires for an utterance that runs longer than this, or when the platform
  /// drops the `ended` altogether. Keep it comfortably longer than
  /// [speechTimeout] so it does not cut ordinary speech short.
  final Duration maxSpeechDuration;
}
