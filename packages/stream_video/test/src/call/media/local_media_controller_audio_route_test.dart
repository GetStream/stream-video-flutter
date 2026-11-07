import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/media/local_media_controller.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';

void main() {
  late MockCallSession session;
  late CallStateNotifier stateManager;
  late LocalMediaController controller;

  const speaker = RtcMediaDevice(
    id: 'Speaker',
    label: 'Speaker',
    kind: RtcMediaDeviceKind.audioOutput,
  );
  const receiver = RtcMediaDevice(
    id: 'Receiver',
    label: 'Receiver',
    kind: RtcMediaDeviceKind.audioOutput,
  );
  const headset = RtcMediaDevice(
    id: 'Headset',
    label: 'Headset',
    kind: RtcMediaDeviceKind.audioOutput,
  );

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    session = MockCallSession();
    when(
      () => session.applyCurrentAudioOutputDevice(),
    ).thenAnswer((_) async {});
    stateManager = CallStateNotifier(createTestCallState());
    controller = LocalMediaController(
      stateManager: stateManager,
      session: () => session,
      sfuStatsReporter: () => null,
      hasPermission: (_) => true,
      rtcMediaDeviceNotifier: MockRtcMediaDeviceNotifier.new,
      audioConfigurationPolicy: () =>
          const AudioConfigurationPolicy.broadcaster(),
      muteVideoWhenInBackground: () => false,
      muteAudioWhenInBackground: () => false,
      onMicrophoneMuted: (_) async {},
      logger: taggedLogger(tag: 'test'),
    );
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  void userChose(RtcMediaDevice device) {
    stateManager.participantSetAudioOutputDevice(device: device);
    stateManager.audioOutputSelectedByUser = true;
  }

  AudioRouteChangedEvent routeChange(
    RtcMediaDevice device,
    AudioRouteChangeReason reason,
  ) => AudioRouteChangedEvent(device: device, reason: reason);

  group('an iOS audio route change', () {
    for (final reason in [
      AudioRouteChangeReason.categoryChange,
      AudioRouteChangeReason.routeConfigurationChange,
    ]) {
      test('from the system (${reason.name}) puts the chosen output back', () {
        userChose(speaker);

        controller.onAudioRouteChanged(routeChange(receiver, reason));

        verify(() => session.applyCurrentAudioOutputDevice()).called(1);
        expect(stateManager.callState.audioOutputDevice, speaker);
        expect(stateManager.audioOutputSelectedByUser, isTrue);
        expect(controller.connectOptions.audioOutputDevice, isNull);
      });
    }

    test('to a new device is followed, even after the user chose one', () {
      userChose(speaker);

      controller.onAudioRouteChanged(
        routeChange(headset, AudioRouteChangeReason.newDeviceAvailable),
      );

      verifyNever(() => session.applyCurrentAudioOutputDevice());
      expect(stateManager.callState.audioOutputDevice, headset);
      expect(stateManager.audioOutputSelectedByUser, isFalse);
      expect(controller.connectOptions.audioOutputDevice, headset);
    });

    test('from the system is followed when the user chose nothing', () {
      stateManager.participantSetAudioOutputDevice(device: speaker);

      controller.onAudioRouteChanged(
        routeChange(receiver, AudioRouteChangeReason.routeConfigurationChange),
      );

      verifyNever(() => session.applyCurrentAudioOutputDevice());
      expect(stateManager.callState.audioOutputDevice, receiver);
      expect(stateManager.audioOutputSelectedByUser, isFalse);
      expect(controller.connectOptions.audioOutputDevice, receiver);
    });

    test('to the output already in use changes nothing', () {
      userChose(speaker);

      controller.onAudioRouteChanged(
        routeChange(speaker, AudioRouteChangeReason.categoryChange),
      );

      verifyNever(() => session.applyCurrentAudioOutputDevice());
      expect(stateManager.audioOutputSelectedByUser, isTrue);
    });
  });

  test('a route change is ignored off iOS', () {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    userChose(speaker);

    controller.onAudioRouteChanged(
      routeChange(receiver, AudioRouteChangeReason.newDeviceAvailable),
    );

    expect(stateManager.callState.audioOutputDevice, speaker);
  });

  group('AudioRouteChangeReason', () {
    test('has the AVAudioSessionRouteChangeReason codes', () {
      expect(
        {
          for (final reason in AudioRouteChangeReason.values)
            reason: reason.code,
        },
        {
          AudioRouteChangeReason.unknown: 0,
          AudioRouteChangeReason.newDeviceAvailable: 1,
          AudioRouteChangeReason.oldDeviceUnavailable: 2,
          AudioRouteChangeReason.categoryChange: 3,
          AudioRouteChangeReason.override: 4,
          AudioRouteChangeReason.wakeFromSleep: 6,
          AudioRouteChangeReason.noSuitableRouteForCategory: 7,
          AudioRouteChangeReason.routeConfigurationChange: 8,
        },
      );
    });

    test('maps each code back, and an unknown or missing one to unknown', () {
      for (final reason in AudioRouteChangeReason.values) {
        expect(AudioRouteChangeReason.fromCode(reason.code), reason);
      }
      expect(
        AudioRouteChangeReason.fromCode(5),
        AudioRouteChangeReason.unknown,
      );
      expect(
        AudioRouteChangeReason.fromCode(null),
        AudioRouteChangeReason.unknown,
      );
    });

    test(
      'counts only a category or route configuration change as the system re-routing',
      () {
        expect(
          AudioRouteChangeReason.values.where(
            (reason) => reason.isSystemReconfiguration,
          ),
          [
            AudioRouteChangeReason.categoryChange,
            AudioRouteChangeReason.routeConfigurationChange,
          ],
        );
      },
    );
  });

  group('the onAudioRouteChange message from the WebRTC plugin', () {
    test('carries the device and the reason', () {
      final event = RtcMediaDeviceNotifier.nativeWebRtcEventFrom({
        'onAudioRouteChange': {
          'deviceId': 'Speaker',
          'label': 'Speaker',
          'reason': 8,
        },
      });

      expect(event, isA<AudioRouteChangedEvent>());
      final routeChange = event! as AudioRouteChangedEvent;
      expect(routeChange.device.id, 'Speaker');
      expect(routeChange.device.kind, RtcMediaDeviceKind.audioOutput);
      expect(
        routeChange.reason,
        AudioRouteChangeReason.routeConfigurationChange,
      );
    });

    test('without a reason has an unknown one', () {
      final event = RtcMediaDeviceNotifier.nativeWebRtcEventFrom({
        'onAudioRouteChange': {'deviceId': 'Receiver'},
      });

      expect(
        (event! as AudioRouteChangedEvent).reason,
        AudioRouteChangeReason.unknown,
      );
    });

    test('without a device is dropped', () {
      expect(
        RtcMediaDeviceNotifier.nativeWebRtcEventFrom({
          'onAudioRouteChange': {'reason': 8},
        }),
        isNull,
      );
    });
  });
}
