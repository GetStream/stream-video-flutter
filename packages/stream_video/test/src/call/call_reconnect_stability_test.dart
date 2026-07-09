// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

class _MockPeerConnection extends Mock implements StreamPeerConnection {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('Call reconnect network stability window', () {
    late BehaviorSubject<InternetStatus> internetStatusController;
    late MockCoordinatorClient coordinatorClient;
    late MockCallSession callSession;
    late MockSessionFactory sessionFactory;
    late _MockPeerConnection mockPc;
    OnReconnectionNeeded? capturedCallback;

    setUp(() {
      internetStatusController = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      coordinatorClient = setupMockCoordinatorClient();
      callSession = setupMockCallSession();
      capturedCallback = null;

      // Build a session factory mock that captures the
      // [onReconnectionNeeded] callback supplied by Call so tests can
      // trigger reconnect with any strategy directly.
      sessionFactory = MockSessionFactory();
      when(() => sessionFactory.sdpEditor).thenReturn(MockSdpEditor());
      when(
        () => sessionFactory.makeCallSession(
          onSuspendedAudioTrackRecorded: any(
            named: 'onSuspendedAudioTrackRecorded',
          ),
          sessionId: any(named: 'sessionId'),
          sessionSeq: any(named: 'sessionSeq'),
          credentials: any(named: 'credentials'),
          stateManager: any(named: 'stateManager'),
          dynascaleManager: any(named: 'dynascaleManager'),
          networkMonitor: any(named: 'networkMonitor'),
          statsOptions: any(named: 'statsOptions'),
          onReconnectionNeeded: any(named: 'onReconnectionNeeded'),
          clientPublishOptions: any(named: 'clientPublishOptions'),
          streamVideo: any(named: 'streamVideo'),
          leftoverTraceRecords: any(named: 'leftoverTraceRecords'),
          pcFactory: any(named: 'pcFactory'),
        ),
      ).thenAnswer((invocation) {
        capturedCallback =
            invocation.namedArguments[const Symbol('onReconnectionNeeded')]
                as OnReconnectionNeeded;
        return Future.value(callSession);
      });

      mockPc = _MockPeerConnection();
      when(() => mockPc.type).thenReturn(StreamPeerType.publisher);
    });

    tearDown(() async {
      await internetStatusController.close();
    });

    Call buildCall({CallStateNotifier? stateManager}) {
      return createTestCall(
        stateManager: stateManager,
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: sessionFactory,
      );
    }

    test(
      'fast reconnect proceeds without waiting the 3s stability window',
      () async {
        final call = buildCall();

        final joinResult = await call.join();
        expect(joinResult.isSuccess, isTrue);

        // Toggle network to trigger fast reconnect via _observeReconnectEvents.
        final stopwatch = Stopwatch()..start();
        internetStatusController.add(InternetStatus.disconnected);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        internetStatusController.add(InternetStatus.connected);

        // fastReconnect must be invoked well before the 3s stability window
        // that the rejoin/migrate path applies. Allow generous slack for
        // scheduler jitter in CI but stay safely under 3s.
        await Future<void>.delayed(const Duration(milliseconds: 500));
        stopwatch.stop();

        verify(
          () => callSession.fastReconnect(
            reconnectDetails: any(named: 'reconnectDetails'),
            capabilities: any(named: 'capabilities'),
            unifiedSessionId: any(named: 'unifiedSessionId'),
          ),
        ).called(1);

        expect(
          stopwatch.elapsed,
          lessThan(const Duration(seconds: 3)),
          reason: 'fast strategy must not apply the 3s stability window',
        );
      },
    );

    test(
      'rejoin reconnect does not proceed before the stability window elapses',
      () async {
        final call = buildCall();

        await call.join();
        expect(capturedCallback, isNotNull);

        // Initial join issues exactly one joinCall; the rejoin path will
        // issue a second one — but only after the stability window expires.
        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);

        // Trigger a rejoin while the network is still reported as
        // connected. The reconnect path must wait the stability window
        // before re-issuing joinCall.
        capturedCallback!(mockPc, SfuReconnectionStrategy.rejoin);

        await Future<void>.delayed(const Duration(milliseconds: 500));

        verifyNever(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        );
      },
    );

    test(
      'rejoin reconnect proceeds once the network stays connected for the '
      'stability window',
      () async {
        final call = buildCall();

        await call.join();
        expect(capturedCallback, isNotNull);

        capturedCallback!(mockPc, SfuReconnectionStrategy.rejoin);

        // Wait past the 3s stability window with the network steady.
        await Future<void>.delayed(const Duration(milliseconds: 3500));

        // Initial join + rejoin = 2 joinCall invocations.
        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: null,
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(2);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'rejoin reconnect restarts the wait when network drops inside the '
      'stability window',
      () async {
        final call = buildCall();

        await call.join();
        expect(capturedCallback, isNotNull);

        // Consume the initial joinCall so subsequent verifications only
        // observe rejoin-driven calls.
        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);

        capturedCallback!(mockPc, SfuReconnectionStrategy.rejoin);

        // Halfway through the first stability window, drop the network so
        // the wait must restart from scratch.
        await Future<void>.delayed(const Duration(milliseconds: 1500));
        internetStatusController.add(InternetStatus.disconnected);

        // The rejoin must not have proceeded yet — the first window was
        // interrupted by the drop above.
        verifyNever(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        );

        // Restore connectivity and give the wait a full clean window.
        await Future<void>.delayed(const Duration(milliseconds: 100));
        internetStatusController.add(InternetStatus.connected);
        await Future<void>.delayed(const Duration(milliseconds: 3500));

        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: null,
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );

    test(
      'rejoin reconnect gives up when network flicker exhausts the total '
      'availability budget',
      () async {
        final customStateManager = CallStateNotifier(
          CallState(
            preferences: DefaultCallPreferences(
              networkAvailabilityTimeout: const Duration(milliseconds: 1500),
            ),
            currentUserId: SampleCallData.defaultUserInfo.id,
            callCid: SampleCallData.defaultCid,
          ),
        );

        final call = buildCall(stateManager: customStateManager);

        await call.join();
        expect(capturedCallback, isNotNull);

        // Consume the initial joinCall before triggering rejoin so we can
        // assert that no further joinCall is issued.
        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);

        capturedCallback!(mockPc, SfuReconnectionStrategy.rejoin);

        // Let the initial connectivity check pass, then drop the network
        // inside the stability window so the wait loop iterates with a
        // shrunken remaining budget. Because the network never returns,
        // the bounded networkFuture times out and the reconnect fails.
        await Future<void>.delayed(const Duration(milliseconds: 500));
        internetStatusController.add(InternetStatus.disconnected);

        // 1500ms budget total → ~1000ms remaining after the drop above.
        // Wait long enough for the bounded wait to time out and the
        // reconnect-failed state to be published.
        await Future<void>.delayed(const Duration(milliseconds: 1500));

        verifyNever(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        );

        // Once budget is exhausted the reconnect path publishes
        // [CallStatusReconnectionFailed], which the Call observer then
        // converts into a disconnected status with the matching reason.
        final status = call.state.value.status;
        expect(
          status is CallStatusReconnectionFailed ||
              (status is CallStatusDisconnected &&
                  status.reason is DisconnectReasonReconnectionFailed),
          isTrue,
          reason: 'expected reconnect to give up, got status: $status',
        );

        customStateManager.dispose();
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'migrate reconnect also waits for the stability window',
      () async {
        final call = buildCall();

        await call.join();
        expect(capturedCallback, isNotNull);

        // Consume the initial joinCall before triggering migrate.
        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);

        capturedCallback!(mockPc, SfuReconnectionStrategy.migrate);

        // Within the stability window, no extra joinCall should be issued.
        await Future<void>.delayed(const Duration(milliseconds: 500));

        verifyNever(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        );
      },
    );

    test(
      'rejoin hint received while reconnect lock is held is not dropped',
      () async {
        // Override start() to return a long fastReconnectDeadline so
        // mustPerformRejoin stays false — this isolates the _isRejoinPending
        // flag as the sole driver of escalation.
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
        ).thenAnswer(
          (_) => Future.value(
            Result.success((
              callState: createTestSfuCallState(),
              fastReconnectDeadline: const Duration(minutes: 5),
            )),
          ),
        );

        // fastReconnect hangs until we release the gate.
        final fastReconnectGate = Completer<void>();
        when(
          () => callSession.fastReconnect(
            reconnectDetails: any(named: 'reconnectDetails'),
            capabilities: any(named: 'capabilities'),
            unifiedSessionId: any(named: 'unifiedSessionId'),
          ),
        ).thenAnswer((_) async {
          await fastReconnectGate.future;
          return Result.error('simulated fast reconnect failure');
        });

        final call = buildCall();
        await call.join();

        // Consume the initial joinCall.
        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);

        // Start a fast reconnect — the loop acquires the reconnect lock and
        // hangs waiting for fastReconnectGate.
        capturedCallback!(mockPc, SfuReconnectionStrategy.fast);
        // Wait long enough for the lock to be acquired.
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Signal a rejoin hint while the reconnect lock is held. The call
        // must record _isRejoinPending=true and not discard the hint.
        capturedCallback!(mockPc, SfuReconnectionStrategy.rejoin);

        // Release the gate: fast reconnect fails. The loop sees
        // _isRejoinPending=true → shouldRejoin=true → strategy switches to
        // rejoin → awaits 3s stability window → issues a second joinCall.
        fastReconnectGate.complete();

        // 3 s stability window + margin.
        await Future<void>.delayed(const Duration(milliseconds: 3500));

        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'fast reconnect escalates to rejoin after three consecutive failures',
      () async {
        // A long fastReconnectDeadline keeps mustPerformRejoin false so only
        // fastReconnectAttemptsCount >= 2 drives the escalation to rejoin.
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
        ).thenAnswer(
          (_) => Future.value(
            Result.success((
              callState: createTestSfuCallState(),
              fastReconnectDeadline: const Duration(minutes: 5),
            )),
          ),
        );

        var fastReconnectCallCount = 0;
        when(
          () => callSession.fastReconnect(
            reconnectDetails: any(named: 'reconnectDetails'),
            capabilities: any(named: 'capabilities'),
            unifiedSessionId: any(named: 'unifiedSessionId'),
          ),
        ).thenAnswer((_) async {
          fastReconnectCallCount++;
          return Result.error('simulated fast reconnect failure');
        });

        final call = buildCall();
        await call.join();

        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);

        // Trigger the reconnect loop. Fast reconnect fails 3 times before
        // fastReconnectAttemptsCount >= 2 causes escalation to rejoin.
        capturedCallback!(mockPc, SfuReconnectionStrategy.fast);

        // 3 fast-reconnect failures (near-instant with zero backoff) +
        // 3 s stability window for the subsequent rejoin + margin.
        await Future<void>.delayed(const Duration(milliseconds: 3500));

        expect(
          fastReconnectCallCount,
          3,
          reason:
              'should attempt fast reconnect exactly 3 times before escalating',
        );

        // After escalation the rejoin path issues a second joinCall.
        verify(
          () => coordinatorClient.joinCall(
            callCid: any(named: 'callCid'),
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
          ),
        ).called(1);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );
  });
}
