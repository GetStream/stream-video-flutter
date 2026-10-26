import 'package:dart_webrtc/dart_webrtc.dart';
import 'package:test/test.dart';

MediaStream? mediaStream;

List<void Function()> testFunctions = <void Function()>[
  () => test('mediaStream?.constructor()', () async {
        mediaStream = await navigator.mediaDevices
            .getUserMedia({'audio': true, 'video': true});

        expect(mediaStream?.id != null, true);
      }),
  () => test('mediaStream?.active()', () {
        expect(mediaStream?.active, true);
      }),
  () => test('mediaStream?.getTracks()', () {
        expect(mediaStream?.getTracks().length, 2);
      }),
  () => test('mediaStream?.getAudioTracks()', () {
        expect(mediaStream?.getAudioTracks().length, 1);
        var track = mediaStream
            ?.getTrackById(mediaStream?.getAudioTracks()[0].id ?? '');
        expect(track?.id, mediaStream?.getAudioTracks()[0].id);
      }),
  () => test('mediaStream?.getVideoTracks()', () {
        expect(mediaStream?.getVideoTracks().length, 1);
        var track = mediaStream
            ?.getTrackById(mediaStream?.getVideoTracks()[0].id ?? '');
        expect(track!.id, mediaStream?.getVideoTracks()[0].id);
      }),
  () => test('mediaStream?.removeTrack()', () {
        var track = mediaStream
            ?.getTrackById(mediaStream?.getVideoTracks()[0].id ?? '');
        mediaStream?.removeTrack(track!);
        expect(mediaStream?.getVideoTracks().length, 0);
      }),
  () => test('mediaStream?.close()', () {
        mediaStream?.getTracks().forEach((element) {
          element.stop();
          mediaStream?.removeTrack(element);
        });
        expect(mediaStream?.getTracks().isEmpty, true);
      })
];
