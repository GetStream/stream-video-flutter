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

Future<void> handleCallInterruptionCallbacks(
  void Function()? onInterruptionStart,
  void Function()? onInterruptionEnd, {
  Object? androidInterruptionSource,
  Object? androidAudioAttributesUsageType,
  Object? androidAudioAttributesContentType,
}) {
  throw UnimplementedError(
    'handleCallInterruptionCallbacks() is not supported on web',
  );
}

Stream<Map<String, dynamic>> get eventStream => const Stream.empty();
