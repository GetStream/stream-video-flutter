import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:web/web.dart' as web;

import 'speech_activity_detector.dart';

final _logger = Logger('WebAudioLevelSource');

const _fftSize = 128;

/// An [AudioLevelSource] that opens a microphone capture of its own, sampled
/// through a Web Audio `AnalyserNode` with an FFT size of [_fftSize].
@internal
Future<AudioLevelCapture> openWebAudioLevelCapture({String? deviceId}) async {
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

  web.AudioContext? audioContext;
  try {
    audioContext = web.AudioContext();
    final source = audioContext.createMediaStreamSource(stream);
    final analyser = audioContext.createAnalyser()..fftSize = _fftSize;
    source.connect(analyser);
    return _WebAudioLevelCapture(stream, audioContext, analyser);
  } catch (_) {
    await _release(stream, audioContext);
    rethrow;
  }
}

/// A microphone capture sampled through an `AnalyserNode`.
///
/// While open it holds the capture, so the browser's microphone indicator
/// stays on.
class _WebAudioLevelCapture implements AudioLevelCapture {
  _WebAudioLevelCapture(this._stream, this._audioContext, this._analyser)
    : _frequencyData = Uint8List(_analyser.frequencyBinCount).toJS {
    // Detection can start outside a user gesture (a moderator mute, or a
    // participant who joined muted), so autoplay policies can hand back a
    // suspended context, and sampling one only ever yields silence.
    _resumeIfSuspended();
  }

  final web.MediaStream _stream;
  final web.AudioContext _audioContext;
  final web.AnalyserNode _analyser;
  final JSUint8Array _frequencyData;
  bool _closed = false;

  /// Guards against queuing a fresh `resume()` on every sample while an
  /// earlier one is still pending.
  bool _resumeInFlight = false;

  @override
  int sample() {
    if (_closed) return 0;

    // Re-checked on every sample: the browser suspends contexts on its own
    // (page backgrounded, audio interruption), and a context that goes back
    // to suspended would otherwise read as permanent silence.
    _resumeIfSuspended();

    _analyser.getByteFrequencyData(_frequencyData);

    var maxByte = 0;
    for (final value in _frequencyData.toDart) {
      if (value > maxByte) maxByte = value;
    }
    return maxByte;
  }

  /// Asks a suspended context to resume, without waiting for it.
  ///
  /// Never awaited: a context blocked by the autoplay policy leaves
  /// `resume()`'s promise pending until the document gets a user gesture.
  /// Left pending, the same promise resumes detection once a gesture arrives.
  void _resumeIfSuspended() {
    if (_resumeInFlight) return;
    if (_audioContext.state != 'suspended') return;

    _resumeInFlight = true;
    _resume().ignore();
  }

  Future<void> _resume() async {
    try {
      await _audioContext.resume().toDart;
    } catch (e) {
      _logger.warning('Failed to resume audio context: $e');
    } finally {
      _resumeInFlight = false;
    }
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _release(_stream, _audioContext);
  }
}

/// Closes [audioContext] and stops the tracks of [stream].
Future<void> _release(
  web.MediaStream stream,
  web.AudioContext? audioContext,
) async {
  for (final track in stream.getTracks().toDart) {
    track.stop();
  }

  if (audioContext == null) return;
  try {
    await audioContext.close().toDart;
  } catch (e) {
    _logger.warning('Failed to close audio context: $e');
  }
}
