// {
//  id: RTCMediaStreamTrack_receiver_5,
//  type: track,
//  timestamp: 1679434739982604.0,
//  totalAudioEnergy: 0.008388901526724536,
//  totalInterruptionDuration: 0.0,
//  removedSamplesForAcceleration: 373,
//  kind: audio,
//  audioLevel: 0.10351878414258248,
//  jitterBufferDelay: 17644.8,
//  interruptionCount: 0,
//  relativePacketArrivalDelay: 7.19,
//  jitterBufferFlushes: 2,
//  concealedSamples: 58080,
//  jitterBufferTargetDelay: 18892.8,
//  trackIdentifier: fb83345f-0514-4793-872b-10524723b9e4,
//  totalSamplesDuration: 8.589999999999861,
//  detached: false,
//  insertedSamplesForDeceleration: 3094,
//  jitterBufferEmittedCount: 236160,
//  delayedPacketOutageSamples: 0,
//  ended: false,
//  totalSamplesReceived: 296160,
//  concealmentEvents: 1,
//  remoteSource: true,
//  silentConcealedSamples: 57560
// }

import 'rtc_media_stream_track.dart';
import 'rtc_writable.dart';

class RtcMediaStreamTrackRemoteAudio
    implements RtcMediaStreamTrack, RtcWritable {
  const RtcMediaStreamTrackRemoteAudio({
    this.id,
    this.type,
    this.timestamp,
    this.totalAudioEnergy,
    this.totalInterruptionDuration,
    this.removedSamplesForAcceleration,
    this.kind,
    this.audioLevel,
    this.jitterBufferDelay,
    this.interruptionCount,
    this.relativePacketArrivalDelay,
    this.jitterBufferFlushes,
    this.concealedSamples,
    this.jitterBufferTargetDelay,
    this.trackIdentifier,
    this.totalSamplesDuration,
    this.detached,
    this.insertedSamplesForDeceleration,
    this.jitterBufferEmittedCount,
    this.delayedPacketOutageSamples,
    this.ended,
    this.totalSamplesReceived,
    this.concealmentEvents,
    this.remoteSource,
    this.silentConcealedSamples,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final double? totalAudioEnergy;
  final double? totalInterruptionDuration;
  final int? removedSamplesForAcceleration;
  final String? kind;
  final double? audioLevel;
  final double? jitterBufferDelay;
  final int? interruptionCount;
  final double? relativePacketArrivalDelay;
  final int? jitterBufferFlushes;
  final int? concealedSamples;
  final double? jitterBufferTargetDelay;
  final String? trackIdentifier;
  final double? totalSamplesDuration;
  final bool? detached;
  final int? insertedSamplesForDeceleration;
  final int? jitterBufferEmittedCount;
  final int? delayedPacketOutageSamples;
  final bool? ended;
  final int? totalSamplesReceived;
  final int? concealmentEvents;
  final bool? remoteSource;
  final int? silentConcealedSamples;

  static RtcMediaStreamTrackRemoteAudio? fromJson(dynamic value) {
    if (value is Map) {
      return RtcMediaStreamTrackRemoteAudio(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        totalAudioEnergy: value['totalAudioEnergy'],
        totalInterruptionDuration: value['totalInterruptionDuration'],
        removedSamplesForAcceleration: value['removedSamplesForAcceleration'],
        kind: value['kind'],
        audioLevel: value['audioLevel'],
        jitterBufferDelay: value['jitterBufferDelay'],
        interruptionCount: value['interruptionCount'],
        relativePacketArrivalDelay: value['relativePacketArrivalDelay'],
        jitterBufferFlushes: value['jitterBufferFlushes'],
        concealedSamples: value['concealedSamples'],
        jitterBufferTargetDelay: value['jitterBufferTargetDelay'],
        trackIdentifier: value['trackIdentifier'],
        totalSamplesDuration: value['totalSamplesDuration'],
        detached: value['detached'],
        insertedSamplesForDeceleration: value['insertedSamplesForDeceleration'],
        jitterBufferEmittedCount: value['jitterBufferEmittedCount'],
        delayedPacketOutageSamples: value['delayedPacketOutageSamples'],
        ended: value['ended'],
        totalSamplesReceived: value['totalSamplesReceived'],
        concealmentEvents: value['concealmentEvents'],
        remoteSource: value['remoteSource'],
        silentConcealedSamples: value['silentConcealedSamples'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCMediaStreamTrackRemoteAudio{id: $id, type: $type, '
        'timestamp: $timestamp, totalAudioEnergy: $totalAudioEnergy, '
        'totalInterruptionDuration: $totalInterruptionDuration, '
        'removedSamplesForAcceleration: $removedSamplesForAcceleration, '
        'kind: $kind, audioLevel: $audioLevel, '
        'jitterBufferDelay: $jitterBufferDelay, '
        'interruptionCount: $interruptionCount, '
        'relativePacketArrivalDelay: $relativePacketArrivalDelay, '
        'jitterBufferFlushes: $jitterBufferFlushes, '
        'concealedSamples: $concealedSamples, '
        'jitterBufferTargetDelay: $jitterBufferTargetDelay, '
        'trackIdentifier: $trackIdentifier, '
        'totalSamplesDuration: $totalSamplesDuration, detached: $detached, '
        'insertedSamplesForDeceleration: $insertedSamplesForDeceleration, '
        'jitterBufferEmittedCount: $jitterBufferEmittedCount, '
        'delayedPacketOutageSamples: $delayedPacketOutageSamples, '
        'ended: $ended, totalSamplesReceived: $totalSamplesReceived, '
        'concealmentEvents: $concealmentEvents, remoteSource: $remoteSource, '
        'silentConcealedSamples: $silentConcealedSamples}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('trackIdentifier: ')
      ..write(trackIdentifier)
      ..write('\n')
      ..write('audioLevel: ')
      ..write(audioLevel)
      ..write('\n')
      ..write('totalAudioEnergy: ')
      ..write(totalAudioEnergy)
      ..write('\n');
  }
}
