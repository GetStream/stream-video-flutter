import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/src/v2/webrtc/peer_type.dart';

import 'sfu_track_type.dart';

/// TODO
extension SfuPeerTypeMapper on sfu_models.PeerType {
  StreamPeerType toDomain() {
    switch (this) {
      case sfu_models.PeerType.PEER_TYPE_SUBSCRIBER:
        return StreamPeerType.subscriber;
      case sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED:
        return StreamPeerType.publisher;
      default:
        throw StateError('unexpected quality: $this');
    }
  }
}

extension SfuTrackTypeMapper on SfuTrackType {
  sfu_models.TrackType toDTO() {
    switch (this) {
      case SfuTrackType.audio:
        return sfu_models.TrackType.TRACK_TYPE_AUDIO;
      case SfuTrackType.video:
        return sfu_models.TrackType.TRACK_TYPE_VIDEO;
      case SfuTrackType.screenShare:
        return sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE;
      case SfuTrackType.screenShareAudio:
        return sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO;
      default:
        return sfu_models.TrackType.TRACK_TYPE_UNSPECIFIED;
    }
  }
}
