import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/state_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('Call.leave()', () {
    late BehaviorSubject<InternetStatus> internetStatusController;
    late MockCoordinatorClient coordinatorClient;
    late MockCallSession callSession;
    late MockStreamVideo mockStreamVideo;

    setUp(() {
      internetStatusController = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      coordinatorClient = setupMockCoordinatorClient();
      callSession = setupMockCallSession();
      mockStreamVideo = setupMockStreamVideo();
    });

    tearDown(() async {
      await internetStatusController.close();
    });

    test(
      'should complete successfully and update state to disconnected',
      () async {
        // Arrange
        final call = createTestCall(
          networkMonitor: setupMockInternetConnection(
            statusStream: internetStatusController,
          ),
          coordinatorClient: coordinatorClient,
          sessionFactory: setupMockSessionFactory(
            callSession: callSession,
          ),
          streamVideo: mockStreamVideo,
        );

        // Join the call first
        final joinResult = await call.join();
        expect(joinResult.isSuccess, isTrue);

        // Verify initial state
        expect(call.state.value.status, isA<CallStatusActive>());

        // Act
        final leaveResult = await call.leave();

        // Assert
        expect(leaveResult, isA<Result<None>>());
        expect(leaveResult.isSuccess, isTrue);
        expect(call.state.value.status.isDisconnected, isTrue);

        // Verify cleanup was called at least once
        verify(
          () => mockStreamVideo.state.removeActiveCall(call),
        ).called(greaterThan(0));
      },
    );

    test(
      'should be idempotent - calling leave multiple times succeeds',
      () async {
        // Arrange
        final call = createTestCall(
          networkMonitor: setupMockInternetConnection(
            statusStream: internetStatusController,
          ),
          coordinatorClient: coordinatorClient,
          sessionFactory: setupMockSessionFactory(
            callSession: callSession,
          ),
          streamVideo: mockStreamVideo,
        );

        await call.join();

        // Act - call leave multiple times
        final result1 = await call.leave();
        final result2 = await call.leave();
        final result3 = await call.leave();

        // Assert - all should succeed
        expect(result1.isSuccess, isTrue);
        expect(result2.isSuccess, isTrue);
        expect(result3.isSuccess, isTrue);

        // Cleanup should be called (subsequent calls should be no-ops)
        verify(
          () => mockStreamVideo.state.removeActiveCall(call),
        ).called(greaterThan(0));
      },
    );

    test('should return success when already disconnected', () async {
      // Arrange - join and then leave to get into disconnected state
      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
        streamVideo: mockStreamVideo,
      );

      await call.join();
      await call.leave();

      // Verify call is disconnected
      expect(call.state.value.status.isDisconnected, isTrue);

      // Act - call leave again on disconnected call
      final result = await call.leave();

      // Assert - should succeed without doing anything
      expect(result.isSuccess, isTrue);

      // State should remain disconnected
      expect(call.state.value.status.isDisconnected, isTrue);
    });

    test('should handle session disposal errors gracefully', () async {
      // Arrange - mock session.dispose() to return a failing future
      final failingCallSession = setupMockCallSession();
      when(failingCallSession.dispose).thenAnswer(
        (_) => Future.error(Exception('Session disposal failed')),
      );

      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: failingCallSession,
        ),
        streamVideo: mockStreamVideo,
      );

      await call.join();

      // Act - leave should not throw even if disposal fails
      final result = await call.leave();

      // Assert - should still succeed (fire-and-forget disposal)
      expect(result.isSuccess, isTrue);
      expect(call.state.value.status.isDisconnected, isTrue);
    });

    test('should clean up outgoing call if it matches', () async {
      // Arrange - create custom client state with exposed emitters
      final outgoingCallEmitter = MutableStateEmitterImpl<Call?>(null);
      final mockClientState = setupMockClientState();
      when(() => mockClientState.outgoingCall).thenReturn(outgoingCallEmitter);
      when(
        () => mockClientState.setOutgoingCall(any()),
      ).thenAnswer((_) async {});

      final customStreamVideo = setupMockStreamVideo(
        clientState: mockClientState,
      );

      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
        streamVideo: customStreamVideo,
      );

      await call.join();

      // Set as outgoing call directly on the emitter
      outgoingCallEmitter.value = call;

      // Act
      await call.leave();

      // Assert - setOutgoingCall(null) should be called
      verify(() => mockClientState.setOutgoingCall(null)).called(1);
    });

    test('should accept disconnect reason parameter', () async {
      // Arrange
      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
        streamVideo: mockStreamVideo,
      );

      await call.join();

      // Act
      final customReason = DisconnectReasonReplaced();
      final result = await call.leave(reason: customReason);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(call.state.value.status.isDisconnected, isTrue);
    });

    test('should handle leave during reconnection', () async {
      // Arrange
      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
        streamVideo: mockStreamVideo,
      );

      await call.join();

      // Simulate network disconnection
      internetStatusController.add(InternetStatus.disconnected);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act - leave during reconnection
      final result = await call.leave();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(call.state.value.status.isDisconnected, isTrue);
    });
  });
}
