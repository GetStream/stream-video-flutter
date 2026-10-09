import 'dart:js_interop';
import 'dart:ui' as ui;
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

/// Captures the frame the web video element of the renderer with [textureId]
/// shows, or null when it has none.
///
/// A web renderer draws into an HTML video element, which a Flutter layer
/// snapshot cannot see, so the element is drawn to a canvas instead. The draw
/// happens before the first await, while the element still holds the frame.
Future<ui.Image?> captureElementFrame(int? textureId) async {
  if (textureId == null) return null;

  final element = web.document.getElementById(
    'video_RTCVideoRenderer-$textureId',
  );
  if (element is! web.HTMLVideoElement) return null;

  final width = element.videoWidth;
  final height = element.videoHeight;
  if (width == 0 || height == 0) return null;

  final canvas = web.HTMLCanvasElement()
    ..width = width
    ..height = height;
  final context = canvas.getContext('2d')! as web.CanvasRenderingContext2D;
  context.drawImage(element, 0, 0);

  final bitmap = await web.window.createImageBitmap(canvas).toDart;
  return ui_web.createImageFromImageBitmap(bitmap);
}
