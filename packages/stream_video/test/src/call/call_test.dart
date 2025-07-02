// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

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
  });
}
