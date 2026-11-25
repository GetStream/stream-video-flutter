import 'dart:async';

import 'package:stream_webrtc_interface/stream_webrtc_interface.dart' as rtc;

import '../../stream_video.dart';

/// [AudioRecognition] implementation backed by a speech activity detector of
/// its own, from [PlatformAudioController.createSpeechActivityDetector].
///
/// Android, iOS and macOS report speech from the audio device module. The
/// browser reports it from a microphone capture of its own, which runs between
/// [start] and [stop].
class AudioRecognitionWebRTC implements AudioRecognition {
  AudioRecognitionWebRTC({
    AudioRecognitionConfig? config,
    this.deviceIdProvider,
  }) : config = config ?? AudioRecognitionConfig.platformDefault();

  final AudioRecognitionConfig config;

  /// Resolves the microphone the browser monitors at each [start]. The
  /// browser's default microphone when it is null, or returns null.
  final String? Function()? deviceIdProvider;

  rtc.SpeechActivityDetector? _detector;

  StreamSubscription<rtc.SpeechActivity>? _subscription;
  Timer? _silenceTimer;
  bool _isSpeaking = false;

  @override
  Future<void> start({
    required SoundStateChangedCallback onSoundStateChanged,
  }) async {
    if (_subscription != null) return;

    final detector = _detector ??= PlatformAudioController.instance
        .createSpeechActivityDetector();
    _subscription = detector.activity.listen(
      (activity) {
        switch (activity) {
          case rtc.SpeechActivity.started:
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
            final maxSpeechDuration = config.maxSpeechDuration;
            if (maxSpeechDuration != null) {
              _armSilence(maxSpeechDuration, onSoundStateChanged);
            } else {
              _silenceTimer?.cancel();
              _silenceTimer = null;
            }

          case rtc.SpeechActivity.ended:
            // Native side may emit `ended` immediately on a brief pause.
            // Debounce to avoid flapping consumers.
            _armSilence(config.speechTimeout, onSoundStateChanged);
        }
      },
    );

    try {
      await detector.start(deviceId: deviceIdProvider?.call());
    } catch (_) {
      await stop();
      rethrow;
    }
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
    final subscription = _subscription;
    if (subscription == null) return;
    _subscription = null;
    _isSpeaking = false;
    await subscription.cancel();
    await _detector?.stop();
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

  /// The config for the platform the app runs on: no [maxSpeechDuration] in
  /// the browser, whose detection always reports the end of speech.
  factory AudioRecognitionConfig.platformDefault() {
    return CurrentPlatform.isWeb
        ? const AudioRecognitionConfig(maxSpeechDuration: null)
        : const AudioRecognitionConfig();
  }

  /// Trailing silence duration before a `started`→`ended` transition is
  /// surfaced to the consumer. Mirrors the debounce of the previous
  /// stats-polling implementation so callers see a similar cadence.
  final Duration speechTimeout;

  /// How long a `started` with no matching `ended` keeps the speaking state
  /// before it is ended anyway. Null keeps it until the `ended`.
  ///
  /// A safety net, not the primary mechanism: the platforms report speech in
  /// transitions (one `started`, one `ended` per utterance), so this only ever
  /// fires for an utterance that runs longer than this, or when the platform
  /// drops the `ended` altogether. Keep it comfortably longer than
  /// [speechTimeout] so it does not cut ordinary speech short.
  final Duration? maxSpeechDuration;
}
