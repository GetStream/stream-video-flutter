// {
//   id: RTCCodec_0_Inbound_101,
//   type: codec,
//   timestamp: 1679505083000830.0,
//   mimeType: video/rtx,
//   transportId: RTCTransport_0_1,
//   clockRate: 90000,
//   sdpFmtpLine: apt=100,
//   payloadType: 101
// }

import 'rtc_stats.dart';

class RtcCodec extends RtcStats {
  const RtcCodec({
    super.id,
    super.type,
    super.timestamp,
    this.sdpFmtpLine,
    this.payloadType,
    this.transportId,
    this.mimeType,
    this.clockRate,
  });

  final String? sdpFmtpLine;
  final int? payloadType;
  final String? transportId;
  final String? mimeType;
  final int? clockRate;

  String? get codecId => id;

  static RtcCodec? fromJson(dynamic value) {
    if (value is Map) {
      return RtcCodec(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        sdpFmtpLine: value['sdpFmtpLine'],
        payloadType: value['payloadType'],
        transportId: value['transportId'],
        mimeType: value['mimeType'],
        clockRate: value['clockRate'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCCodec{id: $id, type: $type, timestamp: $timestamp, '
        'sdpFmtpLine: $sdpFmtpLine, payloadType: $payloadType, '
        'transportId: $transportId, mimeType: $mimeType, '
        'clockRate: $clockRate}';
  }
}
