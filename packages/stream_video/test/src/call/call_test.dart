import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:stream_video/src/call/session/call_session_factory.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import 'call_test_helpers.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call join', () {
    late final CallStateNotifier stateManager;
    late final StreamVideo streamVideo;
    late final CoordinatorClient coordinatorClient;
    late final InternetConnection networkMonitor;
    late final RtcMediaDeviceNotifier rtcMediaDeviceNotifier;
    late final RetryPolicy retryPolicy;
    late final CallSessionFactory sessionFactory;

    setUp(() {
      streamVideo = setupMockStreamVideo(clientState: setupMockClientState());
      coordinatorClient = setupMockCoordinatorClient();
      stateManager = createTestCallStateManager();
      networkMonitor = setupMockInternetConnection();
      rtcMediaDeviceNotifier = setupMockRtcMediaDeviceNotifier();
      retryPolicy = setupMockRetryPolicy();
      sessionFactory = setupMockSessionFactory();
    });

    test('should join the call', () async {
      final call = createTestCall(
        stateManager: stateManager,
        streamVideo: streamVideo,
        coordinatorClient: coordinatorClient,
        networkMonitor: networkMonitor,
        rtcMediaDeviceNotifier: rtcMediaDeviceNotifier,
        retryPolicy: retryPolicy,
        sessionFactory: sessionFactory,
      );

      final result = await call.join();
      expect(result, isA<Result<None>>());
      expect(result.isSuccess, isTrue);
    });
  });
}
