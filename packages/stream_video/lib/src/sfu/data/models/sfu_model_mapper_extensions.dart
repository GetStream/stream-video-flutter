import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/src/webrtc/peer_type.dart';

import '../../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import 'sfu_subscription_details.dart';
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
    if (this == SfuTrackType.audio) {
      return sfu_models.TrackType.TRACK_TYPE_AUDIO;
    } else if (this == SfuTrackType.video) {
      return sfu_models.TrackType.TRACK_TYPE_VIDEO;
    } else if (this == SfuTrackType.screenShare) {
      return sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE;
    } else if (this == SfuTrackType.screenShareAudio) {
      return sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO;
    } else {
      return sfu_models.TrackType.TRACK_TYPE_UNSPECIFIED;
    }
  }
}

extension SfuSubscriptionDetailsMapper on SfuSubscriptionDetails {
  sfu.TrackSubscriptionDetails toDTO() {
    return sfu.TrackSubscriptionDetails(
      userId: userId,
      sessionId: sessionId,
      trackType: trackType.toDTO(),
      dimension: sfu_models.VideoDimension(
        width: dimension?.width,
        height: dimension?.height,
      ),
    );
  }
}
