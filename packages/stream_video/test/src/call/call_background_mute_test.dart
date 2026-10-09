import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/lifecycle/lifecycle_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  @override
  bool enabled = true;
}

/// Pins that an active call turns its camera and microphone off as the app
/// goes to the background, and on again as it comes back.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  MutableStateEmitter<LifecycleState?> appState() =>
      harness.streamVideo.state.appLifecycleState
          as MutableStateEmitter<LifecycleState?>;

  Future<void> goTo(LifecycleState state) async {
    appState().value = state;
    await pumpEventQueue();
  }

  setUp(() {
    harness = ConnectionHarness();
    for (final permission in CallPermission.values) {
      when(
        () => harness.permissionsManager.hasPermission(permission),
      ).thenReturn(true);
    }
    when(() => harness.streamVideo.options).thenReturn(
      StreamVideoOptions(
        muteVideoWhenInBackground: true,
        muteAudioWhenInBackground: true,
        networkMonitorSettings: const NetworkMonitorSettings(
          offlineCheckInterval: testReconnectSettleDelay,
        ),
      ),
    );
    final published = MockRtcLocalTrack();
    when(() => published.mediaTrack).thenReturn(_FakeMediaStreamTrack());
    when(
      () => harness.session.setCameraEnabled(
        any(),
        constraints: any(named: 'constraints'),
      ),
    ).thenAnswer((_) async => Result.success(published));
    when(
      () => harness.session.setMicrophoneEnabled(
        any(),
        constraints: any(named: 'constraints'),
        stopTrackOnMute: any(named: 'stopTrackOnMute'),
      ),
    ).thenAnswer((_) async => Result.success(published));
  });

  tearDown(() => harness.dispose());

  /// Joins a call with the camera and microphone on, and makes it the active
  /// call.
  Future<Call> activeCall({bool active = true}) async {
    final call = harness.buildCall();
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
    await call.setCameraEnabled(enabled: true);
    await call.setMicrophoneEnabled(enabled: true);
    if (active) {
      (harness.streamVideo.state.activeCalls as MutableStateEmitter<List<Call>>)
          .value = [
        call,
      ];
    }
    clearInteractions(harness.session);
    return call;
  }

  void verifyCamera(bool enabled, int times) => verify(
    () => harness.session.setCameraEnabled(
      enabled,
      constraints: any(named: 'constraints'),
    ),
  ).called(times);

  void verifyMicrophone(bool enabled, int times) => verify(
    () => harness.session.setMicrophoneEnabled(
      enabled,
      constraints: any(named: 'constraints'),
      stopTrackOnMute: any(named: 'stopTrackOnMute'),
    ),
  ).called(times);

  test('turns the camera and microphone off in the background, and on '
      'again after', () async {
    final call = await activeCall();
    expect(call.state.value.localParticipant?.isVideoEnabled, isTrue);

    await goTo(LifecycleState.paused);
    verifyCamera(false, 1);
    verifyMicrophone(false, 1);

    await goTo(LifecycleState.resumed);
    verifyCamera(true, 1);
    verifyMicrophone(true, 1);
  });

  test('turns on again only what it turned off', () async {
    final call = await activeCall();
    await call.setMicrophoneEnabled(enabled: false);
    clearInteractions(harness.session);

    await goTo(LifecycleState.paused);
    await goTo(LifecycleState.resumed);

    verifyCamera(false, 1);
    verifyCamera(true, 1);
    verifyNever(
      () => harness.session.setMicrophoneEnabled(
        any(),
        constraints: any(named: 'constraints'),
        stopTrackOnMute: any(named: 'stopTrackOnMute'),
      ),
    );
  });

  test('leaves a call that is not active alone', () async {
    await activeCall(active: false);

    await goTo(LifecycleState.paused);

    verifyNever(
      () => harness.session.setCameraEnabled(
        any(),
        constraints: any(named: 'constraints'),
      ),
    );
  });

  test('a call joined in the background is muted only when the app goes to '
      'the background again', () async {
    appState().value = LifecycleState.paused;
    await activeCall();

    await goTo(LifecycleState.resumed);
    verifyNever(
      () => harness.session.setCameraEnabled(
        any(),
        constraints: any(named: 'constraints'),
      ),
    );

    await goTo(LifecycleState.paused);
    verifyCamera(false, 1);
  });

  test('stops following the app once the call is left', () async {
    final call = await activeCall();
    await call.leave();
    clearInteractions(harness.session);

    await goTo(LifecycleState.paused);

    verifyNever(
      () => harness.session.setCameraEnabled(
        any(),
        constraints: any(named: 'constraints'),
      ),
    );
  });
}
