import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import '../fixtures/stream_video_fixture.dart';

class _MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// Pins the native call screen's decline and end, the auto-reject of an
/// unanswered ring, the ringing pushes, and both ways of accepting a call
/// answered on the native call screen.
void main() {
  const cid = 'default:ringing-call';
  const uuid = 'DF7082E5-D3F5-4244-B96B-F10DF50E8CF6';
  const caller = 'caller-user';
  final callCid = StreamCallCid(cid: cid);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const UserInfo(id: 'fallback'));
    registerFallbackValue(callCid);
  });

  late _MockPushNotificationManager push;
  late StreamController<RingingEvent> nativeEvents;
  late StreamVideoFixture fixture;

  RingingCallCoordinator ringing() => fixture.streamVideo.ringing;

  CallMetadata metadata({
    CallSessionData session = const CallSessionData(),
    Duration autoRejectTimeout = const Duration(seconds: 30),
  }) => CallMetadata(
    cid: callCid,
    details: createTestCallDetails(createdByUserId: caller),
    settings: CallSettings(
      ring: StreamRingSettings(autoRejectTimeout: autoRejectTimeout),
    ),
    session: session,
    users: const {},
    members: const {},
  );

  void getCallReturns(CallMetadata metadata) {
    when(
      () => fixture.client.getCall(
        callCid: any(named: 'callCid'),
        membersLimit: any(named: 'membersLimit'),
        ringing: any(named: 'ringing'),
        notify: any(named: 'notify'),
        video: any(named: 'video'),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        CallReceivedData(callCid: callCid, metadata: metadata),
      ),
    );
  }

  /// The ring the coordinator sends, which leaves an incoming call behind.
  Call ring() {
    fixture.streamVideo.debugHandleCoordinatorEvent(
      CoordinatorCallRingingEvent(
        data: CallRingingData(
          callCid: callCid,
          ringing: true,
          metadata: metadata(),
        ),
        video: false,
        sessionId: 'session-id',
        createdAt: DateTime.now(),
      ),
    );
    return fixture.streamVideo.state.incomingCall.value!;
  }

  VerificationResult verifyRejected(CallRejectReason reason) => verify(
    () => fixture.client.rejectCall(cid: callCid, reason: reason.value),
  );

  setUp(() {
    push = _MockPushNotificationManager();
    nativeEvents = StreamController<RingingEvent>.broadcast();
    when(() => push.onCallEvent).thenAnswer((_) => nativeEvents.stream);
    when(push.dispose).thenAnswer((_) async {});
    when(push.unregisterDevice).thenAnswer((_) async {});
    when(push.activeCalls).thenAnswer((_) async => []);
    when(
      () => push.endCallByCid(any(), silent: any(named: 'silent')),
    ).thenAnswer((_) async {});
    when(
      () => push.showIncomingCall(
        uuid: any(named: 'uuid'),
        callCid: any(named: 'callCid'),
        handle: any(named: 'handle'),
        callerName: any(named: 'callerName'),
        hasVideo: any(named: 'hasVideo'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => push.showMissedCall(
        uuid: any(named: 'uuid'),
        callCid: any(named: 'callCid'),
        handle: any(named: 'handle'),
        callerName: any(named: 'callerName'),
      ),
    ).thenAnswer((_) async {});

    fixture = StreamVideoFixture(
      options: StreamVideoOptions(
        autoConnect: false,
        allowMultipleActiveCalls: true,
      ),
      pushNotificationManagerProvider: (_, _) => push,
    );
    when(
      () => fixture.client.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => fixture.client.acceptCall(cid: any(named: 'cid')),
    ).thenAnswer((_) async => failureWithError('accept refused'));
    getCallReturns(metadata());
  });

  tearDown(() async {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    await fixture.dispose();
    await nativeEvents.close();
  });

  group('the native call screen', () {
    test('a decline rejects the ringing call', () async {
      ring();
      ringing().observeCallDeclinedRingingEvent();

      nativeEvents.add(
        ActionCallDecline(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await pumpEventQueue();

      verifyRejected(CallRejectReason.decline()).called(1);
    });

    test('an end on iOS rejects the incoming call', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
      ring();
      ringing().observeCallEndedRingingEvent();

      nativeEvents.add(
        ActionCallEnded(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await pumpEventQueue();

      verifyRejected(CallRejectReason.callEnded()).called(1);
    });

    test('an end on Android is ignored unless the system ended it', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      ring();
      ringing().observeCallEndedRingingEvent();

      nativeEvents.add(
        ActionCallEnded(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await pumpEventQueue();
      verifyNever(
        () => fixture.client.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      );

      nativeEvents.add(
        ActionCallEnded(
          data: CallData(uuid: uuid, callCid: cid, endedBySystem: true),
        ),
      );
      await pumpEventQueue();
      verifyRejected(CallRejectReason.callEnded()).called(1);
    });
  });

  group('the auto-reject timer', () {
    const timeout = Duration(milliseconds: 50);

    setUp(() => getCallReturns(metadata(autoRejectTimeout: timeout)));

    test('rejects a ring nobody answers', () async {
      ringing().observeCallIncomingRingingEvent();

      nativeEvents.add(
        ActionCallIncoming(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await pumpEventQueue();
      verifyNever(
        () => fixture.client.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      );

      await Future<void>.delayed(timeout * 3);
      verifyRejected(CallRejectReason.timeout()).called(1);
    });

    test('is cancelled by a decline', () async {
      ringing()
        ..observeCallIncomingRingingEvent()
        ..observeCallDeclinedRingingEvent();

      nativeEvents.add(
        ActionCallIncoming(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await pumpEventQueue();
      nativeEvents.add(
        ActionCallDecline(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await Future<void>.delayed(timeout * 3);

      verifyRejected(CallRejectReason.decline()).called(1);
      verifyNever(
        () => fixture.client.rejectCall(
          cid: callCid,
          reason: CallRejectReason.timeout().value,
        ),
      );
    });

    test('is cancelled when the client is disposed', () async {
      ringing().observeCallIncomingRingingEvent();
      nativeEvents.add(
        ActionCallIncoming(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await pumpEventQueue();

      ringing().dispose();
      await Future<void>.delayed(timeout * 3);

      verifyNever(
        () => fixture.client.rejectCall(
          cid: callCid,
          reason: CallRejectReason.timeout().value,
        ),
      );
    });
  });

  group('handleRingingFlowNotifications', () {
    Map<String, dynamic> pushOf(String type) => {
      'sender': 'stream.video',
      'type': type,
      'call_cid': cid,
      'created_by_id': caller,
      'created_by_display_name': 'Caller',
    };

    test('shows a ringing call that still rings', () async {
      final handled = await ringing().handleRingingFlowNotifications(
        pushOf('call.ring'),
      );

      expect(handled, isTrue);
      verify(
        () => push.showIncomingCall(
          uuid: any(named: 'uuid'),
          callCid: cid,
          handle: caller,
          callerName: 'Caller',
          hasVideo: true,
        ),
      ).called(1);
    });

    test('does not show a ringing call that was cancelled', () async {
      getCallReturns(
        metadata(
          session: CallSessionData(rejectedBy: {caller: DateTime.now()}),
        ),
      );

      final handled = await ringing().handleRingingFlowNotifications(
        pushOf('call.ring'),
      );

      expect(handled, isFalse);
      verifyNever(
        () => push.showIncomingCall(
          uuid: any(named: 'uuid'),
          callCid: any(named: 'callCid'),
          handle: any(named: 'handle'),
          callerName: any(named: 'callerName'),
          hasVideo: any(named: 'hasVideo'),
        ),
      );
    });

    test('shows a missed call', () async {
      final handled = await ringing().handleRingingFlowNotifications(
        pushOf('call.missed'),
      );

      expect(handled, isTrue);
      verify(
        () => push.showMissedCall(
          uuid: any(named: 'uuid'),
          callCid: cid,
          handle: caller,
          callerName: 'Caller',
        ),
      ).called(1);
    });

    test('ignores a push that is not from Stream', () async {
      final handled = await ringing().handleRingingFlowNotifications(const {
        'sender': 'some.other.app',
      });

      expect(handled, isFalse);
    });
  });

  group('getCallRingingState', () {
    test('reads the ringing state for the current user', () async {
      final state = await ringing().getCallRingingState(
        callType: StreamCallType.defaultType(),
        id: 'ringing-call',
      );

      expect(state, CallRingingState.ringing);
    });

    test('is ended when the call cannot be read', () async {
      when(
        () => fixture.client.getCall(
          callCid: any(named: 'callCid'),
          membersLimit: any(named: 'membersLimit'),
          ringing: any(named: 'ringing'),
          notify: any(named: 'notify'),
          video: any(named: 'video'),
        ),
      ).thenAnswer((_) async => failureWithError('not found'));

      final state = await ringing().getCallRingingState(
        callType: StreamCallType.defaultType(),
        id: 'ringing-call',
      );

      expect(state, CallRingingState.ended);
    });
  });

  group('accepting a call answered on the native call screen', () {
    test(
      'consumeAndAcceptActiveCall connects before it consumes the call',
      () async {
        when(push.activeCalls).thenAnswer(
          (_) async => [CallData(uuid: uuid, callCid: cid, isAccepted: true)],
        );

        final accepted = await ringing().consumeAndAcceptActiveCall();

        // The accept is refused, so the native call is ended.
        expect(accepted, isFalse);
        verifyInOrder([
          () => fixture.client.connectUser(
            any(),
            includeUserDetails: any(named: 'includeUserDetails'),
          ),
          () => fixture.client.getCall(callCid: callCid),
          () => fixture.client.acceptCall(cid: callCid),
          () => push.endCallByCid(cid),
        ]);
      },
    );

    test('an accept event accepts without connecting first', () async {
      ring();
      ringing().observeCallAcceptRingingEvent();

      nativeEvents.add(
        ActionCallAccept(
          data: CallData(uuid: uuid, callCid: cid),
        ),
      );
      await pumpEventQueue();

      verify(() => fixture.client.acceptCall(cid: callCid)).called(1);
      verify(() => push.endCallByCid(cid)).called(1);
      verifyNever(
        () => fixture.client.connectUser(
          any(),
          includeUserDetails: any(named: 'includeUserDetails'),
        ),
      );
    });

    test('a call accepted elsewhere on this client is handed over', () async {
      final call = ring();
      fixture.streamVideo.state.markCallAcceptedOnThisDevice(callCid, call);
      when(push.activeCalls).thenAnswer(
        (_) async => [CallData(uuid: uuid, callCid: cid, isAccepted: true)],
      );

      Call? handed;
      final accepted = await ringing().consumeAndAcceptActiveCall(
        onCallAccepted: (call) => handed = call,
      );

      expect(accepted, isTrue);
      expect(handed, same(call));
      verifyNever(() => fixture.client.acceptCall(cid: any(named: 'cid')));
    });
  });
}
