import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  @override
  bool enabled = true;
}

/// Notifier whose audio interruptions are driven by the test.
class _InterruptionNotifier extends MockRtcMediaDeviceNotifier {
  // Closed by the test's tearDown, which the lint can't see from here.
  // ignore: close_sinks
  final interruptions = StreamController<bool>.broadcast();

  @override
  Stream<bool> get audioInterruptions => interruptions.stream;
}

/// Pins how a call's microphone follows the platform's interruptions of its
/// audio with [AudioInterruptionReaction.muteMicrophone], also together with
/// the background mute.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;
  late _InterruptionNotifier notifier;
  late RtcLocalTrack published;

  MutableStateEmitter<VideoLifecycleState?> appState() =>
      harness.streamVideo.state.appLifecycleState
          as MutableStateEmitter<VideoLifecycleState?>;

  Future<void> goTo(VideoLifecycleState state) async {
    appState().value = state;
    await pumpEventQueue();
  }

  Future<void> interrupt({required bool interrupted}) async {
    notifier.interruptions.add(interrupted);
    await pumpEventQueue();
  }

  void muteAudioInBackground({required bool audio}) =>
      when(() => harness.streamVideo.options).thenReturn(
        StreamVideoOptions(
          muteAudioWhenInBackground: audio,
          networkMonitorSettings: const NetworkMonitorSettings(
            offlineCheckInterval: testReconnectSettleDelay,
          ),
        ),
      );

  void stubMicrophone(Future<Result<RtcLocalTrack>> Function() answer) => when(
    () => harness.session.setMicrophoneEnabled(
      any(),
      constraints: any(named: 'constraints'),
      stopTrackOnMute: any(named: 'stopTrackOnMute'),
    ),
  ).thenAnswer((_) => answer());

  List<bool> microphoneCalls() => verify(
    () => harness.session.setMicrophoneEnabled(
      captureAny(),
      constraints: any(named: 'constraints'),
      stopTrackOnMute: any(named: 'stopTrackOnMute'),
    ),
  ).captured.cast<bool>();

  void verifyNoMicrophone() => verifyNever(
    () => harness.session.setMicrophoneEnabled(
      any(),
      constraints: any(named: 'constraints'),
      stopTrackOnMute: any(named: 'stopTrackOnMute'),
    ),
  );

  setUp(() {
    harness = ConnectionHarness();
    notifier = _InterruptionNotifier();
    // `Call.join` enumerates devices while applying the call settings.
    when(
      () => notifier.enumerateDevicesFor(any()),
    ).thenAnswer((_) async => const Result.success([]));
    for (final permission in CallPermission.values) {
      when(
        () => harness.permissionsManager.hasPermission(permission),
      ).thenReturn(true);
    }
    muteAudioInBackground(audio: false);
    final track = MockRtcLocalTrack();
    when(() => track.mediaTrack).thenReturn(_FakeMediaStreamTrack());
    published = track;
    stubMicrophone(() async => Result.success(published));
  });

  tearDown(() async {
    await harness.dispose();
    await notifier.interruptions.close();
  });

  /// Joins an active call with the microphone on.
  Future<Call> activeCall({
    AudioInterruptionReaction reaction =
        AudioInterruptionReaction.muteMicrophone,
  }) async {
    final call = harness.buildCall(
      preferences: DefaultCallPreferences(audioInterruptionReaction: reaction),
      rtcMediaDeviceNotifier: notifier,
    );
    await call.join();
    harness.stateManager.state = harness.stateManager.callState.copyWith(
      callParticipants: [
        CallParticipantState(
          userId: harness.stateManager.callState.currentUserId,
          roles: const [],
          name: 'me',
          custom: const {},
          sessionId: 'session-0',
          trackIdPrefix: 'me',
          isLocal: true,
        ),
      ],
    );
    await call.setMicrophoneEnabled(enabled: true);
    (harness.streamVideo.state.activeCalls as MutableStateEmitter<List<Call>>)
        .value = [
      call,
    ];
    clearInteractions(harness.session);
    return call;
  }

  bool microphoneOn(Call call) =>
      call.state.value.localParticipant?.isAudioEnabled ?? false;

  test(
    'turns the microphone off for an interruption and back on after',
    () async {
      final call = await activeCall();

      await interrupt(interrupted: true);
      expect(call.state.value.isAudioInterrupted, isTrue);
      expect(microphoneOn(call), isFalse);

      await interrupt(interrupted: false);
      expect(call.state.value.isAudioInterrupted, isFalse);
      expect(microphoneOn(call), isTrue);
      expect(microphoneCalls(), [false, true]);
    },
  );

  test('changes nothing without the reaction', () async {
    final call = await activeCall(reaction: AudioInterruptionReaction.none);

    await interrupt(interrupted: true);
    expect(call.state.value.isAudioInterrupted, isTrue);
    await interrupt(interrupted: false);

    verifyNoMicrophone();
  });

  test('does not turn the microphone back on after the app set it', () async {
    final call = await activeCall();
    await interrupt(interrupted: true);

    await call.setMicrophoneEnabled(enabled: false);
    clearInteractions(harness.session);
    await interrupt(interrupted: false);

    verifyNoMicrophone();
  });

  test('handles quick interruptions in order', () async {
    final call = await activeCall();
    final mute = Completer<Result<RtcLocalTrack>>();
    stubMicrophone(() => mute.future);

    notifier.interruptions
      ..add(true)
      ..add(false)
      ..add(true);
    await pumpEventQueue();
    stubMicrophone(() async => Result.success(published));
    mute.complete(Result.success(published));
    await pumpEventQueue();

    expect(call.state.value.isAudioInterrupted, isTrue);
    expect(microphoneOn(call), isFalse);
    expect(microphoneCalls(), [false, true, false]);
  });

  test('an interruption that ends in the background turns the microphone on '
      'only when the app comes back', () async {
    muteAudioInBackground(audio: true);
    final call = await activeCall();

    await interrupt(interrupted: true);
    await goTo(VideoLifecycleState.paused);
    await interrupt(interrupted: false);
    expect(microphoneOn(call), isFalse);

    await goTo(VideoLifecycleState.resumed);
    expect(microphoneOn(call), isTrue);
    expect(microphoneCalls(), [false, true]);
  });

  test('coming back during an interruption keeps the microphone off until it '
      'ends', () async {
    muteAudioInBackground(audio: true);
    final call = await activeCall();

    await goTo(VideoLifecycleState.paused);
    await interrupt(interrupted: true);
    await goTo(VideoLifecycleState.resumed);
    expect(microphoneOn(call), isFalse);

    await interrupt(interrupted: false);
    expect(microphoneOn(call), isTrue);
    expect(microphoneCalls(), [false, true]);
  });

  test('a microphone that cannot be turned back on is turned on by the next '
      'session', () async {
    final call = await activeCall();
    await interrupt(interrupted: true);

    stubMicrophone(() async => failureWithError('reconnecting'));
    await interrupt(interrupted: false);

    expect(call.connectOptions.microphone.isEnabled, isTrue);
  });
}
