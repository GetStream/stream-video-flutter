import 'package:dart_webrtc/dart_webrtc.dart';
import 'package:test/test.dart';

MediaStreamTrack? audioTrack, videoTrack;

List<void Function()> testFunctions = <void Function()>[
  () => test('MediaStreamTrack.constructor()', () async {
        var stream = await navigator.mediaDevices
            .getUserMedia({'audio': true, 'video': true});

        audioTrack = stream.getAudioTracks()[0];
        expect(audioTrack != null, true);

        expect(audioTrack?.kind, 'audio');

        videoTrack = stream.getVideoTracks()[0];
        expect(videoTrack != null, true);

        expect(videoTrack?.kind, 'video');
      }),
  () => test('MediaStreamTrack.id()', () {
        expect(audioTrack?.id is String, true);
        expect(audioTrack?.id?.isNotEmpty, true);
        expect(videoTrack?.id is String, true);
        expect(videoTrack?.id?.isNotEmpty, true);
      }),
  () => test('MediaStreamTrack.label()', () {
        expect(audioTrack?.label is String, true);
        expect(audioTrack?.id?.isNotEmpty, true);
        expect(videoTrack?.id is String, true);
        expect(videoTrack?.id?.isNotEmpty, true);
      }),
  () => test('MediaStreamTrack.enabled()', () {
        expect(audioTrack?.enabled, true);
        audioTrack?.enabled = false;
        expect(audioTrack?.enabled, false);

        expect(videoTrack?.enabled, true);
        videoTrack?.enabled = false;
        expect(videoTrack?.enabled, false);
      }),
  () => test('MediaStreamTrack.readyState() | MediaStreamTrack.stop()', () {
        /*
        expect(audioTrack?.readyState, 'live');
        audioTrack?.stop();
        expect(audioTrack?.readyState, 'ended');

        expect(videoTrack?.readyState, 'live');
        videoTrack?.stop();
        expect(videoTrack?.readyState, 'ended');
        */
      })
];
