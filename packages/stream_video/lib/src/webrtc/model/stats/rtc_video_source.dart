// {
//   id: RTCVideoSource_5,
//   type: media-source,
//   timestamp: 1679505083000830.0,
//   kind: video,
//   trackIdentifier: 37CEE2F2-7270-41A9-B7DC-5E1202136968,
//   width: 1280,
//   height: 720,
//   framesPerSecond: 30.0,
//   frames: 2271
// }

import 'rtc_media_source.dart';

class RtcVideoSource extends RtcMediaSource {
  const RtcVideoSource({
    super.id,
    super.type,
    super.timestamp,
    super.kind,
    super.trackIdentifier,
    this.width,
    this.height,
    this.framesPerSecond,
    this.frames,
  });

  final int? width;
  final int? height;
  final double? framesPerSecond;
  final int? frames;

  String? get codecId => id;

  static RtcVideoSource? fromJson(dynamic value) {
    if (value is Map) {
      return RtcVideoSource(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        kind: value['kind'],
        trackIdentifier: value['trackIdentifier'],
        width: value['width'],
        height: value['height'],
        framesPerSecond: value['framesPerSecond'],
        frames: value['frames'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RtcVideoSource{id: $id, type: $type, timestamp: $timestamp, '
        'kind: $kind, trackIdentifier: $trackIdentifier, width: $width, '
        'height: $height, framesPerSecond: $framesPerSecond, frames: $frames}';
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('trackId: ')
      ..write(trackIdentifier)
      ..write('\n')
      ..write('frameSize: w')
      ..write(width)
      ..write('-h')
      ..write(height)
      ..write('\n')
      ..write('framesPerSecond: ')
      ..write(framesPerSecond)
      ..write('\n')
      ..write('frames: ')
      ..write(frames)
      ..write('\n');
  }
}
