import 'dart:async';
import 'dart:js_interop';
import 'dart:math';

import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

import 'platform_events.dart';
import 'third_party/dart_webrtc/factory_impl.dart' as rtc;
import 'third_party/dart_webrtc/media_stream_impl.dart';
import 'web_audio_renderer.dart' as audio_renderer;
import 'web_capabilities.dart';

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// The [WebRtcEngine] of the browser.
final class BrowserWebRtcEngine implements WebRtcEngine {
  BrowserWebRtcEngine();

  @override
  WebRtcCapabilities get capabilities => webRtcCapabilities;

  @override
  WebRtcPlatformEvents get events => DartWebRtcPlatformEvents.instance;

  @override
  MediaDevices get mediaDevices => rtc.navigator.mediaDevices;

  @override
  late final WebRtcAudio audio = _BrowserWebRtcAudio(this);

  @override
  final WebRtcCamera camera = const _BrowserWebRtcCamera();

  @override
  Future<void> configureDefaultFactory({
    PeerConnectionFactoryOptions? options,
    bool refresh = false,
  }) async {
    throw UnsupportedError('The browser has no peer connection factory');
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
    throw UnsupportedError('The browser has no per-call factory');
  }

  @override
  Future<bool> requestCapturePermission({bool fullScreenOnly = false}) async {
    throw UnsupportedError('Screen capture permission is asked on Android');
  }

  @override
  Future<void> presentBroadcastPicker() async {
    throw UnsupportedError('The broadcast picker is only supported on iOS');
  }

  @override
  Future<void> stopBroadcast() async {
    throw UnsupportedError('The broadcast is only supported on iOS');
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
    return _VideoElementFirstFrameWatcher(stream, onFirstFrame);
  }

  @override
  EncryptionManager createEncryptionManager({
    required String userId,
    EncryptionAlgorithm algorithm = EncryptionAlgorithm.aes128Gcm,
  }) {
    throw UnsupportedError('End-to-end encryption is not supported on web');
  }
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
class _BrowserWebRtcAudio implements WebRtcAudio {
  _BrowserWebRtcAudio(this._engine);

  final BrowserWebRtcEngine _engine;

  @override
  Future<void> selectAudioOutput(String deviceId) async {
    await _engine.mediaDevices.selectAudioOutput(
      AudioOutputOptions(deviceId: deviceId),
    );
  }

  @override
  Future<void> selectAudioInput(String deviceId) async {
    throw UnsupportedError('Capture the new microphone instead');
  }

  @override
  Future<void> setPlayoutPaused(bool paused) {
    return audio_renderer.setAudioPlayoutPaused(paused);
  }

  @override
  bool get hasAudioSession => false;

  @override
  Future<void> setAppleAudioConfiguration(
    AppleAudioConfiguration configuration,
  ) async {
    throw UnsupportedError('The browser has no Apple audio session');
  }

  @override
  Future<void> setStereoPlayoutPreferred(bool preferred) async {}

  @override
  Future<void> regainAndroidAudioFocus() async {
    throw UnsupportedError('Audio focus is managed on Android only');
  }

  @override
  Future<void> setAndroidAudioFocusHandledBySystem(
    bool handledBySystem,
  ) async {
    throw UnsupportedError('Audio focus is managed on Android only');
  }

  @override
  Future<void> showAudioRoutePicker() async {
    throw UnsupportedError('The audio route picker is on iOS only');
  }

  @override
  bool isExternalDevice(String? groupId) =>
      groupId?.toLowerCase().contains('bluetooth') ?? false;
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
class _BrowserWebRtcCamera implements WebRtcCamera {
  const _BrowserWebRtcCamera();

  @override
  Future<bool> switchCamera(MediaStreamTrack track) async {
    throw UnsupportedError('Capture the other camera instead');
  }

  @override
  Future<void> setZoom(MediaStreamTrack track, double zoomLevel) async {
    throw UnsupportedError('Zoom is supported on Android and iOS only');
  }

  @override
  Future<void> setFocusPoint(
    MediaStreamTrack track,
    Point<double>? point,
  ) async {
    throw UnsupportedError('Focus is set on Android and iOS only');
  }

  @override
  Future<void> setExposurePoint(
    MediaStreamTrack track,
    Point<double>? point,
  ) async {
    throw UnsupportedError('Exposure is set on Android and iOS only');
  }

  @override
  Future<bool> setMultitaskingAccessEnabled(bool enabled) async {
    throw UnsupportedError('Multitasking camera access is on iOS only');
  }

  @override
  Future<bool?> isMultitaskingAccessSupported() async => null;
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// Plays the stream muted in a video element that is not in the page, and
/// reports the first frame when the element has loaded it.
class _VideoElementFirstFrameWatcher implements FirstFrameWatcher {
  _VideoElementFirstFrameWatcher(MediaStream stream, this._onFirstFrame) {
    _element
      ..muted = true
      ..autoplay = true
      ..playsInline = true
      ..srcObject = (stream as MediaStreamWeb).jsStream;
    _loaded = web.EventStreamProviders.loadedDataEvent
        .forTarget(_element)
        .listen((_) => _report());
    _element.play().toDart.ignore();
  }

  final web.HTMLVideoElement _element = web.HTMLVideoElement();
  final void Function() _onFirstFrame;
  StreamSubscription<web.Event>? _loaded;

  void _report() {
    _loaded?.cancel();
    _loaded = null;
    _onFirstFrame();
  }

  @override
  Future<void> dispose() async {
    await _loaded?.cancel();
    _loaded = null;
    _element
      ..pause()
      ..srcObject = null;
  }
}
