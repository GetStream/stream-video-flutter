import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

import 'media_stream_impl.dart';
import 'rtc_rtp_receiver_impl.dart';
import 'rtc_rtp_sender_impl.dart';

List<RTCRtpEncoding> listToRtpEncodings(List<Map<String, dynamic>> list) {
  return list.map((e) => RTCRtpEncoding.fromMap(e)).toList();
}

@Deprecated('RTCRtpTransceiverInitWeb isn\'t referenced from anywhere.')
class RTCRtpTransceiverInitWeb extends RTCRtpTransceiverInit {
  RTCRtpTransceiverInitWeb(TransceiverDirection direction,
      List<MediaStream> streams, List<RTCRtpEncoding> sendEncodings)
      : super(
            direction: direction,
            streams: streams,
            sendEncodings: sendEncodings);

  factory RTCRtpTransceiverInitWeb.fromMap(Map<dynamic, dynamic> map) {
    if (map['direction'] == null) {
      throw Exception('You must provide a direction');
    }
    if (map['streams'] == null) {
      throw Exception('You must provide the streams');
    }

    return RTCRtpTransceiverInitWeb(
        typeStringToRtpTransceiverDirection[map['direction']]!,
        (map['streams'] as List<MediaStream>).map((e) => e).toList(),
        listToRtpEncodings(map['sendEncodings']));
  }

  Map<String, dynamic> toMap() => {
        'direction': typeRtpTransceiverDirectionToString[direction],
        if (streams != null) 'streamIds': streams!.map((e) => e.id).toList(),
        if (sendEncodings != null)
          'sendEncodings': sendEncodings!.map((e) => e.toMap()).toList(),
      };
}

extension RTCRtpTransceiverInitWebExt on RTCRtpTransceiverInit {
  JSObject toJsObject() => {
        'direction': typeRtpTransceiverDirectionToString[direction],
        if (streams != null)
          'streams':
              streams!.map((e) => (e as MediaStreamWeb).jsStream).toList(),
        if (sendEncodings != null)
          'sendEncodings': sendEncodings!.map((e) => e.toMap()).toList(),
      }.jsify() as JSObject;
}

class RTCRtpTransceiverWeb extends RTCRtpTransceiver {
  RTCRtpTransceiverWeb(this._jsTransceiver, _peerConnectionId);

  factory RTCRtpTransceiverWeb.fromJsObject(web.RTCRtpTransceiver jsTransceiver,
      {String? peerConnectionId}) {
    var transceiver = RTCRtpTransceiverWeb(jsTransceiver, peerConnectionId);
    return transceiver;
  }

  web.RTCRtpTransceiver _jsTransceiver;

  @override
  Future<TransceiverDirection?> getCurrentDirection() async =>
      typeStringToRtpTransceiverDirection[_jsTransceiver.currentDirection];

  @override
  Future<TransceiverDirection> getDirection() async =>
      typeStringToRtpTransceiverDirection[_jsTransceiver.direction]!;

  @override
  String get mid => _jsTransceiver.mid!;

  @override
  RTCRtpSender get sender =>
      RTCRtpSenderWeb.fromJsSender(_jsTransceiver.sender);

  @override
  RTCRtpReceiver get receiver => RTCRtpReceiverWeb(_jsTransceiver.receiver);

  @override
  bool get stoped =>
      _jsTransceiver.getProperty<JSBoolean>('stopped'.toJS).toDart;

  @override
  String get transceiverId => mid;

  @override
  Future<void> setDirection(TransceiverDirection direction) async {
    try {
      _jsTransceiver.direction =
          typeRtpTransceiverDirectionToString[direction]!;
    } on Exception catch (e) {
      throw 'Unable to RTCRtpTransceiver::setDirection: ${e.toString()}';
    }
  }

  @override
  Future<void> stop() async {
    try {
      _jsTransceiver.stop();
    } on Exception catch (e) {
      throw 'Unable to RTCRtpTransceiver::stop: ${e..toString()}';
    }
  }

  @override
  Future<void> setCodecPreferences(List<RTCRtpCodecCapability> codecs) async {
    try {
      _jsTransceiver.setCodecPreferences(codecs
          .map((e) => e.toMap().jsify() as web.RTCRtpCodec)
          .toList()
          .toJS);
    } on Exception catch (e) {
      throw 'Unable to RTCRtpTransceiver::setCodecPreferences: ${e..toString()}';
    }
  }
}
