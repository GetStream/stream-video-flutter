// {
//  id: RTCMediaStreamTrack_receiver_6,
//  type: track,
//  timestamp: 1679434739982604.0,
//  kind: video,
//  frameHeight: 540,
//  frameWidth: 960,
//  framesReceived: 127,
//  framesDecoded: 126,
//  framesDropped: 1
//  totalFramesDuration: 4.572,
//  totalFreezesDuration: 0.0,
//  freezeCount: 0,
//  pauseCount: 0,
//  detached: false,
//  ended: false,
//  remoteSource: true,
//  jitterBufferDelay: 4.69,
//  trackIdentifier: 7df380d6-8e4c-4fb7-a6f2-bdc42bbd0dc6,
//  totalPausesDuration: 0.0,
//  jitterBufferEmittedCount: 126,
//  sumOfSquaredFramesDuration: 0.2560839999999999,
// }

import 'rtc_media_stream_track.dart';
import 'rtc_writable.dart';

class RtcMediaStreamTrackRemoteVideo
    implements RtcMediaStreamTrack, RtcWritable {
  const RtcMediaStreamTrackRemoteVideo({
    this.id,
    this.type,
    this.timestamp,
    this.kind,
    this.frameHeight,
    this.frameWidth,
    this.framesReceived,
    this.framesDecoded,
    this.framesDropped,
    this.totalFramesDuration,
    this.totalFreezesDuration,
    this.freezeCount,
    this.pauseCount,
    this.detached,
    this.ended,
    this.remoteSource,
    this.jitterBufferDelay,
    this.trackIdentifier,
    this.totalPausesDuration,
    this.jitterBufferEmittedCount,
    this.sumOfSquaredFramesDuration,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? kind;
  final int? frameHeight;
  final int? frameWidth;
  final int? framesReceived;
  final int? framesDecoded;
  final int? framesDropped;
  final double? totalFramesDuration;
  final double? totalFreezesDuration;
  final int? freezeCount;
  final int? pauseCount;
  final bool? detached;
  final bool? ended;
  final bool? remoteSource;
  final double? jitterBufferDelay;
  final String? trackIdentifier;
  final double? totalPausesDuration;
  final int? jitterBufferEmittedCount;
  final double? sumOfSquaredFramesDuration;

  static RtcMediaStreamTrackRemoteVideo? fromJson(dynamic value) {
    if (value is Map) {
      return RtcMediaStreamTrackRemoteVideo(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        kind: value['kind'],
        frameHeight: value['frameHeight'],
        frameWidth: value['frameWidth'],
        framesReceived: value['framesReceived'],
        framesDecoded: value['framesDecoded'],
        framesDropped: value['framesDropped'],
        totalFramesDuration: value['totalFramesDuration'],
        totalFreezesDuration: value['totalFreezesDuration'],
        freezeCount: value['freezeCount'],
        pauseCount: value['pauseCount'],
        detached: value['detached'],
        ended: value['ended'],
        remoteSource: value['remoteSource'],
        jitterBufferDelay: value['jitterBufferDelay'],
        trackIdentifier: value['trackIdentifier'],
        totalPausesDuration: value['totalPausesDuration'],
        jitterBufferEmittedCount: value['jitterBufferEmittedCount'],
        sumOfSquaredFramesDuration: value['sumOfSquaredFramesDuration'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCMediaStreamTrackRemoteVideo{id: $id, type: $type, '
        'timestamp: $timestamp, kind: $kind, frameHeight: $frameHeight, '
        'frameWidth: $frameWidth, framesReceived: $framesReceived, '
        'framesDecoded: $framesDecoded, framesDropped: $framesDropped, '
        'totalFramesDuration: $totalFramesDuration, '
        'totalFreezesDuration: $totalFreezesDuration, '
        'freezeCount: $freezeCount, pauseCount: $pauseCount, '
        'detached: $detached, ended: $ended, remoteSource: $remoteSource, '
        'jitterBufferDelay: $jitterBufferDelay, '
        'trackIdentifier: $trackIdentifier, '
        'totalPausesDuration: $totalPausesDuration, '
        'jitterBufferEmittedCount: $jitterBufferEmittedCount, '
        'sumOfSquaredFramesDuration: $sumOfSquaredFramesDuration}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('trackId: ')
      ..write(trackIdentifier)
      ..write('\n')
      ..write('frameSize: w')
      ..write(frameWidth)
      ..write('-h')
      ..write(frameHeight)
      ..write('\n')
      ..write('framesReceived: ')
      ..write(framesReceived)
      ..write('\n')
      ..write('framesDecoded: ')
      ..write(framesDecoded)
      ..write('\n')
      ..write('framesDropped: ')
      ..write(framesDropped)
      ..write('\n');
  }
}
