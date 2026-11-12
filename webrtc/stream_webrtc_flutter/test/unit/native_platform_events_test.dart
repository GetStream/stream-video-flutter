@TestOn('vm')
library;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/src/native/native_platform_events.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const methods = MethodChannel('FlutterWebRTC.Method');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final methodCalls = <MethodCall>[];

  setUpAll(() {
    messenger.setMockMethodCallHandler(methods, (call) async {
      methodCalls.add(call);
      return null;
    });
  });

  tearDownAll(() {
    messenger.setMockMethodCallHandler(methods, null);
  });

  setUp(methodCalls.clear);

  /// Sends [event] with [payload] the way the native side posts it.
  Future<void> emit(String event, [Map<String, Object?> payload = const {}]) {
    return messenger.handlePlatformMessage(
      'FlutterWebRTC.Event',
      const StandardMethodCodec().encodeSuccessEnvelope({
        'event': event,
        ...payload,
      }),
      (_) {},
    );
  }

  /// The first value [stream] emits once [event] is sent.
  Future<T> firstAfter<T>(
    Stream<T> stream,
    String event, [
    Map<String, Object?> payload = const {},
  ]) async {
    final first = stream.first;
    await emit(event, payload);
    return first.timeout(const Duration(seconds: 1));
  }

  final events = platformEvents;

  test('the native implementation is the platform events', () {
    expect(events, same(NativeWebRtcPlatformEvents.instance));
  });

  group('onAudioRouteChanged', () {
    test('carries the route of onAudioRouteChange', () async {
      final route = await firstAfter(
        events.onAudioRouteChanged,
        'onAudioRouteChange',
        {'deviceId': 'speaker-uid', 'label': 'Speaker', 'groupId': 'Speaker'},
      );

      expect(
        route,
        const AudioRoute(
          deviceId: 'speaker-uid',
          label: 'Speaker',
          groupId: 'Speaker',
        ),
      );
    });

    test('names a route without a label by its device id', () async {
      final route = await firstAfter(
        events.onAudioRouteChanged,
        'onAudioRouteChange',
        {'deviceId': 'speaker-uid'},
      );

      expect(route.label, 'speaker-uid');
      expect(route.groupId, isNull);
    });
  });

  group('onSpeechActivity', () {
    test('maps the started and ended types', () async {
      final activities = <SpeechActivity>[];
      final subscription = events.onSpeechActivity.listen(activities.add);

      await emit('onSpeechActivityChanged', {'type': 'started'});
      await emit('onSpeechActivityChanged', {'type': 'unknown'});
      await emit('onSpeechActivityChanged', {'type': 'ended'});
      await pumpEventQueue();
      await subscription.cancel();

      expect(activities, [SpeechActivity.started, SpeechActivity.ended]);
    });
  });

  group('onAudioProcessingStateChanged', () {
    test('carries the four flags', () async {
      final state = await firstAfter(
        events.onAudioProcessingStateChanged,
        'onAudioProcessingStateChanged',
        {
          'stereoPlayoutEnabled': true,
          'voiceProcessingEnabled': false,
          'voiceProcessingBypassed': true,
          'voiceProcessingAGCEnabled': false,
        },
      );

      expect(
        state,
        const AudioProcessingState(
          stereoPlayoutEnabled: true,
          voiceProcessingEnabled: false,
          voiceProcessingBypassed: true,
          voiceProcessingAGCEnabled: false,
        ),
      );
    });

    test('reads a missing flag as false', () async {
      final state = await firstAfter(
        events.onAudioProcessingStateChanged,
        'onAudioProcessingStateChanged',
        {'stereoPlayoutEnabled': true},
      );

      expect(state.stereoPlayoutEnabled, isTrue);
      expect(state.voiceProcessingEnabled, isFalse);
      expect(state.voiceProcessingBypassed, isFalse);
      expect(state.voiceProcessingAGCEnabled, isFalse);
    });
  });

  group('screen sharing', () {
    test('onScreenSharingStarted emits on screenSharingStarted', () async {
      await expectLater(
        firstAfter(events.onScreenSharingStarted, 'screenSharingStarted'),
        completes,
      );
    });

    test('onScreenSharingStopped carries the track id', () async {
      final stopped = await firstAfter(
        events.onScreenSharingStopped,
        'screenSharingStopped',
        {'trackId': 'track-1'},
      );

      expect(stopped, const ScreenSharingStopped(trackId: 'track-1'));
    });

    test('onScreenSharingStopped without a track id', () async {
      final stopped = await firstAfter(
        events.onScreenSharingStopped,
        'screenSharingStopped',
      );

      expect(stopped.trackId, isNull);
    });
  });

  group('onInterruption', () {
    test('maps the start and end events', () async {
      final interruptions = <AudioInterruption>[];
      final subscription = events.onInterruption.listen(interruptions.add);

      await emit('onInterruptionStart');
      await emit('onDeviceChange');
      await emit('onInterruptionEnd');
      await pumpEventQueue();
      await subscription.cancel();

      expect(interruptions, [
        AudioInterruption.started,
        AudioInterruption.ended,
      ]);
    });
  });

  test('an event of another name reaches none of the streams', () async {
    final received = <Object?>[];
    final subscriptions = [
      events.onAudioRouteChanged.listen(received.add),
      events.onSpeechActivity.listen(received.add),
      events.onAudioProcessingStateChanged.listen(received.add),
      events.onScreenSharingStarted.listen((_) => received.add('started')),
      events.onScreenSharingStopped.listen(received.add),
      events.onInterruption.listen(received.add),
    ];

    await emit('onDeviceChange');
    await pumpEventQueue();
    for (final subscription in subscriptions) {
      await subscription.cancel();
    }

    expect(received, isEmpty);
  });

  group('enableInterruptionEvents', () {
    // The host running the tests is neither Android nor iOS.
    test('throws on platforms without interruptions', () {
      expect(
        events.enableInterruptionEvents(),
        throwsA(isA<UnimplementedError>()),
      );
      expect(methodCalls, isEmpty);
    });
  });
}
