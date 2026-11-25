// ignore_for_file: invalid_use_of_visible_for_testing_member, implementation_imports

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/src/native/native_webrtc_capabilities.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_utils/test_wrapper.dart';

class _MockCall extends Mock implements Call {}

const _webrtcChannel = MethodChannel('FlutterWebRTC.Method');

void main() {
  const icons = StreamIcons();

  TestWidgetsFlutterBinding.ensureInitialized();

  late PlatformAudioController controller;
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
    rtc.debugWebRtcCapabilitiesOverride = _capabilities(pauseSupported: true);
    webrtcCalls.clear();
    nativeCalls.clear();
    pauseGate = null;
    pauseError = null;
    final audio = _FakeAudio(
      onSetPlayoutPaused: (paused) async {
        if (!paused) {
          nativeCalls.add('resume');
          return;
        }
        nativeCalls.add('pause');
        await pauseGate?.future;
        if (pauseError case final error?) throw error;
      },
      onCall: webrtcCalls.add,
    );
    controller = PlatformAudioController.instance =
        PlatformAudioController.withEngine(_FakeEngine(audio));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_webrtcChannel, (call) async {
          webrtcCalls.add(call.method);
          return null;
        });
  });

  tearDown(() async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    rtc.debugWebRtcCapabilitiesOverride = _capabilities(pauseSupported: true);
    pauseGate = null;
    pauseError = null;
    if (controller.isAudioPlayoutPaused) await controller.resumeAudioPlayout();
    PlatformAudioController.instance = null;
    CurrentPlatform.debugCurrentPlatformOverride = null;
    rtc.debugWebRtcCapabilitiesOverride = null;
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
    expect(controller.isAudioPlayoutPaused, isFalse);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(controller.isAudioPlayoutPaused, isTrue);
    expect(find.byIcon(icons.mute), findsOneWidget);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(controller.isAudioPlayoutPaused, isFalse);
    expect(find.byIcon(icons.audio), findsOneWidget);

    verifyNever(() => call.setAudioOutputDevice(any()));
    expect(webrtcCalls, isNot(contains('selectAudioOutput')));
  });

  testWidgets('reflects playout paused elsewhere in the app', (tester) async {
    await pumpOption(tester);

    await controller.pauseAudioPlayout();
    await settle(tester);
    expect(find.byIcon(icons.mute), findsOneWidget);

    await controller.resumeAudioPlayout();
    await settle(tester);
    expect(find.byIcon(icons.audio), findsOneWidget);
  });

  testWidgets('unmutes the playout it muted when removed from the tree', (
    tester,
  ) async {
    await pumpOption(tester);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);
    expect(controller.isAudioPlayoutPaused, isTrue);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);

    expect(controller.isAudioPlayoutPaused, isFalse);
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
    expect(controller.isAudioPlayoutPaused, isFalse);
  });

  testWidgets('leaves playout paused by someone else alone on dispose', (
    tester,
  ) async {
    await pumpOption(tester);

    await controller.pauseAudioPlayout();
    await settle(tester);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);

    expect(controller.isAudioPlayoutPaused, isTrue);
  });

  testWidgets(
    'leaves a later pause from elsewhere alone once its own was resumed',
    (tester) async {
      await pumpOption(tester);

      await tester.tap(find.byType(StreamButton));
      await settle(tester);

      await controller.resumeAudioPlayout();
      await settle(tester);
      await controller.pauseAudioPlayout();
      await settle(tester);

      await tester.pumpWidget(const SizedBox());
      await settle(tester);

      expect(controller.isAudioPlayoutPaused, isTrue);
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
    expect(controller.isAudioPlayoutPaused, isTrue);
    expect(find.byIcon(icons.mute), findsOneWidget);
  });

  testWidgets('a failed pause can be retried', (tester) async {
    pauseError = Exception('pause failed');
    await pumpOption(tester);

    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(controller.isAudioPlayoutPaused, isFalse);
    expect(find.byIcon(icons.audio), findsOneWidget);

    pauseError = null;
    await tester.tap(find.byType(StreamButton));
    await settle(tester);

    expect(nativeCalls, ['pause', 'pause']);
    expect(controller.isAudioPlayoutPaused, isTrue);
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
    setUp(() {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.linux;
      rtc.debugWebRtcCapabilitiesOverride = _capabilities(
        pauseSupported: false,
      );
    });

    testWidgets('the button is not shown', (tester) async {
      await pumpOption(tester);

      expect(find.byType(StreamButton), findsNothing);
    });

    test('pausing playout does not report it paused', () async {
      await controller.pauseAudioPlayout();

      expect(controller.isAudioPlayoutPaused, isFalse);
    });
  });
}

/// Android's capabilities, with audio playout pause as given.
rtc.WebRtcCapabilities _capabilities({required bool pauseSupported}) {
  return nativeWebRtcCapabilitiesFor(
    isAndroid: true,
    isIOS: false,
    isMacOS: false,
    isWindows: false,
    isLinux: false,
  ).copyWith(supportsAudioPlayoutPause: pauseSupported);
}

// ignore: subtype_of_sealed_class, a fake for the tests
/// The plugin's engine with the audio of [_FakeAudio].
class _FakeEngine extends Fake implements rtc.WebRtcEngine {
  _FakeEngine(this._audio);

  final rtc.WebRtcAudio _audio;
  final _native = rtc.NativeWebRtcEngine();

  @override
  rtc.WebRtcAudio get audio => _audio;

  @override
  rtc.WebRtcCapabilities get capabilities => _native.capabilities;

  @override
  rtc.WebRtcPlatformEvents get events => _native.events;
}

/// Pauses playout through [onSetPlayoutPaused] and reports every other call
/// to [onCall] by name.
// ignore: subtype_of_sealed_class, a fake for the tests
class _FakeAudio extends Fake implements rtc.WebRtcAudio {
  _FakeAudio({required this.onSetPlayoutPaused, required this.onCall});

  final Future<void> Function(bool paused) onSetPlayoutPaused;
  final void Function(String method) onCall;

  @override
  Future<void> setPlayoutPaused(bool paused) => onSetPlayoutPaused(paused);

  @override
  Future<void> selectAudioOutput(String deviceId) async {
    onCall('selectAudioOutput');
  }
}
