// {
//  id: RTCOutboundRTPAudioStream_2115539764,
//  type: outbound-rtp,
//  timestamp: 1679425535359288.0,
//  transportId: RTCTransport_0_1,
//  headerBytesSent: 4960,
//  nackCount: 0,
//  retransmittedPacketsSent: 0,
//  kind: audio,
//  trackId: RTCMediaStreamTrack_sender_3,
//  targetBitrate: 32000.0,
//  ssrc: 2115539764,
//  mediaType: audio,
//  bytesSent: 8060,
//  mediaSourceId: RTCAudioSource_3,
//  remoteId: RTCRemoteInboundRtpAudioStream_2115539764,
//  codecId: RTCCodec_1_Outbound_111,
//  packetsSent: 248,
//  retransmittedBytesSent: 0
// }

import '../../../utils/format.dart';
import 'rtc_outbound_rtp.dart';
import 'rtc_writable.dart';

class RtcOutboundRtpAudioStream implements RtcOutboundRtp, RtcWritable {
  const RtcOutboundRtpAudioStream({
    this.id,
    this.type,
    this.timestamp,
    this.transportId,
    this.headerBytesSent,
    this.nackCount,
    this.retransmittedPacketsSent,
    this.kind,
    this.trackId,
    this.targetBitrate,
    this.ssrc,
    this.mediaType,
    this.bytesSent,
    this.mediaSourceId,
    this.remoteId,
    this.codecId,
    this.packetsSent,
    this.retransmittedBytesSent,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? transportId;
  final int? headerBytesSent;
  final int? nackCount;
  final int? retransmittedPacketsSent;
  final String? kind;
  final String? trackId;
  final double? targetBitrate;
  final int? ssrc;
  final String? mediaType;
  final int? bytesSent;
  final String? mediaSourceId;
  final String? remoteId;
  final String? codecId;
  final int? packetsSent;
  final int? retransmittedBytesSent;

  static RtcOutboundRtpAudioStream? fromJson(dynamic value) {
    if (value is Map) {
      return RtcOutboundRtpAudioStream(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        headerBytesSent: value['headerBytesSent'],
        nackCount: value['nackCount'],
        retransmittedPacketsSent: value['retransmittedPacketsSent'],
        kind: value['kind'],
        trackId: value['trackId'],
        targetBitrate: value['targetBitrate'],
        ssrc: value['ssrc'],
        mediaType: value['mediaType'],
        bytesSent: value['bytesSent'],
        mediaSourceId: value['mediaSourceId'],
        remoteId: value['remoteId'],
        codecId: value['codecId'],
        packetsSent: value['packetsSent'],
        retransmittedBytesSent: value['retransmittedBytesSent'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCOutboundRTPAudioStream{id: $id, type: $type, '
        'timestamp: $timestamp, transportId: $transportId, '
        'headerBytesSent: $headerBytesSent, '
        'nackCount: $nackCount, '
        'retransmittedPacketsSent: $retransmittedPacketsSent, kind: $kind, '
        'trackId: $trackId, targetBitrate: $targetBitrate, ssrc: $ssrc, '
        'mediaType: $mediaType, bytesSent: $bytesSent, '
        'mediaSourceId: $mediaSourceId, remoteId: $remoteId, '
        'codecId: $codecId, packetsSent: $packetsSent, '
        'retransmittedBytesSent: $retransmittedBytesSent}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('outboundId: ')
      ..write(id.hashCode)
      ..write('\n')
      ..write('ssrc: ')
      ..write(ssrc)
      ..write('\n')
      ..write('packetsSent: ')
      ..write(packetsSent)
      ..write('\n')
      ..write('bytesSent: ')
      ..write(bytesCountToReadableString(bytesSent ?? 0))
      ..write('\n');
  }
}
