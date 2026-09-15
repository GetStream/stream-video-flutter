// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../test_helpers.dart';

class MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// On iOS the CallKit screen is up before any Dart code runs, so the user can
/// answer while the app is still starting. The ringing events are broadcast and
/// never replayed, so the `ActionCallAccept` for that answer is gone by the time
/// the app subscribes — `verifyDisplayedIncomingCalls` is the only thing left
/// that can pick the call up.
void main() {
  const cid = 'default:ringing-call';
  const uuid = 'DF7082E5-D3F5-4244-B96B-F10DF50E8CF6';

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    registerFallbackValue(
      StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'fallback-call-id',
      ),
    );
  });

  group('verifyDisplayedIncomingCalls with an answered call', () {
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;
    late MockPushNotificationManager mockPushManager;

    setUp(() {
      // The lost-accept recovery is iOS only; see _acceptDisplayedIncomingCall.
      CurrentPlatform.debugPlatformOverride = PlatformType.ios;
      mockCoordinatorClient = MockCoordinatorClient();
      mockPushManager = MockPushNotificationManager();

      when(
        () => mockCoordinatorClient.events,
      ).thenReturn(MutableSharedEmitterImpl<CoordinatorEvent>());

      when(
        () => mockPushManager.endCallByCid(any(), silent: any(named: 'silent')),
      ).thenAnswer((_) async {});

      streamVideo = StreamVideo.create(
        'test-api-key',
        user: User.regular(userId: 'test-user', name: 'Test User'),
        userToken:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU',
        options: StreamVideoOptions(
          allowMultipleActiveCalls: true,
          autoConnect: false,
        ),
        pushNotificationManagerProvider: (_, _) => mockPushManager,
      );
    });

    tearDown(() async {
      CurrentPlatform.debugPlatformOverride = null;
      await StreamVideo.reset();
    });

    void displayCall({required bool isAccepted}) {
      when(() => mockPushManager.activeCalls()).thenAnswer(
        (_) async => [
          CallData(uuid: uuid, callCid: cid, isAccepted: isAccepted),
        ],
      );
    }

    /// Seeding the incoming call is what a consumed ringing event leaves behind;
    /// it also keeps `consumeIncomingCall` from reaching for the network.
    Call seedIncomingCall() {
      final callCid = StreamCallCid(cid: cid);

      final call = Call.fromRinging(
        data: CallRingingData(
          callCid: callCid,
          ringing: true,
          metadata: CallMetadata(
            cid: callCid,
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

      (streamVideo.state as MutableClientState).incomingCall.value = call;
      return call;
    }

    test('accepts a call that was answered before the app subscribed', () async {
      // The regression: this call used to be skipped outright, on the assumption
      // that the accept flow had it — leaving it answered on the CallKit screen
      // and never joined.
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => Result.error('accept rejected'));

      displayCall(isAccepted: true);
      seedIncomingCall();

      await streamVideo.verifyDisplayedIncomingCalls();

      verify(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).called(1);
    });

    test('ends the native call when accepting it fails', () async {
      // The user is already on an answered CallKit screen at this point, so it
      // must not be left there when the call cannot be accepted.
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => Result.error('accept rejected'));

      displayCall(isAccepted: true);
      seedIncomingCall();

      await streamVideo.verifyDisplayedIncomingCalls();

      verify(() => mockPushManager.endCallByCid(cid)).called(1);
    });

    test('hands the accepted call to onCallAccepted', () async {
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      // Joining is fire-and-forget; fail it fast so the test does not depend on
      // anything past the accept.
      when(
        () => mockCoordinatorClient.joinCall(
          callCid: any(named: 'callCid'),
          create: any(named: 'create'),
          migratingFrom: any(named: 'migratingFrom'),
          migratingFromList: any(named: 'migratingFromList'),
          video: any(named: 'video'),
          membersLimit: any(named: 'membersLimit'),
          e2ee: any(named: 'e2ee'),
        ),
      ).thenAnswer((_) async => Result.error('join rejected'));

      displayCall(isAccepted: true);
      final seeded = seedIncomingCall();

      Call? accepted;
      await streamVideo.verifyDisplayedIncomingCalls(
        onCallAccepted: (call) => accepted = call,
      );

      expect(accepted, same(seeded));
      expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);
    });

    test('does not accept a call that is already accepted here', () async {
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      final call = seedIncomingCall();
      await call.accept();
      clearInteractions(mockCoordinatorClient);

      // A second pass over the displayed calls must be a no-op, not a second
      // accept: `verifyDisplayedIncomingCalls` runs on every
      // `observeCoreRingingEvents`.
      displayCall(isAccepted: true);
      await streamVideo.verifyDisplayedIncomingCalls();

      verifyNever(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      );
    });

    test('ignores a displayed call with no cid', () async {
      when(
        () => mockPushManager.activeCalls(),
      ).thenAnswer((_) async => [const CallData(uuid: uuid, isAccepted: true)]);

      seedIncomingCall();

      await streamVideo.verifyDisplayedIncomingCalls();

      verifyNever(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      );
    });

    test('leaves an answered call alone on Android', () async {
      // Android answers from the app's own notification, so the accept event is
      // not lost there and a terminated-state answer is owned by
      // consumeAndAcceptActiveCall. Accepting here too would hand the app a
      // second onCallAccepted and navigate it twice.
      CurrentPlatform.debugPlatformOverride = PlatformType.android;

      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      displayCall(isAccepted: true);
      seedIncomingCall();

      await streamVideo.verifyDisplayedIncomingCalls();

      verifyNever(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      );
    });
  });

  group('consumeIncomingCall', () {
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;
    late MockPushNotificationManager mockPushManager;

    setUp(() {
      mockCoordinatorClient = MockCoordinatorClient();
      mockPushManager = MockPushNotificationManager();

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
        pushNotificationManagerProvider: (_, _) => mockPushManager,
      );
    });

    tearDown(() async {
      await StreamVideo.reset();
    });

    test('returns the same Call instance for repeated consumes', () async {
      // Two instances for one cid means whichever joins first wins and the other
      // is rejected as "a call with the same cid is in progress" — an app handed
      // the loser renders a Call whose state never advances, so it sits on its
      // connecting UI while the media is already flowing on the other one.
      final callCid = StreamCallCid(cid: cid);
      final metadata = CallMetadata(
        cid: callCid,
        details: createTestCallDetails(createdByUserId: 'other-user'),
        settings: const CallSettings(),
        session: const CallSessionData(),
        users: const {},
        members: const {},
      );

      final first = await streamVideo.consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        metadata: metadata,
      );
      final second = await streamVideo.consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        metadata: metadata,
      );

      expect(first.getDataOrNull(), isNotNull);
      expect(second.getDataOrNull(), same(first.getDataOrNull()));

      // Consuming must not raise the app-facing incoming-call signal: the
      // native screen is already showing this call, and an app that renders its
      // own incoming UI from it would end up with two.
      expect(streamVideo.state.incomingCall.valueOrNull, isNull);
    });

    test('reuses the call the ringing event already created', () async {
      // WS first, push second. consumeIncomingCall must hand back the instance
      // the coordinator event put in state, not build a second one.
      final callCid = StreamCallCid(cid: cid);
      final metadata = CallMetadata(
        cid: callCid,
        details: createTestCallDetails(createdByUserId: 'other-user'),
        settings: const CallSettings(),
        session: const CallSessionData(),
        users: const {},
        members: const {},
      );

      final fromEvent = Call.fromRinging(
        data: CallRingingData(
          callCid: callCid,
          ringing: true,
          metadata: metadata,
        ),
        coordinatorClient: mockCoordinatorClient,
        streamVideo: streamVideo,
        networkMonitor: InternetConnection.createInstance(),
      );
      (streamVideo.state as MutableClientState).incomingCall.value = fromEvent;

      final consumed = await streamVideo.consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        metadata: metadata,
      );

      expect(consumed.getDataOrNull(), same(fromEvent));
    });

    test('keeps the consumed call when the ringing event arrives after', () async {
      // Push first, WS second — the routine cold-start order, since the
      // coordinator only connects once the push has woken the app. Replacing the
      // consumed call here would hand an app listening on state.incomingCall a
      // second Call for the same cid, whose join is rejected as "a call with the
      // same cid is in progress" and whose state therefore never advances.
      final callCid = StreamCallCid(cid: cid);
      final metadata = CallMetadata(
        cid: callCid,
        details: createTestCallDetails(createdByUserId: 'other-user'),
        settings: const CallSettings(),
        session: const CallSessionData(),
        users: const {},
        members: const {},
      );

      final consumed = await streamVideo.consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        metadata: metadata,
      );

      streamVideo.debugHandleCoordinatorEvent(
        CoordinatorCallRingingEvent(
          data: CallRingingData(
            callCid: callCid,
            ringing: true,
            metadata: metadata,
          ),
          video: false,
          sessionId: 'session-id',
          createdAt: DateTime.now(),
        ),
      );

      expect(
        streamVideo.state.incomingCall.valueOrNull,
        same(consumed.getDataOrNull()),
      );
    });

    test('clears the incoming call once it is cleaned up', () async {
      // Nothing else clears it. A stale entry makes a later ring for the same
      // cid look like one that is already on screen, so it is dropped.
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      final callCid = StreamCallCid(cid: cid);
      final metadata = CallMetadata(
        cid: callCid,
        details: createTestCallDetails(createdByUserId: 'other-user'),
        settings: const CallSettings(),
        session: const CallSessionData(),
        users: const {},
        members: const {},
      );

      final consumed = await streamVideo.consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        metadata: metadata,
      );

      // The ringing event is what publishes it.
      streamVideo.debugHandleCoordinatorEvent(
        CoordinatorCallRingingEvent(
          data: CallRingingData(
            callCid: callCid,
            ringing: true,
            metadata: metadata,
          ),
          video: false,
          sessionId: 'session-id',
          createdAt: DateTime.now(),
        ),
      );
      expect(streamVideo.state.incomingCall.valueOrNull, isNotNull);

      await consumed.getDataOrNull()!.leave();

      expect(streamVideo.state.incomingCall.valueOrNull, isNull);
    });

    test(
      'an older call tearing down leaves a newer one for the same cid alone',
      () async {
        // Two Calls can exist for one cid: consumeIncomingCall reuses an instance
        // from state.incomingCall without caching it, and the ringing event only
        // consults the cache, so it builds a second. If the older one's teardown
        // cleared by cid alone it would wipe the newer one's acceptance, and the
        // accepted-event handler would then end its native call.
        when(
          () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
        ).thenAnswer((_) async => const Result.success(none));

        final callCid = StreamCallCid(cid: cid);
        final metadata = CallMetadata(
          cid: callCid,
          details: createTestCallDetails(createdByUserId: 'other-user'),
          settings: const CallSettings(),
          session: const CallSessionData(),
          users: const {},
          members: const {},
        );

        Call makeCall() => Call.fromRinging(
          data: CallRingingData(
            callCid: callCid,
            ringing: true,
            metadata: metadata,
          ),
          coordinatorClient: mockCoordinatorClient,
          streamVideo: streamVideo,
          networkMonitor: InternetConnection.createInstance(),
        );

        final older = makeCall();
        final newer = makeCall();

        await newer.accept();
        expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);

        await older.leave();

        expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);
      },
    );

    test('rings again for a cid that already rang and ended', () async {
      // The reuse guard must not outlive the call it was protecting.
      when(
        () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));

      final callCid = StreamCallCid(cid: cid);
      final metadata = CallMetadata(
        cid: callCid,
        details: createTestCallDetails(createdByUserId: 'other-user'),
        settings: const CallSettings(),
        session: const CallSessionData(),
        users: const {},
        members: const {},
      );

      final first = await streamVideo.consumeIncomingCall(
        uuid: uuid,
        cid: cid,
        metadata: metadata,
      );
      await first.getDataOrNull()!.leave();

      streamVideo.debugHandleCoordinatorEvent(
        CoordinatorCallRingingEvent(
          data: CallRingingData(
            callCid: callCid,
            ringing: true,
            metadata: metadata,
          ),
          video: false,
          sessionId: 'session-id',
          createdAt: DateTime.now(),
        ),
      );

      final second = streamVideo.state.incomingCall.valueOrNull;
      expect(second, isNotNull);
      expect(second, isNot(same(first.getDataOrNull())));
    });
  });

  group('consumeAndAcceptActiveCall alongside the ringing accept flow', () {
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;
    late MockPushNotificationManager mockPushManager;

    setUp(() {
      mockCoordinatorClient = MockCoordinatorClient();
      mockPushManager = MockPushNotificationManager();

      when(
        () => mockCoordinatorClient.events,
      ).thenReturn(MutableSharedEmitterImpl<CoordinatorEvent>());
      when(
        () => mockPushManager.endCallByCid(any(), silent: any(named: 'silent')),
      ).thenAnswer((_) async {});
      when(() => mockPushManager.activeCalls()).thenAnswer(
        (_) async => [
          const CallData(uuid: uuid, callCid: cid, isAccepted: true),
        ],
      );

      streamVideo = StreamVideo.create(
        'test-api-key',
        user: User.regular(userId: 'test-user', name: 'Test User'),
        userToken:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU',
        options: StreamVideoOptions(
          allowMultipleActiveCalls: true,
          autoConnect: false,
        ),
        pushNotificationManagerProvider: (_, _) => mockPushManager,
      );
    });

    tearDown(() async {
      await StreamVideo.reset();
    });

    test(
      'does not hang up a call the other entry point already accepted',
      () async {
        // Both entry points are reachable on one Android cold start, because the
        // carve-out meant to keep them apart reads a lifecycle state that is
        // never `detached` there. A second accept fails the status guard in
        // Call.accept, and that failure path ends the native call — hanging up a
        // call that is already live.
        when(
          () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
        ).thenAnswer((_) async => const Result.success(none));

        final callCid = StreamCallCid(cid: cid);
        final call = Call.fromRinging(
          data: CallRingingData(
            callCid: callCid,
            ringing: true,
            metadata: CallMetadata(
              cid: callCid,
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
        (streamVideo.state as MutableClientState).incomingCall.value = call;

        // The ringing-event flow got there first.
        await call.accept();
        expect(streamVideo.isCallAcceptedOnThisDevice(cid), isTrue);

        Call? handed;
        final result = await streamVideo.consumeAndAcceptActiveCall(
          onCallAccepted: (call) => handed = call,
        );

        expect(result, isTrue);
        expect(handed, same(call));
        verifyNever(
          () =>
              mockPushManager.endCallByCid(any(), silent: any(named: 'silent')),
        );
        // Still exactly the one accept the first flow sent.
        verify(
          () => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')),
        ).called(1);
      },
    );
  });
}
