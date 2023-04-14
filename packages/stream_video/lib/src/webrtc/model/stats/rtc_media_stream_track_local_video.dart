// {
//  id: RTCMediaStreamTrack_sender_2,
//  type: track,
//  timestamp: 1679425535359288.0,
//  kind: video,
//  frameHeight: 1280,
//  frameWidth: 720,
//  framesSent: 159,
//  hugeFramesSent: 0,
//  detached: false,
//  ended: false,
//  remoteSource: false,
//  trackIdentifier: 503d949a-f020-49cc-9a23-61bc1e04e89b,
//  mediaSourceId: RTCVideoSource_2
// }

import 'rtc_media_stream_track.dart';
import 'rtc_writable.dart';

class RtcMediaStreamTrackLocalVideo
    implements RtcMediaStreamTrack, RtcWritable {
  const RtcMediaStreamTrackLocalVideo({
    this.id,
    this.type,
    this.timestamp,
    this.kind,
    this.frameHeight,
    this.frameWidth,
    this.framesSent,
    this.hugeFramesSent,
    this.detached,
    this.ended,
    this.remoteSource,
    this.trackIdentifier,
    this.mediaSourceId,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? kind;
  final int? frameHeight;
  final int? frameWidth;
  final int? framesSent;
  final int? hugeFramesSent;
  final bool? detached;
  final bool? ended;
  final bool? remoteSource;
  final String? trackIdentifier;
  final String? mediaSourceId;

  static RtcMediaStreamTrackLocalVideo? fromJson(dynamic value) {
    if (value is Map) {
      return RtcMediaStreamTrackLocalVideo(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        kind: value['kind'],
        frameHeight: value['frameHeight'],
        frameWidth: value['frameWidth'],
        framesSent: value['framesSent'],
        hugeFramesSent: value['hugeFramesSent'],
        detached: value['detached'],
        ended: value['ended'],
        remoteSource: value['remoteSource'],
        trackIdentifier: value['trackIdentifier'],
        mediaSourceId: value['mediaSourceId'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCMediaStreamTrackLocalVideo{id: $id, type: $type, '
        'timestamp: $timestamp, kind: $kind, frameHeight: $frameHeight, '
        'frameWidth: $frameWidth, framesSent: $framesSent, '
        'hugeFramesSent: $hugeFramesSent, detached: $detached, '
        'ended: $ended, remoteSource: $remoteSource, '
        'trackIdentifier: $trackIdentifier, mediaSourceId: $mediaSourceId}';
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
      ..write('framesSent: ')
      ..write(framesSent)
      ..write('\n');
  }
}
