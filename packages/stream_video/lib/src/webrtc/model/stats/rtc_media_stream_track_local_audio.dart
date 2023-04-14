// {
//  id: RTCMediaStreamTrack_sender_3,
//  type: track,
//  timestamp: 1679425535359288.0,
//  kind: audio,
//  mediaSourceId: RTCAudioSource_3
//  trackIdentifier: 3137ee0d-6f04-4e53-a45a-20fbdcdcd1ca,
//  remoteSource: false,
//  detached: false,
//  ended: false,
// }

import 'rtc_media_stream_track.dart';
import 'rtc_writable.dart';

class RtcMediaStreamTrackLocalAudio
    implements RtcMediaStreamTrack, RtcWritable {
  const RtcMediaStreamTrackLocalAudio({
    this.id,
    this.type,
    this.timestamp,
    this.kind,
    this.mediaSourceId,
    this.trackIdentifier,
    this.remoteSource,
    this.detached,
    this.ended,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? kind;
  final String? mediaSourceId;
  final String? trackIdentifier;
  final bool? remoteSource;
  final bool? detached;
  final bool? ended;

  static RtcMediaStreamTrackLocalAudio? fromJson(dynamic value) {
    if (value is Map) {
      return RtcMediaStreamTrackLocalAudio(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        kind: value['kind'],
        mediaSourceId: value['mediaSourceId'],
        trackIdentifier: value['trackIdentifier'],
        remoteSource: value['remoteSource'],
        detached: value['detached'],
        ended: value['ended'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCMediaStreamTrackLocalAudio{id: $id, type: $type, '
        'timestamp: $timestamp, kind: $kind, mediaSourceId: $mediaSourceId, '
        'trackIdentifier: $trackIdentifier, remoteSource: $remoteSource, '
        'detached: $detached, ended: $ended}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('trackId: ')
      ..write(trackIdentifier)
      ..write('\n')
      ..write('mediaSourceId: ')
      ..write(mediaSourceId)
      ..write('\n');
  }
}
