import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/audio/audio_session.dart';
import 'package:stream_video/src/webrtc/audio/ios_audio_session.dart';
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

    IosAudioSession session() {
      return IosAudioSession(
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

    test('restore applies the configuration set last', () async {
      final audioSession = session();

      await audioSession.set(policy: viewer, speakerOn: true);
      await audioSession.set(policy: viewer);
      applied.clear();
      await audioSession.restore();

      expect(applied, [
        viewer.getAppleConfiguration(defaultToSpeaker: false).toMap(),
      ]);
    });

    test('a failed set keeps the configuration set before it', () async {
      final audioSession = session();
      await audioSession.set(policy: viewer, speakerOn: true);
      applyError = StateError('audio session busy');

      expect((await audioSession.set(policy: viewer)).isFailure, isTrue);

      final earlier = viewer.getAppleConfiguration(defaultToSpeaker: true);
      expect(audioSession.configuration?.toMap(), earlier.toMap());
      applyError = null;
      applied.clear();
      await audioSession.restore();
      expect(applied, [earlier.toMap()]);
    });

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
        IosAudioSession.speakerOnFor(_output('speaker'), viewer),
        isTrue,
      );
    });

    test('the earpiece never asks for the loudspeaker', () {
      expect(
        IosAudioSession.speakerOnFor(_output('earpiece'), broadcaster),
        isFalse,
      );
    });

    test('another output follows the policy', () {
      expect(
        IosAudioSession.speakerOnFor(_output('bluetooth'), broadcaster),
        broadcaster.defaultsToSpeaker,
      );
      expect(
        IosAudioSession.speakerOnFor(_output('bluetooth'), viewer),
        viewer.defaultsToSpeaker,
      );
    });
  });

  group('selectOutput', () {
    test('routes the audio to the device', () async {
      final selected = <String>[];
      final audioSession = IosAudioSession(
        selectAudioOutput: (deviceId) async => selected.add(deviceId),
      );

      await audioSession.selectOutput(_output('bluetooth'));

      expect(selected, ['bluetooth']);
    });
  });

  group('AudioSession.forPlatform', () {
    tearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

    test('is the Apple session on iOS', () {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;

      expect(AudioSession.forPlatform(), isA<IosAudioSession>());
    });

    test('is the default session elsewhere', () {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      expect(AudioSession.forPlatform(), isA<DefaultAudioSession>());
    });
  });

  group('DefaultAudioSession', () {
    late FakeWebRtcPlatform platform;

    setUp(() => platform = FakeWebRtcPlatform()..install());
    tearDown(() => platform.uninstall());

    test('configures nothing and still switches the output', () async {
      const audioSession = DefaultAudioSession();

      expect((await audioSession.set(policy: viewer)).isSuccess, isTrue);
      expect((await audioSession.restore()).isSuccess, isTrue);
      await audioSession.selectOutput(_output('headset'));

      expect(platform.callsOf('selectAudioOutput'), hasLength(1));
      expect(platform.callsOf('setAppleAudioConfiguration'), isEmpty);
    });
  });
}
