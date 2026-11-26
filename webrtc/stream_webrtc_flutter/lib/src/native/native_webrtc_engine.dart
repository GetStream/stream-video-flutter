import 'dart:async';
import 'dart:math';

import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../third_party/flutter_webrtc/helper.dart';
import '../third_party/flutter_webrtc/native/encryption_manager_impl.dart'
    as e2ee;
import '../third_party/flutter_webrtc/native/factory_impl.dart' as rtc;
import '../third_party/flutter_webrtc/native/native_peer_connection_factory.dart';
import '../third_party/flutter_webrtc/native/rtc_video_renderer_impl.dart';
import '../third_party/flutter_webrtc/native/utils.dart';
import 'native_audio_renderer.dart' as audio_renderer;

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// The [WebRtcEngine] of Android, iOS, macOS, Windows and Linux, on the
/// plugin's platform channels.
final class NativeWebRtcEngine implements WebRtcEngine {
  NativeWebRtcEngine();

  @override
  WebRtcCapabilities get capabilities => rtc.webRtcCapabilities;

  @override
  WebRtcPlatformEvents get events => rtc.platformEvents;

  @override
  MediaDevices get mediaDevices => rtc.navigator.mediaDevices;

  @override
  final WebRtcAudio audio = const _NativeWebRtcAudio();

  @override
  final WebRtcCamera camera = const _NativeWebRtcCamera();

  @override
  Future<void> configureDefaultFactory({
    PeerConnectionFactoryOptions? options,
    bool refresh = false,
  }) {
    return WebRTC.initialize(factoryOptions: options, refresh: refresh);
  }

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, {
    Map<String, dynamic> constraints = const {},
  }) {
    return rtc.createPeerConnection(configuration, constraints);
  }

  @override
  Future<PeerConnectionFactory> createPeerConnectionFactory({
    PeerConnectionFactoryOptions options = const PeerConnectionFactoryOptions(),
  }) async {
    if (!capabilities.supportsPerCallFactory) {
      throw UnsupportedError('Per-call factories are not supported here');
    }
    final native = await NativePeerConnectionFactory.create(options: options);
    return _NativePerCallFactory(native);
  }

  @override
  Future<bool> requestCapturePermission({bool fullScreenOnly = false}) {
    return Helper.requestCapturePermission(fullScreenOnly: fullScreenOnly);
  }

  @override
  RTCAudioRenderer createAudioRenderer(
    String id, {
    AudioRendererTraceHandler? onTrace,
  }) {
    return audio_renderer.createAudioRenderer(id, onTrace: onTrace);
  }

  @override
  Future<FirstFrameWatcher> watchFirstFrame(
    MediaStream stream, {
    required void Function() onFirstFrame,
  }) async {
    final renderer = RTCVideoRenderer();
    try {
      await renderer.initialize();
      var reported = false;
      renderer
        ..onFirstFrameRendered = () {
          if (reported) return;
          reported = true;
          onFirstFrame();
        }
        ..srcObject = stream;
    } catch (_) {
      await renderer.dispose();
      rethrow;
    }
    return _RendererFirstFrameWatcher(renderer);
  }

  @override
  EncryptionManager createEncryptionManager({
    required String userId,
    EncryptionAlgorithm algorithm = EncryptionAlgorithm.aes128Gcm,
  }) {
    return e2ee.createEncryptionManager(userId: userId, algorithm: algorithm);
  }
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// A [PeerConnectionFactory] over a [NativePeerConnectionFactory].
class _NativePerCallFactory implements PeerConnectionFactory {
  _NativePerCallFactory(this._native);

  final NativePeerConnectionFactory _native;

  @override
  String get factoryId => _native.factoryId;

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, {
    Map<String, dynamic> constraints = const {},
  }) {
    return _native.createPeerConnection(configuration, constraints);
  }

  @override
  Future<MediaStream> getUserMedia(Map<String, dynamic> mediaConstraints) {
    return _native.getUserMedia(mediaConstraints);
  }

  @override
  Future<MediaStream> getDisplayMedia(Map<String, dynamic> mediaConstraints) {
    return _native.getDisplayMedia(mediaConstraints);
  }

  @override
  Future<bool> requestCapturePermission({bool fullScreenOnly = false}) {
    return _native.requestCapturePermission(fullScreenOnly: fullScreenOnly);
  }

  @override
  Future<void> setMicrophoneMuted(bool muted) {
    return _native.setMicrophoneMuted(muted);
  }

  @override
  Future<bool> isMicrophoneMuted() => _native.isMicrophoneMuted();

  @override
  Future<void> suspendAudio() => _native.suspendAudio();

  @override
  Future<void> resumeAudio() => _native.resumeAudio();

  @override
  Future<void> dispose() => _native.dispose();
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
class _NativeWebRtcAudio implements WebRtcAudio {
  const _NativeWebRtcAudio();

  @override
  Future<void> selectAudioOutput(String deviceId) {
    return Helper.selectAudioOutput(deviceId);
  }

  @override
  Future<void> selectAudioInput(String deviceId) {
    return Helper.selectAudioInput(deviceId);
  }

  @override
  Future<void> setPlayoutPaused(bool paused) {
    return audio_renderer.setAudioPlayoutPaused(paused);
  }

  @override
  Future<void> setAppleAudioConfiguration(
    AppleAudioConfiguration configuration,
  ) {
    return Helper.setAppleAudioConfiguration(configuration);
  }

  @override
  Future<void> setStereoPlayoutPreferred(bool preferred) {
    return Helper.setiOSStereoPlayoutPreferred(preferred);
  }

  @override
  Future<void> regainAndroidAudioFocus() => Helper.regainAndroidAudioFocus();

  @override
  Future<void> setAndroidAudioFocusHandledBySystem(bool handledBySystem) {
    return Helper.setAndroidAudioFocusHandledBySystem(handledBySystem);
  }

  @override
  Future<void> showAudioRoutePicker() {
    return Helper.triggeriOSAudioRouteSelectionUI();
  }
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
class _NativeWebRtcCamera implements WebRtcCamera {
  const _NativeWebRtcCamera();

  @override
  Future<bool> switchCamera(MediaStreamTrack track) {
    return Helper.switchCamera(track);
  }

  @override
  Future<void> setZoom(MediaStreamTrack track, double zoomLevel) {
    return Helper.setZoom(track, zoomLevel);
  }

  @override
  Future<void> setFocusPoint(MediaStreamTrack track, Point<double>? point) {
    return Helper.setFocusPoint(track, point);
  }

  @override
  Future<void> setExposurePoint(MediaStreamTrack track, Point<double>? point) {
    return Helper.setExposurePoint(track, point);
  }

  @override
  Future<bool> setMultitaskingAccessEnabled(bool enabled) {
    return Helper.enableIOSMultitaskingCameraAccess(enabled);
  }

  @override
  Future<bool?> isMultitaskingAccessSupported() {
    return Helper.isIOSMultitaskingCameraAccessSupported();
  }
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
class _RendererFirstFrameWatcher implements FirstFrameWatcher {
  _RendererFirstFrameWatcher(this._renderer);

  final RTCVideoRenderer _renderer;

  @override
  Future<void> dispose() {
    _renderer.srcObject = null;
    return _renderer.dispose();
  }
}
