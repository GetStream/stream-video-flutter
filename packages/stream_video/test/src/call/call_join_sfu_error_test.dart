import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Join SFU error handling', () {
    late MockCallSession mockCallSession;
    late MockSessionFactory mockSessionFactory;
    late MockCoordinatorClient coordinatorClient;

    setUp(() {
      mockCallSession = setupMockCallSession();
      mockSessionFactory = setupMockSessionFactory(
        callSession: mockCallSession,
      );
      coordinatorClient = setupMockCoordinatorClient();
    });

    group('unrecoverable SFU errors', () {
      test(
        'should stop retries immediately when SFU returns disconnect strategy',
        () async {
          when(
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).thenAnswer(
            (_) async => Result.failure(
              VideoErrorWithCause(
                message: 'SFU disconnect',
                cause: SfuError(
                  message: 'SFU disconnect',
                  code: SfuErrorCode.unspecified,
                  shouldRetry: false,
                  reconnectStrategy: SfuReconnectionStrategy.disconnect,
                ),
              ),
            ),
          );

          final call = createTestCall(
            sessionFactory: mockSessionFactory,
            coordinatorClient: coordinatorClient,
          );

          final result = await call.join();

          expect(result.isFailure, isTrue);

          verify(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).called(1);

          verify(
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).called(1);

          verify(
            () => mockCallSession.leave(
              reason: any(named: 'reason'),
            ),
          ).called(1);
        },
      );
    });

    group('join error codes triggering SFU migration', () {
      for (final errorCode in [
        SfuErrorCode.sfuFull,
        SfuErrorCode.sfuShuttingDown,
        SfuErrorCode.callParticipantLimitReached,
      ]) {
        test(
          'should trigger immediate SFU migration for $errorCode',
          () async {
            final localSession = setupMockCallSession();
            final localSessionFactory = setupMockSessionFactory(
              callSession: localSession,
            );
            final localCoordinator = setupMockCoordinatorClient();

            when(
              () => localSession.start(
                reconnectDetails: any(named: 'reconnectDetails'),
                capabilities: any(named: 'capabilities'),
                onRtcManagerCreatedCallback: any(
                  named: 'onRtcManagerCreatedCallback',
                ),
                isAnonymousUser: any(named: 'isAnonymousUser'),
                unifiedSessionId: any(named: 'unifiedSessionId'),
              ),
            ).thenAnswer(
              (_) async => Result.failure(
                VideoErrorWithCause(
                  message: 'Join error: $errorCode',
                  cause: SfuError(
                    message: 'Join error: $errorCode',
                    code: errorCode,
                    shouldRetry: true,
                    reconnectStrategy: SfuReconnectionStrategy.migrate,
                  ),
                ),
              ),
            );

            final call = createTestCall(
              sessionFactory: localSessionFactory,
              coordinatorClient: localCoordinator,
            );

            await call.join();

            // First attempt: no migration
            // Subsequent attempts: migration triggered immediately after
            // first failure because the error code is a join error code
            verifyInOrder([
              () => localCoordinator.joinCall(
                callCid: any(named: 'callCid'),
                create: any(named: 'create'),
                migratingFrom: null,
                migratingFromList: any(named: 'migratingFromList'),
                video: any(named: 'video'),
                membersLimit: any(named: 'membersLimit'),
              ),
              () => localSession.start(
                reconnectDetails: any(named: 'reconnectDetails'),
                capabilities: any(named: 'capabilities'),
                onRtcManagerCreatedCallback: any(
                  named: 'onRtcManagerCreatedCallback',
                ),
                isAnonymousUser: any(named: 'isAnonymousUser'),
                unifiedSessionId: any(named: 'unifiedSessionId'),
              ),
              () => localCoordinator.joinCall(
                callCid: any(named: 'callCid'),
                create: any(named: 'create'),
                migratingFrom: SampleCallData.defaultCredentials.sfuServer.name,
                migratingFromList: any(named: 'migratingFromList'),
                video: any(named: 'video'),
                membersLimit: any(named: 'membersLimit'),
              ),
              () => localSession.start(
                reconnectDetails: any(named: 'reconnectDetails'),
                capabilities: any(named: 'capabilities'),
                onRtcManagerCreatedCallback: any(
                  named: 'onRtcManagerCreatedCallback',
                ),
                isAnonymousUser: any(named: 'isAnonymousUser'),
                unifiedSessionId: any(named: 'unifiedSessionId'),
              ),
              () => localCoordinator.joinCall(
                callCid: any(named: 'callCid'),
                create: any(named: 'create'),
                migratingFrom: SampleCallData.defaultCredentials.sfuServer.name,
                migratingFromList: any(named: 'migratingFromList'),
                video: any(named: 'video'),
                membersLimit: any(named: 'membersLimit'),
              ),
              () => localSession.start(
                reconnectDetails: any(named: 'reconnectDetails'),
                capabilities: any(named: 'capabilities'),
                onRtcManagerCreatedCallback: any(
                  named: 'onRtcManagerCreatedCallback',
                ),
                isAnonymousUser: any(named: 'isAnonymousUser'),
                unifiedSessionId: any(named: 'unifiedSessionId'),
              ),
            ]);
          },
        );
      }
    });

    group('non-join SFU errors', () {
      test(
        'should require 2 failures on the same SFU before triggering migration',
        () async {
          when(
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).thenAnswer(
            (_) async => Result.failure(
              VideoErrorWithCause(
                message: 'Internal server error',
                cause: SfuError(
                  message: 'Internal server error',
                  code: SfuErrorCode.internalServerError,
                  shouldRetry: true,
                  reconnectStrategy: SfuReconnectionStrategy.rejoin,
                ),
              ),
            ),
          );

          final call = createTestCall(
            sessionFactory: mockSessionFactory,
            coordinatorClient: coordinatorClient,
          );

          await call.join();

          // Attempt 0: joinCall (no migration) + start (fail)
          // Attempt 1: start only (fail, no joinCall since credentials exist)
          //   → after this, 2 failures on same SFU → migration triggered
          // Attempt 2: joinCall (with migration) + start (fail)
          verifyInOrder([
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: null,
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: SampleCallData.defaultCredentials.sfuServer.name,
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ]);
        },
      );

      test(
        'should not trigger migration for single non-join SFU error',
        () async {
          var callCount = 0;
          when(
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              return Result.failure(
                VideoErrorWithCause(
                  message: 'Participant not found',
                  cause: SfuError(
                    message: 'Participant not found',
                    code: SfuErrorCode.participantNotFound,
                    shouldRetry: true,
                    reconnectStrategy: SfuReconnectionStrategy.rejoin,
                  ),
                ),
              );
            }
            return Result.success(
              (
                callState: createTestSfuCallState(),
                fastReconnectDeadline: Duration.zero,
              ),
            );
          });

          final call = createTestCall(
            sessionFactory: mockSessionFactory,
            coordinatorClient: coordinatorClient,
          );

          final result = await call.join();

          expect(result.isSuccess, isTrue);

          // Only 1 joinCall (the initial one) since the second attempt
          // succeeds without needing migration
          verify(
            () => coordinatorClient.joinCall(
              callCid: any(named: 'callCid'),
              create: any(named: 'create'),
              migratingFrom: any(named: 'migratingFrom'),
              migratingFromList: any(named: 'migratingFromList'),
              video: any(named: 'video'),
              membersLimit: any(named: 'membersLimit'),
            ),
          ).called(1);

          verify(
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).called(2);
        },
      );
    });

    group('max retries exhausted', () {
      test(
        'should leave call after exhausting all retry attempts',
        () async {
          when(
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).thenAnswer(
            (_) async => Result.failure(
              VideoErrorWithCause(
                message: 'Media transport failure',
                cause: SfuError(
                  message: 'Media transport failure',
                  code: SfuErrorCode.participantMediaTransportFailure,
                  shouldRetry: true,
                  reconnectStrategy: SfuReconnectionStrategy.rejoin,
                ),
              ),
            ),
          );

          final call = createTestCall(
            sessionFactory: mockSessionFactory,
            coordinatorClient: coordinatorClient,
          );

          final result = await call.join();

          expect(result.isFailure, isTrue);

          verify(
            () => mockCallSession.start(
              reconnectDetails: any(named: 'reconnectDetails'),
              capabilities: any(named: 'capabilities'),
              onRtcManagerCreatedCallback: any(
                named: 'onRtcManagerCreatedCallback',
              ),
              isAnonymousUser: any(named: 'isAnonymousUser'),
              unifiedSessionId: any(named: 'unifiedSessionId'),
            ),
          ).called(3);
        },
      );
    });

    group('SfuErrorCode.isJoinErrorCode', () {
      test('sfuFull should be a join error code', () {
        expect(SfuErrorCode.sfuFull.isJoinErrorCode, isTrue);
      });

      test('sfuShuttingDown should be a join error code', () {
        expect(SfuErrorCode.sfuShuttingDown.isJoinErrorCode, isTrue);
      });

      test('callParticipantLimitReached should be a join error code', () {
        expect(
          SfuErrorCode.callParticipantLimitReached.isJoinErrorCode,
          isTrue,
        );
      });

      test('non-join error codes should not be join error codes', () {
        final nonJoinCodes = [
          SfuErrorCode.unspecified,
          SfuErrorCode.publishTrackNotFound,
          SfuErrorCode.publishTracksMismatch,
          SfuErrorCode.publishTrackOutOfOrder,
          SfuErrorCode.publishTrackVideoLayerNotFound,
          SfuErrorCode.liveEnded,
          SfuErrorCode.participantNotFound,
          SfuErrorCode.participantMigratingOut,
          SfuErrorCode.participantMigrationFailed,
          SfuErrorCode.participantMigrating,
          SfuErrorCode.participantReconnectFailed,
          SfuErrorCode.participantMediaTransportFailure,
          SfuErrorCode.participantSignalLost,
          SfuErrorCode.callNotFound,
          SfuErrorCode.requestValidationFailed,
          SfuErrorCode.unauthenticated,
          SfuErrorCode.permissionDenied,
          SfuErrorCode.tooManyRequests,
          SfuErrorCode.internalServerError,
        ];

        for (final code in nonJoinCodes) {
          expect(
            code.isJoinErrorCode,
            isFalse,
            reason: '$code should not be a join error code',
          );
        }
      });
    });
  });
}
