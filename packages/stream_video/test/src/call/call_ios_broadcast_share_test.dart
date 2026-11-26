import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/media/ios_broadcast_screen_share.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../fixtures/webrtc_capabilities.dart';
import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  @override
  bool enabled = true;

  @override
  String? get id => 'screen-share';

  @override
  set onEnded(void Function()? callback) {}
}

/// Audio controller whose screen share events are driven by the test.
// ignore: subtype_of_sealed_class, a mock for the tests
class _BroadcastEventsController extends MockPlatformAudioController {
  // Closed by the test's tearDown, which the lint can't see from here.
  // ignore: close_sinks
  final events = StreamController<NativeWebRtcEvent>.broadcast();

  @override
  Stream<NativeWebRtcEvent> nativeWebRtcEventsStream() => events.stream;
}

const _requested = ScreenShareConstraints(
  useiOSBroadcastExtension: true,
  params: RtcVideoParametersPresets.h720_16x9,
);

/// Matches the broadcast constraints [call] shares without a request: the
/// broadcast extension at the call's screen share resolution.
Matcher _isDefaultBroadcast(Call call) => isA<ScreenShareConstraints>()
    .having((c) => c.useiOSBroadcastExtension, 'useiOSBroadcastExtension', true)
    .having((c) => c.captureScreenAudio, 'captureScreenAudio', false)
    .having((c) => c.deviceId, 'deviceId', isNull)
    .having((c) => c.maxFrameRate, 'maxFrameRate', isNull)
    .having(
      (c) => c.params,
      'params',
      call.state.value.settings.screenShare.targetResolution.toVideoParams(
        defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
      ),
    );

/// A mock RTC manager whose audio session setup succeeds.
MockRtcManager _rtcManager() {
  final manager = MockRtcManager();
  when(
    () => manager.configureAudioSession(
      policy: any(named: 'policy'),
      speakerOn: any(named: 'speakerOn'),
    ),
  ).thenAnswer((_) async => const Result.success(none));
  return manager;
}

/// Pins how a call shares the screen through the iOS broadcast extension:
/// enabling only shows the picker, and the share starts with the broadcast.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(const AudioConfigurationPolicy.broadcaster());
    registerFallbackValue(const ScreenShareConstraints());
  });

  late ConnectionHarness harness;
  late MockRtcMediaDeviceNotifier notifier;
  late _BroadcastEventsController audio;
  late MockRtcLocalTrack shared;

  Future<void> emit(NativeWebRtcEvent event) async {
    audio.events.add(event);
    await pumpEventQueue();
  }

  void stubScreenShare(Future<Result<RtcLocalTrack>> Function() answer) {
    for (final session in harness.sessions) {
      when(
        () => session.setScreenShareEnabled(
          any(),
          constraints: any(named: 'constraints'),
        ),
      ).thenAnswer((_) => answer());
    }
  }

  List<(bool, ScreenShareConstraints?)> screenShareCalls() {
    final captured = verify(
      () => harness.session.setScreenShareEnabled(
        captureAny(),
        constraints: captureAny(named: 'constraints'),
      ),
    ).captured;
    return [
      for (var i = 0; i < captured.length; i += 2)
        (captured[i] as bool, captured[i + 1] as ScreenShareConstraints?),
    ];
  }

  void verifyNoScreenShare([MockCallSession? session]) => verifyNever(
    () => (session ?? harness.session).setScreenShareEnabled(
      any(),
      constraints: any(named: 'constraints'),
    ),
  );

  /// Makes each session start apply the call's connect options, which the
  /// default session mock skips.
  void applyOptionsOnStart() {
    for (final session in harness.sessions) {
      when(
        () => session.setCameraEnabled(
          any(),
          constraints: any(named: 'constraints'),
        ),
      ).thenAnswer((_) async => failureWithError('no camera'));
      when(
        () => session.setMicrophoneEnabled(
          any(),
          constraints: any(named: 'constraints'),
        ),
      ).thenAnswer((_) async => failureWithError('no microphone'));
      when(
        () => session.start(
          reconnectDetails: any(named: 'reconnectDetails'),
          onRtcManagerCreatedCallback: any(
            named: 'onRtcManagerCreatedCallback',
          ),
          isAnonymousUser: any(named: 'isAnonymousUser'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
          clientEventRetryCount: any(named: 'clientEventRetryCount'),
        ),
      ).thenAnswer((invocation) async {
        final onCreated =
            invocation.namedArguments[#onRtcManagerCreatedCallback]
                as FutureOr<void> Function(RtcManager)?;
        await onCreated?.call(MockRtcManager());
        return Result.success((
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero,
        ));
      });
    }
  }

  MutableStateEmitter<List<Call>> activeCalls() =>
      harness.streamVideo.state.activeCalls as MutableStateEmitter<List<Call>>;

  setUp(() {
    overrideWebRtcCapabilities(platform: PlatformType.ios);
    IosBroadcastScreenShare.resetOwnership();
    // A second call that joins gets the second session.
    harness = ConnectionHarness(sessionCount: 2);
    for (final session in harness.sessions) {
      final manager = _rtcManager();
      when(() => session.rtcManager).thenReturn(manager);
    }
    final clientState = harness.streamVideo.state;
    when(() => clientState.setActiveCall(any())).thenAnswer((
      invocation,
    ) async {
      final call = invocation.positionalArguments.first as Call?;
      if (call != null) activeCalls().value = [...activeCalls().value, call];
    });
    notifier = MockRtcMediaDeviceNotifier();
    audio = _BroadcastEventsController();
    PlatformAudioController.instance = audio;
    IosBroadcastScreenShare.observeBroadcasts();
    when(
      () => notifier.enumerateDevicesFor(any()),
    ).thenAnswer((_) async => const Result.success([]));
    when(notifier.presentiOSBroadcastPicker).thenAnswer((_) async {});
    when(notifier.stopiOSBroadcast).thenAnswer((_) async {});
    for (final permission in CallPermission.values) {
      when(
        () => harness.permissionsManager.hasPermission(permission),
      ).thenReturn(true);
    }
    shared = MockRtcLocalTrack();
    when(() => shared.mediaTrack).thenReturn(_FakeMediaStreamTrack());
    stubScreenShare(() async => Result.success(shared));
  });

  tearDown(() async {
    await harness.dispose();
    PlatformAudioController.instance = null;
    await audio.events.close();
  });

  /// Joins an active call with a local participant. [clear] forgets what the
  /// join did on the session.
  Future<Call> joinedCall({bool clear = true}) async {
    final call = harness.buildCall(rtcMediaDeviceNotifier: notifier);
    // The calls share a cid, so the join of a second one would be refused
    // while the first one is active.
    final others = activeCalls().value;
    activeCalls().value = [];
    expect((await call.join()).isSuccess, isTrue);
    activeCalls().value = [...others, ...activeCalls().value];
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
    if (clear) clearInteractions(harness.session);
    return call;
  }

  bool sharing(Call call) =>
      call.state.value.localParticipant?.isScreenShareEnabled ?? false;

  /// Collects the screen share failures [call] reports from now on.
  List<StreamCallScreenShareFailedEvent> shareFailures(Call call) {
    final failures = <StreamCallScreenShareFailedEvent>[];
    call.callEvents.listen((event) {
      if (event is StreamCallScreenShareFailedEvent) failures.add(event);
    });
    return failures;
  }

  test('enabling shows the picker and shares nothing yet', () async {
    final call = await joinedCall();

    final result = await call.setScreenShareEnabled(
      enabled: true,
      constraints: _requested,
    );

    expect(result.isSuccess, isTrue);
    verify(notifier.presentiOSBroadcastPicker).called(1);
    verifyNoScreenShare();
    expect(sharing(call), isFalse);
  });

  test(
    'enabling before the join fails without showing the picker',
    () async {
      final call = harness.buildCall(rtcMediaDeviceNotifier: notifier);

      final result = await call.setScreenShareEnabled(
        enabled: true,
        constraints: _requested,
      );

      expect(result.isFailure, isTrue);
      verifyNever(notifier.presentiOSBroadcastPicker);

      // The failed enable is not a request: a later broadcast is shared with
      // the default constraints.
      await call.join();
      await emit(ScreenSharingStartedEvent());
      final calls = screenShareCalls();
      expect(calls, hasLength(1));
      expect(calls.single.$1, isTrue);
      expect(calls.single.$2, _isDefaultBroadcast(call));
    },
  );

  test('a picker that cannot be shown fails the enable', () async {
    final call = await joinedCall();
    when(notifier.presentiOSBroadcastPicker).thenThrow(
      PlatformException(code: 'BroadcastPickerError'),
    );

    final result = await call.setScreenShareEnabled(
      enabled: true,
      constraints: _requested,
    );

    expect(result.isFailure, isTrue);
    verifyNoScreenShare();
    expect(sharing(call), isFalse);
  });

  test('the start event shares with the requested constraints', () async {
    final call = await joinedCall();
    final failures = shareFailures(call);
    await call.setScreenShareEnabled(enabled: true, constraints: _requested);

    await emit(ScreenSharingStartedEvent());

    expect(screenShareCalls(), [(true, _requested)]);
    expect(sharing(call), isTrue);
    expect(failures, isEmpty);
  });

  test('a second start event does not share again', () async {
    final call = await joinedCall();
    await call.setScreenShareEnabled(enabled: true, constraints: _requested);
    await emit(ScreenSharingStartedEvent());
    when(
      () => harness.session.getTrack(any(), SfuTrackType.screenShare),
    ).thenReturn(shared);
    clearInteractions(harness.session);
    final failures = shareFailures(call);

    await emit(ScreenSharingStartedEvent());

    verifyNoScreenShare();
    expect(sharing(call), isTrue);
    expect(failures, isEmpty);
  });

  test(
    'a start event without a request shares with the default broadcast '
    'constraints',
    () async {
      final call = await joinedCall();

      await emit(ScreenSharingStartedEvent());

      final calls = screenShareCalls();
      expect(calls, hasLength(1));
      expect(calls.single.$1, isTrue);
      expect(calls.single.$2?.useiOSBroadcastExtension, isTrue);
      expect(sharing(call), isTrue);
    },
  );

  group('with more than one call', () {
    test('a broadcast another call requested is not shared', () async {
      final other = await joinedCall();
      await other.setScreenShareEnabled(enabled: true, constraints: _requested);
      final call = await joinedCall();

      await emit(ScreenSharingStartedEvent());

      expect(screenShareCalls(), [(true, _requested)]);
      verifyNoScreenShare(harness.sessions[1]);
      expect(sharing(call), isFalse);
    });

    test('a broadcast this call requested is shared even when another call '
        'is active', () async {
      final other = harness.buildCall(rtcMediaDeviceNotifier: notifier);
      final call = await joinedCall();
      activeCalls().value = [other];
      await call.setScreenShareEnabled(enabled: true, constraints: _requested);

      await emit(ScreenSharingStartedEvent());

      expect(screenShareCalls(), [(true, _requested)]);
      expect(sharing(call), isTrue);
    });

    test(
      'a broadcast nobody requested is only shared in the active call',
      () async {
        final other = harness.buildCall(rtcMediaDeviceNotifier: notifier);
        final call = await joinedCall();
        activeCalls().value = [other];

        await emit(ScreenSharingStartedEvent());

        verifyNoScreenShare();
        expect(sharing(call), isFalse);
      },
    );

    test(
      'a broadcast requested by a call that left is shared in the remaining '
      'active call',
      () async {
        final left = await joinedCall();
        final call = await joinedCall();
        await left.setScreenShareEnabled(
          enabled: true,
          constraints: _requested,
        );
        await left.leave();
        activeCalls().value = [call];

        await emit(ScreenSharingStartedEvent());

        verifyNoScreenShare();
        final captured = verify(
          () => harness.sessions[1].setScreenShareEnabled(
            true,
            constraints: captureAny(named: 'constraints'),
          ),
        ).captured;
        expect(captured.single, _isDefaultBroadcast(call));
        expect(sharing(call), isTrue);
      },
    );

    test(
      'a broadcast nobody requested is not shared while several calls are '
      'active',
      () async {
        final other = harness.buildCall(rtcMediaDeviceNotifier: notifier);
        final call = await joinedCall();
        activeCalls().value = [other, call];

        await emit(ScreenSharingStartedEvent());

        verifyNoScreenShare();
        expect(sharing(call), isFalse);
      },
    );
  });

  test('a failed share leaves the share off and stops the broadcast', () async {
    final call = await joinedCall();
    final failures = shareFailures(call);
    stubScreenShare(() async => failureWithError('no capture'));

    await emit(ScreenSharingStartedEvent());

    expect(screenShareCalls(), hasLength(1));
    expect(sharing(call), isFalse);
    verify(notifier.stopiOSBroadcast).called(1);
    expect(failures, hasLength(1));
    expect(failures.single.callCid, call.callCid);
    expect(failures.single.reason, ScreenShareFailureReason.publishFailed);
    expect(failures.single.error, isA<StreamVideoException>());
  });

  test('a call disposed while the broadcast ends reports nothing', () async {
    final call = await joinedCall();
    final stopping = Completer<void>();
    when(notifier.stopiOSBroadcast).thenAnswer((_) => stopping.future);
    stubScreenShare(() async => failureWithError('no capture'));

    await emit(ScreenSharingStartedEvent());
    verify(notifier.stopiOSBroadcast).called(1);
    await call.dispose();
    stopping.complete();
    await pumpEventQueue();

    expect(sharing(call), isFalse);
  });

  test('a share that throws stops the broadcast', () async {
    final call = await joinedCall();
    final failures = shareFailures(call);
    final error = StateError('no capture');
    stubScreenShare(() async => throw error);

    await emit(ScreenSharingStartedEvent());

    expect(sharing(call), isFalse);
    verify(notifier.stopiOSBroadcast).called(1);
    expect(failures, hasLength(1));
    expect(failures.single.reason, ScreenShareFailureReason.publishFailed);
    expect(failures.single.error, same(error));
  });

  test(
    'a start event without the screenshare permission shares nothing, ends '
    'the broadcast and reports it',
    () async {
      final call = await joinedCall();
      final failures = shareFailures(call);
      when(
        () => harness.permissionsManager.hasPermission(
          CallPermission.screenshare,
        ),
      ).thenReturn(false);

      await emit(ScreenSharingStartedEvent());

      verifyNoScreenShare();
      verify(notifier.stopiOSBroadcast).called(1);
      expect(sharing(call), isFalse);
      expect(failures, hasLength(1));
      expect(
        failures.single.reason,
        ScreenShareFailureReason.missingPermission,
      );
      expect(failures.single.error, isNull);
    },
  );

  test(
    'a disable before the start still shares the broadcast, with the default '
    'broadcast constraints',
    () async {
      final call = await joinedCall();
      await call.setScreenShareEnabled(enabled: true, constraints: _requested);
      await call.setScreenShareEnabled(enabled: false);
      clearInteractions(harness.session);

      await emit(ScreenSharingStartedEvent());

      final calls = screenShareCalls();
      expect(calls, hasLength(1));
      expect(calls.single.$1, isTrue);
      expect(calls.single.$2, _isDefaultBroadcast(call));
    },
  );

  test('a broadcast started before the call is joined is shared on the '
      'join', () async {
    applyOptionsOnStart();
    harness.buildCall(rtcMediaDeviceNotifier: notifier);
    await pumpEventQueue();

    await emit(ScreenSharingStartedEvent());
    verifyNoScreenShare();

    await joinedCall(clear: false);

    final calls = screenShareCalls();
    expect(calls, hasLength(1));
    expect(calls.single.$1, isTrue);
    expect(calls.single.$2?.useiOSBroadcastExtension, isTrue);
  });

  group('a broadcast started before any call exists', () {
    setUp(applyOptionsOnStart);

    test('is shared by the call that joins', () async {
      await emit(ScreenSharingStartedEvent());

      await joinedCall(clear: false);

      final calls = screenShareCalls();
      expect(calls, hasLength(1));
      expect(calls.single.$1, isTrue);
      expect(calls.single.$2?.useiOSBroadcastExtension, isTrue);
    });

    test('is not shared by a second call that joins', () async {
      await emit(ScreenSharingStartedEvent());
      await joinedCall();
      activeCalls().value = [];

      final second = await joinedCall();
      expect(activeCalls().value, [second]);

      verifyNoScreenShare(harness.sessions[1]);
      expect(sharing(second), isFalse);
    });

    test('that stopped is not shared by the call that joins', () async {
      await emit(ScreenSharingStartedEvent());
      await emit(ScreenSharingStoppedEvent());

      await joinedCall(clear: false);

      verifyNoScreenShare();
    });
  });

  test('the stop event disables the share', () async {
    final call = await joinedCall();
    await emit(ScreenSharingStartedEvent());
    when(
      () => harness.session.getTrack(any(), SfuTrackType.screenShare),
    ).thenReturn(shared);
    clearInteractions(harness.session);

    await emit(ScreenSharingStoppedEvent(trackId: 'screen-share'));

    expect(screenShareCalls().single.$1, isFalse);
    expect(sharing(call), isFalse);
  });
}
