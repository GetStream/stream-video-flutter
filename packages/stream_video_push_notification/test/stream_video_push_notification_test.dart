import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pb.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:test/test.dart';

import 'mocks.dart';

Future<void> main() async {
  final streamVideo = StreamVideoMock();
  final callNotificationWrapper = CallNotificationWrapperMock();
  final sharedPreferences = SharedPreferencesMock();
  var sut = await StreamVideoPushNotificationManager.create(
    streamVideo,
    sharedPreferences: sharedPreferences,
    callNotification: callNotificationWrapper,
  );
  var callEnvolope = CallEnvelope(users: {
    '0': User(id: '0', name: "Jc", imageUrl: 'https://domain.com/jc.jpg')
  });
  var call = CallMock();
  when(() => streamVideo.getOrCreateCall(
      type: any(named: 'type'),
      id: any(named: 'id'))).thenAnswer((_) => Future.value(callEnvolope));
  when(() => streamVideo.acceptCall(
      type: any(named: 'type'),
      id: any(named: 'id'))).thenAnswer((invocation) => Future.value(call));
  when(() => streamVideo.rejectCall(callCid: any(named: 'callCid')))
      .thenAnswer((invocation) => Future.value(SendEventResponseMock()));
  when(() => callNotificationWrapper.showCallNotification(
        callId: any(named: 'callId'),
        callers: any(named: 'callers'),
        isVideoCall: any(named: 'isVideoCall'),
        avatarUrl: any(named: 'avatarUrl'),
        onCallAccepted: any(named: 'onCallAccepted'),
        onCallRejected: any(named: 'onCallRejected'),
      )).thenAnswer((invocation) => Future.value());
  when(() => sharedPreferences.setString(any(), any()))
      .thenAnswer((_) => Future.value(true));
  when(sharedPreferences.reload).thenAnswer((_) => Future.value());
  when(() => sharedPreferences.remove('incomingCallCid'))
      .thenAnswer((_) => Future.value(true));

  test('A valid RemoteMessage should be handled', () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call_incoming',
      'call_cid': 'call:123',
    };

    final result = await sut.handlePushNotification(data);

    expect(result, true);
    verify(() => streamVideo.getOrCreateCall(type: 'call', id: '123'))
        .called(1);
    verify(() => callNotificationWrapper.showCallNotification(
          callId: any(named: 'callId', that: equals('call:123')),
          callers: any(named: 'callers', that: equals('Jc')),
          isVideoCall: any(named: 'isVideoCall', that: equals(true)),
          avatarUrl: any(
              named: 'avatarUrl', that: equals('https://domain.com/jc.jpg')),
          onCallAccepted: any(named: 'onCallAccepted'),
          onCallRejected: any(named: 'onCallRejected'),
        )).called(1);
  });

  test('When a call is accepted the cid should be stored on sharedpreferences',
      () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call_incoming',
      'call_cid': 'call:123',
    };
    when(() => callNotificationWrapper.showCallNotification(
          callId: any(named: 'callId'),
          callers: any(named: 'callers'),
          isVideoCall: any(named: 'isVideoCall'),
          avatarUrl: any(named: 'avatarUrl'),
          onCallAccepted: any(named: 'onCallAccepted'),
          onCallRejected: any(named: 'onCallRejected'),
        )).thenAnswer((invocation) {
      final onCallAccepted =
          invocation.namedArguments[const Symbol('onCallAccepted')] as void
              Function(String callId);
      final callId = invocation.namedArguments[const Symbol('callId')];
      onCallAccepted(callId);
      return Future.value();
    });

    await sut.handlePushNotification(data);

    verify(() => sharedPreferences.setString('incomingCallCid', 'call:123'))
        .called(1);
    verify(() => streamVideo.acceptCall(type: 'call', id: '123')).called(1);
  });

  test('When a call is rejected it needs to be rejected on StreamVideo',
      () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call_incoming',
      'call_cid': 'call:123',
    };
    when(() => callNotificationWrapper.showCallNotification(
          callId: any(named: 'callId'),
          callers: any(named: 'callers'),
          isVideoCall: any(named: 'isVideoCall'),
          avatarUrl: any(named: 'avatarUrl'),
          onCallAccepted: any(named: 'onCallAccepted'),
          onCallRejected: any(named: 'onCallRejected'),
        )).thenAnswer((invocation) {
      final onCallRejected =
          invocation.namedArguments[const Symbol('onCallRejected')] as void
              Function(String callId);
      final callId = invocation.namedArguments[const Symbol('callId')];
      onCallRejected(callId);
      return Future.value();
    });

    await sut.handlePushNotification(data);

    verify(() => streamVideo.rejectCall(callCid: 'call:123')).called(1);
  });

  test('When a call was accepted, it should be able to be consumed', () async {
    when(() => sharedPreferences.getString('incomingCallCid'))
        .thenReturn('call:123');
    final resutl = await sut.consumeIncomingCall();

    expect(resutl, call);
    verify(() => streamVideo.acceptCall(
        type: any(named: 'type'), id: any(named: 'id'))).called(1);
  });

  test("When there aren't any accepted call, it shouldn't consume any call",
      () async {
    when(() => sharedPreferences.getString('incomingCallCid')).thenReturn(null);
    final resutl = await sut.consumeIncomingCall();

    expect(resutl, null);
    verifyNever(() =>
        streamVideo.acceptCall(type: any(named: 'type'), id: any(named: 'id')));
  });

  test("A RemoteMessage without stream.video as sender shouldn't be handled",
      () async {
    const data = {
      'type': 'call_incoming',
      'call_cid': 'call:123',
    };

    final result = await sut.handlePushNotification(data);

    expect(result, false);
  });

  test("A RemoteMessage without call_incoming as type shouldn't be handled",
      () async {
    const data = {
      'sender': 'stream.video',
      'call_cid': 'call:123',
    };

    final result = await sut.handlePushNotification(data);

    expect(result, false);
  });

  test("A RemoteMessage without a valid call_cid shouldn't be handled",
      () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call_incoming',
    };

    final result = await sut.handlePushNotification(data);

    expect(result, false);
  });
}
