import 'dart:async';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../../../native/native_platform_events.dart';
import '../../../native/native_webrtc_capabilities.dart';
import '../desktop_capturer.dart';
import 'data_packet_cryptor_impl.dart';
import 'desktop_capturer_impl.dart';
import 'media_recorder_impl.dart';
import 'media_stream_impl.dart';
import 'mediadevices_impl.dart';
import 'navigator_impl.dart';
import 'rtc_peerconnection_impl.dart';
import 'rtc_video_renderer_impl.dart';
import 'utils.dart';

class RTCFactoryNative extends RTCFactory {
  RTCFactoryNative._internal();

  static final RTCFactory instance = RTCFactoryNative._internal();

  Future<void> setVideoEffects(String trackId, List<String> names) async {
    await WebRTC.invokeMethod('setVideoEffects', {
      'trackId': trackId,
      'names': names,
    });
  }

  @override
  Future<MediaStream> createLocalMediaStream(String label) async {
    final response = await WebRTC.invokeMethod('createLocalMediaStream');
    if (response == null) {
      throw Exception('createLocalMediaStream return null, something wrong');
    }
    return MediaStreamNative(response['streamId'], label);
  }

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) async {
    final defaultConstraints = <String, dynamic>{
      'mandatory': {},
      'optional': [
        {'DtlsSrtpKeyAgreement': true},
      ],
    };

    final response = await WebRTC.invokeMethod(
      'createPeerConnection',
      <String, dynamic>{
        'configuration': configuration,
        'constraints': constraints.isEmpty ? defaultConstraints : constraints,
      },
    );

    final String peerConnectionId = response['peerConnectionId'];
    return RTCPeerConnectionNative(peerConnectionId, configuration);
  }

  @override
  MediaRecorder mediaRecorder() {
    return MediaRecorderNative();
  }

  @override
  VideoRenderer videoRenderer() {
    return RTCVideoRenderer();
  }

  @override
  Navigator get navigator => NavigatorNative.instance;

  @override
  @Deprecated('use NativePeerConnectionFactory.getRtpReceiverCapabilities')
  Future<RTCRtpCapabilities> getRtpReceiverCapabilities(String kind) async {
    final response = await WebRTC.invokeMethod(
      'getRtpReceiverCapabilities',
      <String, dynamic>{'kind': kind},
    );
    return RTCRtpCapabilities.fromMap(response);
  }

  @override
  @Deprecated('use NativePeerConnectionFactory.getRtpSenderCapabilities')
  Future<RTCRtpCapabilities> getRtpSenderCapabilities(String kind) async {
    final response = await WebRTC.invokeMethod(
      'getRtpSenderCapabilities',
      <String, dynamic>{'kind': kind},
    );
    return RTCRtpCapabilities.fromMap(response);
  }

  @override
  FrameCryptorFactory get frameCryptorFactory => throw UnimplementedError(
    'FrameCryptor support has been temporarily removed from '
    'stream_webrtc_flutter and will be re-added in a future release.',
  );
}

Future<void> setVideoEffects(
  String trackId, {
  required List<String> names,
}) async {
  return (RTCFactoryNative.instance as RTCFactoryNative).setVideoEffects(
    trackId,
    names,
  );
}

Future<RTCPeerConnection> createPeerConnection(
  Map<String, dynamic> configuration, [
  Map<String, dynamic> constraints = const {},
]) async {
  return RTCFactoryNative.instance.createPeerConnection(
    configuration,
    constraints,
  );
}

Future<MediaStream> createLocalMediaStream(String label) async {
  return RTCFactoryNative.instance.createLocalMediaStream(label);
}

@Deprecated('use NativePeerConnectionFactory.getRtpReceiverCapabilities')
Future<RTCRtpCapabilities> getRtpReceiverCapabilities(String kind) async {
  // ignore: deprecated_member_use_from_same_package
  return RTCFactoryNative.instance.getRtpReceiverCapabilities(kind);
}

@Deprecated('use NativePeerConnectionFactory.getRtpSenderCapabilities')
Future<RTCRtpCapabilities> getRtpSenderCapabilities(String kind) async {
  // ignore: deprecated_member_use_from_same_package
  return RTCFactoryNative.instance.getRtpSenderCapabilities(kind);
}

MediaRecorder mediaRecorder() {
  return RTCFactoryNative.instance.mediaRecorder();
}

Navigator get navigator => RTCFactoryNative.instance.navigator;

DesktopCapturer get desktopCapturer => DesktopCapturerNative.instance;

MediaDevices get mediaDevices => MediaDeviceNative.instance;

/// The raw events of the plugin's event channel, each a single-entry map from
/// the event name to the native payload. Read [platformEvents] instead.
@internal
Stream<Map<String, dynamic>> get eventStream =>
    MediaDeviceNative.instance.eventStream;

/// The events the platform reports outside of a peer connection, a track or a
/// renderer.
WebRtcPlatformEvents get platformEvents => NativeWebRtcPlatformEvents.instance;

DataPacketCryptorFactory get dataPacketCryptorFactory =>
    DataPacketCryptorFactoryImpl.instance;

/// What the WebRTC implementation on this platform can do.
WebRtcCapabilities get webRtcCapabilities =>
    // ignore: invalid_use_of_visible_for_testing_member, the override's reader
    debugWebRtcCapabilitiesOverride ?? nativeWebRtcCapabilities;
