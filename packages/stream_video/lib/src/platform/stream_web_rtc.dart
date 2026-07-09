import 'dart:math';

import 'package:webrtc_interface/webrtc_interface.dart';

import '../models/audio_configuration.dart';
import 'stream_web_rtc_default.dart'
    if (dart.library.js_interop) 'stream_web_rtc_default_web.dart';

/// Provides the WebRTC engine globals that have no equivalent in the pure
/// Dart `webrtc_interface`/`dart_webrtc` packages: native audio routing
/// (`Helper`), the per-call native peer-connection factory, and native audio
/// session setup. Everything else (`RTCPeerConnection`, `MediaStream`, …) is
/// used directly via `webrtc_interface` and never needs this engine.
///
/// `stream_video_flutter` registers a plugin-backed implementation via
/// `StreamVideoFlutter.ensureInitialized()`. There is deliberately no
/// pure-Dart/web default assigned here — see `stream_web_rtc_default.dart`
/// (native: throws; web: real `dart_webrtc`-backed engine), selected via
/// conditional import so `dart_webrtc`'s JS-interop internals are never
/// compiled into a native target.
abstract class StreamWebRtc {
  static StreamWebRtc instance = defaultStreamWebRtc;

  /// The global peer-connection factory entrypoint (used when no per-call
  /// native factory is available, e.g. on web/desktop).
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints,
  ]);

  /// The global `navigator.mediaDevices` equivalent.
  MediaDevices get mediaDevices;

  /// Builds a per-call native peer-connection factory. Returns `null` on
  /// platforms without this concept (web, desktop) — callers fall back to
  /// [createPeerConnection].
  Future<StreamNativeFactory?> createNativeFactory({
    required Map<String, dynamic> options,
  });

  StreamWebRtcHelper get helper;

  /// Refreshes the native audio session configuration that new native
  /// peer-connection factories will pick up. No-op where not applicable.
  Future<void> initializeAudioConfiguration({
    required bool refresh,
    required Map<String, dynamic> options,
  });

  /// Native screen-share/audio-processing/speech-activity events. Empty on
  /// platforms without a native event channel (web).
  Stream<Map<String, dynamic>> get nativeEventStream;

  /// Registers system audio-interruption callbacks (phone calls, Siri,
  /// alarms on iOS; audio focus/telephony on Android). No-op on web.
  Future<void> handleCallInterruptionCallbacks({
    void Function()? onInterruptionStart,
    void Function()? onInterruptionEnd,
    StreamAndroidInterruptionSource androidInterruptionSource =
        StreamAndroidInterruptionSource.audioFocusAndTelephony,
  });

  /// Watches [stream] for its first rendered video frame, invoking
  /// [onFirstFrame] at most once. Returns a dispose callback.
  Future<Future<void> Function()> watchFirstVideoFrame({
    required MediaStream stream,
    required void Function() onFirstFrame,
  });
}

/// Per-call native peer-connection factory, mirroring
/// `stream_webrtc_flutter`'s `NativePeerConnectionFactory` without exposing
/// its type.
abstract class StreamNativeFactory {
  String get factoryId;

  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints,
  ]);

  Future<MediaStream> getUserMedia(Map<String, dynamic> mediaConstraints);

  Future<MediaStream> getDisplayMedia(Map<String, dynamic> mediaConstraints);

  Future<bool> requestCapturePermission();

  Future<void> suspendAudio();

  Future<void> resumeAudio();

  Future<void> dispose();
}

/// Mirrors `stream_webrtc_flutter`'s static `Helper` class as an injectable
/// interface.
abstract class StreamWebRtcHelper {
  Future<bool> switchCamera(MediaStreamTrack track);

  Future<void> setZoom(MediaStreamTrack videoTrack, double zoomLevel);

  Future<void> setFocusPoint(MediaStreamTrack videoTrack, Point<double>? point);

  Future<void> setExposurePoint(
    MediaStreamTrack videoTrack,
    Point<double>? point,
  );

  Future<void> selectAudioOutput(String deviceId);

  Future<void> selectAudioInput(String deviceId);

  Future<void> pauseAudioPlayout();

  Future<void> resumeAudioPlayout();

  Future<void> regainAndroidAudioFocus();

  Future<void> setAppleAudioConfiguration(StreamAppleAudioConfiguration config);

  Future<bool> requestCapturePermission();

  Future<bool> enableIOSMultitaskingCameraAccess(bool enable);

  Future<void> triggeriOSAudioRouteSelectionUI();

  Future<void> setiOSStereoPlayoutPreferred(bool preferred);
}
