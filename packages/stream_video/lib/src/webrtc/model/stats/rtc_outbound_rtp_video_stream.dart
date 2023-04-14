// {
//   id: RTCOutboundRTPVideoStream_3543377621,
//   type: outbound-rtp,
//   timestamp: 1679425535359288.0,
//   transportId: RTCTransport_0_1,
//   qpSum: 615,
//   headerBytesSent: 161944,
//   hugeFramesSent: 0,
//   framesEncoded: 51,
//   nackCount: 0,
//   totalPacketSendDelay: 7.045,
//   rid: f,
//   totalEncodeTime: 0.938,
//   firCount: 0,
//   pliCount: 2,
//   packetsSent: 854,
//   frameHeight: 1280,
//   frameWidth: 720,
//   framesSent: 51,
//   framesPerSecond: 12.0,
//   keyFramesEncoded: 3,
//   retransmittedPacketsSent: 0,
//   kind: video,
//   trackId: RTCMediaStreamTrack_sender_2,
//   ssrc: 3543377621,
//   mediaType: video,
//   qualityLimitationReason: none,
//   qualityLimitationResolutionChanges: 1,
//   bytesSent: 221789,
//   mediaSourceId: RTCVideoSource_2,
//   encoderImplementation: SimulcastEncoderAdapter (libvpx, libvpx, libvpx),
//   remoteId: RTCRemoteInboundRtpVideoStream_3543377621,
//   codecId: RTCCodec_0_Outbound_96,
//   totalEncodedBytesTarget: 0,
//   retransmittedBytesSent: 0,
// }

import '../../../utils/format.dart';
import 'rtc_outbound_rtp.dart';
import 'rtc_writable.dart';

class RTCOutboundRTPVideoStream implements RtcOutboundRtp, RtcWritable {
  const RTCOutboundRTPVideoStream({
    this.id,
    this.type,
    this.timestamp,
    this.transportId,
    this.qpSum,
    this.headerBytesSent,
    this.hugeFramesSent,
    this.framesEncoded,
    this.nackCount,
    this.totalPacketSendDelay,
    this.rid,
    this.totalEncodeTime,
    this.firCount,
    this.pliCount,
    this.packetsSent,
    this.frameHeight,
    this.frameWidth,
    this.framesSent,
    this.framesPerSecond,
    this.keyFramesEncoded,
    this.retransmittedPacketsSent,
    this.kind,
    this.trackId,
    this.ssrc,
    this.mediaType,
    this.qualityLimitationReason,
    this.qualityLimitationResolutionChanges,
    this.bytesSent,
    this.mediaSourceId,
    this.encoderImplementation,
    this.remoteId,
    this.codecId,
    this.totalEncodedBytesTarget,
    this.retransmittedBytesSent,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? transportId;
  final int? qpSum;
  final int? headerBytesSent;
  final int? hugeFramesSent;
  final int? framesEncoded;
  final int? nackCount;
  final double? totalPacketSendDelay;
  final String? rid;
  final double? totalEncodeTime;
  final int? firCount;
  final int? pliCount;
  final int? packetsSent;
  final int? frameHeight;
  final int? frameWidth;
  final int? framesSent;
  final double? framesPerSecond;
  final int? keyFramesEncoded;
  final int? retransmittedPacketsSent;
  final String? kind;
  final String? trackId;
  final int? ssrc;
  final String? mediaType;
  final String? qualityLimitationReason;
  final int? qualityLimitationResolutionChanges;
  final int? bytesSent;
  final String? mediaSourceId;
  final String? encoderImplementation;
  final String? remoteId;
  final String? codecId;
  final int? totalEncodedBytesTarget;
  final int? retransmittedBytesSent;

  static RTCOutboundRTPVideoStream? fromJson(dynamic value) {
    if (value is Map) {
      return RTCOutboundRTPVideoStream(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        qpSum: value['qpSum'],
        headerBytesSent: value['headerBytesSent'],
        hugeFramesSent: value['hugeFramesSent'],
        framesEncoded: value['framesEncoded'],
        nackCount: value['nackCount'],
        totalPacketSendDelay: value['totalPacketSendDelay'],
        rid: value['rid'],
        totalEncodeTime: value['totalEncodeTime'],
        firCount: value['firCount'],
        pliCount: value['pliCount'],
        packetsSent: value['packetsSent'],
        frameHeight: value['frameHeight'],
        frameWidth: value['frameWidth'],
        framesSent: value['framesSent'],
        framesPerSecond: value['framesPerSecond'],
        keyFramesEncoded: value['keyFramesEncoded'],
        retransmittedPacketsSent: value['retransmittedPacketsSent'],
        kind: value['kind'],
        trackId: value['trackId'],
        ssrc: value['ssrc'],
        mediaType: value['mediaType'],
        qualityLimitationReason: value['qualityLimitationReason'],
        qualityLimitationResolutionChanges:
            value['qualityLimitationResolutionChanges'],
        bytesSent: value['bytesSent'],
        mediaSourceId: value['mediaSourceId'],
        encoderImplementation: value['encoderImplementation'],
        remoteId: value['remoteId'],
        codecId: value['codecId'],
        totalEncodedBytesTarget: value['totalEncodedBytesTarget'],
        retransmittedBytesSent: value['retransmittedBytesSent'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCOutboundRTPVideoStream{id: $id, type: $type, '
        'timestamp: $timestamp, transportId: $transportId, qpSum: $qpSum, '
        'headerBytesSent: $headerBytesSent, hugeFramesSent: $hugeFramesSent, '
        'framesEncoded: $framesEncoded, nackCount: $nackCount, '
        'totalPacketSendDelay: $totalPacketSendDelay, rid: $rid, '
        'totalEncodeTime: $totalEncodeTime, firCount: $firCount, '
        'pliCount: $pliCount, packetsSent: $packetsSent, '
        'frameHeight: $frameHeight, frameWidth: $frameWidth, '
        'framesSent: $framesSent, framesPerSecond: $framesPerSecond, '
        'keyFramesEncoded: $keyFramesEncoded, '
        'retransmittedPacketsSent: $retransmittedPacketsSent, kind: $kind, '
        'trackId: $trackId, ssrc: $ssrc, mediaType: $mediaType, '
        'qualityLimitationReason: $qualityLimitationReason, '
        'qualityLimitationResolutionChanges: '
        '$qualityLimitationResolutionChanges, '
        'bytesSent: $bytesSent, mediaSourceId: $mediaSourceId, '
        'encoderImplementation: $encoderImplementation, remoteId: '
        '$remoteId, codecId: $codecId, '
        'totalEncodedBytesTarget: $totalEncodedBytesTarget, '
        'retransmittedBytesSent: $retransmittedBytesSent}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('outboundId: ')
      ..write(id.hashCode)
      ..write('\n')
      ..write('rid: ')
      ..write(rid)
      ..write('\n')
      ..write('ssrc: ')
      ..write(ssrc)
      ..write('\n')
      ..write('packetsSent: ')
      ..write(packetsSent)
      ..write('\n')
      ..write('bytesSent: ')
      ..write(bytesCountToReadableString(bytesSent ?? 0))
      ..write('\n')
      ..write('frameSize: w')
      ..write(frameWidth)
      ..write('-h')
      ..write(frameHeight)
      ..write('\n')
      ..write('framesEncoded: ')
      ..write(framesEncoded)
      ..write('\n')
      ..write('framesPerSecond: ')
      ..write(framesPerSecond)
      ..write('\n');
  }
}
