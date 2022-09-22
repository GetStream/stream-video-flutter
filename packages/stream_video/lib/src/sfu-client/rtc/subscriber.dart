import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';

typedef OnTrack = void Function(RTCTrackEvent);

// class Subscriber {
// late RTCPeerConnection pc;

// Subscriber(this.rpcClient);

// final SfuSignalingClient rpcClient;
Future<RTCPeerConnection> createSubscriber(
 {required  String sfuUrl,
  required SfuSignalingClient rpcClient,
  OnTrack? onTrack,}
) async {
  final subscriber = await createPeerConnection({
    'iceServers': [
      {
        'urls': 'stun:stun.l.google.com:19302',
      },
      {
        'urls': 'turn:${sfuUrl}:3478',
        'username': 'video',
        'credential': 'video',
      },
    ],
  });
  subscriber.onIceCandidate = (candidate) async {
    await rpcClient.sendCandidate(
      //  sessionId: rpcClient.sessionId,
      publisher: false,
      candidate: candidate.candidate,
      sdpMid: candidate.sdpMid, // ?? undefined,
      sdpMLineIndex: candidate.sdpMLineIndex, //?? undefined,
      // usernameFragment: candidate.usernameFragment?? undefined,
    );
  };
  subscriber.onTrack = onTrack;

  //  dispatcher.on('subscriberOffer', async (message) => {
  //   if (message.eventPayload.oneofKind !== 'subscriberOffer') return;
  //   const { subscriberOffer } = message.eventPayload;
  //   console.log(`Received subscriberOffer`, subscriberOffer);

  //   await subscriber.setRemoteDescription({
  //     type: 'offer',
  //     sdp: subscriberOffer.sdp,
  //   });

  //   const answer = await subscriber.createAnswer();
  //   await subscriber.setLocalDescription(answer);
  //   await rpcClient.rpc.sendAnswer({
  //     sessionId: rpcClient.sessionId,
  //     peerType: PeerType.SUBSCRIBER,
  //     sdp: answer.sdp || '',
  //   });
  // });
  return subscriber;
}
// }
