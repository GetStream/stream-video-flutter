import 'package:stream_video/src/track/remote/remote.dart';
import 'package:stream_video/src/track/track.dart';

class RemoteVideoTrack extends RemoteTrack with VideoTrack {
  RemoteVideoTrack({
    required super.type,
    required super.mediaStream,
    required super.mediaStreamTrack,
    super.receiver,
  });
}
