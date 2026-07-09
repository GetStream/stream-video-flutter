import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

MockPermissionsManager _mockPermissionsWithEndCall() {
  final pm = MockPermissionsManager();
  when(pm.endCall).thenAnswer(
    (_) async => const Result.success(none),
  );
  return pm;
}

/// Returns a [MockCallSession] that has the extra stubs needed by
/// [Call.suspendAudio] and [Call.resumeAudio].
MockCallSession _mockSessionForAudioSuspension() {
  final session = setupMockCallSession();
  // rtcManager is nullable; returning null means no tracks to iterate.
  when(() => session.rtcManager).thenReturn(null);
  when(
    () => session.resumeSuspendedAudioTracks(any()),
  ).thenAnswer((_) async {});
  return session;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    // Fallback value for Map<String, SuspendedTrackState> used in any().
    registerFallbackValue(<String, SuspendedTrackState>{});
  });

  // -------------------------------------------------------------------------
  // suspendAudio
  // -------------------------------------------------------------------------
  group('Call.suspendAudio()', () {
    late BehaviorSubject<NetworkStatus> internetStatusController;
    late MockCallSession callSession;
    late MockStreamVideo mockStreamVideo;

    setUp(() {
      internetStatusController = BehaviorSubject<NetworkStatus>.seeded(
        NetworkStatus.connected,
      );
      callSession = _mockSessionForAudioSuspension();
      mockStreamVideo = setupMockStreamVideo();
    });

    tearDown(() async => internetStatusController.close());

    test(
      'is a no-op and leaves isAudioSuspended false when called before join',
      () async {
        // Before join, _pcFactory is null → early-return path.
        final call = createTestCall(
          networkMonitor: setupMockNetworkMonitor(
            statusStream: internetStatusController,
          ),
          sessionFactory: setupMockSessionFactory(callSession: callSession),
          streamVideo: mockStreamVideo,
        );

        await call.suspendAudio();

        expect(call.state.value.isAudioSuspended, isFalse);
      },
    );

    test('sets isAudioSuspended to true after join', () async {
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
      );

      await call.join();
      await call.suspendAudio();

      expect(call.state.value.isAudioSuspended, isTrue);
    });

    test('is idempotent — second call does not change state again', () async {
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
      );

      await call.join();
      await call.suspendAudio();

      expect(call.state.value.isAudioSuspended, isTrue);

      // A second call must be a no-op (guard: isAudioSuspended already true).
      await call.suspendAudio();
      expect(call.state.value.isAudioSuspended, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // resumeAudio
  // -------------------------------------------------------------------------
  group('Call.resumeAudio()', () {
    late BehaviorSubject<NetworkStatus> internetStatusController;
    late MockCallSession callSession;
    late MockStreamVideo mockStreamVideo;

    setUp(() {
      internetStatusController = BehaviorSubject<NetworkStatus>.seeded(
        NetworkStatus.connected,
      );
      callSession = _mockSessionForAudioSuspension();
      mockStreamVideo = setupMockStreamVideo();
    });

    tearDown(() async => internetStatusController.close());

    test('is a no-op when called before join (no factory)', () async {
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
      );

      // Should complete without throwing and leave state untouched.
      await expectLater(call.resumeAudio(), completes);
      expect(call.state.value.isAudioSuspended, isFalse);
    });

    test('sets isAudioSuspended to false after a prior suspend', () async {
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
      );

      await call.join();
      await call.suspendAudio();
      expect(call.state.value.isAudioSuspended, isTrue);

      await call.resumeAudio();
      expect(call.state.value.isAudioSuspended, isFalse);
    });

    test('calls resumeSuspendedAudioTracks on the active session', () async {
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
      );

      await call.join();
      await call.suspendAudio();
      await call.resumeAudio();

      verify(
        () => callSession.resumeSuspendedAudioTracks(any()),
      ).called(1);
    });

    test('suspend → resume → suspend cycle updates state correctly', () async {
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
      );

      await call.join();

      await call.suspendAudio();
      expect(call.state.value.isAudioSuspended, isTrue);

      await call.resumeAudio();
      expect(call.state.value.isAudioSuspended, isFalse);

      await call.suspendAudio();
      expect(call.state.value.isAudioSuspended, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // Call.end() — unified _disconnect path
  // -------------------------------------------------------------------------
  group('Call.end()', () {
    late BehaviorSubject<NetworkStatus> internetStatusController;
    late MockCallSession callSession;
    late MockStreamVideo mockStreamVideo;

    setUp(() {
      internetStatusController = BehaviorSubject<NetworkStatus>.seeded(
        NetworkStatus.connected,
      );
      callSession = setupMockCallSession();
      mockStreamVideo = setupMockStreamVideo();
    });

    tearDown(() async => internetStatusController.close());

    test('returns an error when the call is not active', () async {
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
        permissionManager: _mockPermissionsWithEndCall(),
      );

      // Do NOT join — status is idle/not active.
      final result = await call.end();

      expect(result.isFailure, isTrue);
      expect(call.state.value.status, isNot(isA<CallStatusDisconnected>()));
    });

    test(
      'succeeds and sets status to disconnected when call is active',
      () async {
        final call = createTestCall(
          networkMonitor: setupMockNetworkMonitor(
            statusStream: internetStatusController,
          ),
          sessionFactory: setupMockSessionFactory(callSession: callSession),
          streamVideo: mockStreamVideo,
          permissionManager: _mockPermissionsWithEndCall(),
        );

        await call.join();
        expect(call.state.value.status, isA<CallStatusActive>());

        final result = await call.end();

        expect(result.isSuccess, isTrue);
        expect(call.state.value.status.isDisconnected, isTrue);
      },
    );

    test('calls endCall() on the permissions manager', () async {
      final permissionsManager = _mockPermissionsWithEndCall();
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
        permissionManager: permissionsManager,
      );

      await call.join();
      await call.end();

      verify(permissionsManager.endCall).called(1);
    });

    test('is idempotent — second end() after disconnect is a no-op', () async {
      final permissionsManager = _mockPermissionsWithEndCall();
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: mockStreamVideo,
        permissionManager: permissionsManager,
      );

      await call.join();
      final result1 = await call.end();
      final result2 = await call.end(); // call is already disconnected

      expect(result1.isSuccess, isTrue);
      // Second call returns error because status is no longer active.
      expect(result2.isFailure, isTrue);
      // endCall was only called once.
      verify(permissionsManager.endCall).called(1);
    });

    test(
      'leave() and end() do not both disconnect — whichever runs first wins',
      () async {
        final permissionsManager = _mockPermissionsWithEndCall();
        final call = createTestCall(
          networkMonitor: setupMockNetworkMonitor(
            statusStream: internetStatusController,
          ),
          sessionFactory: setupMockSessionFactory(callSession: callSession),
          streamVideo: mockStreamVideo,
          permissionManager: permissionsManager,
        );

        await call.join();
        await call.leave();

        // Call is now disconnected. end() must return error (not active).
        final endResult = await call.end();
        expect(endResult.isFailure, isTrue);
        // endCall should NOT have been called because we left, not ended.
        verifyNever(permissionsManager.endCall);
      },
    );
  });

  // -------------------------------------------------------------------------
  // updateViewportVisibility disconnected guard
  // -------------------------------------------------------------------------
  group('Call.updateViewportVisibility() disconnected guard', () {
    late BehaviorSubject<NetworkStatus> internetStatusController;

    setUp(() {
      internetStatusController = BehaviorSubject<NetworkStatus>.seeded(
        NetworkStatus.connected,
      );
    });

    tearDown(() async => internetStatusController.close());

    test('returns success immediately when call is disconnected', () async {
      final callSession = setupMockCallSession();
      final call = createTestCall(
        networkMonitor: setupMockNetworkMonitor(
          statusStream: internetStatusController,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: setupMockStreamVideo(),
      );

      await call.join();
      await call.leave();

      expect(call.state.value.status.isDisconnected, isTrue);

      final result = await call.updateViewportVisibility(
        sessionId: 'session-id',
        userId: 'user-id',
        trackType: SfuTrackType.video,
        visibility: ViewportVisibility.visible,
      );

      expect(result.isSuccess, isTrue);
    });
  });
}
