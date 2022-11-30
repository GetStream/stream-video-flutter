import 'package:stream_video/src/track/remote/remote.dart';
import 'package:stream_video/src/track/track.dart';
import 'package:stream_video/src/types/other.dart';

class RemoteVideoTrack extends RemoteTrack with VideoTrack {
  RemoteVideoTrack({
    required super.name,
    required super.source,
    required super.mediaStream,
    required super.mediaStreamTrack,
    super.receiver,
  }) : super(kind: TrackType.video);
}
