import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';

Future<RTCPeerConnection> createPublisher(
    {required String sfuUrl, required SfuSignalingClient rpcClient}) async {
  final publisher = await createPeerConnection({
    'iceServers': [
      {
        'urls': 'stun:stun.l.google.com:19302',
      },
      {
        'urls': "turn:${sfuUrl}:3478",
        'username': 'video',
        'credential': 'video',
      },
    ],
  });
  publisher.onIceCandidate = (candidate) async {
    await rpcClient.sendCandidate(
      publisher: true,
      candidate: candidate.candidate,
      sdpMid: candidate.sdpMid,
      sdpMLineIndex: candidate.sdpMLineIndex,
      // usernameFragment: candidate.use as String?,
    );
  };
  publisher.onRenegotiationNeeded = () async {
    final offer = await publisher.createOffer();
    await publisher.setLocalDescription(offer);
    final sfu = await rpcClient.setPublisher(
      sdp: offer.sdp,
    );

    await publisher
        .setRemoteDescription(RTCSessionDescription(sfu.sdp, 'answer'));
  };
  return publisher;
}
