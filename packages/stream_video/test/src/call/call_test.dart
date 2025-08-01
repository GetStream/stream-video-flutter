// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'call_test_helpers.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call', () {
    test('should join the call', () async {
      final call = createTestCall();

      final result = await call.join();
      expect(result, isA<Result<None>>());
      expect(result.isSuccess, isTrue);
    });

    test(
        'join call should migrate to new SFU after 2 failures, and make 3 attempts to join the call',
        () async {
      final mockCallSession = setupMockCallSession();
      final mockSessionFactory =
          setupMockSessionFactory(callSession: mockCallSession);

      final coordinatorClient = setupMockCoordinatorClient();

      when(
        () => mockCallSession.start(
          reconnectDetails: any(named: 'reconnectDetails'),
          onRtcManagerCreatedCallback:
              any(named: 'onRtcManagerCreatedCallback'),
          isAnonymousUser: any(named: 'isAnonymousUser'),
        ),
      ).thenAnswer(
        (_) async => const Result.failure(
          VideoError(message: 'Failed to start session'),
        ),
      );

      final call = createTestCall(
        sessionFactory: mockSessionFactory,
        coordinatorClient: coordinatorClient,
      );

      await call.join();

      // Migrate to new SFU after 2 failures
      // Make 3 attempts to join the call (start the session)
      verifyInOrder([
        () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              ringing: any(named: 'ringing'),
              create: any(named: 'create'),
              migratingFrom: null,
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
        () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              onRtcManagerCreatedCallback:
                  any(named: 'onRtcManagerCreatedCallback'),
              isAnonymousUser: any(named: 'isAnonymousUser'),
            ),
        () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              onRtcManagerCreatedCallback:
                  any(named: 'onRtcManagerCreatedCallback'),
              isAnonymousUser: any(named: 'isAnonymousUser'),
            ),
        () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              ringing: any(named: 'ringing'),
              create: any(named: 'create'),
              migratingFrom: defaultCredentials.sfuServer.name,
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
        () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              onRtcManagerCreatedCallback:
                  any(named: 'onRtcManagerCreatedCallback'),
              isAnonymousUser: any(named: 'isAnonymousUser'),
            ),
      ]);
    });

    test('should reconnect when internet connection is lost and recovered',
        () async {
      final internetStatusController =
          BehaviorSubject<InternetStatus>.seeded(InternetStatus.connected);

      final coordinatorClient = setupMockCoordinatorClient();
      final callSession = setupMockCallSession();

      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
      );

      final result = await call.join();
      expect(result, isA<Result<None>>());
      expect(result.isSuccess, isTrue);

      verify(
        () => coordinatorClient.joinCall(
          callCid: defaultCid,
          ringing: null,
          create: true,
          migratingFrom: null,
          video: false,
          membersLimit: null,
        ),
      ).called(1);

      verifyNever(callSession.fastReconnect);

      internetStatusController.add(InternetStatus.disconnected);
      await Future<void>.delayed(Duration.zero);
      internetStatusController.add(InternetStatus.connected);
      await Future<void>.delayed(Duration.zero);

      verify(callSession.fastReconnect).called(1);

      await internetStatusController.close();
    });

    test(
        'should timeout when network is unavailable longer than networkAvailabilityTimeout',
        () async {
      final customPreferences = DefaultCallPreferences(
        networkAvailabilityTimeout: const Duration(milliseconds: 100),
      );

      final customStateManager = CallStateNotifier(
        CallState(
          preferences: customPreferences,
          currentUserId: defaultUserInfo.id,
          callCid: defaultCid,
        ),
      );

      final internetStatusController =
          BehaviorSubject<InternetStatus>.seeded(InternetStatus.connected);

      final coordinatorClient = setupMockCoordinatorClient();
      final callSession = setupMockCallSession();

      // Track when fastReconnect is called during the timeout scenario
      var fastReconnectCallCount = 0;
      when(callSession.fastReconnect).thenAnswer((_) {
        fastReconnectCallCount++;
        return Future.value(
          Result.success(
            (
              callState: createTestSfuCallState(),
              fastReconnectDeadline: Duration.zero,
            ),
          ),
        );
      });

      final call = createTestCall(
        stateManager: customStateManager,
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
      );

      // First join the call successfully
      final joinResult = await call.join();
      expect(joinResult, isA<Result<None>>());
      expect(joinResult.isSuccess, isTrue);

      // Verify the custom timeout is set in the call state
      expect(
        call.state.value.preferences.networkAvailabilityTimeout,
        const Duration(milliseconds: 100),
      );

      // Simulate network disconnection to trigger reconnection
      internetStatusController.add(InternetStatus.disconnected);
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(internetStatusController.value, InternetStatus.disconnected);
      expect(fastReconnectCallCount, 0);

      await internetStatusController.close();
      customStateManager.dispose();
    });

    test('should set audio input device', () async {
      final internetStatusController =
          BehaviorSubject<InternetStatus>.seeded(InternetStatus.connected);

      final coordinatorClient = setupMockCoordinatorClient();
      final callSession = setupMockCallSession();

      when(() => callSession.setAudioInputDevice(any<RtcMediaDevice>()))
          .thenAnswer((_) => Future.value(const Result.success(none)));

      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
      );

      const audioDevice = RtcMediaDevice(
        id: 'id',
        label: 'label',
        kind: RtcMediaDeviceKind.audioInput,
      );

      await call.join();

      final result = await call.setAudioInputDevice(audioDevice);

      expect(result, isA<Result<None>>());
      expect(result.isSuccess, isTrue);

      expect(call.connectOptions.audioInputDevice, audioDevice);

      await internetStatusController.close();
    });

    test(
        'should set audio input device when track missing, set later when unmute',
        () async {
      final internetStatusController =
          BehaviorSubject<InternetStatus>.seeded(InternetStatus.connected);

      final coordinatorClient = setupMockCoordinatorClient();
      final callSession = setupMockCallSession();
      final mockPermissionManager = MockPermissionsManager();

      when(() => mockPermissionManager.hasPermission(CallPermission.sendAudio))
          .thenAnswer((_) => true);

      final resultArray = <Result<None>>[
        Result.failure(
          VideoErrorWithCause(
            message: '',
            cause: TrackMissingException(trackType: SfuTrackType.audio),
          ),
        ),
        const Result.success(none),
      ];

      when(() => callSession.setAudioInputDevice(any<RtcMediaDevice>()))
          .thenAnswer(
        (_) => Future.value(resultArray.removeAt(0)),
      );

      when(() => callSession.setMicrophoneEnabled(any()))
          .thenAnswer((_) => Future.value(Result.success(MockRtcLocalTrack())));

      final call = createTestCall(
        permissionManager: mockPermissionManager,
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        coordinatorClient: coordinatorClient,
        sessionFactory: setupMockSessionFactory(
          callSession: callSession,
        ),
      );

      const audioDevice = RtcMediaDevice(
        id: 'id',
        label: 'label',
        kind: RtcMediaDeviceKind.audioInput,
      );

      await call.join();

      final result = await call.setAudioInputDevice(audioDevice);

      expect(result, isA<Result<None>>());
      expect(result.isSuccess, isTrue);

      expect(call.connectOptions.audioInputDevice, audioDevice);

      await call.setMicrophoneEnabled(enabled: true);

      verifyInOrder([
        () => callSession.setAudioInputDevice(audioDevice),
        () => callSession.setMicrophoneEnabled(true),
        () => callSession.setAudioInputDevice(audioDevice),
      ]);

      await internetStatusController.close();
    });

    test(
        'should handle concurrent setCameraEnabled calls without race conditions',
        () async {
      final mockPermissionManager = MockPermissionsManager();
      when(() => mockPermissionManager.hasPermission(CallPermission.sendVideo))
          .thenAnswer((_) => true);

      final call = createTestCall(permissionManager: mockPermissionManager);
      final callOrder = <String>[];

      final futures = <Future<Result<None>>>[];

      for (var i = 0; i < 8; i++) {
        final enabled = i.isEven;
        futures.add(
          call.setCameraEnabled(enabled: enabled).then((result) {
            callOrder.add('call-$i-enabled-$enabled-completed');
            return result;
          }),
        );

        // Small delay to ensure calls are started in order
        await Future<void>.delayed(const Duration(milliseconds: 2));
      }

      // Wait for all calls to complete
      final results = await Future.wait(futures);

      // Assert
      expect(results.length, 8);
      expect(callOrder.length, 8);

      for (var i = 0; i < results.length; i++) {
        expect(results[i], isA<Result<None>>());
      }

      // Verify that calls completed in order (indicating proper serialization)
      for (var i = 0; i < 8; i++) {
        final enabled = i.isEven;
        expect(callOrder[i], 'call-$i-enabled-$enabled-completed');
      }
    });
  });
}
