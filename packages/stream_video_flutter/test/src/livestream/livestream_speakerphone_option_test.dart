import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

class _MockCall extends Mock implements Call {}

const _webrtcChannel = MethodChannel('FlutterWebRTC.Method');

void main() {
  const icons = StreamIcons();

  TestWidgetsFlutterBinding.ensureInitialized();

  final notifier = RtcMediaDeviceNotifier.instance;
  final originalNativePause = notifier.nativePauseAudioPlayout;
  final originalNativeResume = notifier.nativeResumeAudioPlayout;
  final webrtcCalls = <String>[];

  /// Every native pause and resume, in order.
  final nativeCalls = <String>[];

  /// When set, the native pause does not complete until this does.
  Completer<void>? pauseGate;

  /// When set, the native pause throws it.
  Exception? pauseError;

  setUpAll(() {
    registerFallbackValue(
      const RtcMediaDevice(
        id: 'speaker',
        kind: RtcMediaDeviceKind.audioOutput,
        label: 'Speaker',
      ),
    );
  });

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    webrtcCalls.clear();
    nativeCalls.clear();
    pauseGate = null;
    pauseError = null;
    notifier
      ..nativePauseAudioPlayout = () async {
        nativeCalls.add('pause');
        await pauseGate?.future;
        if (pauseError case final error?) throw error;
      }
      ..nativeResumeAudioPlayout = () async => nativeCalls.add('resume');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_webrtcChannel, (call) async {
          webrtcCalls.add(call.method);
          return null;
        });
  });

  tearDown(() async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    pauseGate = null;
    pauseError = null;
    if (notifier.isAudioPlayoutPaused) await notifier.resumeAudioPlayout();
    notifier
      ..nativePauseAudioPlayout = originalNativePause
      ..nativeResumeAudioPlayout = originalNativeResume;
    CurrentPlatform.debugCurrentPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_webrtcChannel, null);
  });

  Future<_MockCall> pumpOption(WidgetTester tester) async {
    final call = _MockCall();
    await tester.pumpWidget(
      TestWrapper(child: LivestreamSpeakerphoneOption(call: call)),
    );
    return call;
  }

  // A playout state change reaches the widget asynchronously, so one pump
  // delivers it and the next builds the frame.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
  }

  testWidgets('mutes and unmutes playback without touching the output route', (
    tester,
  ) async {
    final call = await pumpOption(tester);

    expect(find.byIcon(icons.audio), findsOneWidget);
    expect(notifier.isAudioPlayoutPaused, isFalse);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isTrue);
    expect(find.byIcon(icons.mute), findsOneWidget);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isFalse);
    expect(find.byIcon(icons.audio), findsOneWidget);

    verifyNever(() => call.setAudioOutputDevice(any()));
    expect(webrtcCalls, isNot(contains('selectAudioOutput')));
  });

  testWidgets('reflects playout paused elsewhere in the app', (tester) async {
    await pumpOption(tester);

    await notifier.pauseAudioPlayout();
    await settle(tester);
    expect(find.byIcon(icons.mute), findsOneWidget);

    await notifier.resumeAudioPlayout();
    await settle(tester);
    expect(find.byIcon(icons.audio), findsOneWidget);
  });

  testWidgets('unmutes the playout it muted when removed from the tree', (
    tester,
  ) async {
    await pumpOption(tester);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);
    expect(notifier.isAudioPlayoutPaused, isTrue);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isFalse);
  });

  testWidgets('unmutes when removed while its pause is still in flight', (
    tester,
  ) async {
    pauseGate = Completer<void>();
    await pumpOption(tester);

    await tester.tap(find.byType(StreamButton));
    await tester.pumpWidget(const SizedBox());
    expect(nativeCalls, ['pause']);

    pauseGate!.complete();
    await settle(tester);

    expect(nativeCalls, ['pause', 'resume']);
    expect(notifier.isAudioPlayoutPaused, isFalse);
  });

  testWidgets('leaves playout paused by someone else alone on dispose', (
    tester,
  ) async {
    await pumpOption(tester);

    await notifier.pauseAudioPlayout();
    await settle(tester);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isTrue);
  });

  testWidgets(
    'leaves a later pause from elsewhere alone once its own was resumed',
    (tester) async {
      await pumpOption(tester);

      await tester.tap(find.byType(StreamButton));
      await settle(tester);

      await notifier.resumeAudioPlayout();
      await settle(tester);
      await notifier.pauseAudioPlayout();
      await settle(tester);

      await tester.pumpWidget(const SizedBox());
      await settle(tester);

      expect(notifier.isAudioPlayoutPaused, isTrue);
    },
  );

  testWidgets('ignores taps while a pause is in flight', (tester) async {
    pauseGate = Completer<void>();
    await pumpOption(tester);

    await tester.tap(find.byType(StreamButton));
    await tester.pump();
    await tester.tap(find.byType(StreamButton));
    await tester.pump();

    pauseGate!.complete();
    await settle(tester);

    expect(nativeCalls, ['pause']);
    expect(notifier.isAudioPlayoutPaused, isTrue);
    expect(find.byIcon(icons.mute), findsOneWidget);
  });

  testWidgets('a failed pause can be retried', (tester) async {
    pauseError = Exception('pause failed');
    await pumpOption(tester);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isFalse);
    expect(find.byIcon(icons.audio), findsOneWidget);

    pauseError = null;
    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(nativeCalls, ['pause', 'pause']);
    expect(notifier.isAudioPlayoutPaused, isTrue);
    expect(find.byIcon(icons.mute), findsOneWidget);
  });

  testWidgets('does not resume on dispose after its pause failed', (
    tester,
  ) async {
    pauseError = Exception('pause failed');
    await pumpOption(tester);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
    await settle(tester);

    expect(nativeCalls, ['pause']);
  });

  group('where pausing playout is not supported', () {
    setUp(
      () => CurrentPlatform.debugCurrentPlatformOverride = PlatformType.linux,
    );

    testWidgets('the button is not shown', (tester) async {
      await pumpOption(tester);

      expect(find.byType(StreamButton), findsNothing);
    });

    test('pausing playout does not report it paused', () async {
      await notifier.pauseAudioPlayout();

      expect(notifier.isAudioPlayoutPaused, isFalse);
    });
  });
}
