// {
//  id: RTCInboundRTPVideoStream_491507150,
//  type: inbound-rtp,
//  timestamp: 1679434739982604.0,
//  transportId: RTCTransport_0_1,
//  qpSum: 3446,
//  lastPacketReceivedTimestamp: 1679434739956.0,
//  nackCount: 0,
//  firCount: 0,
//  pliCount: 3,
//  packetsLost: 0,
//  keyFramesDecoded: 1,
//  totalSquaredInterFrameDelay: 0.25719600000000004,
//  totalAssemblyTime: 0.336,
//  frameHeight: 540,
//  frameWidth: 960,
//  framesDropped: 1,
//  framesReceived: 127,
//  framesPerSecond: 29.0,
//  framesDecoded: 126,
//  framesAssembledFromMultiplePackets: 118,
//  totalInterFrameDelay: 4.571999999999997
//  decoderImplementation: c2.goldfish.vp8.decoder,
//  kind: video,
//  trackId: RTCMediaStreamTrack_receiver_6,
//  jitterBufferDelay: 4.69,
//  ssrc: 491507150,
//  mediaType: video,
//  minPlayoutDelay: 0.0,
//  headerBytesReceived: 10200,
//  jitterBufferEmittedCount: 126,
//  codecId: RTCCodec_2_Inbound_96,
//  bytesReceived: 519288,
//  totalProcessingDelay: 2.635,
//  jitter: 0.007,
//  packetsReceived: 510,
//  totalDecodeTime: 0.435,
// }

import '../../../utils/format.dart';
import 'rtc_inbound_rtp.dart';
import 'rtc_writable.dart';

class RtcInboundRtpVideoStream implements RtcInboundRtp, RtcWritable {
  const RtcInboundRtpVideoStream({
    this.id,
    this.type,
    this.timestamp,
    this.transportId,
    this.qpSum,
    this.lastPacketReceivedTimestamp,
    this.nackCount,
    this.firCount,
    this.pliCount,
    this.packetsLost,
    this.keyFramesDecoded,
    this.totalSquaredInterFrameDelay,
    this.totalAssemblyTime,
    this.frameHeight,
    this.frameWidth,
    this.framesDropped,
    this.framesReceived,
    this.framesPerSecond,
    this.framesDecoded,
    this.totalInterFrameDelay,
    this.decoderImplementation,
    this.kind,
    this.trackId,
    this.jitterBufferDelay,
    this.ssrc,
    this.mediaType,
    this.minPlayoutDelay,
    this.headerBytesReceived,
    this.jitterBufferEmittedCount,
    this.codecId,
    this.bytesReceived,
    this.totalProcessingDelay,
    this.jitter,
    this.packetsReceived,
    this.totalDecodeTime,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? transportId;
  final int? qpSum;
  final double? lastPacketReceivedTimestamp;
  final int? nackCount;
  final int? firCount;
  final int? pliCount;
  final int? packetsLost;
  final int? keyFramesDecoded;
  final double? totalSquaredInterFrameDelay;
  final double? totalAssemblyTime;
  final int? frameHeight;
  final int? frameWidth;
  final int? framesDropped;
  final int? framesReceived;
  final double? framesPerSecond;
  final int? framesDecoded;
  final double? totalInterFrameDelay;
  final String? decoderImplementation;
  final String? kind;
  final String? trackId;
  final double? jitterBufferDelay;
  final int? ssrc;
  final String? mediaType;
  final double? minPlayoutDelay;
  final int? headerBytesReceived;
  final int? jitterBufferEmittedCount;
  final String? codecId;
  final int? bytesReceived;
  final double? totalProcessingDelay;
  final double? jitter;
  final int? packetsReceived;
  final double? totalDecodeTime;

  static RtcInboundRtpVideoStream? fromJson(dynamic value) {
    if (value is Map) {
      return RtcInboundRtpVideoStream(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        qpSum: value['qpSum'],
        lastPacketReceivedTimestamp: value['lastPacketReceivedTimestamp'],
        nackCount: value['nackCount'],
        firCount: value['firCount'],
        pliCount: value['pliCount'],
        packetsLost: value['packetsLost'],
        keyFramesDecoded: value['keyFramesDecoded'],
        totalSquaredInterFrameDelay: value['totalSquaredInterFrameDelay'],
        totalAssemblyTime: value['totalAssemblyTime'],
        frameHeight: value['frameHeight'],
        frameWidth: value['frameWidth'],
        framesDropped: value['framesDropped'],
        framesReceived: value['framesReceived'],
        framesPerSecond: value['framesPerSecond'],
        framesDecoded: value['framesDecoded'],
        totalInterFrameDelay: value['totalInterFrameDelay'],
        decoderImplementation: value['decoderImplementation'],
        kind: value['kind'],
        trackId: value['trackId'],
        jitterBufferDelay: value['jitterBufferDelay'],
        ssrc: value['ssrc'],
        mediaType: value['mediaType'],
        minPlayoutDelay: value['minPlayoutDelay'],
        headerBytesReceived: value['headerBytesReceived'],
        jitterBufferEmittedCount: value['jitterBufferEmittedCount'],
        codecId: value['codecId'],
        bytesReceived: value['bytesReceived'],
        totalProcessingDelay: value['totalProcessingDelay'],
        jitter: value['jitter'],
        packetsReceived: value['packetsReceived'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCInboundRTPVideoStream{id: $id, type: $type, '
        'timestamp: $timestamp, transportId: $transportId, qpSum: $qpSum, '
        'lastPacketReceivedTimestamp: $lastPacketReceivedTimestamp, '
        'nackCount: $nackCount, firCount: $firCount, pliCount: $pliCount, '
        'packetsLost: $packetsLost, keyFramesDecoded: $keyFramesDecoded, '
        'totalSquaredInterFrameDelay: $totalSquaredInterFrameDelay, '
        'totalAssemblyTime: $totalAssemblyTime, frameHeight: $frameHeight, '
        'frameWidth: $frameWidth, framesDropped: $framesDropped, '
        'framesReceived: $framesReceived, framesPerSecond: $framesPerSecond, '
        'framesDecoded: $framesDecoded, '
        'totalInterFrameDelay: $totalInterFrameDelay, '
        'decoderImplementation: $decoderImplementation, kind: $kind, '
        'trackId: $trackId, jitterBufferDelay: $jitterBufferDelay, '
        'ssrc: $ssrc, mediaType: $mediaType, '
        'minPlayoutDelay: $minPlayoutDelay, '
        'headerBytesReceived: $headerBytesReceived, '
        'jitterBufferEmittedCount: $jitterBufferEmittedCount, '
        'codecId: $codecId, bytesReceived: $bytesReceived, '
        'totalProcessingDelay: $totalProcessingDelay, jitter: $jitter, '
        'packetsReceived: $packetsReceived, totalDecodeTime: $totalDecodeTime}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('ssrc: ')
      ..write(ssrc)
      ..write('\n')
      ..write('packetsReceived: ')
      ..write(packetsReceived)
      ..write('\n')
      ..write('bytesReceived: ')
      ..write(bytesCountToReadableString(bytesReceived ?? 0))
      ..write('\n')
      ..write('packetsLost: ')
      ..write(packetsLost)
      ..write('\n')
      ..write('frameSize: w')
      ..write(frameWidth)
      ..write('-h')
      ..write(frameHeight)
      ..write('\n')
      ..write('framesReceived: ')
      ..write(framesReceived)
      ..write('\n')
      ..write('framesDropped: ')
      ..write(framesDropped)
      ..write('\n')
      ..write('framesPerSecond: ')
      ..write(framesPerSecond)
      ..write('\n');
  }
}
