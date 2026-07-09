import 'dart:math';

import 'package:dart_webrtc/dart_webrtc.dart' as dart_webrtc;
import 'package:webrtc_interface/webrtc_interface.dart';

import '../models/audio_configuration.dart';
import 'stream_web_rtc.dart';

/// Web/Jaspr [StreamWebRtc] backed by `dart_webrtc`. Only ever reached via
/// the conditional import in `stream_web_rtc.dart` (`if (dart.library
/// .js_interop)`) — never imported unconditionally, so `dart_webrtc`'s
/// JS-interop internals are never compiled into a native target.
final StreamWebRtc defaultStreamWebRtc = DartWebRtcEngine();

class DartWebRtcEngine implements StreamWebRtc {
  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) {
    return dart_webrtc.createPeerConnection(configuration, constraints);
  }

  @override
  MediaDevices get mediaDevices => dart_webrtc.mediaDevices;

  @override
  Future<StreamNativeFactory?> createNativeFactory({
    required Map<String, dynamic> options,
  }) async {
    // No per-call native factory concept on web; callers fall back to
    // createPeerConnection/mediaDevices.
    return null;
  }

  @override
  StreamWebRtcHelper get helper => const _WebStreamWebRtcHelper();

  @override
  Future<void> initializeAudioConfiguration({
    required bool refresh,
    required Map<String, dynamic> options,
  }) async {
    // No native audio session to configure on web.
  }

  @override
  Stream<Map<String, dynamic>> get nativeEventStream => const Stream.empty();

  @override
  Future<void> handleCallInterruptionCallbacks({
    void Function()? onInterruptionStart,
    void Function()? onInterruptionEnd,
    StreamAndroidInterruptionSource androidInterruptionSource =
        StreamAndroidInterruptionSource.audioFocusAndTelephony,
  }) async {
    // Browsers have no phone-call-style interruption concept.
  }

  @override
  Future<Future<void> Function()> watchFirstVideoFrame({
    required MediaStream stream,
    required void Function() onFirstFrame,
  }) async {
    final element = dart_webrtc.RTCVideoElement();
    var fired = false;
    final subscription = element.onCanPlay.listen((_) {
      if (fired) return;
      fired = true;
      onFirstFrame();
    });
    element.srcObject = stream;
    return () async {
      await subscription.cancel();
      element.srcObject = null;
    };
  }
}

class _WebStreamWebRtcHelper implements StreamWebRtcHelper {
  const _WebStreamWebRtcHelper();

  @override
  Future<bool> switchCamera(MediaStreamTrack track) async => false;

  @override
  Future<void> setZoom(MediaStreamTrack videoTrack, double zoomLevel) async {}

  @override
  Future<void> setFocusPoint(
    MediaStreamTrack videoTrack,
    Point<double>? point,
  ) async {}

  @override
  Future<void> setExposurePoint(
    MediaStreamTrack videoTrack,
    Point<double>? point,
  ) async {}

  @override
  Future<void> selectAudioOutput(String deviceId) async {}

  @override
  Future<void> selectAudioInput(String deviceId) async {}

  @override
  Future<void> pauseAudioPlayout() async {}

  @override
  Future<void> resumeAudioPlayout() async {}

  @override
  Future<void> regainAndroidAudioFocus() async {}

  @override
  Future<void> setAppleAudioConfiguration(
    StreamAppleAudioConfiguration config,
  ) async {}

  @override
  Future<bool> requestCapturePermission() async {
    // getDisplayMedia() handles the browser's own capture permission prompt.
    return true;
  }

  @override
  Future<bool> enableIOSMultitaskingCameraAccess(bool enable) async => false;

  @override
  Future<void> triggeriOSAudioRouteSelectionUI() async {}

  @override
  Future<void> setiOSStereoPlayoutPreferred(bool preferred) async {}
}
