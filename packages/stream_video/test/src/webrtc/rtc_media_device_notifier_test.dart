import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/webrtc/rtc_media_device/device_enumeration_trigger.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

const _camera = {
  'deviceId': '0',
  'groupId': 'camera',
  'kind': 'videoinput',
  'label': 'Camera 0, Facing back, Orientation 90',
};

const _sources = [
  _camera,
  {
    'deviceId': 'microphone-1',
    'groupId': 'microphone',
    'kind': 'audioinput',
    'label': 'Built-in microphone',
  },
  {
    'deviceId': 'speaker',
    'groupId': 'speaker',
    'kind': 'audiooutput',
    'label': 'Speakerphone',
  },
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('FlutterWebRTC.Method');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  var getSourcesCalls = 0;
  Map<Object?, Object?>? initializeOptions;
  var sources = _sources;
  Completer<void>? getSourcesGate;

  late RtcMediaDeviceNotifier notifier;

  setUpAll(() async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'initialize':
          initializeOptions =
              (call.arguments as Map)['options'] as Map<Object?, Object?>;
          return null;
        case 'getSources':
          getSourcesCalls++;
          await getSourcesGate?.future;
          return {'sources': sources};
        default:
          return null;
      }
    });

    notifier = RtcMediaDeviceNotifier.instance;
    // Let the enumeration started by the constructor finish.
    await notifier.onDeviceChange.first;
  });

  tearDownAll(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  setUp(() {
    getSourcesCalls = 0;
    getSourcesGate = null;
    sources = _sources;
    // Drop the traces of earlier tests.
    notifier.getTrace();
  });

  void fireDeviceChange() {
    rtc.navigator.mediaDevices.ondevicechange?.call(null);
  }

  /// The data of every enumeration-trigger trace recorded since the last call.
  List<Object?> takeTriggerTraces() {
    return notifier
        .getTrace()
        .snapshot
        .where((record) => record.tag == TraceTag.enumerateDevicesTrigger)
        .map((record) => record.data)
        .toList();
  }

  group('device-change events', () {
    const debounce = RtcMediaDeviceNotifier.deviceChangeDebounce;

    test('a burst enumerates once, after the debounce', () {
      fakeAsync((async) {
        for (var i = 0; i < 5; i++) {
          fireDeviceChange();
          async.elapse(debounce ~/ 5);
        }

        // The last event restarted the debounce.
        expect(getSourcesCalls, 0);

        async.elapse(debounce);
        expect(getSourcesCalls, 1);
      });
    });

    test('events further apart than the debounce each enumerate', () {
      fakeAsync((async) {
        fireDeviceChange();
        async.elapse(debounce);
        fireDeviceChange();
        async.elapse(debounce);

        expect(getSourcesCalls, 2);
      });
    });

    test('an event during an enumeration reads the devices again', () {
      fakeAsync((async) {
        getSourcesGate = Completer<void>();

        notifier.enumerateDevices();
        async.flushMicrotasks();
        fireDeviceChange();

        // The debounced enumeration waits for the running one.
        async.elapse(debounce);
        expect(getSourcesCalls, 1);

        getSourcesGate!.complete();
        async.flushMicrotasks();

        expect(getSourcesCalls, 2);
      });
    });
  });

  test('concurrent calls share one platform enumeration', () async {
    getSourcesGate = Completer<void>();

    final results = [
      notifier.enumerateDevices(),
      notifier.audioOutputs(),
      notifier.videoInputs(),
    ];
    getSourcesGate!.complete();

    final [all, audioOutputs, videoInputs] = await Future.wait(results);

    expect(getSourcesCalls, 1);
    expect(all.getDataOrNull(), hasLength(3));
    expect(audioOutputs.getDataOrNull()?.map((d) => d.id), ['speaker']);
    expect(videoInputs.getDataOrNull()?.map((d) => d.id), ['0']);
  });

  test(
    'callers get their own list and listeners an unmodifiable one',
    () async {
      getSourcesGate = Completer<void>();

      final first = notifier.enumerateDevices();
      final second = notifier.enumerateDevices();
      getSourcesGate!.complete();

      final firstDevices = (await first).getDataOrNull()!;
      final secondDevices = (await second).getDataOrNull()!;
      firstDevices.removeLast();

      expect(secondDevices, hasLength(3));

      final emitted = await notifier.onDeviceChange.first;
      expect(emitted, hasLength(3));
      expect(emitted.clear, throwsUnsupportedError);
    },
  );

  test('sequential calls each enumerate', () async {
    await notifier.enumerateDevices();
    await notifier.enumerateDevices();

    expect(getSourcesCalls, 2);
  });

  group('errors', () {
    test('an empty device list fails with a message for each call', () async {
      sources = [];

      final all = await notifier.enumerateDevices();
      final audioOutputs = await notifier.audioOutputs();

      expect((all as Failure).videoError.message, 'No devices found');
      expect(
        (audioOutputs as Failure).videoError.message,
        'No devices found for kind: ${RtcMediaDeviceKind.audioOutput}',
      );
    });

    test('a kind with no devices fails while the full list succeeds', () async {
      sources = [_camera];

      final all = await notifier.enumerateDevices();
      final audioOutputs = await notifier.audioOutputs();

      expect(all.getDataOrNull()?.map((d) => d.id), ['0']);
      expect(
        (audioOutputs as Failure).videoError.message,
        'No devices found for kind: ${RtcMediaDeviceKind.audioOutput}',
      );
    });
  });

  group('trace', () {
    test('records the trigger of each call', () async {
      await notifier.enumerateDevices();
      await notifier.enumerateDevicesFor(DeviceEnumerationTrigger.flipCamera);

      expect(takeTriggerTraces(), [
        {'trigger': 'explicit', 'coalesced': false},
        {'trigger': 'flipCamera', 'coalesced': false},
      ]);
    });

    test('marks calls that joined a running enumeration', () async {
      getSourcesGate = Completer<void>();

      final first = notifier.enumerateDevicesFor(
        DeviceEnumerationTrigger.callSettings,
      );
      final second = notifier.audioOutputs();
      getSourcesGate!.complete();
      await Future.wait([first, second]);

      expect(takeTriggerTraces(), [
        {'trigger': 'callSettings', 'coalesced': false},
        {'trigger': 'explicit', 'coalesced': true},
      ]);
    });

    test('records device-change enumerations', () {
      fakeAsync((async) {
        fireDeviceChange();
        async.elapse(RtcMediaDeviceNotifier.deviceChangeDebounce);

        expect(takeTriggerTraces(), [
          {'trigger': 'deviceChange', 'coalesced': false},
        ]);
      });
    });

    test('records each enumeration result once', () async {
      getSourcesGate = Completer<void>();

      final first = notifier.enumerateDevices();
      final second = notifier.enumerateDevices();
      getSourcesGate!.complete();
      await Future.wait([first, second]);

      final results = notifier.getTrace().snapshot.where(
        (record) => record.tag == TraceTag.enumerateDevices,
      );
      expect(results, hasLength(1));
    });
  });

  group('audio playout pause', () {
    late Future<void> Function() originalPause;
    late Future<void> Function() originalResume;
    final nativeCalls = <String>[];
    Exception? pauseError;

    setUp(() {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      nativeCalls.clear();
      pauseError = null;
      originalPause = notifier.nativePauseAudioPlayout;
      originalResume = notifier.nativeResumeAudioPlayout;
      notifier
        ..nativePauseAudioPlayout = () async {
          nativeCalls.add('pause');
          if (pauseError case final error?) throw error;
        }
        ..nativeResumeAudioPlayout = () async => nativeCalls.add('resume');
    });

    tearDown(() async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      pauseError = null;
      if (notifier.isAudioPlayoutPaused) await notifier.resumeAudioPlayout();
      notifier
        ..nativePauseAudioPlayout = originalPause
        ..nativeResumeAudioPlayout = originalResume;
      CurrentPlatform.debugCurrentPlatformOverride = null;
    });

    test('starts unpaused and emits only when the state changes', () async {
      expect(notifier.isAudioPlayoutPaused, isFalse);

      final emitted = <bool>[];
      final subscription = notifier.audioPlayoutPausedChanges.listen(
        emitted.add,
      );

      await notifier.pauseAudioPlayout();
      await notifier.pauseAudioPlayout();
      expect(notifier.isAudioPlayoutPaused, isTrue);

      await notifier.resumeAudioPlayout();
      await notifier.resumeAudioPlayout();
      expect(notifier.isAudioPlayoutPaused, isFalse);

      await subscription.cancel();
      expect(emitted, [false, true, false]);
      expect(nativeCalls, ['pause', 'pause', 'resume', 'resume']);
    });

    for (final platform in [PlatformType.windows, PlatformType.linux]) {
      test('does nothing on ${platform.name}', () async {
        CurrentPlatform.debugCurrentPlatformOverride = platform;

        expect(notifier.isAudioPlayoutPauseSupported, isFalse);
        await notifier.pauseAudioPlayout();

        expect(notifier.isAudioPlayoutPaused, isFalse);
        expect(nativeCalls, isEmpty);
      });
    }

    test('a pause that throws leaves the state unchanged', () async {
      final error = Exception('pause failed');
      pauseError = error;

      await expectLater(notifier.pauseAudioPlayout(), throwsA(same(error)));

      expect(notifier.isAudioPlayoutPaused, isFalse);
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
      final subscription = notifier.nativeWebRtcEventsStream().listen(
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
      final subscription = notifier.nativeWebRtcEventsStream().listen(
        events.add,
      );

      await emit('onAudioRouteChange', {'deviceId': '', 'label': 'Speaker'});
      await subscription.cancel();

      expect(events, isEmpty);
    });

    test('speech activity reaches the speech activity stream', () async {
      final events = <SpeechActivityEvent>[];
      final subscription = notifier.speechActivityStream.listen(events.add);

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

      final traces = notifier.getTrace().snapshot.where(
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
        notifier.handleCallInterruptionCallbacks(),
        throwsA(isA<UnimplementedError>()),
      );
    });

    group('with interruptions reported', () {
      late _FakePlatformEvents events;
      late rtc.WebRtcPlatformEvents original;

      setUp(() {
        original = notifier.platformEvents;
        events = _FakePlatformEvents();
        notifier.platformEvents = events;
      });

      tearDown(() async {
        notifier.platformEvents = original;
        await events.interruptions.close();
      });

      test('the callbacks run on start and end', () async {
        final calls = <String>[];
        await notifier.handleCallInterruptionCallbacks(
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
        await notifier.handleCallInterruptionCallbacks(
          onInterruptionStart: () => calls.add('first'),
        );
        await notifier.handleCallInterruptionCallbacks(
          onInterruptionStart: () => calls.add('second'),
        );

        events.interruptions.add(rtc.AudioInterruption.started);
        await pumpEventQueue();

        expect(calls, ['second']);
      });

      test('of two overlapping calls, the last one wins', () async {
        final calls = <String>[];
        await Future.wait([
          notifier.handleCallInterruptionCallbacks(
            onInterruptionStart: () => calls.add('first'),
          ),
          notifier.handleCallInterruptionCallbacks(
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
      await notifier.reinitializeAudioConfiguration(policy);

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
