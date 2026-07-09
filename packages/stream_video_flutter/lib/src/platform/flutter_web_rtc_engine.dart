import 'dart:math';

import 'package:stream_video/stream_video.dart' hide MediaDevices;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:webrtc_interface/webrtc_interface.dart';

/// [StreamWebRtc] backed by `stream_webrtc_flutter`, preserving the native
/// SDK's existing WebRTC behavior exactly.
class FlutterWebRtcEngine implements StreamWebRtc {
  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) {
    return rtc.createPeerConnection(configuration, constraints);
  }

  @override
  MediaDevices get mediaDevices => rtc.navigator.mediaDevices;

  @override
  Future<StreamNativeFactory?> createNativeFactory({
    required Map<String, dynamic> options,
  }) async {
    final factory = await rtc.NativePeerConnectionFactory.create(
      options: options,
    );
    return _NativeFactoryAdapter(factory);
  }

  @override
  StreamWebRtcHelper get helper => const _FlutterStreamWebRtcHelper();

  @override
  Future<void> initializeAudioConfiguration({
    required bool refresh,
    required Map<String, dynamic> options,
  }) {
    return rtc.WebRTC.initialize(refresh: refresh, options: options);
  }

  @override
  Stream<Map<String, dynamic>> get nativeEventStream => rtc.eventStream;

  @override
  Future<void> handleCallInterruptionCallbacks({
    void Function()? onInterruptionStart,
    void Function()? onInterruptionEnd,
    StreamAndroidInterruptionSource androidInterruptionSource =
        StreamAndroidInterruptionSource.audioFocusAndTelephony,
  }) {
    return rtc.handleCallInterruptionCallbacks(
      onInterruptionStart,
      onInterruptionEnd,
      androidInterruptionSource: rtc.AndroidInterruptionSource.values.byName(
        androidInterruptionSource.name,
      ),
    );
  }

  @override
  Future<Future<void> Function()> watchFirstVideoFrame({
    required MediaStream stream,
    required void Function() onFirstFrame,
  }) async {
    final renderer = rtc.RTCVideoRenderer();
    await renderer.initialize();
    var fired = false;
    renderer.onFirstFrameRendered = () {
      if (fired) return;
      fired = true;
      onFirstFrame();
    };
    renderer.srcObject = stream;
    return () async {
      renderer.srcObject = null;
      await renderer.dispose();
    };
  }
}

class _NativeFactoryAdapter implements StreamNativeFactory {
  _NativeFactoryAdapter(this._factory);

  final rtc.NativePeerConnectionFactory _factory;

  @override
  String get factoryId => _factory.factoryId;

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) {
    return _factory.createPeerConnection(configuration, constraints);
  }

  @override
  Future<MediaStream> getUserMedia(Map<String, dynamic> mediaConstraints) {
    return _factory.getUserMedia(mediaConstraints);
  }

  @override
  Future<MediaStream> getDisplayMedia(Map<String, dynamic> mediaConstraints) {
    return _factory.getDisplayMedia(mediaConstraints);
  }

  @override
  Future<bool> requestCapturePermission() {
    return _factory.requestCapturePermission();
  }

  @override
  Future<void> suspendAudio() => _factory.suspendAudio();

  @override
  Future<void> resumeAudio() => _factory.resumeAudio();

  @override
  Future<void> dispose() => _factory.dispose();
}

class _FlutterStreamWebRtcHelper implements StreamWebRtcHelper {
  const _FlutterStreamWebRtcHelper();

  @override
  Future<bool> switchCamera(MediaStreamTrack track) {
    return rtc.Helper.switchCamera(track);
  }

  @override
  Future<void> setZoom(MediaStreamTrack videoTrack, double zoomLevel) {
    return rtc.Helper.setZoom(videoTrack, zoomLevel);
  }

  @override
  Future<void> setFocusPoint(
    MediaStreamTrack videoTrack,
    Point<double>? point,
  ) {
    return rtc.Helper.setFocusPoint(videoTrack, point);
  }

  @override
  Future<void> setExposurePoint(
    MediaStreamTrack videoTrack,
    Point<double>? point,
  ) {
    return rtc.Helper.setExposurePoint(videoTrack, point);
  }

  @override
  Future<void> selectAudioOutput(String deviceId) {
    return rtc.Helper.selectAudioOutput(deviceId);
  }

  @override
  Future<void> selectAudioInput(String deviceId) {
    return rtc.Helper.selectAudioInput(deviceId);
  }

  @override
  Future<void> pauseAudioPlayout() => rtc.Helper.pauseAudioPlayout();

  @override
  Future<void> resumeAudioPlayout() => rtc.Helper.resumeAudioPlayout();

  @override
  Future<void> regainAndroidAudioFocus() {
    return rtc.Helper.regainAndroidAudioFocus();
  }

  @override
  Future<void> setAppleAudioConfiguration(
    StreamAppleAudioConfiguration config,
  ) {
    return rtc.Helper.setAppleAudioConfiguration(
      rtc.AppleAudioConfiguration(
        appleAudioMode: config.appleAudioMode == null
            ? null
            : rtc.AppleAudioMode.values.byName(config.appleAudioMode!.name),
        appleAudioCategory: config.appleAudioCategory == null
            ? null
            : rtc.AppleAudioCategory.values.byName(
                config.appleAudioCategory!.name,
              ),
        appleAudioCategoryOptions: config.appleAudioCategoryOptions
            ?.map((o) => rtc.AppleAudioCategoryOption.values.byName(o.name))
            .toSet(),
      ),
    );
  }

  @override
  Future<bool> requestCapturePermission() {
    return rtc.Helper.requestCapturePermission();
  }

  @override
  Future<bool> enableIOSMultitaskingCameraAccess(bool enable) {
    return rtc.Helper.enableIOSMultitaskingCameraAccess(enable);
  }

  @override
  Future<void> triggeriOSAudioRouteSelectionUI() {
    return rtc.Helper.triggeriOSAudioRouteSelectionUI();
  }

  @override
  Future<void> setiOSStereoPlayoutPreferred(bool preferred) {
    return rtc.Helper.setiOSStereoPlayoutPreferred(preferred);
  }
}
