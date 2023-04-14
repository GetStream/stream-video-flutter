// {
//   id: RTCRemoteInboundRTPVideoStream_3784832368,
//   type: remote-inbound-rtp,
//   timestamp: 1679505082075000.0,
//   transportId: RTCTransport_0_1,
//   kind: video,
//   localId: RTCOutboundRTPVideoStream_3784832368,
//   codecId: RTCCodec_0_Outbound_98,
//   ssrc: 3784832368
//   jitter: 0.004722222222222222,
//   roundTripTimeMeasurements: 72,
//   roundTripTime: 0.162,
//   totalRoundTripTime: 11.728,
//   fractionLost: 0.0,
//   packetsLost: 0,
// }

import 'rtc_remote_inbound_rtp.dart';

class RtcRemoteInboundRtpVideoStream extends RtcRemoteInboundRtp {
  const RtcRemoteInboundRtpVideoStream({
    super.id,
    super.type,
    super.timestamp,
    super.transportId,
    super.kind,
    super.outboundId,
    super.codecId,
    super.ssrc,
    super.jitter,
    super.roundTripTimeMeasurements,
    super.roundTripTime,
    super.totalRoundTripTime,
    super.fractionLost,
    super.packetsLost,
  });

  static RtcRemoteInboundRtpVideoStream? fromJson(dynamic value) {
    if (value is Map) {
      return RtcRemoteInboundRtpVideoStream(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        kind: value['kind'],
        outboundId: value['localId'],
        codecId: value['codecId'],
        ssrc: value['ssrc'],
        jitter: value['jitter'],
        roundTripTimeMeasurements: value['roundTripTimeMeasurements'],
        roundTripTime: value['roundTripTime'],
        totalRoundTripTime: value['totalRoundTripTime'],
        fractionLost: value['fractionLost'],
        packetsLost: value['packetsLost'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RtcRemoteInboundRtpVideoStream{id: $id, type: $type, '
        'timestamp: $timestamp, transportId: $transportId, kind: $kind, '
        'outboundId: $outboundId, codecId: $codecId, '
        'ssrc: $ssrc, jitter: $jitter, '
        'roundTripTimeMeasurements: $roundTripTimeMeasurements, '
        'roundTripTime: $roundTripTime, '
        'totalRoundTripTime: $totalRoundTripTime, '
        'fractionLost: $fractionLost, packetsLost: $packetsLost}';
  }
}
