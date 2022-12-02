import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';
import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/sfu-client/sfu_client.dart';
import 'package:stream_video/src/types/other.dart';

Future<RTCPeerConnection> createSubscriber({
  required SfuClient sfuClient,
  required RTCConfiguration configuration,
  Map<String, dynamic> constraints = const {},
  required Stream<ICETrickle> onIceCandidates,
  void Function(RTCTrackEvent event)? onTrack,
  void Function(MediaStream stream)? onAddStream,
  void Function(MediaStream stream)? onRemoveStream,
}) async {
  final subscriber = await createPeerConnection(
    configuration.toMap(),
    constraints,
  );

  subscriber
    ..onIceConnectionState = (state) {
      logger.shout('Subscriber ICE connection state: $state');
    }
    ..onIceGatheringState = (state) {
      logger.shout('Subscriber ICE gathering state: $state');
    }
    ..onIceCandidate = (candidate) async {
      logger.shout('Subscriber onIceCandidate: $candidate');

      final iceCandidate = json.encode(candidate.toMap());
      await sfuClient.iceTrickle(
        iceCandidate: iceCandidate,
        peerType: PeerType.PEER_TYPE_SUBSCRIBER,
      );
    }
    ..onTrack = onTrack
    ..onAddStream = onAddStream
    ..onRemoveStream = onRemoveStream;

  StreamSubscription<ICETrickle>? candidatesSubscription;

  sfuClient.on(
    SfuEvent_EventPayload.subscriberOffer.name,
    (payload) async {
      logger.shout('Subscriber offer: $payload');

      final offer = payload.subscriberOffer;

      await subscriber.setRemoteDescription(
        RTCSessionDescription(offer.sdp, 'offer'),
      );

      await candidatesSubscription?.cancel();
      logger.shout('Started listening subscriber ice candidates');
      candidatesSubscription = onIceCandidates.listen((candidate) async {
        logger.shout('Subscriber ice candidate: $candidate');
        try {
          final iceCandidateJson = json.decode(candidate.iceCandidate);
          final iceCandidate = RTCIceCandidate(
            iceCandidateJson['candidate'],
            iceCandidateJson['sdpMid'],
            iceCandidateJson['sdpMLineIndex'],
          );

          logger.shout('Adding subscriber ice candidate: $iceCandidate');
          await subscriber.addCandidate(iceCandidate);
        } catch (e, stk) {
          logger.shout('Error adding subscriber ice candidate', e, stk);
        }
      });

      // apply ice candidates
      final answer = await subscriber.createAnswer();
      await subscriber.setLocalDescription(answer);

      await sfuClient.sendAnswer(
        sdp: answer.sdp!,
        peerType: PeerType.PEER_TYPE_SUBSCRIBER,
      );
    },
  );

  return subscriber;
}
