import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

import 'media_stream_impl.dart';

class MediaRecorderWeb extends MediaRecorder {
  late web.MediaRecorder _recorder;
  late Completer<String> _completer;

  @override
  Future<void> start(
    String path, {
    MediaStreamTrack? videoTrack,
    RecorderAudioChannel? audioChannel,
  }) {
    throw 'Use startWeb on Flutter Web!';
  }

  @override
  void startWeb(
    MediaStream stream, {
    Function(dynamic blob, bool isLastOne)? onDataChunk,
    String mimeType = 'video/webm',
    int timeSlice = 1000,
  }) {
    var _native = stream as MediaStreamWeb;
    _recorder = web.MediaRecorder(
        _native.jsStream, web.MediaRecorderOptions(mimeType: mimeType));
    if (onDataChunk == null) {
      var _chunks = <web.Blob>[];
      _completer = Completer<String>();
      final callback = (web.Event event) {
        final blob = event.getProperty('data'.toJS) as web.Blob;
        if (blob.size > 0) {
          _chunks.add(blob);
        }
        if (_recorder.state == 'inactive') {
          final blob =
              web.Blob(_chunks.toJS, web.BlobPropertyBag(type: mimeType));
          _completer.complete(web.URL.createObjectURL(blob));
        }
      };
      final onError = (JSAny error) {
        _completer.completeError(error);
      };
      _recorder.addEventListener('dataavailable', callback.toJS);
      _recorder.addEventListener('error', onError.toJS);
    } else {
      final callback = (web.Event event) {
        onDataChunk(
          event.getProperty('data'.toJS),
          _recorder.state == 'inactive',
        );
      };
      _recorder.addEventListener('dataavailable', callback.toJS);
    }
    _recorder.start(timeSlice);
  }

  @override
  Future<dynamic> stop() {
    _recorder.stop();
    return _completer.future;
  }
}
