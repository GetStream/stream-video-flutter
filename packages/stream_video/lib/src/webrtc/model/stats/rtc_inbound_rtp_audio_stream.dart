// {
//  id: RTCInboundRTPAudioStream_318972291,
//  type: inbound-rtp,
//  timestamp: 1679434739982604.0,
//  transportId: RTCTransport_0_1,
//  totalAudioEnergy: 0.008388901526724536,
//  lastPacketReceivedTimestamp: 1679434739975.0,
//  audioLevel: 0.10351878414258248,
//  packetsLost: 0,
//  totalSamplesReceived: 296160,
//  concealmentEvents: 1,
//  removedSamplesForAcceleration: 373,
//  kind: audio,
//  trackId: RTCMediaStreamTrack_receiver_5,
//  jitterBufferDelay: 17644.8,
//  ssrc: 318972291,
//  concealedSamples: 58080,
//  mediaType: audio,
//  totalSamplesDuration: 8.589999999999861,
//  headerBytesReceived: 3000,
//  insertedSamplesForDeceleration: 3094,
//  packetsDiscarded: 0,
//  fecPacketsReceived: 0,
//  jitterBufferEmittedCount: 236160,
//  codecId: RTCCodec_0_Inbound_111,
//  bytesReceived: 16493,
//  jitter: 0.003,
//  packetsReceived: 250,
//  silentConcealedSamples: 57560,
//  fecPacketsDiscarded: 0
// }

import '../../../utils/format.dart';
import 'rtc_inbound_rtp.dart';
import 'rtc_writable.dart';

class RtcInboundRtpAudioStream implements RtcInboundRtp, RtcWritable {
  const RtcInboundRtpAudioStream({
    this.id,
    this.type,
    this.timestamp,
    this.transportId,
    this.totalAudioEnergy,
    this.lastPacketReceivedTimestamp,
    this.audioLevel,
    this.packetsLost,
    this.totalSamplesReceived,
    this.concealmentEvents,
    this.removedSamplesForAcceleration,
    this.kind,
    this.trackId,
    this.jitterBufferDelay,
    this.ssrc,
    this.concealedSamples,
    this.mediaType,
    this.totalSamplesDuration,
    this.headerBytesReceived,
    this.insertedSamplesForDeceleration,
    this.packetsDiscarded,
    this.fecPacketsReceived,
    this.jitterBufferEmittedCount,
    this.codecId,
    this.bytesReceived,
    this.jitter,
    this.packetsReceived,
    this.silentConcealedSamples,
    this.fecPacketsDiscarded,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? transportId;
  final double? totalAudioEnergy;
  final double? lastPacketReceivedTimestamp;
  final double? audioLevel;
  final int? packetsLost;
  final int? totalSamplesReceived;
  final int? concealmentEvents;
  final int? removedSamplesForAcceleration;
  final String? kind;
  final String? trackId;
  final double? jitterBufferDelay;
  final int? ssrc;
  final int? concealedSamples;
  final String? mediaType;
  final double? totalSamplesDuration;
  final int? headerBytesReceived;
  final int? insertedSamplesForDeceleration;
  final int? packetsDiscarded;
  final int? fecPacketsReceived;
  final int? jitterBufferEmittedCount;
  final String? codecId;
  final int? bytesReceived;
  final double? jitter;
  final int? packetsReceived;
  final int? silentConcealedSamples;
  final int? fecPacketsDiscarded;

  static RtcInboundRtpAudioStream? fromJson(dynamic value) {
    if (value is Map) {
      return RtcInboundRtpAudioStream(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        totalAudioEnergy: value['totalAudioEnergy'],
        lastPacketReceivedTimestamp: value['lastPacketReceivedTimestamp'],
        audioLevel: value['audioLevel'],
        packetsLost: value['packetsLost'],
        totalSamplesReceived: value['totalSamplesReceived'],
        concealmentEvents: value['concealmentEvents'],
        removedSamplesForAcceleration: value['removedSamplesForAcceleration'],
        kind: value['kind'],
        trackId: value['trackId'],
        jitterBufferDelay: value['jitterBufferDelay'],
        ssrc: value['ssrc'],
        concealedSamples: value['concealedSamples'],
        mediaType: value['mediaType'],
        totalSamplesDuration: value['totalSamplesDuration'],
        headerBytesReceived: value['headerBytesReceived'],
        insertedSamplesForDeceleration: value['insertedSamplesForDeceleration'],
        packetsDiscarded: value['packetsDiscarded'],
        fecPacketsReceived: value['fecPacketsReceived'],
        jitterBufferEmittedCount: value['jitterBufferEmittedCount'],
        codecId: value['codecId'],
        bytesReceived: value['bytesReceived'],
        jitter: value['jitter'],
        packetsReceived: value['packetsReceived'],
        silentConcealedSamples: value['silentConcealedSamples'],
        fecPacketsDiscarded: value['fecPacketsDiscarded'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCInboundRTPAudioStream{id: $id, type: $type, '
        'timestamp: $timestamp, transportId: $transportId, '
        'totalAudioEnergy: $totalAudioEnergy, '
        'lastPacketReceivedTimestamp: $lastPacketReceivedTimestamp, '
        'audioLevel: $audioLevel, packetsLost: $packetsLost, '
        'totalSamplesReceived: $totalSamplesReceived, '
        'concealmentEvents: $concealmentEvents, '
        'removedSamplesForAcceleration: $removedSamplesForAcceleration, '
        'kind: $kind, trackId: $trackId, '
        'jitterBufferDelay: $jitterBufferDelay, ssrc: $ssrc, '
        'concealedSamples: $concealedSamples, mediaType: $mediaType, '
        'totalSamplesDuration: $totalSamplesDuration, '
        'headerBytesReceived: $headerBytesReceived, '
        'insertedSamplesForDeceleration: $insertedSamplesForDeceleration, '
        'packetsDiscarded: $packetsDiscarded, '
        'fecPacketsReceived: $fecPacketsReceived, '
        'jitterBufferEmittedCount: $jitterBufferEmittedCount, '
        'codecId: $codecId, bytesReceived: $bytesReceived, '
        'jitter: $jitter, packetsReceived: $packetsReceived, '
        'silentConcealedSamples: $silentConcealedSamples, '
        'fecPacketsDiscarded: $fecPacketsDiscarded}';
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
      ..write('\n');
  }
}
