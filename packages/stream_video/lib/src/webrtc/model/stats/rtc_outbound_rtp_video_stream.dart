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
import 'rtc_stats.dart';
import 'rtc_writable.dart';

class RtcOutboundRtpVideoStream extends RtcStats
    implements RtcOutboundRtp, RtcWritable {
  const RtcOutboundRtpVideoStream({
    super.id,
    super.type,
    super.timestamp,
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
    this.jitter,
    this.targetBitrate,
  });

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
  final double? jitter;
  final double? targetBitrate;

  static RtcOutboundRtpVideoStream? fromJson(dynamic value) {
    if (value is Map) {
      return RtcOutboundRtpVideoStream(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        qpSum: (value['qpSum'] as num?)?.toInt(),
        headerBytesSent: (value['headerBytesSent'] as num?)?.toInt(),
        hugeFramesSent: (value['hugeFramesSent'] as num?)?.toInt(),
        framesEncoded: (value['framesEncoded'] as num?)?.toInt(),
        nackCount: (value['nackCount'] as num?)?.toInt(),
        totalPacketSendDelay: value['totalPacketSendDelay'],
        rid: value['rid'],
        totalEncodeTime: value['totalEncodeTime'],
        firCount: (value['firCount'] as num?)?.toInt(),
        pliCount: (value['pliCount'] as num?)?.toInt(),
        packetsSent: (value['packetsSent'] as num?)?.toInt(),
        frameHeight: (value['frameHeight'] as num?)?.toInt(),
        frameWidth: (value['frameWidth'] as num?)?.toInt(),
        framesSent: (value['framesSent'] as num?)?.toInt(),
        framesPerSecond: value['framesPerSecond'],
        keyFramesEncoded: (value['keyFramesEncoded'] as num?)?.toInt(),
        retransmittedPacketsSent: (value['retransmittedPacketsSent'] as num?)?.toInt(),
        kind: value['kind'],
        trackId: value['trackId'],
        ssrc: (value['ssrc'] as num?)?.toInt(),
        mediaType: value['mediaType'],
        qualityLimitationReason: value['qualityLimitationReason'],
        qualityLimitationResolutionChanges: (value['qualityLimitationResolutionChanges'] as num?)?.toInt(),
        bytesSent: (value['bytesSent'] as num?)?.toInt(),
        mediaSourceId: value['mediaSourceId'],
        encoderImplementation: value['encoderImplementation'],
        remoteId: value['remoteId'],
        codecId: value['codecId'],
        totalEncodedBytesTarget: (value['totalEncodedBytesTarget'] as num?)?.toInt(),
        retransmittedBytesSent: (value['retransmittedBytesSent'] as num?)?.toInt(),
        jitter: value['jitter'],
        targetBitrate: value['targetBitrate'],
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
        'retransmittedBytesSent: $retransmittedBytesSent} '
        'jitter: $jitter'
        'targetBitrate: $targetBitrate';
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
