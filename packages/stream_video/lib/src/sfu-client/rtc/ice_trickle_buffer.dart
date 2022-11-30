import 'package:rxdart/rxdart.dart';

import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';

/// A buffer for ICE Candidates. Used for ICE Trickle:
/// - https://bloggeek.me/webrtcglossary/trickle-ice/
class IceTrickleBuffer {
  /// A buffer for ICE Candidates for the subscriber.
  Stream<ICETrickle> get onSubscriberCandidates {
    return _subscriberCandidates.stream;
  }

  /// A buffer for ICE Candidates for the publisher.
  Stream<ICETrickle> get onPublisherCandidates {
    return _publisherCandidates.stream;
  }

  final _subscriberCandidates = ReplaySubject<ICETrickle>(sync: true);
  final _publisherCandidates = ReplaySubject<ICETrickle>(sync: true);

  /// Pushes an ICETrickle to the appropriate buffer.
  void push(ICETrickle iceTrickle) {
    final peerType = iceTrickle.peerType;
    switch (peerType) {
      case PeerType.PEER_TYPE_SUBSCRIBER:
        return _subscriberCandidates.add(iceTrickle);
      case PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED:
        return _publisherCandidates.add(iceTrickle);
    }
  }

  /// Closes the buffers.
  Future<void> dispose() async {
    await _subscriberCandidates.close();
    await _publisherCandidates.close();
  }
}
