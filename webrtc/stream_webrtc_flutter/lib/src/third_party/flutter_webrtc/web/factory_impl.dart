import 'package:meta/meta.dart';

import '../desktop_capturer.dart';

export 'package:stream_dart_webrtc/stream_dart_webrtc.dart'
    hide MediaDevices, MediaRecorder, videoRenderer;

DesktopCapturer get desktopCapturer => throw UnimplementedError();

Future<void> setVideoEffects(
  String trackId, {
  required List<String> names,
}) async {
  throw UnimplementedError('setVideoEffects() is not supported on web');
}

/// The raw events of the plugin's event channel. Empty on web.
@internal
Stream<Map<String, dynamic>> get eventStream => const Stream.empty();
