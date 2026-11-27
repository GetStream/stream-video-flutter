import 'dart:js_interop';

import 'package:stream_video_filters/web.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:web/web.dart' as web;

/// A custom effect, to try that path out: draws each camera frame on a
/// canvas in grayscale, and sends the canvas.
///
/// Drawing follows the video's frames, so it slows down while the tab is in
/// the background.
final VideoFilter grayscaleFilter = CustomWebVideoFilter(
  'grayscale',
  process: _grayscale,
);

Future<WebVideoProcessing> _grayscale(web.MediaStreamTrack input) async {
  final video = web.HTMLVideoElement()
    ..muted = true
    ..playsInline = true
    ..srcObject = web.MediaStream([input].toJS);
  await video.play().toDart;

  final canvas = web.HTMLCanvasElement();
  final context = canvas.getContext('2d')! as web.CanvasRenderingContext2D;
  var running = true;

  void draw(JSAny? _, JSAny? _) {
    if (!running) return;
    if (canvas.width != video.videoWidth ||
        canvas.height != video.videoHeight) {
      canvas
        ..width = video.videoWidth
        ..height = video.videoHeight;
    }
    // Resizing the canvas resets its context, so the filter is set each
    // time.
    context
      ..filter = 'grayscale(1)'
      ..drawImage(video, 0, 0);
    video.requestVideoFrameCallback(draw.toJS);
  }

  draw(null, null);
  final output = canvas.captureStream().getVideoTracks().toDart.first;
  return WebVideoProcessing(
    output,
    stop: () {
      running = false;
      video
        ..pause()
        ..srcObject = null;
    },
  );
}
