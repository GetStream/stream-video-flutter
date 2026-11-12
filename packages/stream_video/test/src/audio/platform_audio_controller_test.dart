import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../fixtures/webrtc_capabilities.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('FlutterWebRTC.Method');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  Map<Object?, Object?>? initializeOptions;

  late PlatformAudioController controller;

  setUpAll(() {
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'initialize') {
        initializeOptions =
            (call.arguments as Map)['options'] as Map<Object?, Object?>;
      }
      return null;
    });

    controller = PlatformAudioController.instance;
  });

  tearDownAll(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  setUp(() {
    // Drop the traces of earlier tests.
    controller.getTrace();
  });

  group('audio playout pause', () {
    late Future<void> Function() originalPause;
    late Future<void> Function() originalResume;
    final nativeCalls = <String>[];
    Exception? pauseError;

    setUp(() {
      rtc.debugWebRtcCapabilitiesOverride = webRtcCapabilitiesOf(
        PlatformType.android,
      );
      nativeCalls.clear();
      pauseError = null;
      originalPause = controller.nativePauseAudioPlayout;
      originalResume = controller.nativeResumeAudioPlayout;
      controller
        ..nativePauseAudioPlayout = () async {
          nativeCalls.add('pause');
          if (pauseError case final error?) throw error;
        }
        ..nativeResumeAudioPlayout = () async => nativeCalls.add('resume');
    });

    tearDown(() async {
      rtc.debugWebRtcCapabilitiesOverride = webRtcCapabilitiesOf(
        PlatformType.android,
      );
      pauseError = null;
      if (controller.isAudioPlayoutPaused) {
        await controller.resumeAudioPlayout();
      }
      controller
        ..nativePauseAudioPlayout = originalPause
        ..nativeResumeAudioPlayout = originalResume;
      rtc.debugWebRtcCapabilitiesOverride = null;
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
      expect(nativeCalls, ['pause', 'pause', 'resume', 'resume']);
    });

    for (final platform in [PlatformType.windows, PlatformType.linux]) {
      test('does nothing on ${platform.name}', () async {
        rtc.debugWebRtcCapabilitiesOverride = webRtcCapabilitiesOf(platform);

        expect(controller.isAudioPlayoutPauseSupported, isFalse);
        await controller.pauseAudioPlayout();

        expect(controller.isAudioPlayoutPaused, isFalse);
        expect(nativeCalls, isEmpty);
      });
    }

    test('a pause that throws leaves the state unchanged', () async {
      final error = Exception('pause failed');
      pauseError = error;

      await expectLater(controller.pauseAudioPlayout(), throwsA(same(error)));

      expect(controller.isAudioPlayoutPaused, isFalse);
    });
  });

  group('plugin events', () {
    /// Sends [event] with [payload] the way the native side posts it.
    Future<void> emit(
      String event, [
      Map<String, Object?> payload = const {},
    ]) async {
      await messenger.handlePlatformMessage(
        'FlutterWebRTC.Event',
        const StandardMethodCodec().encodeSuccessEnvelope({
          'event': event,
          ...payload,
        }),
        (_) {},
      );
      await pumpEventQueue();
    }

    test('screen sharing and audio route changes reach the native '
        'events', () async {
      final events = <NativeWebRtcEvent>[];
      final subscription = controller.nativeWebRtcEventsStream().listen(
        events.add,
      );

      await emit('screenSharingStarted');
      await emit('screenSharingStopped', {'trackId': 'track-1'});
      await emit('onAudioRouteChange', {
        'deviceId': 'speaker-uid',
        'label': 'Speaker',
        'groupId': 'Speaker',
      });
      await subscription.cancel();

      expect(events, [
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

    test('an audio route without a device id is dropped', () async {
      final events = <NativeWebRtcEvent>[];
      final subscription = controller.nativeWebRtcEventsStream().listen(
        events.add,
      );

      await emit('onAudioRouteChange', {'deviceId': '', 'label': 'Speaker'});
      await subscription.cancel();

      expect(events, isEmpty);
    });

    test('speech activity reaches the speech activity stream', () async {
      final events = <SpeechActivityEvent>[];
      final subscription = controller.speechActivityStream.listen(events.add);

      await emit('onSpeechActivityChanged', {'type': 'started'});
      await emit('onSpeechActivityChanged', {'type': 'ended'});
      await subscription.cancel();

      expect(events, [
        isA<SpeechActivityStarted>(),
        isA<SpeechActivityEnded>(),
      ]);
    });

    test('an audio processing change is traced', () async {
      await emit('onAudioProcessingStateChanged', {
        'stereoPlayoutEnabled': true,
        'voiceProcessingEnabled': false,
        'voiceProcessingBypassed': true,
        'voiceProcessingAGCEnabled': false,
      });

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

    // The host running the tests is neither Android nor iOS.
    test('interruption callbacks are refused where the platform reports '
        'none', () async {
      await expectLater(
        controller.handleCallInterruptionCallbacks(),
        throwsA(isA<UnimplementedError>()),
      );
    });

    group('with interruptions reported', () {
      late _FakePlatformEvents events;
      late rtc.WebRtcPlatformEvents original;

      setUp(() {
        original = controller.platformEvents;
        events = _FakePlatformEvents();
        controller.platformEvents = events;
      });

      tearDown(() async {
        controller.platformEvents = original;
        await events.interruptions.close();
      });

      test('the callbacks run on start and end', () async {
        final calls = <String>[];
        await controller.handleCallInterruptionCallbacks(
          onInterruptionStart: () => calls.add('start'),
          onInterruptionEnd: () => calls.add('end'),
          androidInterruptionSource:
              rtc.AndroidInterruptionSource.telephonyOnly,
        );

        events.interruptions
          ..add(rtc.AudioInterruption.started)
          ..add(rtc.AudioInterruption.ended);
        await pumpEventQueue();

        expect(events.enabledWith, [
          rtc.AndroidInterruptionSource.telephonyOnly,
        ]);
        expect(calls, ['start', 'end']);
      });

      test('a second call replaces the callbacks of the first', () async {
        final calls = <String>[];
        await controller.handleCallInterruptionCallbacks(
          onInterruptionStart: () => calls.add('first'),
        );
        await controller.handleCallInterruptionCallbacks(
          onInterruptionStart: () => calls.add('second'),
        );

        events.interruptions.add(rtc.AudioInterruption.started);
        await pumpEventQueue();

        expect(calls, ['second']);
      });

      test('of two overlapping calls, the last one wins', () async {
        final calls = <String>[];
        await Future.wait([
          controller.handleCallInterruptionCallbacks(
            onInterruptionStart: () => calls.add('first'),
          ),
          controller.handleCallInterruptionCallbacks(
            onInterruptionStart: () => calls.add('second'),
          ),
        ]);

        events.interruptions.add(rtc.AudioInterruption.started);
        await pumpEventQueue();

        expect(calls, ['second']);
      });
    });
  });

  group('reinitializeAudioConfiguration', () {
    test('refreshes the implicit factory without the Apple '
        'configuration', () async {
      const policy = AudioConfigurationPolicy.viewer();
      await controller.reinitializeAudioConfiguration(policy);

      expect(initializeOptions, {
        'bypassVoiceProcessing': true,
        'androidAudioConfiguration': policy.getAndroidConfiguration().toMap(),
      });
    });
  });
}

// ignore: subtype_of_sealed_class, a fake for the tests
class _FakePlatformEvents implements rtc.WebRtcPlatformEvents {
  // Closed in the tests' tearDown.
  // ignore: close_sinks
  final interruptions = StreamController<rtc.AudioInterruption>.broadcast();
  final enabledWith = <rtc.AndroidInterruptionSource>[];

  @override
  Stream<rtc.AudioInterruption> get onInterruption => interruptions.stream;

  @override
  Future<void> enableInterruptionEvents({
    rtc.AndroidInterruptionSource androidInterruptionSource =
        rtc.AndroidInterruptionSource.audioFocusAndTelephony,
  }) async {
    enabledWith.add(androidInterruptionSource);
  }

  @override
  Stream<rtc.AudioRoute> get onAudioRouteChanged => const Stream.empty();

  @override
  Stream<rtc.SpeechActivity> get onSpeechActivity => const Stream.empty();

  @override
  Stream<rtc.AudioProcessingState> get onAudioProcessingStateChanged =>
      const Stream.empty();

  @override
  Stream<void> get onScreenSharingStarted => const Stream.empty();

  @override
  Stream<rtc.ScreenSharingStopped> get onScreenSharingStopped =>
      const Stream.empty();
}
