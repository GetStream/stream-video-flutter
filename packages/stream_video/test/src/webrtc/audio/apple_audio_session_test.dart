import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/audio/apple_audio_session.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/rtc_manager_fakes.dart';

RtcMediaDevice _output(String id, {String? groupId}) => RtcMediaDevice(
  id: id,
  label: id,
  kind: RtcMediaDeviceKind.audioOutput,
  groupId: groupId,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const viewer = AudioConfigurationPolicy.viewer();
  const broadcaster = AudioConfigurationPolicy.broadcaster();

  group('set and restore', () {
    late List<Map<String, dynamic>> applied;
    Object? applyError;

    AppleAudioSession session() {
      return AppleAudioSession(
        apply: (configuration) async {
          final error = applyError;
          if (error != null) throw error;
          applied.add(configuration.toMap());
        },
      );
    }

    setUp(() {
      applied = [];
      applyError = null;
    });

    test('restore does nothing before anything was set', () async {
      final audioSession = session();

      expect((await audioSession.restore()).isSuccess, isTrue);
      expect(applied, isEmpty);
    });

    test(
      'set applies the configuration and restore applies it again',
      () async {
        final audioSession = session();
        final expected = viewer.getAppleConfiguration(defaultToSpeaker: true);

        expect(
          (await audioSession.set(policy: viewer, speakerOn: true)).isSuccess,
          isTrue,
        );
        expect((await audioSession.restore()).isSuccess, isTrue);

        expect(applied, [expected.toMap(), expected.toMap()]);
      },
    );

    test('a failed set is reported and not remembered', () async {
      final audioSession = session();
      applyError = StateError('audio session busy');

      final result = await audioSession.set(policy: viewer);

      expect(result.isFailure, isTrue);
      expect(audioSession.configuration, isNull);
    });

    test('a failed restore is reported', () async {
      final audioSession = session();
      await audioSession.set(policy: viewer);
      applyError = StateError('audio session busy');

      expect((await audioSession.restore()).isFailure, isTrue);
    });
  });

  group('speakerOnFor', () {
    test('the loudspeaker is asked for when it is selected', () {
      expect(
        AppleAudioSession.speakerOnFor(_output('speaker'), viewer),
        isTrue,
      );
    });

    test('the earpiece never asks for the loudspeaker', () {
      expect(
        AppleAudioSession.speakerOnFor(_output('earpiece'), broadcaster),
        isFalse,
      );
    });

    test('another output follows the policy', () {
      expect(
        AppleAudioSession.speakerOnFor(_output('bluetooth'), broadcaster),
        broadcaster.defaultsToSpeaker,
      );
      expect(
        AppleAudioSession.speakerOnFor(_output('bluetooth'), viewer),
        viewer.defaultsToSpeaker,
      );
    });
  });

  group('selectOutput', () {
    late FakeWebRtcPlatform platform;

    setUp(() => platform = FakeWebRtcPlatform()..install());
    tearDown(() => platform.uninstall());

    test('routes the audio to the device', () async {
      await AppleAudioSession().selectOutput(_output('bluetooth'));

      expect(
        platform.callsOf('selectAudioOutput').single.arguments,
        containsPair('deviceId', 'bluetooth'),
      );
    });
  });
}
