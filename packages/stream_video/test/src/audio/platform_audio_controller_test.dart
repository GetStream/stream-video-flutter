import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart' as rtc;

import '../../fixtures/fake_webrtc_engine.dart';
import '../../fixtures/webrtc_capabilities.dart';

void main() {
  late FakePlatformEvents events;
  late FakeWebRtcEngine engine;
  late PlatformAudioController controller;

  setUp(() {
    events = FakePlatformEvents();
    engine = FakeWebRtcEngine(events: events);
    controller = PlatformAudioController.withEngine(engine);
  });

  tearDown(() => events.close());

  group('audio playout pause', () {
    Exception? pauseError;

    setUp(() {
      overrideWebRtcCapabilities(platform: PlatformType.android);
      pauseError = null;
      engine.audio.onSetPlayoutPaused = (paused) async {
        if (paused) {
          if (pauseError case final error?) throw error;
        }
      };
    });

    test('starts unpaused and emits only when the state changes', () async {
      expect(controller.isAudioPlayoutPaused, isFalse);

      final emitted = <bool>[];
      final subscription = controller.audioPlayoutPausedChanges.listen(
        emitted.add,
      );

      await controller.pauseAudioPlayout();
      await controller.pauseAudioPlayout();
      expect(controller.isAudioPlayoutPaused, isTrue);

      await controller.resumeAudioPlayout();
      await controller.resumeAudioPlayout();
      expect(controller.isAudioPlayoutPaused, isFalse);

      await subscription.cancel();
      expect(emitted, [false, true, false]);
      expect(engine.audio.calls, ['pause', 'pause', 'resume', 'resume']);
    });

    test('traces each pause and resume', () async {
      await controller.pauseAudioPlayout();
      await controller.resumeAudioPlayout();

      final tags = controller.getTrace().snapshot.map((record) => record.tag);
      expect(tags, [TraceTag.pauseAudioPlayout, TraceTag.resumeAudioPlayout]);
    });

    for (final platform in [PlatformType.windows, PlatformType.linux]) {
      test('does nothing on ${platform.name}', () async {
        overrideWebRtcCapabilities(platform: platform);

        expect(controller.isAudioPlayoutPauseSupported, isFalse);
        await controller.pauseAudioPlayout();

        expect(controller.isAudioPlayoutPaused, isFalse);
        expect(engine.audio.calls, isEmpty);
      });
    }

    test('a pause that throws leaves the state unchanged', () async {
      final error = Exception('pause failed');
      pauseError = error;

      await expectLater(controller.pauseAudioPlayout(), throwsA(same(error)));

      expect(controller.isAudioPlayoutPaused, isFalse);
    });
  });

  group('platform events', () {
    test('screen sharing and audio route changes reach the native '
        'events', () async {
      final received = <NativeWebRtcEvent>[];
      final subscription = controller.nativeWebRtcEventsStream().listen(
        received.add,
      );

      events.screenSharingStarts.add(null);
      events.screenSharingStops.add(
        const rtc.ScreenSharingStopped(trackId: 'track-1'),
      );
      events.audioRoutes.add(
        const rtc.AudioRoute(
          deviceId: 'speaker-uid',
          label: 'Speaker',
          groupId: 'Speaker',
        ),
      );
      await pumpEventQueue();
      await subscription.cancel();

      expect(received, [
        isA<ScreenSharingStartedEvent>(),
        isA<ScreenSharingStoppedEvent>().having(
          (e) => e.trackId,
          'trackId',
          'track-1',
        ),
        isA<AudioRouteChangedEvent>().having(
          (e) => e.device,
          'device',
          const RtcMediaDevice(
            id: 'speaker-uid',
            label: 'Speaker',
            groupId: 'Speaker',
            kind: RtcMediaDeviceKind.audioOutput,
          ),
        ),
      ]);
    });

    test('an audio route change carries its reason', () async {
      final received = <NativeWebRtcEvent>[];
      final subscription = controller.nativeWebRtcEventsStream().listen(
        received.add,
      );

      events.audioRoutes
        ..add(
          const rtc.AudioRoute(
            deviceId: 'Speaker',
            label: 'Speaker',
            reason: AudioRouteChangeReason.routeConfigurationChange,
          ),
        )
        ..add(const rtc.AudioRoute(deviceId: 'Receiver', label: 'Receiver'));
      await pumpEventQueue();
      await subscription.cancel();

      expect(received.cast<AudioRouteChangedEvent>().map((e) => e.reason), [
        AudioRouteChangeReason.routeConfigurationChange,
        AudioRouteChangeReason.unknown,
      ]);
    });

    test('speech activity reaches the speech activity stream', () async {
      final received = <SpeechActivityEvent>[];
      final subscription = controller.speechActivityStream.listen(
        received.add,
      );

      events.speechActivity
        ..add(rtc.SpeechActivity.started)
        ..add(rtc.SpeechActivity.ended);
      await pumpEventQueue();
      await subscription.cancel();

      expect(received, [
        isA<SpeechActivityStarted>(),
        isA<SpeechActivityEnded>(),
      ]);
    });

    test('an audio processing change is traced', () async {
      events.audioProcessingStates.add(
        const rtc.AudioProcessingState(
          stereoPlayoutEnabled: true,
          voiceProcessingEnabled: false,
          voiceProcessingBypassed: true,
          voiceProcessingAGCEnabled: false,
        ),
      );
      await pumpEventQueue();

      final traces = controller.getTrace().snapshot.where(
        (record) => record.tag == TraceTag.audioProcessingStateChanged,
      );
      expect(traces.map((record) => record.data), [
        {
          'stereoPlayoutEnabled': true,
          'voiceProcessingEnabled': false,
          'voiceProcessingBypassed': true,
          'voiceProcessingAGCEnabled': false,
        },
      ]);
    });
  });

  group('audioInterruptions', () {
    late _FakePlatformEvents events;

    /// A controller of its own, not listened to yet.
    late PlatformAudioController fresh;

    setUp(() {
      overrideWebRtcCapabilities(platform: PlatformType.android);
      events = _FakePlatformEvents();
      fresh = PlatformAudioController.withEngine(
        FakeWebRtcEngine(events: events),
      );
    });

    tearDown(() async {
      await events.interruptions.close();
    });

    test('maps a start to true and an end to false', () async {
      final received = <bool>[];
      final subscription = fresh.audioInterruptions.listen(received.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      events.interruptions
        ..add(rtc.AudioInterruption.started)
        ..add(rtc.AudioInterruption.ended);
      await pumpEventQueue();

      expect(received, [true, false]);
    });

    test('enables the interruptions once, on the first listen', () async {
      expect(events.enableCount, 0);

      final first = fresh.audioInterruptions.listen((_) {});
      final second = fresh.audioInterruptions.listen((_) {});
      await pumpEventQueue();
      await first.cancel();
      await second.cancel();
      final third = fresh.audioInterruptions.listen((_) {});
      addTearDown(third.cancel);
      await pumpEventQueue();

      expect(events.enableCount, 1);
      expect(events.listeners, 1);
    });

    test('reports none where the platform reports no interruptions', () async {
      overrideWebRtcCapabilities(platform: PlatformType.linux);
      final received = <bool>[];
      final subscription = fresh.audioInterruptions.listen(received.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      events.interruptions.add(rtc.AudioInterruption.started);
      await pumpEventQueue();

      expect(events.enableCount, 0);
      expect(events.listeners, 0);
      expect(received, isEmpty);
    });

    test('passes on an interruption reported while enabling', () async {
      final enabling = Completer<void>();
      events.enableGates.add(enabling);
      final received = <bool>[];
      final subscription = fresh.audioInterruptions.listen(received.add);
      addTearDown(subscription.cancel);

      events.interruptions.add(rtc.AudioInterruption.started);
      await pumpEventQueue();
      enabling.complete();
      await pumpEventQueue();

      expect(received, [true]);
    });

    test('tries again on the next first listen after enabling '
        'failed', () async {
      events.enableError = StateError('enable failed');
      final failed = fresh.audioInterruptions.listen((_) {});
      await pumpEventQueue();
      await failed.cancel();
      expect(events.listeners, 0);

      events.enableError = null;
      final received = <bool>[];
      final subscription = fresh.audioInterruptions.listen(received.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();
      events.interruptions.add(rtc.AudioInterruption.started);
      await pumpEventQueue();

      expect(events.enableCount, 2);
      expect(received, [true]);
    });

    test('tries again on the next first listen after enabling threw '
        'synchronously', () async {
      events.syncEnableError = StateError('enable failed');
      final failed = fresh.audioInterruptions.listen((_) {});
      await pumpEventQueue();
      await failed.cancel();
      expect(events.listeners, 0);

      events.syncEnableError = null;
      final received = <bool>[];
      final subscription = fresh.audioInterruptions.listen(received.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();
      events.interruptions.add(rtc.AudioInterruption.started);
      await pumpEventQueue();

      expect(events.enableCount, 2);
      expect(received, [true]);
    });
  });

  group('system-managed audio focus', () {
    test('is supported where WebRTC can leave focus to the system', () {
      overrideWebRtcCapabilities(platform: PlatformType.android);
      expect(
        PlatformAudioController.isSystemManagedAudioFocusSupported,
        isTrue,
      );

      overrideWebRtcCapabilities(platform: PlatformType.ios);
      expect(
        PlatformAudioController.isSystemManagedAudioFocusSupported,
        isFalse,
      );
    });

    test('telling WebRTC does nothing where it is not supported', () async {
      overrideWebRtcCapabilities(platform: PlatformType.ios);

      await controller.setAndroidAudioFocusHandledBySystem(
        handledBySystem: true,
      );

      expect(engine.audio.calls, isEmpty);
    });
  });

  group('reinitializeAudioConfiguration', () {
    test('refreshes the implicit factory without the Apple '
        'configuration', () async {
      const policy = AudioConfigurationPolicy.viewer();
      await controller.reinitializeAudioConfiguration(policy);

      final options = engine.defaultFactoryOptions.single!;
      expect(options.bypassVoiceProcessing, isTrue);
      expect(
        options.androidAudioConfiguration?.toMap(),
        policy.getAndroidConfiguration().toMap(),
      );
      expect(options.appleAudioConfiguration, isNull);
    });

    test('prefers stereo playout when voice processing is bypassed', () async {
      await controller.reinitializeAudioConfiguration(
        const AudioConfigurationPolicy.viewer(),
      );
      await controller.reinitializeAudioConfiguration(
        const AudioConfigurationPolicy.broadcaster(),
      );

      expect(
        engine.defaultFactoryOptions.map((o) => o?.preferStereoPlayout),
        [true, false],
      );
    });
  });

  test('regaining Android audio focus is traced', () async {
    await controller.regainAndroidAudioFocus();

    expect(engine.audio.calls, ['regainAndroidAudioFocus']);
    final tags = controller.getTrace().snapshot.map((record) => record.tag);
    expect(tags, contains(TraceTag.regainAndroidAudioFocus));
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
}

// ignore: subtype_of_sealed_class, a fake for the tests
class _FakePlatformEvents implements rtc.WebRtcPlatformEvents {
  // Closed in the tests' tearDown.
  // ignore: close_sinks
  final interruptions = StreamController<rtc.AudioInterruption>.broadcast();

  /// How many times [enableInterruptionEvents] ran.
  int enableCount = 0;

  /// When not empty, each enable waits for the next of these.
  final enableGates = <Completer<void>>[];

  /// When set, enabling fails with it.
  Error? enableError;

  /// When set, enabling throws it before returning a future.
  Error? syncEnableError;

  /// The subscriptions to [onInterruption] not cancelled yet.
  int listeners = 0;

  @override
  Stream<rtc.AudioInterruption> get onInterruption => Stream.multi((
    controller,
  ) {
    listeners++;
    final subscription = interruptions.stream.listen(controller.add);
    controller.onCancel = () {
      listeners--;
      return subscription.cancel();
    };
  }, isBroadcast: true);

  @override
  Future<void> enableInterruptionEvents() {
    enableCount++;
    if (syncEnableError case final error?) throw error;
    return _enable();
  }

  Future<void> _enable() async {
    if (enableGates.isNotEmpty) await enableGates.removeAt(0).future;
    if (enableError case final error?) throw error;
  }

  @override
  Stream<rtc.AudioRoute> get onAudioRouteChanged => const Stream.empty();

  @override
  Stream<rtc.SpeechActivity> get onSpeechActivity => const Stream.empty();

  @override
  rtc.SpeechActivityDetector createSpeechActivityDetector() {
    throw UnimplementedError();
  }

  @override
  Stream<rtc.AudioProcessingState> get onAudioProcessingStateChanged =>
      const Stream.empty();

  @override
  Stream<void> get onScreenSharingStarted => const Stream.empty();

  @override
  Stream<rtc.ScreenSharingStopped> get onScreenSharingStopped =>
      const Stream.empty();
}
