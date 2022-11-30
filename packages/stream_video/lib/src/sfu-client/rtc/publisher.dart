import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';
import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/sfu-client/sfu_client.dart';
import 'package:stream_video/src/types/other.dart';

Future<RTCPeerConnection> createPublisher({
  required SfuClient sfuClient,
  required RTCConfiguration configuration,
  Map<String, dynamic> constraints = const {},
  required Stream<ICETrickle> onIceCandidates,
}) async {
  final publisher = await createPeerConnection(
    configuration.toMap(),
    constraints,
  );

  publisher
    ..onIceConnectionState = (state) {
      logger.info('Publisher ICE connection state: $state');
    }
    ..onIceGatheringState = (state) {
      logger.info('Publisher ICE gathering state: $state');
    }
    ..onAddStream = (stream) {
      logger.info('Publisher onAddStream: $stream');
    }
    ..onIceCandidate = (candidate) async {
      logger.info('Publisher onIceCandidate: $candidate');

      final iceCandidate = json.encode(candidate.toMap());
      await sfuClient.rpc.iceTrickle(
        ICETrickle(
          iceCandidate: iceCandidate,
          sessionId: sfuClient.sessionId,
          peerType: PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED,
        ),
      );
    };

  StreamSubscription<ICETrickle>? candidatesSubscription;
  // will fire once media is attached to the peer connection
  publisher.onRenegotiationNeeded = () async {
    logger.info('Publisher onRenegotiationNeeded');

    final offer = await publisher.createOffer();
    await publisher.setLocalDescription(offer);

    final response = await sfuClient.setPublisher(sdp: offer.sdp!);

    await publisher.setRemoteDescription(
      RTCSessionDescription(response.sdp, 'answer'),
    );

    await candidatesSubscription?.cancel();
    logger.info('Started listening publisher ice candidates');
    candidatesSubscription = onIceCandidates.listen((candidate) async {
      logger.info('Publisher ice candidate: $candidate');
      try {
        final iceCandidateJson = json.decode(candidate.iceCandidate);
        final iceCandidate = RTCIceCandidate(
          iceCandidateJson['candidate'],
          iceCandidateJson['sdpMid'],
          iceCandidateJson['sdpMLineIndex'],
        );

        logger.info('Adding publisher ice candidate: $iceCandidate');
        await publisher.addCandidate(iceCandidate);
      } catch (e, stk) {
        logger.warning('Error adding publisher ice candidate', e, stk);
      }
    });
  };

  return publisher;
}
