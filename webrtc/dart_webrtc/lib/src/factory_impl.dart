import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

import 'frame_cryptor_impl.dart';
import 'media_recorder_impl.dart';
import 'media_stream_impl.dart';
import 'navigator_impl.dart';
import 'rtc_peerconnection_impl.dart';
import 'rtc_rtp_capailities_imp.dart';

@JS('RTCRtpSender')
@staticInterop
class RTCRtpSenderJs {
  external static web.RTCRtpCapabilities getCapabilities(String kind);
}

@JS('RTCRtpReceiver')
@staticInterop
class RTCRtpReceiverJs {
  external static web.RTCRtpCapabilities getCapabilities(String kind);
}

class RTCFactoryWeb extends RTCFactory {
  RTCFactoryWeb._internal();
  static final instance = RTCFactoryWeb._internal();

  @override
  Future<RTCPeerConnection> createPeerConnection(
      Map<String, dynamic> configuration,
      [Map<String, dynamic>? constraints]) async {
    final constr = (constraints != null && constraints.isNotEmpty)
        ? constraints
        : {
            'mandatory': {},
            'optional': [
              {'DtlsSrtpKeyAgreement': true},
            ],
          };
    final jsRtcPc = web.RTCPeerConnection(
        {...constr, ...configuration}.jsify() as web.RTCConfiguration);
    final _peerConnectionId = base64Encode(jsRtcPc.toString().codeUnits);
    return RTCPeerConnectionWeb(_peerConnectionId, jsRtcPc);
  }

  @override
  Future<MediaStream> createLocalMediaStream(String label) async {
    final jsMs = web.MediaStream();
    return MediaStreamWeb(jsMs, 'local');
  }

  @override
  MediaRecorder mediaRecorder() {
    return MediaRecorderWeb();
  }

  @override
  VideoRenderer videoRenderer() {
    throw UnimplementedError();
  }

  @override
  Navigator get navigator => NavigatorWeb();

  @override
  FrameCryptorFactory get frameCryptorFactory =>
      FrameCryptorFactoryImpl.instance;

  @override
  Future<RTCRtpCapabilities> getRtpReceiverCapabilities(String kind) async {
    var caps = RTCRtpReceiverJs.getCapabilities(kind);
    return RTCRtpCapabilitiesWeb.fromJsObject(caps);
  }

  @override
  Future<RTCRtpCapabilities> getRtpSenderCapabilities(String kind) async {
    var caps = RTCRtpSenderJs.getCapabilities(kind);
    return RTCRtpCapabilitiesWeb.fromJsObject(caps);
  }
}

Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration,
    [Map<String, dynamic>? constraints]) {
  return RTCFactoryWeb.instance
      .createPeerConnection(configuration, constraints);
}

Future<MediaStream> createLocalMediaStream(String label) {
  return RTCFactoryWeb.instance.createLocalMediaStream(label);
}

Future<RTCRtpCapabilities> getRtpReceiverCapabilities(String kind) async {
  return RTCFactoryWeb.instance.getRtpReceiverCapabilities(kind);
}

Future<RTCRtpCapabilities> getRtpSenderCapabilities(String kind) async {
  return RTCFactoryWeb.instance.getRtpSenderCapabilities(kind);
}

MediaRecorder mediaRecorder() {
  return RTCFactoryWeb.instance.mediaRecorder();
}

VideoRenderer videoRenderer() {
  return RTCFactoryWeb.instance.videoRenderer();
}

Navigator get navigator => RTCFactoryWeb.instance.navigator;

FrameCryptorFactory get frameCryptorFactory => FrameCryptorFactoryImpl.instance;

MediaDevices get mediaDevices => navigator.mediaDevices;
