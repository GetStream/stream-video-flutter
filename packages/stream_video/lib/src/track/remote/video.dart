import '../track.dart';
import 'remote.dart';

class RemoteVideoTrack extends RemoteTrack with VideoTrack {
  RemoteVideoTrack({
    required super.type,
    required super.mediaStream,
    required super.mediaStreamTrack,
    super.receiver,
  });
}
