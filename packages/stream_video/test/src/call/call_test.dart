// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
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
