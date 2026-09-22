// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

/// The acceptance marker exists to close the window between accepting a call
/// and [Call.join] adding it to `activeCalls`. On a cold start that window is
/// where the integrator navigates to its own call UI, and anything that reads
/// `activeCalls` during it cannot tell an accept on this device from an accept
/// on another one — which is how an answered CallKit call got torn down.
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

  group('StreamVideo.isCallAcceptedOnThisDevice', () {
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;

    setUp(() {
      mockCoordinatorClient = MockCoordinatorClient();

      // `thenAnswer`, not `thenReturn`: a SharedEmitter is a Stream, which
      // mocktail refuses to hand back from `thenReturn`.
      final coordinatorEvents = MutableSharedEmitter<CoordinatorEvent>();
      when(() => mockCoordinatorClient.events).thenAnswer(
        (_) => coordinatorEvents,
      );

      streamVideo = StreamVideo.create(
        'test-api-key',
        user: User(id: 'test-user', name: 'Test User'),
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

    const cid = 'default:ringing-call';

    Call createIncomingCall() {
      final ringingCallCid = StreamCallCid.from(
        id: 'ringing-call',
        type: StreamCallType.defaultType(),
      );

      return Call.fromRinging(
        data: CallRingingData(
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
        ),
        coordinatorClient: mockCoordinatorClient,
        streamVideo: streamVideo,
        networkMonitor: InternetConnection.createInstance(),
      );
    }

    test('is false for a call that was never accepted', () {
      createIncomingCall();

      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isFalse);
    });

    test('is set before the coordinator accept completes', () async {
      // The ordering this whole fix rests on. The coordinator cannot report the
      // call as accepted by us — over the WS or in `session.acceptedBy` — before
      // it has received this request, so a marker that is already set while the
      // request is in flight can never be observed too late.
      final acceptCompleter = Completer<Result<None>>();
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) => acceptCompleter.future);

      final call = createIncomingCall();
      final acceptFuture = call.accept();

      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);

      acceptCompleter.complete(const Result.success(none));
      await acceptFuture;

      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);
    });

    test('stays set while the call is accepted but not yet joined', () async {
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      final call = createIncomingCall();
      await call.accept();

      // Exactly the state a cold start is in while the integrator navigates to
      // its call screen: accepted, but `join()` has not run.
      expect(streamVideo.activeCalls, isEmpty);
      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);
    });

    test('is cleared when the coordinator accept fails', () async {
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => failureWithError('network error'));

      final call = createIncomingCall();
      final result = await call.accept();

      expect(result.isFailure, isTrue);
      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isFalse);
    });

    test('is cleared once the call is cleaned up', () async {
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      final call = createIncomingCall();
      await call.accept();
      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);

      await call.leave();

      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isFalse);
    });

    test('is tracked per cid', () async {
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      final call = createIncomingCall();
      await call.accept();

      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);
      expect(
        streamVideo.isCallAcceptedOnThisDevice('default:some-other-call'),
        isFalse,
      );
    });
  });
}
