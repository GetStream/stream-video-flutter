import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/src/v2/webrtc/peer_type.dart';

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
