// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/src/state_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

CallMetadata _metadataWithSettings(CallSettings settings) {
  return CallMetadata(
    cid: SampleCallData.defaultCid,
    details: SampleCallData.defaultCallMetadata.details,
    settings: settings,
    session: const CallSessionData(),
    users: const {},
    members: const {},
  );
}

CoordinatorJoined _joinedWithSettings(
  CallSettings settings, {
  List<CallPermission> ownCapabilities = const [],
}) {
  return CoordinatorJoined(
    wasCreated: true,
    members: const {},
    users: const {},
    duration: '0',
    statsOptions: StatsOptions(
      enableRtcStats: true,
      reportingIntervalMs: 5000,
    ),
    ownCapabilities: ownCapabilities,
    metadata: _metadataWithSettings(settings),
    credentials: SampleCallData.defaultCredentials,
  );
}

/// Polls until [mockCall] has been invoked at least once, or fails after
/// [timeout]. This avoids fragile fixed-duration sleeps by yielding the
/// event loop in a tight retry loop until the async reconnect chain completes.
Future<void> _waitForMockCall(
  dynamic Function() mockCall, {
  Duration timeout = const Duration(seconds: 2),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    try {
      verify(mockCall).called(greaterThanOrEqualTo(1));
      return;
    } on TestFailure {
      // Not yet — yield and retry.
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }
  // Final attempt — let it throw if still not called.
  verify(mockCall).called(greaterThanOrEqualTo(1));
}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call audio processing', () {
    late BehaviorSubject<InternetStatus> internetStatusController;
    late MockCoordinatorClient coordinatorClient;
    late MockCallSession callSession;
    late MockStreamVideo mockStreamVideo;
    late MockPermissionsManager mockPermissionsManager;

    setUp(() {
      internetStatusController = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      coordinatorClient = setupMockCoordinatorClient();
      callSession = setupMockCallSession();
      mockStreamVideo = setupMockStreamVideo();
      mockPermissionsManager = MockPermissionsManager();
    });

    tearDown(() async {
      await internetStatusController.close();
    });

    // ---------------------------------------------------------------
    // startAudioProcessing
    // ---------------------------------------------------------------
    group('startAudioProcessing', () {
      test('returns error when audio processor is not configured', () async {
        when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(false);

        final call = createTestCall(
          networkMonitor: setupMockInternetConnection(
            statusStream: internetStatusController,
          ),
          coordinatorClient: coordinatorClient,
          sessionFactory: setupMockSessionFactory(callSession: callSession),
          streamVideo: mockStreamVideo,
        );

        await call.join();

        final result = await call.startAudioProcessing();

        expect(result.isFailure, isTrue);
      });

      test(
        'returns error when user lacks enableNoiseCancellation permission',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(false);

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          final result = await call.startAudioProcessing();

          expect(result.isFailure, isTrue);
        },
      );

      test(
        'returns failure when device does not support advanced audio processing',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            mockStreamVideo.deviceSupportsAdvancedAudioProcessing,
          ).thenAnswer((_) async => const Result.success(false));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          final result = await call.startAudioProcessing(
            requireAdvancedAudioProcessingSupport: true,
          );

          expect(result.isFailure, isTrue);
        },
      );

      test(
        'returns error when advanced audio processing check itself fails',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            mockStreamVideo.deviceSupportsAdvancedAudioProcessing,
          ).thenAnswer(
            (_) async => const Result.failure(
              VideoError(message: 'check failed'),
            ),
          );

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          final result = await call.startAudioProcessing(
            requireAdvancedAudioProcessingSupport: true,
          );

          expect(result.isFailure, isTrue);
        },
      );

      test(
        'enables audio processing and notifies SFU on success',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            callSession.notifyNoiseCancellationStarted,
          ).thenAnswer((_) async => const Result.success(none));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          final result = await call.startAudioProcessing();

          expect(result.isSuccess, isTrue);
          expect(call.state.value.isAudioProcessing, isTrue);
          verify(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).called(1);
          verify(callSession.notifyNoiseCancellationStarted).called(1);
        },
      );

      test(
        'does not notify SFU or update state when setAudioProcessingEnabled fails',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer(
            (_) async =>
                const Result.failure(VideoError(message: 'enable failed')),
          );

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          final result = await call.startAudioProcessing();

          expect(result.isFailure, isTrue);
          expect(call.state.value.isAudioProcessing, isFalse);
          verifyNever(callSession.notifyNoiseCancellationStarted);
        },
      );

      test(
        'succeeds without advanced-support check when requireAdvanced is false',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            callSession.notifyNoiseCancellationStarted,
          ).thenAnswer((_) async => const Result.success(none));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          final result = await call.startAudioProcessing(
            requireAdvancedAudioProcessingSupport: false,
          );

          expect(result.isSuccess, isTrue);
          verifyNever(mockStreamVideo.deviceSupportsAdvancedAudioProcessing);
        },
      );
    });

    // ---------------------------------------------------------------
    // stopAudioProcessing
    // ---------------------------------------------------------------
    group('stopAudioProcessing', () {
      test('returns error when audio processor is not configured', () async {
        when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(false);

        final call = createTestCall(
          networkMonitor: setupMockInternetConnection(
            statusStream: internetStatusController,
          ),
          coordinatorClient: coordinatorClient,
          sessionFactory: setupMockSessionFactory(callSession: callSession),
          streamVideo: mockStreamVideo,
        );

        await call.join();

        final result = await call.stopAudioProcessing();

        expect(result.isFailure, isTrue);
      });

      test('disables audio processing and notifies SFU on success', () async {
        when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
        when(
          () => mockPermissionsManager.hasPermission(
            CallPermission.enableNoiseCancellation,
          ),
        ).thenReturn(true);
        when(
          () => mockStreamVideo.setAudioProcessingEnabled(true),
        ).thenAnswer((_) async => const Result.success(none));
        when(
          () => mockStreamVideo.setAudioProcessingEnabled(false),
        ).thenAnswer((_) async => const Result.success(none));
        when(
          callSession.notifyNoiseCancellationStarted,
        ).thenAnswer((_) async => const Result.success(none));
        when(
          callSession.notifyNoiseCancellationStopped,
        ).thenAnswer((_) async => const Result.success(none));

        final call = createTestCall(
          networkMonitor: setupMockInternetConnection(
            statusStream: internetStatusController,
          ),
          coordinatorClient: coordinatorClient,
          sessionFactory: setupMockSessionFactory(callSession: callSession),
          streamVideo: mockStreamVideo,
          permissionManager: mockPermissionsManager,
        );

        await call.join();

        await call.startAudioProcessing();
        expect(call.state.value.isAudioProcessing, isTrue);

        final result = await call.stopAudioProcessing();

        expect(result.isSuccess, isTrue);
        expect(call.state.value.isAudioProcessing, isFalse);
        verify(
          () => mockStreamVideo.setAudioProcessingEnabled(false),
        ).called(1);
        verify(callSession.notifyNoiseCancellationStopped).called(1);
      });

      test(
        'does not notify SFU or update state when disable fails',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(false),
          ).thenAnswer(
            (_) async =>
                const Result.failure(VideoError(message: 'disable failed')),
          );
          when(
            callSession.notifyNoiseCancellationStarted,
          ).thenAnswer((_) async => const Result.success(none));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();
          await call.startAudioProcessing();
          expect(call.state.value.isAudioProcessing, isTrue);

          final result = await call.stopAudioProcessing();

          expect(result.isFailure, isTrue);
          expect(call.state.value.isAudioProcessing, isTrue);
          verifyNever(callSession.notifyNoiseCancellationStopped);
        },
      );
    });

    // ---------------------------------------------------------------
    // Auto-on noise cancellation on join
    // ---------------------------------------------------------------
    group('auto-on noise cancellation on join', () {
      test(
        'starts audio processing when call settings have autoOn mode',
        () async {
          const autoOnSettings = CallSettings(
            audio: StreamAudioSettings(
              noiseCancellation: StreamNoiceCancellingSettings(
                mode: NoiceCancellationSettingsMode.autoOn,
              ),
            ),
          );

          when(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).thenAnswer(
            (_) async => Result.success(
              _joinedWithSettings(
                autoOnSettings,
                ownCapabilities: [CallPermission.enableNoiseCancellation],
              ),
            ),
          );

          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            mockStreamVideo.deviceSupportsAdvancedAudioProcessing,
          ).thenAnswer((_) async => const Result.success(true));
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            callSession.notifyNoiseCancellationStarted,
          ).thenAnswer((_) async => const Result.success(none));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          // startAudioProcessing is called via unawaited, pump microtask queue
          await Future<void>.delayed(Duration.zero);

          verify(
            mockStreamVideo.deviceSupportsAdvancedAudioProcessing,
          ).called(1);
          verify(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).called(1);
        },
      );

      test(
        'does not start audio processing when noiseCancellation is null',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          await call.join();
          await Future<void>.delayed(Duration.zero);

          verifyNever(() => mockStreamVideo.setAudioProcessingEnabled(any()));
        },
      );

      test(
        'does not start audio processing when mode is available (not autoOn)',
        () async {
          const availableSettings = CallSettings(
            audio: StreamAudioSettings(
              noiseCancellation: StreamNoiceCancellingSettings(
                mode: NoiceCancellationSettingsMode.available,
              ),
            ),
          );

          when(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).thenAnswer(
            (_) async => Result.success(
              _joinedWithSettings(availableSettings),
            ),
          );

          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          await call.join();
          await Future<void>.delayed(Duration.zero);

          verifyNever(() => mockStreamVideo.setAudioProcessingEnabled(any()));
        },
      );

      test(
        'does not start audio processing when processor is not configured',
        () async {
          const autoOnSettings = CallSettings(
            audio: StreamAudioSettings(
              noiseCancellation: StreamNoiceCancellingSettings(
                mode: NoiceCancellationSettingsMode.autoOn,
              ),
            ),
          );

          when(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).thenAnswer(
            (_) async => Result.success(
              _joinedWithSettings(autoOnSettings),
            ),
          );

          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(false);

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          await call.join();
          await Future<void>.delayed(Duration.zero);

          verifyNever(() => mockStreamVideo.setAudioProcessingEnabled(any()));
        },
      );
    });

    // ---------------------------------------------------------------
    // Re-bind audio filter after rejoin / migrate
    // ---------------------------------------------------------------
    group('re-bind audio filter after rejoin/migrate', () {
      test(
        'rebinds audio processing after rejoin when processing was active',
        () async {
          // Make fast reconnect fail so the system falls back to rejoin,
          // which is the code path that re-binds the audio filter.
          when(
            () => callSession.fastReconnect(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).thenAnswer(
            (_) async => const Result.failure(
              VideoError(message: 'fast reconnect failed'),
            ),
          );

          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            callSession.notifyNoiseCancellationStarted,
          ).thenAnswer((_) async => const Result.success(none));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          final joinResult = await call.join();
          expect(joinResult.isSuccess, isTrue);

          await call.startAudioProcessing();
          expect(call.state.value.isAudioProcessing, isTrue);

          // 1 call so far from startAudioProcessing
          verify(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).called(1);

          // Trigger network reconnection — fast reconnect will fail,
          // causing a fallback to rejoin which hits the rebind path.
          internetStatusController.add(InternetStatus.disconnected);
          await Future<void>.delayed(Duration.zero);
          internetStatusController.add(InternetStatus.connected);

          // Poll until the rejoin path calls setAudioProcessingEnabled(true)
          // again, rather than relying on a fixed sleep duration.
          await _waitForMockCall(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          );
        },
      );

      test(
        'does not rebind when audio processing was not active',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          final joinResult = await call.join();
          expect(joinResult.isSuccess, isTrue);
          expect(call.state.value.isAudioProcessing, isFalse);

          // No calls so far
          verifyNever(() => mockStreamVideo.setAudioProcessingEnabled(any()));

          internetStatusController.add(InternetStatus.disconnected);
          await Future<void>.delayed(Duration.zero);
          internetStatusController.add(InternetStatus.connected);
          await Future<void>.delayed(const Duration(milliseconds: 100));

          // Still no calls — processing was not active so nothing to rebind
          verifyNever(() => mockStreamVideo.setAudioProcessingEnabled(any()));
        },
      );

      test(
        'does not rebind when processor is not configured',
        () async {
          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(false);

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          final joinResult = await call.join();
          expect(joinResult.isSuccess, isTrue);

          internetStatusController.add(InternetStatus.disconnected);
          await Future<void>.delayed(Duration.zero);
          internetStatusController.add(InternetStatus.connected);
          await Future<void>.delayed(const Duration(milliseconds: 100));

          verifyNever(() => mockStreamVideo.setAudioProcessingEnabled(any()));
        },
      );
    });

    // ---------------------------------------------------------------
    // clear() audio processing teardown
    // ---------------------------------------------------------------
    group('clear() audio processing teardown', () {
      test(
        'stops audio processing on leave when autoOn and no other call needs it',
        () async {
          const autoOnSettings = CallSettings(
            audio: StreamAudioSettings(
              noiseCancellation: StreamNoiceCancellingSettings(
                mode: NoiceCancellationSettingsMode.autoOn,
              ),
            ),
          );

          final activeCallsEmitter = MutableStateEmitterImpl<List<Call>>(
            [],
            sync: true,
          );

          final clientState = setupMockClientState();
          when(() => clientState.activeCalls).thenReturn(activeCallsEmitter);

          final streamVideo = setupMockStreamVideo(clientState: clientState);
          when(streamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => streamVideo.setAudioProcessingEnabled(false),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            () => streamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer((_) async => const Result.success(none));
          when(() => streamVideo.activeCalls).thenReturn(const <Call>[]);

          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            callSession.notifyNoiseCancellationStarted,
          ).thenAnswer((_) async => const Result.success(none));
          when(
            callSession.notifyNoiseCancellationStopped,
          ).thenAnswer((_) async => const Result.success(none));

          when(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).thenAnswer(
            (_) async => Result.success(
              _joinedWithSettings(
                autoOnSettings,
                ownCapabilities: [CallPermission.enableNoiseCancellation],
              ),
            ),
          );

          when(
            streamVideo.deviceSupportsAdvancedAudioProcessing,
          ).thenAnswer((_) async => const Result.success(true));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: streamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();
          await Future<void>.delayed(Duration.zero);

          await call.leave();
          await Future<void>.delayed(Duration.zero);

          verify(
            () => streamVideo.setAudioProcessingEnabled(false),
          ).called(greaterThanOrEqualTo(1));
        },
      );
    });

    // ---------------------------------------------------------------
    // setAudioBitrateProfile and audio processing interaction
    // ---------------------------------------------------------------
    group('setAudioBitrateProfile and audio processing interaction', () {
      test(
        'returns error when hifi audio is not enabled',
        () async {
          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          await call.join();

          final result = call.setAudioBitrateProfile(
            SfuAudioBitrateProfile.musicHighQuality,
          );

          expect(result.isFailure, isTrue);
        },
      );

      test(
        'stops audio processing when switching to musicHighQuality profile',
        () async {
          const hifiSettings = CallSettings(
            audio: StreamAudioSettings(hifiAudioEnabled: true),
          );

          when(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).thenAnswer(
            (_) async => Result.success(
              _joinedWithSettings(
                hifiSettings,
                ownCapabilities: [CallPermission.enableNoiseCancellation],
              ),
            ),
          );

          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(false),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            callSession.notifyNoiseCancellationStopped,
          ).thenAnswer((_) async => const Result.success(none));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          await call.join();

          final result = call.setAudioBitrateProfile(
            SfuAudioBitrateProfile.musicHighQuality,
          );

          expect(result.isSuccess, isTrue);
          await Future<void>.delayed(Duration.zero);

          verify(
            () => mockStreamVideo.setAudioProcessingEnabled(false),
          ).called(1);
        },
      );

      test(
        'starts audio processing when switching away from musicHighQuality',
        () async {
          const hifiSettings = CallSettings(
            audio: StreamAudioSettings(hifiAudioEnabled: true),
          );

          when(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).thenAnswer(
            (_) async => Result.success(
              _joinedWithSettings(
                hifiSettings,
                ownCapabilities: [CallPermission.enableNoiseCancellation],
              ),
            ),
          );

          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(true);
          when(
            () => mockPermissionsManager.hasPermission(
              CallPermission.enableNoiseCancellation,
            ),
          ).thenReturn(true);
          when(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).thenAnswer((_) async => const Result.success(none));
          when(
            callSession.notifyNoiseCancellationStarted,
          ).thenAnswer((_) async => const Result.success(none));

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
            permissionManager: mockPermissionsManager,
          );

          await call.join();

          final result = call.setAudioBitrateProfile(
            SfuAudioBitrateProfile.voiceStandard,
          );

          expect(result.isSuccess, isTrue);
          await Future<void>.delayed(Duration.zero);

          verify(
            () => mockStreamVideo.setAudioProcessingEnabled(true),
          ).called(1);
        },
      );

      test(
        'does not toggle audio processing when processor is not configured',
        () async {
          const hifiSettings = CallSettings(
            audio: StreamAudioSettings(hifiAudioEnabled: true),
          );

          when(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).thenAnswer(
            (_) async => Result.success(
              _joinedWithSettings(hifiSettings),
            ),
          );

          when(mockStreamVideo.isAudioProcessorConfigured).thenReturn(false);

          final call = createTestCall(
            networkMonitor: setupMockInternetConnection(
              statusStream: internetStatusController,
            ),
            coordinatorClient: coordinatorClient,
            sessionFactory: setupMockSessionFactory(callSession: callSession),
            streamVideo: mockStreamVideo,
          );

          await call.join();

          call.setAudioBitrateProfile(
            SfuAudioBitrateProfile.musicHighQuality,
          );
          await Future<void>.delayed(Duration.zero);

          verifyNever(() => mockStreamVideo.setAudioProcessingEnabled(any()));
        },
      );
    });
  });
}
