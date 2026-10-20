import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class _MockCall extends Mock implements Call {}

const _webrtcChannel = MethodChannel('FlutterWebRTC.Method');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final notifier = RtcMediaDeviceNotifier.instance;
  final webrtcCalls = <String>[];

  /// When set, `pauseAudioPlayout` does not answer until it completes.
  ///
  /// The WebRTC plugin only reaches the platform channel on Android, iOS and
  /// macOS hosts, so the gate holds the pause in flight only when the tests
  /// run on macOS; elsewhere the pause completes at once and these tests check
  /// the end state only.
  Completer<void>? pauseGate;

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
    CurrentPlatform.debugPlatformOverride = PlatformType.android;
    webrtcCalls.clear();
    pauseGate = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_webrtcChannel, (call) async {
          webrtcCalls.add(call.method);
          if (call.method == 'pauseAudioPlayout') await pauseGate?.future;
          return null;
        });
  });

  tearDown(() async {
    CurrentPlatform.debugPlatformOverride = PlatformType.android;
    pauseGate = null;
    if (notifier.isAudioPlayoutPaused) await notifier.resumeAudioPlayout();
    CurrentPlatform.debugPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_webrtcChannel, null);
  });

  Future<_MockCall> pumpOption(WidgetTester tester) async {
    final call = _MockCall();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: LivestreamSpeakerphoneOption(call: call)),
      ),
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

    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    expect(notifier.isAudioPlayoutPaused, isFalse);

    await tester.tap(find.byType(IconButton));
    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isTrue);
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isFalse);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

    verifyNever(() => call.setAudioOutputDevice(any()));
    expect(webrtcCalls, isNot(contains('selectAudioOutput')));
  });

  testWidgets('reflects playout paused elsewhere in the app', (tester) async {
    await pumpOption(tester);

    await notifier.pauseAudioPlayout();
    await settle(tester);
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);

    await notifier.resumeAudioPlayout();
    await settle(tester);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
  });

  testWidgets('unmutes the playout it muted when removed from the tree', (
    tester,
  ) async {
    await pumpOption(tester);

    await tester.tap(find.byType(IconButton));
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

    await tester.tap(find.byType(IconButton));
    await tester.pumpWidget(const SizedBox());

    pauseGate!.complete();
    await settle(tester);

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

      await tester.tap(find.byType(IconButton));
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
    await pumpOption(tester);

    // Press twice in the same turn, so the second press lands while the first
    // pause is still in flight on any host, not only where the gate holds it.
    final onPressed = tester
        .widget<IconButton>(find.byType(IconButton))
        .onPressed!;
    onPressed();
    onPressed();

    await settle(tester);

    expect(notifier.isAudioPlayoutPaused, isTrue);
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
    expect(
      webrtcCalls.where((it) => it == 'pauseAudioPlayout'),
      hasLength(lessThanOrEqualTo(1)),
    );
    expect(webrtcCalls, isNot(contains('resumeAudioPlayout')));
  });

  group('where pausing playout is not supported', () {
    setUp(() => CurrentPlatform.debugPlatformOverride = PlatformType.linux);

    testWidgets('the button is not shown', (tester) async {
      await pumpOption(tester);

      expect(find.byType(IconButton), findsNothing);
    });

    test('pausing playout does not report it paused', () async {
      await notifier.pauseAudioPlayout();

      expect(notifier.isAudioPlayoutPaused, isFalse);
    });
  });
}
