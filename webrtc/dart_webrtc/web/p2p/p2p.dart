import 'package:dart_webrtc/dart_webrtc.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

import 'signaling.dart';

void main() {
  test('String.split() splits the string on the delimiter', () {
    var string = 'foo,bar,baz';
    expect(string.split(','), equals(['foo', 'bar', 'baz']));
  });

  test('String.trim() removes surrounding whitespace', () {
    var string = '  foo ';
    expect(string.trim(), equals('foo'));
  });

  var signaling = Signaling('demo.cloudwebrtc.com');

  var local = web.document.querySelector('#local');

  var localVideo = RTCVideoElement();

  local?.append(localVideo.htmlElement);

  var remote = web.document.querySelector('#remote');

  var remoteVideo = RTCVideoElement();

  remote?.append(remoteVideo.htmlElement);

  signaling.onLocalStream = (MediaStream stream) {
    localVideo.srcObject = stream;
  };

  signaling.onAddRemoteStream = (MediaStream stream) {
    remoteVideo.srcObject = stream;
  };

  signaling.connect();
  signaling.onStateChange = (SignalingState state) {
    web.document.querySelector('#output')?.textContent = state.toString();
    if (state == SignalingState.CallStateBye) {
      localVideo.srcObject = null;
      remoteVideo.srcObject = null;
    }
  };
}

/*
void loopBackTest() {
  var local = document.querySelector('#local');
  var localVideo = VideoElement()
    ..autoplay = true
    ..muted = true
    ..controls = false
    ..style.objectFit = 'contain' // contain or cover
    ..style.border = 'none'
    ..id = 'dart-webrtc-video-01';

  // Allows Safari iOS to play the video inline
  localVideo.setAttribute('playsinline', 'true');
  local.append(localVideo);
  dartWebRTCTest(localVideo);
}

void dartWebRTCTest(VideoElement video) async {
  var list = await PromiseToFuture<List<dynamic>>(
      navigator.mediaDevices.enumerateDevices());
  list.forEach((e) {
    if (e is MediaDeviceInfo) {
      print('MediaDeviceInfo: ${e.label}');
    } else if (e is InputDeviceInfo) {
      print('InputDeviceInfo: ${e.label}');
    }
  });

  var pc = RTCPeerConnection();
  print('connectionState: ${pc.connectionState}');
  pc.onaddstream = (MediaStreamEvent event) {};
  var stream = await PromiseToFuture<MediaStream>(
      navigator.mediaDevices.getDisplayMedia()
      /*.getUserMedia(MediaStreamConstraints(audio: true, video: true))*/);
  print('getDisplayMedia: stream.id => ${stream.id}');
  stream.oninactive = (Event event) {
    print('oninactive: stream.id => ${event.target.id}');
    video.srcObject = null;
    video.remove();
  };
  pc.addStream(stream);
  var rtcVideo = ConvertToRTCVideoElement(video);
  rtcVideo.srcObject = stream;
}
*/
