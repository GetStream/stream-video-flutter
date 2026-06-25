// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    registerFallbackValue(
      StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'fallback-call-id',
      ),
    );
  });

  group('Call.accept optimistic acceptance', () {
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;

    setUp(() {
      mockCoordinatorClient = MockCoordinatorClient();

      when(
        () => mockCoordinatorClient.events,
      ).thenReturn(MutableSharedEmitterImpl<CoordinatorEvent>());

      streamVideo = StreamVideo.create(
        'test-api-key',
        user: User.regular(userId: 'test-user', name: 'Test User'),
        userToken:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU',
        options: StreamVideoOptions(
          allowMultipleActiveCalls: true,
          autoConnect: false,
        ),
      );
    });

    tearDown(() async {
      await StreamVideo.reset();
    });

    Call createIncomingCall() {
      final ringingCallCid = StreamCallCid.from(
        id: 'ringing-call',
        type: StreamCallType.defaultType(),
      );

      final ringingData = CallRingingData(
        callCid: ringingCallCid,
        ringing: true,
        metadata: CallMetadata(
          cid: ringingCallCid,
          details: createTestCallDetails(createdByUserId: 'other-user'),
          settings: const CallSettings(),
          session: const CallSessionData(),
          users: const {},
          members: const {},
        ),
      );

      return Call.fromRinging(
        data: ringingData,
        coordinatorClient: mockCoordinatorClient,
        streamVideo: streamVideo,
        networkMonitor: InternetConnection.createInstance(),
      );
    }

    test(
      'marks call as accepted before coordinator accept completes',
      () async {
        final acceptCompleter = Completer<Result<None>>();
        when(
          () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
        ).thenAnswer((_) => acceptCompleter.future);

        final call = createIncomingCall();
        final acceptFuture = call.accept();

        final statusWhilePending =
            call.state.value.status as CallStatusIncoming;
        expect(statusWhilePending.acceptedByMe, isTrue);

        acceptCompleter.complete(const Result.success(none));
        final result = await acceptFuture;

        expect(result.isSuccess, isTrue);
        final statusAfterSuccess =
            call.state.value.status as CallStatusIncoming;
        expect(statusAfterSuccess.acceptedByMe, isTrue);
      },
    );

    test('reverts acceptedByMe when coordinator accept fails', () async {
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => Result.error('network error'));

      final call = createIncomingCall();
      final result = await call.accept();

      expect(result.isFailure, isTrue);
      final status = call.state.value.status as CallStatusIncoming;
      expect(status.acceptedByMe, isFalse);
    });

    test('allows retry after failed accept', () async {
      var acceptAttempts = 0;
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async {
        acceptAttempts++;
        if (acceptAttempts == 1) {
          return Result.error('network error');
        }
        return const Result.success(none);
      });

      final call = createIncomingCall();

      final firstResult = await call.accept();
      expect(firstResult.isFailure, isTrue);
      expect(
        (call.state.value.status as CallStatusIncoming).acceptedByMe,
        isFalse,
      );

      final secondResult = await call.accept();
      expect(secondResult.isSuccess, isTrue);
      expect(
        (call.state.value.status as CallStatusIncoming).acceptedByMe,
        isTrue,
      );
      expect(acceptAttempts, 2);
    });
  });

  group('CallStateNotifier.lifecycleCallAccepted', () {
    late CallStateNotifier stateNotifier;

    setUp(() {
      stateNotifier = CallStateNotifier(
        CallState(
          callCid: StreamCallCid.from(
            type: StreamCallType.defaultType(),
            id: 'test-call',
          ),
          currentUserId: 'current-user',
          preferences: DefaultCallPreferences(),
        ).copyWith(
          status: CallStatus.incoming(acceptedByMe: false),
        ),
      );
    });

    tearDown(() {
      stateNotifier.dispose();
    });

    test('marks incoming call as accepted', () {
      stateNotifier.lifecycleCallAccepted();

      final status = stateNotifier.state.status as CallStatusIncoming;
      expect(status.acceptedByMe, isTrue);
    });

    test('reverts accepted call to not accepted', () {
      stateNotifier.state = stateNotifier.state.copyWith(
        status: CallStatus.incoming(acceptedByMe: true),
      );

      stateNotifier.lifecycleCallAccepted(accepted: false);

      final status = stateNotifier.state.status as CallStatusIncoming;
      expect(status.acceptedByMe, isFalse);
    });

    test('ignores duplicate accept transition', () {
      stateNotifier.lifecycleCallAccepted();
      final acceptedState = stateNotifier.state;

      stateNotifier.lifecycleCallAccepted();

      expect(stateNotifier.state, same(acceptedState));
    });

    test('ignores duplicate revert transition', () {
      stateNotifier.lifecycleCallAccepted(accepted: false);

      expect(stateNotifier.state.status, isA<CallStatusIncoming>());
      expect(
        (stateNotifier.state.status as CallStatusIncoming).acceptedByMe,
        isFalse,
      );
    });

    test('ignores transition when call is not incoming', () {
      stateNotifier.state = stateNotifier.state.copyWith(
        status: CallStatus.connected(),
      );
      final connectedState = stateNotifier.state;

      stateNotifier.lifecycleCallAccepted();

      expect(stateNotifier.state, same(connectedState));
    });
  });
}
