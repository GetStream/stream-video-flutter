import 'dart:async';

import 'package:webrtc_interface/webrtc_interface.dart';

/// Web stub. Per-call peer connection factories are a native-only concept —
/// the browser's WebRTC implementation owns audio device routing
/// process-wide and exposes no equivalent. Calling [create] on web throws
/// [UnimplementedError] so callers can fall back to the top-level
/// browser-backed APIs.
class NativePeerConnectionFactory {
  NativePeerConnectionFactory._(this.factoryId);

  final String factoryId;

  static Future<NativePeerConnectionFactory> create({
    Map<String, dynamic>? options,
  }) async {
    throw UnimplementedError(
      'NativePeerConnectionFactory is not supported on web',
    );
  }

  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) async => throw UnimplementedError();

  Future<MediaStream> getUserMedia(
    Map<String, dynamic> mediaConstraints,
  ) async => throw UnimplementedError();

  Future<MediaStream> getDisplayMedia(
    Map<String, dynamic> mediaConstraints,
  ) async => throw UnimplementedError();

  Future<MediaStream> createLocalMediaStream(String label) async =>
      throw UnimplementedError();

  Future<bool> requestCapturePermission({bool fullScreenOnly = false}) async =>
      throw UnimplementedError();

  Future<RTCRtpCapabilities> getRtpSenderCapabilities(String kind) async =>
      throw UnimplementedError();

  Future<RTCRtpCapabilities> getRtpReceiverCapabilities(String kind) async =>
      throw UnimplementedError();

  Future<void> startLocalRecording() async => throw UnimplementedError();
  Future<void> stopLocalRecording() async => throw UnimplementedError();

  /// ADM-level microphone mute is iOS / macOS only.
  static bool get isAdmMicrophoneMuteSupported => false;

  Future<void> setMicrophoneMuted(bool muted) async => throw UnsupportedError(
    'ADM-level microphone mute is not supported on web',
  );

  Future<bool> isMicrophoneMuted() async => throw UnsupportedError(
    'ADM-level microphone mute is not supported on web',
  );

  Future<void> suspendAudio() async {}
  Future<void> resumeAudio() async {}

  Future<void> dispose() async {}
}
