import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/apple_audio_route.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  group('resolveAppleSpeakerOn', () {
    const viewer = AudioConfigurationPolicy.viewer();
    const hiFi = AudioConfigurationPolicy.hiFi();
    const broadcaster = AudioConfigurationPolicy.broadcaster();

    test('asks for the loudspeaker when it is requested', () {
      for (final policy in const [viewer, hiFi, broadcaster]) {
        expect(
          resolveAppleSpeakerOn(policy: policy, speakerRequested: true),
          isTrue,
          reason: '${policy.runtimeType}',
        );
      }
    });

    test('the viewer policy keeps the loudspeaker as the built-in output when '
        'another device is selected', () {
      // Headphones, Bluetooth, or `speakerDefaultOn` overwritten by connect
      // options passed to `join`.
      expect(
        resolveAppleSpeakerOn(policy: viewer, speakerRequested: false),
        isTrue,
      );
    });

    test('an explicit earpiece choice wins over the viewer policy', () {
      expect(
        resolveAppleSpeakerOn(
          policy: viewer,
          speakerRequested: false,
          earpieceRequested: true,
        ),
        isFalse,
      );
    });

    test('the broadcaster and HiFi policies only ask for the loudspeaker on '
        'request', () {
      for (final policy in const [broadcaster, hiFi]) {
        expect(
          resolveAppleSpeakerOn(policy: policy, speakerRequested: false),
          isFalse,
          reason: '${policy.runtimeType}',
        );
      }
    });
  });

  group('AppleAudioRouteDevice', () {
    RtcMediaDevice output(String id, {String? groupId}) => RtcMediaDevice(
      id: id,
      label: id,
      kind: RtcMediaDeviceKind.audioOutput,
      groupId: groupId,
    );

    test('recognises the built-in speaker by id, in any case', () {
      expect(output('Speaker').isBuiltInSpeaker, isTrue);
      expect(output('speaker').isBuiltInSpeaker, isTrue);
      expect(output('Built-In Receiver').isBuiltInSpeaker, isFalse);
    });

    test('recognises the earpiece by id or by the iOS receiver port', () {
      expect(output('earpiece').isBuiltInEarpiece, isTrue);
      expect(
        output('Built-In Receiver', groupId: 'Receiver').isBuiltInEarpiece,
        isTrue,
      );
      expect(
        output('bt', groupId: 'BluetoothA2DPOutput').isBuiltInEarpiece,
        isFalse,
      );
      expect(output('Speaker', groupId: 'Speaker').isBuiltInEarpiece, isFalse);
    });
  });
}
