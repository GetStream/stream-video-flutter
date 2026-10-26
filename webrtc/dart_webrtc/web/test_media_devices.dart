import 'package:dart_webrtc/dart_webrtc.dart';
import 'package:test/test.dart';

void closeMediaStream(MediaStream stream) {
  stream.getTracks().forEach((element) {
    element.stop();
  });
}

List<void Function()> testFunctions = <void Function()>[
  () => test('MediaDevices.enumerateDevices()', () async {
        var list = await navigator.mediaDevices.enumerateDevices();
        list.forEach((e) {
          print('${e.runtimeType}: ${e.label}, type => ${e.kind}');
        });
      }),
  () => test('MediaDevices.getUserMedia()', () async {
        var stream = await navigator.mediaDevices
            .getUserMedia({'audio': true, 'video': true});
        print('getUserMedia: stream.id => ${stream.id}');

        print(
            'getUserMedia: audio track.id => ${stream.getAudioTracks()[0].id}');
        expect(stream.getAudioTracks().isNotEmpty, true);
        print(
            'getUserMedia: video track.id => ${stream.getVideoTracks()[0].id}');
        expect(stream.getVideoTracks().isNotEmpty, true);

        closeMediaStream(stream);

        stream = await navigator.mediaDevices
            .getUserMedia({'audio': false, 'video': true});

        expect(stream.getAudioTracks().isEmpty, true);
        expect(stream.getVideoTracks().isNotEmpty, true);

        closeMediaStream(stream);

        stream = await navigator.mediaDevices
            .getUserMedia({'audio': true, 'video': false});

        expect(stream.getAudioTracks().isNotEmpty, true);
        expect(stream.getVideoTracks().isEmpty, true);

        closeMediaStream(stream);
        /*
        expect(
            await mediaDevices.getUserMedia(
                constraints:
                    MediaStreamConstraints(audio: false, video: false)),
            throwsException);*/
      }),
  () => test('MediaDevices.getDisplayMedia()', () async {
        /*
        var stream = await mediaDevices.getDisplayMedia(
            constraints: MediaStreamConstraints(audio: false, video: true));
        print('getDisplayMedia: stream.id => ${stream.id}');
        expect(stream != null, true);
        expect(stream.getAudioTracks().isEmpty, true);
        print(
            'getDisplayMedia: video track.id => ${stream.getVideoTracks()[0].id}');
        expect(stream.getVideoTracks().isNotEmpty, true);

        closeMediaStream(stream);
      */
      })
];
