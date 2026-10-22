import 'dart:async';

import 'package:flutter/services.dart';

import 'package:webrtc_interface/webrtc_interface.dart';

import 'media_stream_impl.dart';
import 'rtc_peerconnection_impl.dart';
import 'utils.dart';

/// Per-call peer connection factory.
///
/// Wraps a native `NativePeerConnectionFactory` (Android / iOS / macOS) so
/// each call owns an isolated `AudioDeviceModule`.
///
/// All methods route to the underlying factory by sending its [factoryId] over
/// the method channel.
class NativePeerConnectionFactory {
  NativePeerConnectionFactory._(this.factoryId);

  final String factoryId;
  bool _disposed = false;

  /// Builds a fresh per-call factory. Initializes the WebRTC plugin if it
  /// hasn't been initialized yet.
  ///
  /// [options] mirrors the [WebRTC.initialize] options map
  static Future<NativePeerConnectionFactory> create({
    Map<String, dynamic>? options,
  }) async {
    final response = await WebRTC.invokeMethod(
      'createPeerConnectionFactory',
      <String, dynamic>{'options': options ?? <String, dynamic>{}},
    );

    if (response == null) {
      throw Exception(
        'createPeerConnectionFactory returned null, something wrong',
      );
    }

    final factoryId = response['factoryId'] as String;
    return NativePeerConnectionFactory._(factoryId);
  }

  /// Builds a peer connection that lives inside this factory.
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) async {
    _checkDisposed('createPeerConnection');
    final defaultConstraints = <String, dynamic>{
      'mandatory': <String, dynamic>{},
      'optional': <Map<String, dynamic>>[
        {'DtlsSrtpKeyAgreement': true},
      ],
    };
    final response =
        await WebRTC.invokeMethod('createPeerConnection', <String, dynamic>{
          'configuration': configuration,
          'constraints': constraints.isEmpty ? defaultConstraints : constraints,
          'factoryId': factoryId,
        });

    final peerConnectionId = response['peerConnectionId'] as String;
    return RTCPeerConnectionNative(peerConnectionId, configuration);
  }

  /// Captures user media against this factory.
  Future<MediaStream> getUserMedia(
    Map<String, dynamic> mediaConstraints,
  ) async {
    _checkDisposed('getUserMedia');
    try {
      final response = await WebRTC.invokeMethod(
        'getUserMedia',
        <String, dynamic>{
          'constraints': mediaConstraints,
          'factoryId': factoryId,
        },
      );
      if (response == null) {
        throw Exception('getUserMedia returned null, something wrong');
      }
      final stream = MediaStreamNative(response['streamId'] as String, 'local');
      stream.setMediaTracks(
        response['audioTracks'] ?? <dynamic>[],
        response['videoTracks'] ?? <dynamic>[],
      );
      return stream;
    } on PlatformException catch (e) {
      throw 'Unable to getUserMedia: ${e.message}';
    }
  }

  /// Captures the screen against this factory.
  Future<MediaStream> getDisplayMedia(
    Map<String, dynamic> mediaConstraints,
  ) async {
    _checkDisposed('getDisplayMedia');
    try {
      final response = await WebRTC.invokeMethod(
        'getDisplayMedia',
        <String, dynamic>{
          'constraints': mediaConstraints,
          'factoryId': factoryId,
        },
      );
      if (response == null) {
        throw Exception('getDisplayMedia returned null, something wrong');
      }
      final stream = MediaStreamNative(response['streamId'] as String, 'local');
      stream.setMediaTracks(response['audioTracks'], response['videoTracks']);
      return stream;
    } on PlatformException catch (e) {
      throw 'Unable to getDisplayMedia: ${e.message}';
    }
  }

  /// Creates an empty local media stream backed by this factory.
  Future<MediaStream> createLocalMediaStream(String label) async {
    _checkDisposed('createLocalMediaStream');
    final response = await WebRTC.invokeMethod(
      'createLocalMediaStream',
      <String, dynamic>{'factoryId': factoryId},
    );
    if (response == null) {
      throw Exception('createLocalMediaStream returned null, something wrong');
    }
    return MediaStreamNative(response['streamId'] as String, label);
  }

  /// Requests Android screen-capture permission. The granted projection data
  /// lives on this factory's `GetUserMediaImpl`, so the subsequent
  /// [getDisplayMedia] call must be issued through this same instance.
  Future<bool> requestCapturePermission({bool fullScreenOnly = false}) async {
    _checkDisposed('requestCapturePermission');
    if (!WebRTC.platformIsAndroid) {
      throw Exception('requestCapturePermission only supported for Android');
    }
    final result = await WebRTC.invokeMethod(
      'requestCapturePermission',
      <String, dynamic>{
        'factoryId': factoryId,
        'fullScreenOnly': fullScreenOnly,
      },
    );
    return result == true;
  }

  Future<RTCRtpCapabilities> getRtpSenderCapabilities(String kind) async {
    _checkDisposed('getRtpSenderCapabilities');
    final response = await WebRTC.invokeMethod(
      'getRtpSenderCapabilities',
      <String, dynamic>{'kind': kind, 'factoryId': factoryId},
    );
    return RTCRtpCapabilities.fromMap(response);
  }

  Future<RTCRtpCapabilities> getRtpReceiverCapabilities(String kind) async {
    _checkDisposed('getRtpReceiverCapabilities');
    final response = await WebRTC.invokeMethod(
      'getRtpReceiverCapabilities',
      <String, dynamic>{'kind': kind, 'factoryId': factoryId},
    );
    return RTCRtpCapabilities.fromMap(response);
  }

  Future<void> startLocalRecording() async {
    _checkDisposed('startLocalRecording');
    try {
      await WebRTC.invokeMethod('startLocalRecording', <String, dynamic>{
        'factoryId': factoryId,
      });
    } on PlatformException catch (e) {
      throw 'Unable to start local recording: ${e.message}';
    }
  }

  Future<void> stopLocalRecording() async {
    _checkDisposed('stopLocalRecording');
    try {
      await WebRTC.invokeMethod('stopLocalRecording', <String, dynamic>{
        'factoryId': factoryId,
      });
    } on PlatformException catch (e) {
      throw 'Unable to stop local recording: ${e.message}';
    }
  }

  /// Whether ADM-level microphone mute is available on the current platform.
  ///
  /// iOS and macOS only — see [setMicrophoneMuted].
  static bool get isAdmMicrophoneMuteSupported =>
      WebRTC.platformIsIOS || WebRTC.platformIsMacOS;

  /// Mutes/unmutes mic at the ADM level (**iOS/macOS only**), allowing detection
  /// of "speaking while muted."
  ///
  /// No Android support: mute the local audio track there instead.
  /// Throws [UnsupportedError] elsewhere; guard with
  /// [isAdmMicrophoneMuteSupported].
  Future<void> setMicrophoneMuted(bool muted) async {
    _checkAdmMuteSupported('setMicrophoneMuted');
    _checkDisposed('setMicrophoneMuted');
    try {
      await WebRTC.invokeMethod('appleAdmSetMicrophoneMuted', <String, dynamic>{
        'factoryId': factoryId,
        'muted': muted,
      });
    } on PlatformException catch (e) {
      throw 'Unable to set microphone muted: ${e.message}';
    }
  }

  /// Reads back the audio-device-module microphone mute state.
  ///
  /// **iOS / macOS only**, same rationale as [setMicrophoneMuted]. Throws
  /// [UnsupportedError] elsewhere.
  ///
  /// Note that the native readback cannot distinguish "not muted" from "the
  /// ADM could not be queried": both surface as `false`. Treat a `false` here
  /// as "not known to be muted" rather than proof that capture is live.
  Future<bool> isMicrophoneMuted() async {
    _checkAdmMuteSupported('isMicrophoneMuted');
    _checkDisposed('isMicrophoneMuted');
    try {
      final response = await WebRTC.invokeMethod(
        'appleAdmIsMicrophoneMuted',
        <String, dynamic>{'factoryId': factoryId},
      );
      return response == true;
    } on PlatformException catch (e) {
      throw 'Unable to read microphone muted: ${e.message}';
    }
  }

  void _checkAdmMuteSupported(String method) {
    if (!isAdmMicrophoneMuteSupported) {
      throw UnsupportedError(
        'NativePeerConnectionFactory.$method is only supported on iOS and '
        'macOS. Mute the local audio track instead.',
      );
    }
  }

  /// Disposes the underlying native factory.
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await WebRTC.invokeMethod('disposePeerConnectionFactory', <String, dynamic>{
      'factoryId': factoryId,
    });
  }

  /// Suspends this factory's audio capture + playback. Use when another
  /// factory needs exclusive access to mic/speaker resources (multicall scenario). Native impl
  Future<void> suspendAudio() async {
    _checkDisposed('suspendAudio');
    await WebRTC.invokeMethod(
      'suspendAudioPeerConnectionFactory',
      <String, dynamic>{'factoryId': factoryId},
    );
  }

  /// Resumes a previously [suspendAudio]'d factory.
  Future<void> resumeAudio() async {
    _checkDisposed('resumeAudio');
    await WebRTC.invokeMethod(
      'resumeAudioPeerConnectionFactory',
      <String, dynamic>{'factoryId': factoryId},
    );
  }

  void _checkDisposed(String op) {
    if (_disposed) {
      throw StateError(
        '$op called on disposed NativePeerConnectionFactory($factoryId)',
      );
    }
  }
}
