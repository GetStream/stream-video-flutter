// {
//   id: RTCRemoteInboundRtpVideoStream_3784832368,
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

import 'rtc_inbound_rtp.dart';
import 'rtc_writable.dart';

class RtcRemoteInboundRtp implements RtcInboundRtp, RtcWritable {
  const RtcRemoteInboundRtp({
    this.id,
    this.type,
    this.timestamp,
    this.transportId,
    this.kind,
    this.outboundId,
    this.codecId,
    this.ssrc,
    this.jitter,
    this.roundTripTimeMeasurements,
    this.roundTripTime,
    this.totalRoundTripTime,
    this.fractionLost,
    this.packetsLost,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? transportId;
  final String? kind;
  final String? outboundId;
  final String? codecId;
  final int? ssrc;
  final double? jitter;
  final int? roundTripTimeMeasurements;
  final double? roundTripTime;
  final double? totalRoundTripTime;
  final double? fractionLost;
  final int? packetsLost;

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('ssrc: ')
      ..write(ssrc)
      ..write('\n')
      ..write('outboundId: ')
      ..write(outboundId.hashCode)
      ..write('\n')
      ..write('roundTripTime: ')
      ..write(roundTripTime)
      ..write('\n')
      ..write('packetsLost: ')
      ..write(packetsLost)
      ..write('\n');
  }
}
