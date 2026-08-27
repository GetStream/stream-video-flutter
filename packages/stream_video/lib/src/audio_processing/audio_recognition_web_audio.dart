import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import '../logger/impl/tagged_logger.dart';
import 'audio_recognition.dart';

/// [AudioRecognition] implementation for web backed by the Web Audio API.
///
/// This implementation opens its own microphone stream and samples an
/// [web.AnalyserNode] on a timer, mirroring the JS SDK's `createSoundDetector`.
///
/// Note: while active it holds a microphone capture, so the browser's
/// "microphone in use" indicator stays on even though the user is muted. This
/// is a limitation of the Web Audio API.
class AudioRecognitionWebAudio implements AudioRecognition {
  AudioRecognitionWebAudio({
    this.config = const WebAudioRecognitionConfig(),
    this.deviceIdProvider,
  });

  final WebAudioRecognitionConfig config;

  /// Resolves the microphone to monitor at each [start]. Used when
  /// [WebAudioRecognitionConfig.deviceId] is null. Falls back to the
  /// browser's default microphone when both are null.
  final String? Function()? deviceIdProvider;

  web.MediaStream? _stream;
  web.AudioContext? _audioContext;
  Timer? _detectionTimer;
  Timer? _trailingSilenceTimer;
  bool _isSpeaking = false;
  bool _started = false;

  /// Guards against queuing a fresh `resume()` on every detection tick while
  /// an earlier one is still pending.
  bool _resumeInFlight = false;

  /// Bumped on every [stop] so an in-flight [start] can detect it was
  /// cancelled while awaiting `getUserMedia`.
  int _generation = 0;

  @override
  Future<void> start({
    required SoundStateChangedCallback onSoundStateChanged,
  }) async {
    if (_started) return;
    _started = true;
    final generation = _generation;

    final web.MediaStream stream;
    try {
      final deviceId = config.deviceId ?? deviceIdProvider?.call();
      stream = await web.window.navigator.mediaDevices
          .getUserMedia(
            web.MediaStreamConstraints(
              audio: deviceId == null
                  ? true.toJS
                  : <String, Object>{
                      'deviceId': {'exact': deviceId},
                    }.jsify()!,
            ),
          )
          .toDart;
    } catch (_) {
      _started = false;
      rethrow;
    }

    if (!_started || generation != _generation) {
      // Stopped while acquiring the microphone.
      _stopStream(stream);
      return;
    }

    _stream = stream;
    final audioContext = web.AudioContext();
    _audioContext = audioContext;

    final source = audioContext.createMediaStreamSource(stream);
    final analyser = audioContext.createAnalyser()..fftSize = config.fftSize;
    source.connect(analyser);

    // Detection can starts outside a user gesture (a moderator mute, or
    // a participant who joined muted), so autoplay policies can hand back a
    // suspended context, and sampling one only ever yields silence.
    _resumeIfSuspended(audioContext);

    final frequencyData = Uint8List(analyser.frequencyBinCount).toJS;
    _detectionTimer = Timer.periodic(config.detectionInterval, (_) {
      // Re-checked every tick rather than only at start: the browser suspends
      // contexts on its own (page backgrounded, audio interruption), and a
      // context that goes back to suspended mid-call would otherwise read as
      // permanent silence.
      _resumeIfSuspended(audioContext);

      analyser.getByteFrequencyData(frequencyData);

      var maxByte = 0;
      for (final value in frequencyData.toDart) {
        if (value > maxByte) maxByte = value;
      }

      if (maxByte >= config.audioLevelThreshold) {
        _trailingSilenceTimer?.cancel();
        _trailingSilenceTimer = null;
        if (_isSpeaking) return;
        _isSpeaking = true;
        onSoundStateChanged(
          SoundState(isSpeaking: true, audioLevel: maxByte / 255),
        );
      } else if (_isSpeaking) {
        // Debounce brief pauses so consumers don't flap.
        _trailingSilenceTimer ??= Timer(config.speechTimeout, () {
          _trailingSilenceTimer = null;
          if (!_isSpeaking) return;
          _isSpeaking = false;
          onSoundStateChanged(
            const SoundState(isSpeaking: false, audioLevel: 0),
          );
        });
      }
    });
  }

  /// Asks a suspended context to resume, without waiting for it.
  ///
  /// Deliberately never awaited. A context blocked by the autoplay policy
  /// leaves `resume()`'s promise pending until the document gets a user
  /// gesture — Chrome does not reject it — so awaiting would stall [start],
  /// and with it every start/stop transition queued behind it. Left pending,
  /// the same promise is what resumes detection once a gesture does arrive.
  void _resumeIfSuspended(web.AudioContext audioContext) {
    if (_resumeInFlight) return;
    if (audioContext.state != 'suspended') return;

    _resumeInFlight = true;
    _resume(audioContext).ignore();
  }

  Future<void> _resume(web.AudioContext audioContext) async {
    try {
      await audioContext.resume().toDart;
    } catch (e) {
      _logger.w(() => 'Failed to resume audio context: $e');
    } finally {
      _resumeInFlight = false;
    }
  }

  @override
  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    _generation++;
    _resumeInFlight = false;

    _detectionTimer?.cancel();
    _detectionTimer = null;
    _trailingSilenceTimer?.cancel();
    _trailingSilenceTimer = null;
    _isSpeaking = false;

    final audioContext = _audioContext;
    _audioContext = null;
    if (audioContext != null) {
      try {
        await audioContext.close().toDart;
      } catch (e) {
        _logger.w(() => 'Failed to close audio context: $e');
      }
    }

    final stream = _stream;
    _stream = null;
    if (stream != null) _stopStream(stream);
  }

  @override
  Future<void> dispose() async {
    await stop();
  }

  void _stopStream(web.MediaStream stream) {
    for (final track in stream.getTracks().toDart) {
      track.stop();
    }
  }
}

class WebAudioRecognitionConfig {
  const WebAudioRecognitionConfig({
    this.detectionInterval = const Duration(milliseconds: 500),
    this.speechTimeout = const Duration(milliseconds: 500),
    this.fftSize = 128,
    this.audioLevelThreshold = 150,
    this.deviceId,
  });

  /// How often the analyser is sampled. Mirrors the JS SDK's
  /// `detectionFrequencyInMs`.
  final Duration detectionInterval;

  /// Trailing silence duration before a speaking→silent transition is
  /// surfaced to the consumer. Mirrors the debounce of the native
  /// event-based implementation.
  final Duration speechTimeout;

  /// FFT size of the analyser node; the sampled frequency-bin count is half
  /// of this.
  final int fftSize;

  /// A frequency-bin byte value (0–255) at or above this threshold counts as
  /// sound. Mirrors the JS SDK's `audioLevelThreshold`.
  final int audioLevelThreshold;

  /// Microphone device to monitor. Defaults to the browser's default
  /// microphone.
  final String? deviceId;
}

final _logger = taggedLogger(tag: 'SV:AudioRecognitionWebAudio');
