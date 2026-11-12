import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/outgoing_call_reporter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

class _MockManager extends Mock implements PushNotificationManager {}

class _MockCall extends Mock implements Call {}

class _MockCallStateEmitter extends Mock implements StateEmitter<CallState> {}

const _me = 'caller';

CallMemberState _member(String userId, {String? name}) => CallMemberState(
  userId: userId,
  roles: const [],
  name: name ?? userId,
  custom: const {},
);

/// A call whose status the test drives.
class _FakeCall {
  _FakeCall({
    String id = 'call-id',
    List<CallMemberState>? members,
    bool video = true,
  }) {
    final cid = StreamCallCid.from(type: StreamCallType.defaultType(), id: id);
    final emitter = _MockCallStateEmitter();
    when(() => emitter.value).thenReturn(
      CallState(
        callCid: cid,
        currentUserId: _me,
        preferences: DefaultCallPreferences(),
      ).copyWith(
        callMembers:
            members ?? [_member(_me), _member('ada', name: 'Ada Lovelace')],
        settings: CallSettings(video: StreamVideoSettings(enabled: video)),
      ),
    );
    // `thenAnswer`: a StateEmitter is a Stream, which `thenReturn` refuses.
    when(() => call.state).thenAnswer((_) => emitter);
    when(() => call.callCid).thenReturn(cid);
    when(
      () => call.partialState<CallStatus>(any()),
    ).thenAnswer((_) => status.stream);
    when(
      () => call.leave(reason: any(named: 'reason')),
    ).thenAnswer((_) async => const Result.success(none));
  }

  final call = _MockCall();

  // Left open unless a test closes it: an open state stream is a call that goes on.
  // ignore: close_sinks
  final status = StreamController<CallStatus>(sync: true);
}

class _Harness {
  _Harness() {
    when(
      () => manager.startOutgoingCall(
        uuid: any(named: 'uuid'),
        callCid: any(named: 'callCid'),
        avatar: any(named: 'avatar'),
        handle: any(named: 'handle'),
        callerName: any(named: 'callerName'),
        hasVideo: any(named: 'hasVideo'),
      ),
    ).thenAnswer((_) async {});
    when(() => manager.setCallConnected(any())).thenAnswer((_) async {});
    when(() => manager.endCall(any())).thenAnswer((_) async {});
    when(() => manager.onCallEvent).thenAnswer((_) => events.stream);

    reporter = OutgoingCallReporter(
      manager: manager,
      outgoingCalls: outgoing.stream,
      isActive: active.contains,
      newUuid: () => 'uuid-${++_uuids}',
    );
  }

  final manager = _MockManager();
  final outgoing = StreamController<Call?>(sync: true);
  final events = StreamController<RingingEvent>.broadcast(sync: true);
  final active = <Call>{};
  late final OutgoingCallReporter reporter;
  var _uuids = 0;

  /// Makes [call] the outgoing call and rings it.
  _FakeCall ring([_FakeCall? call]) {
    final fake = call ?? _FakeCall();
    outgoing.add(fake.call);
    fake.status.add(CallStatus.outgoing());
    return fake;
  }

  void callKitEnds(RingingEvent Function(CallData data) event, String uuid) {
    events.add(event(CallData(uuid: uuid, callCid: 'default:call-id')));
  }

  void verifyStarted({
    required String uuid,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  }) {
    verify(
      () => manager.startOutgoingCall(
        uuid: uuid,
        callCid: 'default:call-id',
        handle: handle,
        callerName: callerName,
        hasVideo: hasVideo,
      ),
    ).called(1);
  }

  void verifyNotStarted() {
    verifyNever(
      () => manager.startOutgoingCall(
        uuid: any(named: 'uuid'),
        callCid: any(named: 'callCid'),
        avatar: any(named: 'avatar'),
        handle: any(named: 'handle'),
        callerName: any(named: 'callerName'),
        hasVideo: any(named: 'hasVideo'),
      ),
    );
  }
}

/// Lets the reporter's unawaited platform calls run.
Future<void> _settle() => pumpEventQueue();

void main() {
  setUpAll(() {
    registerFallbackValue((CallState state) => state.status);
    registerFallbackValue(DisconnectReason.nativeCallEnded());
  });

  late _Harness harness;

  setUp(() => harness = _Harness());
  tearDown(() => harness.reporter.dispose());

  group('starting', () {
    test('reports a call to CallKit once it rings', () async {
      final call = _FakeCall();
      harness.outgoing.add(call.call);
      call.status.add(CallStatus.idle());
      await _settle();
      harness.verifyNotStarted();

      call.status.add(CallStatus.outgoing());
      await _settle();

      harness.verifyStarted(
        uuid: 'uuid-1',
        handle: 'ada',
        callerName: 'Ada Lovelace',
      );
    });

    test('reports it once, whatever the ring does', () async {
      final call = harness.ring();
      call.status.add(CallStatus.outgoing(acceptedByCallee: true));
      await _settle();

      harness.verifyStarted(
        uuid: 'uuid-1',
        handle: 'ada',
        callerName: 'Ada Lovelace',
      );
    });

    test('names every callee of a group call, by id when unnamed', () async {
      harness.ring(
        _FakeCall(
          members: [
            _member(_me),
            _member('ada', name: 'Ada'),
            _member('grace', name: ''),
          ],
          video: false,
        ),
      );
      await _settle();

      // CallKit needs one handle, so a group call is known by its id.
      harness.verifyStarted(
        uuid: 'uuid-1',
        handle: 'call-id',
        callerName: 'Ada, grace',
        hasVideo: false,
      );
    });

    test('does not report a call that never rings', () async {
      final call = _FakeCall();
      harness.outgoing.add(call.call);
      call.status
        ..add(CallStatus.idle())
        ..add(CallStatus.connecting())
        ..add(CallStatus.connected())
        ..add(CallStatus.disconnected(const DisconnectReason.ended()));
      await _settle();

      harness.verifyNotStarted();
      verifyNever(() => harness.manager.setCallConnected(any()));
      verifyNever(() => harness.manager.endCall(any()));
    });

    test('follows the same call once when it is emitted again', () async {
      final call = harness.ring();
      harness.outgoing.add(call.call);
      await _settle();

      verify(() => call.call.partialState<CallStatus>(any())).called(1);
    });
  });

  group('connecting', () {
    test('marks the CallKit call connected once the call connects', () async {
      final call = harness.ring();
      call.status.add(CallStatus.connecting());
      await _settle();
      verifyNever(() => harness.manager.setCallConnected(any()));

      call.status.add(CallStatus.connected());
      await _settle();

      verify(() => harness.manager.setCallConnected('uuid-1')).called(1);
    });

    test('does not mark it connected again after a reconnect', () async {
      final call = harness.ring();
      call.status
        ..add(CallStatus.connected())
        ..add(CallStatus.reconnecting(1))
        ..add(CallStatus.connected());
      await _settle();

      verify(() => harness.manager.setCallConnected('uuid-1')).called(1);
    });
  });

  group('ending', () {
    test('ends the CallKit call when the call disconnects', () async {
      final call = harness.ring();
      call.status
        ..add(CallStatus.disconnected(DisconnectReason.lastParticipantLeft()))
        ..add(CallStatus.disconnected(const DisconnectReason.ended()));
      await _settle();

      verify(() => harness.manager.endCall('uuid-1')).called(1);
    });

    test('ends it when the call state closes', () async {
      final call = harness.ring();
      await call.status.close();
      await _settle();

      verify(() => harness.manager.endCall('uuid-1')).called(1);
    });

    test(
      'ends it when the call stops being the outgoing one unjoined',
      () async {
        harness.ring();
        harness.outgoing.add(null);
        await _settle();

        verify(() => harness.manager.endCall('uuid-1')).called(1);
      },
    );

    test('keeps a joined call until it disconnects', () async {
      final call = harness.ring();
      harness.active.add(call.call);
      harness.outgoing.add(null);
      await _settle();
      verifyNever(() => harness.manager.endCall(any()));

      call.status.add(CallStatus.disconnected(const DisconnectReason.ended()));
      await _settle();

      verify(() => harness.manager.endCall('uuid-1')).called(1);
    });

    test('reports a second outgoing call under its own uuid', () async {
      harness.ring();
      harness.ring(_FakeCall());
      await _settle();

      verify(() => harness.manager.endCall('uuid-1')).called(1);
      harness.verifyStarted(
        uuid: 'uuid-2',
        handle: 'ada',
        callerName: 'Ada Lovelace',
      );
    });
  });

  group('ended in CallKit', () {
    test('leaves a call that still rings, which cancels the ring', () async {
      final call = harness.ring();
      await _settle();

      harness.callKitEnds((data) => ActionCallEnded(data: data), 'uuid-1');
      await _settle();
      verify(
        () => call.call.leave(reason: DisconnectReason.nativeCallEnded()),
      ).called(1);

      call.status.add(CallStatus.disconnected(const DisconnectReason.ended()));
      await _settle();
      // CallKit already ended it.
      verifyNever(() => harness.manager.endCall(any()));
    });

    test('leaves a joined call to the ringing flow coordinator', () async {
      final call = harness.ring();
      harness.active.add(call.call);

      harness.callKitEnds((data) => ActionCallEnded(data: data), 'uuid-1');
      call.status.add(CallStatus.disconnected(const DisconnectReason.ended()));
      await _settle();

      verifyNever(() => call.call.leave(reason: any(named: 'reason')));
      verifyNever(() => harness.manager.endCall(any()));
    });

    test('leaves a declined call to the ringing flow coordinator', () async {
      final call = harness.ring();

      harness.callKitEnds((data) => ActionCallDecline(data: data), 'uuid-1');
      call.status.add(CallStatus.disconnected(const DisconnectReason.ended()));
      await _settle();

      verifyNever(() => call.call.leave(reason: any(named: 'reason')));
      verifyNever(() => harness.manager.endCall(any()));
    });

    test('ignores the end of another CallKit call', () async {
      final call = harness.ring();

      harness.callKitEnds((data) => ActionCallEnded(data: data), 'other');
      await _settle();

      verifyNever(() => call.call.leave(reason: any(named: 'reason')));
    });
  });

  test('stops following calls once disposed', () async {
    final call = harness.ring();
    await harness.reporter.dispose();

    call.status.add(CallStatus.disconnected(const DisconnectReason.ended()));
    harness.outgoing.add(null);
    await _settle();

    verifyNever(() => harness.manager.endCall(any()));
  });

  group('IOSPushConfiguration.reportOutgoingCalls', () {
    test('is off unless set', () {
      expect(const IOSPushConfiguration().reportOutgoingCalls, isNull);
      expect(
        const StreamVideoPushConfiguration(
          ios: IOSPushConfiguration(iconName: 'Icon'),
        ).merge(null).ios?.reportOutgoingCalls,
        isNull,
      );
    });

    test('survives a merge that does not set it', () {
      const configured = IOSPushConfiguration(reportOutgoingCalls: true);

      expect(
        configured
            .merge(const IOSPushConfiguration(iconName: 'Icon'))
            .reportOutgoingCalls,
        isTrue,
      );
      expect(
        configured
            .merge(const IOSPushConfiguration(reportOutgoingCalls: false))
            .reportOutgoingCalls,
        isFalse,
      );
    });

    test('round-trips through JSON', () {
      const configured = IOSPushConfiguration(reportOutgoingCalls: true);

      expect(
        IOSPushConfiguration.fromJson(configured.toJson()).reportOutgoingCalls,
        isTrue,
      );
    });
  });
}
