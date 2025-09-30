import '../../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../webrtc/model/rtc_video_encoding.dart';
import '../../../webrtc/peer_type.dart';
import 'sfu_client_capability.dart';
import 'sfu_codec.dart';
import 'sfu_publish_options.dart';
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
    }

    throw StateError('unexpected quality: $this');
  }
}

extension SfuClientCapabilityMapper on SfuClientCapability {
  sfu_models.ClientCapability toDTO() {
    switch (this) {
      case SfuClientCapability.subscriberVideoPause:
        return sfu_models
            .ClientCapability
            .CLIENT_CAPABILITY_SUBSCRIBER_VIDEO_PAUSE;
      case SfuClientCapability.unspecified:
        return sfu_models.ClientCapability.CLIENT_CAPABILITY_UNSPECIFIED;
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

extension RtcVideoQualityMapper on RtcVideoQuality {
  sfu_models.VideoQuality toDTO() {
    return switch (this) {
      RtcVideoQuality.lowUnspecified =>
        sfu_models.VideoQuality.VIDEO_QUALITY_LOW_UNSPECIFIED,
      RtcVideoQuality.mid => sfu_models.VideoQuality.VIDEO_QUALITY_MID,
      RtcVideoQuality.high => sfu_models.VideoQuality.VIDEO_QUALITY_HIGH,
      RtcVideoQuality.off => sfu_models.VideoQuality.VIDEO_QUALITY_OFF,
    };
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

extension SfuCodecMapper on SfuCodec {
  sfu_models.Codec toDTO() {
    return sfu_models.Codec(
      payloadType: payloadType,
      name: name,
      fmtp: fmtpLine,
      clockRate: clockRate,
      encodingParameters: encodingParameters,
    );
  }
}

extension SfuPublishOptionsMapper on SfuPublishOptions {
  sfu_models.PublishOption toDTO() {
    return sfu_models.PublishOption(
      trackType: trackType.toDTO(),
      codec: codec.toDTO(),
      maxSpatialLayers: maxSpatialLayers,
      maxTemporalLayers: maxTemporalLayers,
      bitrate: bitrate,
      fps: fps,
      id: id,
      videoDimension: sfu_models.VideoDimension(
        width: videoDimension?.width,
        height: videoDimension?.height,
      ),
    );
  }
}
