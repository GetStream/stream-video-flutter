import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/media/ios_broadcast_owner.dart';
import 'package:stream_video/src/call/media/local_media_controller.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../fixtures/webrtc_capabilities.dart';
import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  @override
  bool enabled = true;

  @override
  set onEnded(void Function()? callback) {}
}

// ignore: subtype_of_sealed_class, a mock for the tests
class _BroadcastEventsController extends MockPlatformAudioController {
  // Closed by the test's tearDown, which the lint can't see from here.
  // ignore: close_sinks
  final events = StreamController<NativeWebRtcEvent>.broadcast();

  @override
  Stream<NativeWebRtcEvent> nativeWebRtcEventsStream() => events.stream;
}

MockCallSession _session() {
  final session = MockCallSession();
  final track = MockRtcLocalTrack();
  when(() => track.mediaTrack).thenReturn(_FakeMediaStreamTrack());
  when(
    () => session.setScreenShareEnabled(
      any(),
      constraints: any(named: 'constraints'),
    ),
  ).thenAnswer((_) async => Result.success(track));
  return session;
}

/// Pins how a call's connect options carry an iOS broadcast from one session
/// to the next.
void main() {
  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(const ScreenShareConstraints());
  });

  late MockCallSession? session;
  late MockRtcMediaDeviceNotifier notifier;
  late _BroadcastEventsController audio;
  late LocalMediaController controller;
  late StreamSubscription<NativeWebRtcEvent> subscription;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    overrideWebRtcCapabilities(platform: PlatformType.ios);
    IosBroadcastOwner.instance.reset();
    session = _session();
    notifier = MockRtcMediaDeviceNotifier();
    when(notifier.presentiOSBroadcastPicker).thenAnswer((_) async {});
    when(notifier.stopiOSBroadcast).thenAnswer((_) async {});
    audio = _BroadcastEventsController();
    PlatformAudioController.instance = audio;
    controller = LocalMediaController(
      stateManager: CallStateNotifier(createTestCallState()),
      session: () => session,
      sfuStatsReporter: () => null,
      hasPermission: (_) => true,
      rtcMediaDeviceNotifier: () => notifier,
      audioConfigurationPolicy: () =>
          const AudioConfigurationPolicy.broadcaster(),
      muteVideoWhenInBackground: () => false,
      muteAudioWhenInBackground: () => false,
      onMicrophoneMuted: (_) async {},
      onAudioOutputDeviceSet: (_) async {},
      defaultBroadcastTarget: () => controller,
      logger: taggedLogger(tag: 'test'),
    );
    subscription = controller.observeNativeWebRtcEvents();
  });

  tearDown(() async {
    await subscription.cancel();
    await audio.events.close();
    PlatformAudioController.instance = null;
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  Future<void> emit(NativeWebRtcEvent event) async {
    audio.events.add(event);
    await pumpEventQueue();
  }

  List<ScreenShareConstraints?> enabledOn(MockCallSession session) {
    return verify(
      () => session.setScreenShareEnabled(
        true,
        constraints: captureAny(named: 'constraints'),
      ),
    ).captured.cast<ScreenShareConstraints?>();
  }

  void verifyNotEnabledOn(MockCallSession session) => verifyNever(
    () => session.setScreenShareEnabled(
      true,
      constraints: any(named: 'constraints'),
    ),
  );

  group('a new session', () {
    test('captures the running broadcast again, without the picker', () async {
      await emit(ScreenSharingStartedEvent());
      final shared = enabledOn(session!).single;
      expect(shared?.useiOSBroadcastExtension, isTrue);

      final next = session = _session();
      await controller.applyConnectOptions(session: next);

      expect(enabledOn(next), [shared]);
      verifyNever(notifier.presentiOSBroadcastPicker);
    });

    test('does not capture a broadcast that stopped', () async {
      await emit(ScreenSharingStartedEvent());
      await emit(ScreenSharingStoppedEvent());

      final next = session = _session();
      await controller.applyConnectOptions(session: next);

      verifyNotEnabledOn(next);
      verifyNever(notifier.presentiOSBroadcastPicker);
    });
  });
}
