import 'package:dart_webrtc/dart_webrtc.dart';
import 'package:test/test.dart';

late RTCPeerConnection pc1;
late RTCPeerConnection pc2;

late RTCSessionDescription offer;
late RTCSessionDescription answer;

void addStateCallbacks(RTCPeerConnection pc, String title) {
  pc.onConnectionState = (RTCPeerConnectionState state) {
    print('$title: onconnectionstatechange => ${state.toString()}');
  };
  pc.onIceConnectionState = (RTCIceConnectionState state) {
    print('$title: oniceconnectionstatechange => ${state.toString()}');
  };
  pc.onIceGatheringState = (RTCIceGatheringState state) {
    print('$title: onicegatheringstatechange => ${state.toString()}');
  };
  pc.onSignalingState = (RTCSignalingState state) {
    print('$title: onsignalingstatechange => ${state.toString()}');
  };

  pc.onAddStream = (MediaStream stream) {
    print('$title: onaddstream => ${stream.id}');
  };

  pc.onTrack = (RTCTrackEvent event) async {
    print(
        '$title: ontrack => ${event.track.id}, \nkind =>  ${event.track.kind}\nstream.length => ${event.streams.length}');
    var params = event.receiver!.parameters;
    print('reducedSize => ${params.rtcp!.reducedSize}');
  };
}

List<void Function()> testFunctions = <void Function()>[
  () => test('RTCPeerConnection.constructor()', () async {
        pc1 = await createPeerConnection({'iceServers': []});

        expect(pc1.connectionState,
            RTCPeerConnectionState.RTCPeerConnectionStateNew);
        expect(pc1.signalingState, RTCSignalingState.RTCSignalingStateStable);

        pc2 = await createPeerConnection({'iceServers': []});

        expect(pc2.connectionState,
            RTCPeerConnectionState.RTCPeerConnectionStateNew);
        expect(pc2.signalingState, RTCSignalingState.RTCSignalingStateStable);

        addStateCallbacks(pc1, 'pc1');
        addStateCallbacks(pc2, 'pc2');

        pc1.onIceCandidate = (RTCIceCandidate? candidate) async {
          if (candidate == null) {
            print('pc1: end-of-candidate');
            return;
          }
          print('pc1: onicecaniddate => ${candidate.candidate}');
          await pc2.addCandidate(candidate);
        };

        pc2.onIceCandidate = (RTCIceCandidate? candidate) async {
          if (candidate == null) {
            print('pc2: end-of-candidate');
            return;
          }
          print('pc2: onicecaniddate => ${candidate.candidate}');
          await pc1.addCandidate(candidate);
        };
      }),
  () => test('RTCPeerConnection.addTransceiver()', () async {
        await pc1.addTransceiver(
            kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
            init: RTCRtpTransceiverInit(
                direction: TransceiverDirection.SendOnly));
        await pc1.addTransceiver(
            kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
            init: RTCRtpTransceiverInit(
                direction: TransceiverDirection.SendOnly));

        await pc2.addTransceiver(
            kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
            init: RTCRtpTransceiverInit(
                direction: TransceiverDirection.RecvOnly));
        await pc2.addTransceiver(
            kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
            init: RTCRtpTransceiverInit(
                direction: TransceiverDirection.RecvOnly));
      }),
  () => test('RTCPeerConnection.createOffer()', () async {
        offer = await pc1.createOffer();
        print('pc1 offer => ${offer.sdp}');
        await pc1.setLocalDescription(offer);
        expect(pc1.signalingState,
            RTCSignalingState.RTCSignalingStateHaveLocalOffer);

        await pc2.setRemoteDescription(offer);
        expect(pc2.signalingState,
            RTCSignalingState.RTCSignalingStateHaveRemoteOffer);
      }),
  () => test('RTCPeerConnection.createAnswer()', () async {
        answer = await pc2.createAnswer({});
        await pc2.setLocalDescription(answer);
        expect(pc2.signalingState, RTCSignalingState.RTCSignalingStateStable);
        print('pc2 answer => ${answer.sdp}');
        await pc1.setRemoteDescription(answer);
        expect(pc1.signalingState, RTCSignalingState.RTCSignalingStateStable);
      }),
  () => test('RTCPeerConnection.localDescription()', () async {
        var localDescription1 = await pc1.getLocalDescription();
        expect(localDescription1!.type, 'offer');
        expect(localDescription1.sdp!.isNotEmpty, true);
        var localDescription2 = await pc2.getLocalDescription();
        expect(localDescription2!.type, 'answer');
        expect(localDescription2.sdp!.isNotEmpty, true);
      }),
  () => test('RTCPeerConnection.remoteDescription()', () async {
        var localDescription1 = await pc1.getLocalDescription();
        expect(localDescription1!.type, 'answer');
        expect(localDescription1.sdp!.isNotEmpty, true);
        var localDescription2 = await pc2.getLocalDescription();
        expect(localDescription2!.type, 'offer');
        expect(localDescription2.sdp!.isNotEmpty, true);
      }),
  () => test('RTCPeerConnection.close()', () async {
        await Future.delayed(Duration(seconds: 5), () {
          pc1.close();
          expect(pc1.signalingState, RTCSignalingState.RTCSignalingStateClosed);
          pc2.close();
          expect(pc2.signalingState, RTCSignalingState.RTCSignalingStateClosed);
        });
      })
];
