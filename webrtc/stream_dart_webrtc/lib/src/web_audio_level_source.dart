import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:web/web.dart' as web;

import 'speech_activity_detector.dart';

final _logger = Logger('WebAudioLevelSource');

/// An [AudioLevelSource] on a microphone capture of its own, sampled through a
/// Web Audio `AnalyserNode`.
///
/// While open it holds the capture, so the browser's microphone indicator
/// stays on.
@internal
class WebAudioLevelSource implements AudioLevelSource {
  WebAudioLevelSource({this.fftSize = 128});

  /// FFT size of the analyser; it samples half as many frequency bins.
  final int fftSize;

  web.MediaStream? _stream;
  web.AudioContext? _audioContext;
  web.AnalyserNode? _analyser;
  JSUint8Array? _frequencyData;

  /// Guards against queuing a fresh `resume()` on every sample while an
  /// earlier one is still pending.
  bool _resumeInFlight = false;

  @override
  Future<void> open({String? deviceId}) async {
    final stream = await web.window.navigator.mediaDevices
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

    _stream = stream;
    final audioContext = web.AudioContext();
    _audioContext = audioContext;

    final source = audioContext.createMediaStreamSource(stream);
    final analyser = audioContext.createAnalyser()..fftSize = fftSize;
    source.connect(analyser);
    _analyser = analyser;
    _frequencyData = Uint8List(analyser.frequencyBinCount).toJS;

    // Detection can start outside a user gesture (a moderator mute, or a
    // participant who joined muted), so autoplay policies can hand back a
    // suspended context, and sampling one only ever yields silence.
    _resumeIfSuspended(audioContext);
  }

  @override
  int sample() {
    final audioContext = _audioContext;
    final analyser = _analyser;
    final frequencyData = _frequencyData;
    if (audioContext == null || analyser == null || frequencyData == null) {
      return 0;
    }

    // Re-checked on every sample: the browser suspends contexts on its own
    // (page backgrounded, audio interruption), and a context that goes back
    // to suspended would otherwise read as permanent silence.
    _resumeIfSuspended(audioContext);

    analyser.getByteFrequencyData(frequencyData);

    var maxByte = 0;
    for (final value in frequencyData.toDart) {
      if (value > maxByte) maxByte = value;
    }
    return maxByte;
  }

  /// Asks a suspended context to resume, without waiting for it.
  ///
  /// Never awaited: a context blocked by the autoplay policy leaves
  /// `resume()`'s promise pending until the document gets a user gesture.
  /// Left pending, the same promise resumes detection once a gesture arrives.
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
      _logger.warning('Failed to resume audio context: $e');
    } finally {
      _resumeInFlight = false;
    }
  }

  @override
  Future<void> close() async {
    _resumeInFlight = false;
    _analyser = null;
    _frequencyData = null;

    final audioContext = _audioContext;
    _audioContext = null;
    if (audioContext != null) {
      try {
        await audioContext.close().toDart;
      } catch (e) {
        _logger.warning('Failed to close audio context: $e');
      }
    }

    final stream = _stream;
    _stream = null;
    if (stream != null) {
      for (final track in stream.getTracks().toDart) {
        track.stop();
      }
    }
  }
}
