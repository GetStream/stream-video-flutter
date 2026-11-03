import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';
import 'fixtures/data.dart';

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  @override
  bool enabled = true;
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('Call applies its connect options', () {
    late MockCallSession callSession;
    late MockPermissionsManager permissionManager;

    // The default mock never runs the callback that applies the connect
    // options, so the session has to hand it an rtc manager itself.
    void startInvokesRtcManagerCreated() {
      when(
        () => callSession.start(
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
            invocation.namedArguments[const Symbol(
                  'onRtcManagerCreatedCallback',
                )]
                as FutureOr<void> Function(RtcManager)?;

        await onCreated?.call(_MockRtcManager());

        return Result.success((
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero,
        ));
      });
    }

    setUp(() {
      callSession = setupMockCallSession();
      permissionManager = MockPermissionsManager();

      for (final permission in CallPermission.values) {
        when(
          () => permissionManager.hasPermission(permission),
        ).thenReturn(true);
      }

      startInvokesRtcManagerCreated();
    });

    Future<Call> joinWith(CallConnectOptions connectOptions) async {
      final call = createTestCall(
        permissionManager: permissionManager,
        sessionFactory: setupMockSessionFactory(callSession: callSession),
      );
      // Cancels the stats sends the published tracks schedule.
      addTearDown(call.dispose);

      await call.join(connectOptions: connectOptions);
      // The connect options are applied unawaited, so let them settle.
      await pumpEventQueue();

      return call;
    }

    // A refused apply leaves the device off. The intent has to come down with
    // it: a control that reads it while no track has been reported would
    // otherwise draw the device as live for the rest of the call, and refuse
    // to toggle, having no track to mute.
    test(
      'drops the microphone intent when the call refuses to send audio',
      () async {
        when(
          () => permissionManager.hasPermission(CallPermission.sendAudio),
        ).thenReturn(false);

        final call = await joinWith(
          CallConnectOptions(microphone: TrackOption.enabled()),
        );

        expect(call.connectOptions.microphone, isA<TrackDisabled>());
        expect(call.connectOptions.microphone.isDisabled, isTrue);
      },
    );

    test(
      'drops the camera intent when the call refuses to send video',
      () async {
        when(
          () => permissionManager.hasPermission(CallPermission.sendVideo),
        ).thenReturn(false);

        final call = await joinWith(
          CallConnectOptions(camera: TrackOption.enabled()),
        );

        expect(call.connectOptions.camera, isA<TrackDisabled>());
        expect(call.connectOptions.camera.isDisabled, isTrue);
      },
    );

    test('leaves the other device alone when only one is refused', () async {
      when(
        () => permissionManager.hasPermission(CallPermission.sendAudio),
      ).thenReturn(false);

      when(
        () => callSession.setCameraEnabled(
          any(),
          constraints: any(named: 'constraints'),
        ),
      ).thenAnswer((_) async => Result.success(MockRtcLocalTrack()));

      final call = await joinWith(
        CallConnectOptions(
          microphone: TrackOption.enabled(),
          camera: TrackOption.enabled(),
        ),
      );

      expect(call.connectOptions.microphone, isA<TrackDisabled>());
      expect(call.connectOptions.camera.isDisabled, isFalse);
    });

    test('keeps the intent when the apply succeeds', () async {
      when(
        () => callSession.setMicrophoneEnabled(
          any(),
          constraints: any(named: 'constraints'),
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
      ).thenAnswer((_) async => Result.success(MockRtcLocalTrack()));

      final call = await joinWith(
        CallConnectOptions(microphone: TrackOption.enabled()),
      );

      expect(call.connectOptions.microphone.isDisabled, isFalse);
    });

    test('off iOS, picks the audio output after publishing', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);
      // The stats reporter reads the thermal state on Android.
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      for (final channel in ['thermal', 'thermal/events']) {
        messenger.setMockMethodCallHandler(
          MethodChannel(channel),
          (_) async => null,
        );
        addTearDown(
          () => messenger.setMockMethodCallHandler(
            MethodChannel(channel),
            null,
          ),
        );
      }

      when(
        () => callSession.setMicrophoneEnabled(
          any(),
          constraints: any(named: 'constraints'),
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
      ).thenAnswer((_) async => Result.success(MockRtcLocalTrack()));
      when(
        () => callSession.setAudioOutputDevice(any()),
      ).thenAnswer((_) async => const Result.success(none));

      const speaker = RtcMediaDevice(
        id: 'speaker',
        label: 'Speaker',
        kind: RtcMediaDeviceKind.audioOutput,
      );
      await joinWith(
        CallConnectOptions(
          microphone: TrackOption.enabled(),
          audioOutputDevice: speaker,
        ),
      );

      verifyInOrder([
        () => callSession.setMicrophoneEnabled(
          true,
          constraints: any(named: 'constraints'),
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
        () => callSession.setAudioOutputDevice(speaker),
      ]);
    });
  });

  group('setCameraTargetResolution', () {
    const resolution = StreamTargetResolution(
      width: 640,
      height: 360,
      bitrate: 500000,
    );

    late ConnectionHarness harness;

    setUp(() => harness = _harnessWithCamera(3));

    tearDown(() => harness.dispose());

    test(
      'a resolution set during the call is used by the camera a rejoin opens',
      () async {
        final [_, second, _] = harness.sessions;
        final call = harness.buildCall();
        await call.join();
        await pumpEventQueue();

        await call.setCameraTargetResolution(resolution);
        await call.setCameraEnabled(enabled: true);
        expect(call.connectOptions.targetResolution, resolution);

        harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
        await pumpEventQueue();

        final constraints =
            verify(
                  () => second.setCameraEnabled(
                    true,
                    constraints: captureAny(named: 'constraints'),
                  ),
                ).captured.single
                as CameraConstraints;
        expect(constraints.params, resolution.toVideoParams());
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'a resolution set between failed join attempts is used by the attempt '
      'that joins again',
      () async {
        final [first, second, third] = harness.sessions;
        // The call settings name a resolution of their own, which a join
        // applies again.
        final joined = SampleCallData.coordinatorJoinedSuccess;
        harness.stubJoinCall(
          () async => Result.success(
            CoordinatorJoined(
              wasCreated: joined.wasCreated,
              members: joined.members,
              users: joined.users,
              duration: joined.duration,
              statsOptions: joined.statsOptions,
              ownCapabilities: joined.ownCapabilities,
              credentials: joined.credentials,
              metadata: CallMetadata(
                cid: joined.metadata.cid,
                details: joined.metadata.details,
                session: joined.metadata.session,
                users: joined.metadata.users,
                members: joined.metadata.members,
                settings: const CallSettings(
                  video: StreamVideoSettings(
                    targetResolution: StreamTargetResolution(
                      width: 1280,
                      height: 720,
                      bitrate: 1500000,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        late final Call call;
        // Two failures on one SFU make the next attempt join the coordinator
        // again, to be sent elsewhere.
        harness
          ..stubSessionStart(first, () async {
            await call.setCameraTargetResolution(resolution);
            return const Result.failure(
              StreamVideoException(message: 'sfu unreachable'),
            );
          })
          ..stubSessionStart(
            second,
            () async => const Result.failure(
              StreamVideoException(message: 'sfu unreachable'),
            ),
          );
        call = harness.buildCall();

        final result = await call.join(
          connectOptions: CallConnectOptions(camera: TrackOption.enabled()),
        );
        await pumpEventQueue();

        expect(result.isSuccess, isTrue);
        final constraints =
            verify(
                  () => third.setCameraEnabled(
                    true,
                    constraints: captureAny(named: 'constraints'),
                  ),
                ).captured.single
                as CameraConstraints;
        expect(constraints.params, resolution.toVideoParams());
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test('carries a resolution set before the join through it', () async {
      final call = harness.buildCall();

      await call.setCameraTargetResolution(resolution);
      await call.join();

      expect(call.connectOptions.targetResolution, resolution);
    });
  });

  group('setConnectOptions', () {
    late ConnectionHarness harness;

    setUp(() {
      harness = _harnessWithCamera(1);
      when(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      ).thenAnswer((_) async => const Result.success(none));
    });

    tearDown(() => harness.dispose());

    VerificationResult verifyCameraOpened() => verify(
      () => harness.session.setCameraEnabled(
        true,
        constraints: any(named: 'constraints'),
      ),
    );

    test('wins over the options passed to join', () async {
      final call = harness.buildCall();

      final result = call.setConnectOptions(
        CallConnectOptions(camera: TrackOption.enabled()),
      );
      await call.join(
        connectOptions: CallConnectOptions(camera: TrackOption.disabled()),
      );
      await pumpEventQueue();

      expect(result.isSuccess, isTrue);
      verifyCameraOpened().called(1);
    });

    test('applies a change made while an outgoing call rings', () async {
      final call = harness.buildCall(status: CallStatus.outgoing());

      final joining = call.join();
      await pumpEventQueue();
      final result = call.setConnectOptions(
        call.connectOptions.copyWith(camera: TrackOption.disabled()),
      );
      harness.stateManager.state = harness.stateManager.callState.copyWith(
        status: CallStatus.outgoing(acceptedByCallee: true),
      );

      expect(result.isSuccess, isTrue);
      expect((await joining).isSuccess, isTrue);
      await pumpEventQueue();
      // The call settings open the camera by default; the change made while
      // ringing turned it off.
      verifyNever(
        () => harness.session.setCameraEnabled(
          true,
          constraints: any(named: 'constraints'),
        ),
      );
    });

    // The outgoing screen previews the camera on the call's own factory and
    // hands the track over while ringing. Cancelled before pickup, no session
    // adopts it, and a renderer still bound to it crashed natively once the
    // factory was freed under it.
    test(
      'stops a track handed over while ringing before disposing its factory',
      () async {
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
        addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

        final events = <String>[];
        const channel = MethodChannel('FlutterWebRTC.Method');
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(channel, (call) async {
          switch (call.method) {
            case 'createPeerConnectionFactory':
              return {'factoryId': 'factory-1'};
            case 'disposePeerConnectionFactory':
              events.add('factory disposed');
          }
          return null;
        });
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

        final call = harness.buildCall(status: CallStatus.outgoing());
        final nativeFactory = await call.ensureNativeFactory();

        final preview = MockRtcLocalTrack();
        when(() => preview.trackId).thenReturn('local:video');
        when(() => preview.nativeFactory).thenReturn(nativeFactory);
        when(preview.stop).thenAnswer((_) async => events.add('track stopped'));
        expect(
          call
              .setConnectOptions(
                call.connectOptions.copyWith(
                  camera: TrackOption.provided(preview),
                ),
              )
              .isSuccess,
          isTrue,
        );

        final joining = call.join();
        await pumpEventQueue();
        await call.leave();
        await joining;
        await pumpEventQueue();

        expect(events, ['track stopped', 'factory disposed']);
      },
    );

    test(
      'fails once the join applied its options, and changes nothing',
      () async {
        final call = harness.buildCall();
        await call.join();
        await pumpEventQueue();
        final before = call.connectOptions;
        clearInteractions(harness.session);

        final result = call.setConnectOptions(
          before.copyWith(camera: TrackOption.enabled()),
        );

        expect(result.isFailure, isTrue);
        expect(call.connectOptions, before);
        verifyNever(
          () => harness.session.setCameraEnabled(
            any(),
            constraints: any(named: 'constraints'),
          ),
        );
      },
    );

    test(
      'applies a change made while the session is still connecting',
      () async {
        late final Call call;
        Result<None>? result;
        when(
          () => harness.session.start(
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
          // The join applied the call settings; the session has not applied
          // the options yet.
          result = call.setConnectOptions(
            call.connectOptions.copyWith(camera: TrackOption.disabled()),
          );
          final onCreated =
              invocation.namedArguments[#onRtcManagerCreatedCallback]
                  as FutureOr<void> Function(RtcManager)?;
          await onCreated?.call(_MockRtcManager());
          return Result.success((
            callState: createTestSfuCallState(),
            fastReconnectDeadline: Duration.zero,
          ));
        });
        call = harness.buildCall();

        await call.join();
        await pumpEventQueue();

        expect(result?.isSuccess, isTrue);
        // The call settings open the camera by default.
        verifyNever(
          () => harness.session.setCameraEnabled(
            true,
            constraints: any(named: 'constraints'),
          ),
        );
      },
    );

    test('applies a change made while a retry is connecting', () async {
      final h = _harnessWithCamera(2);
      addTearDown(h.dispose);
      final [first, second] = h.sessions;
      late final Call call;
      Result<None>? result;

      void stubStart(
        MockCallSession session,
        Result<SessionStartResult> Function() answer, {
        void Function()? beforeApplying,
      }) {
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
          beforeApplying?.call();
          final onCreated =
              invocation.namedArguments[#onRtcManagerCreatedCallback]
                  as FutureOr<void> Function(RtcManager)?;
          await onCreated?.call(_MockRtcManager());
          return answer();
        });
      }

      // The first session applies the options, then fails to start.
      stubStart(
        first,
        () => const Result.failure(
          StreamVideoException(message: 'sfu unreachable'),
        ),
      );
      stubStart(
        second,
        () => Result.success((
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero,
        )),
        beforeApplying: () => result = call.setConnectOptions(
          call.connectOptions.copyWith(camera: TrackOption.disabled()),
        ),
      );
      call = h.buildCall();

      expect((await call.join()).isSuccess, isTrue);
      await pumpEventQueue();

      expect(result?.isSuccess, isTrue);
      // The call settings open the camera by default.
      verifyNever(
        () => second.setCameraEnabled(
          true,
          constraints: any(named: 'constraints'),
        ),
      );
    }, timeout: const Timeout(Duration(seconds: 30)));

    group('across join attempts that apply the call settings again', () {
      late ConnectionHarness h;

      setUp(() {
        h = _harnessWithCamera(3);
      });

      tearDown(() => h.dispose());

      /// Fails the first two sessions, so the third attempt joins the
      /// coordinator again. [beforeFailing] runs as the first one starts.
      void failTwice({void Function()? beforeFailing}) {
        final [first, second, _] = h.sessions;
        h
          ..stubSessionStart(first, () async {
            beforeFailing?.call();
            return const Result.failure(
              StreamVideoException(message: 'sfu unreachable'),
            );
          })
          ..stubSessionStart(
            second,
            () async => const Result.failure(
              StreamVideoException(message: 'sfu unreachable'),
            ),
          );
      }

      void verifyThirdKeptCameraOff() => verifyNever(
        () => h.sessions[2].setCameraEnabled(
          true,
          constraints: any(named: 'constraints'),
        ),
      );

      test('keeps a change made between them', () async {
        late final Call call;
        Result<None>? result;
        failTwice(
          beforeFailing: () => result = call.setConnectOptions(
            call.connectOptions.copyWith(
              camera: TrackOption.disabled(),
              microphone: TrackOption.disabled(),
            ),
          ),
        );
        call = h.buildCall();

        expect((await call.join()).isSuccess, isTrue);
        await pumpEventQueue();

        expect(result?.isSuccess, isTrue);
        // The call settings turn both on by default.
        verifyThirdKeptCameraOff();
        expect(call.connectOptions.camera.isDisabled, isTrue);
        expect(call.connectOptions.microphone.isDisabled, isTrue);
      }, timeout: const Timeout(Duration(seconds: 30)));

      test('keeps a change made before the first of them', () async {
        failTwice();
        final call = h.buildCall();

        expect(
          call
              .setConnectOptions(
                CallConnectOptions(camera: TrackOption.disabled()),
              )
              .isSuccess,
          isTrue,
        );
        expect((await call.join()).isSuccess, isTrue);
        await pumpEventQueue();

        verifyThirdKeptCameraOff();
        expect(call.connectOptions.camera.isDisabled, isTrue);
      }, timeout: const Timeout(Duration(seconds: 30)));
    });

    group('the deprecated setter', () {
      test('applies a write before the join', () async {
        final call = harness.buildCall();

        // ignore: deprecated_member_use_from_same_package
        call.connectOptions = CallConnectOptions(camera: TrackOption.enabled());
        await call.join(
          connectOptions: CallConnectOptions(camera: TrackOption.disabled()),
        );
        await pumpEventQueue();

        verifyCameraOpened().called(1);
      });

      test('changes nothing once the join applied its options', () async {
        final call = harness.buildCall();
        await call.join();
        await pumpEventQueue();
        final before = call.connectOptions;

        // ignore: deprecated_member_use_from_same_package
        call.connectOptions = before.copyWith(camera: TrackOption.disabled());

        expect(call.connectOptions, before);
      });
    });
  });
}

/// A harness of [sessionCount] sessions that start, apply the connect
/// options, and open a camera on request.
ConnectionHarness _harnessWithCamera(int sessionCount) {
  final harness = ConnectionHarness(sessionCount: sessionCount);
  for (final permission in CallPermission.values) {
    when(
      () => harness.permissionsManager.hasPermission(permission),
    ).thenReturn(true);
  }
  for (final session in harness.sessions) {
    final published = MockRtcLocalTrack();
    when(() => published.mediaTrack).thenReturn(_FakeMediaStreamTrack());
    when(
      () => session.setCameraEnabled(
        any(),
        constraints: any(named: 'constraints'),
      ),
    ).thenAnswer((_) async => Result.success(published));
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
      await onCreated?.call(_MockRtcManager());
      return Result.success((
        callState: createTestSfuCallState(),
        fastReconnectDeadline: Duration.zero,
      ));
    });
  }
  return harness;
}
