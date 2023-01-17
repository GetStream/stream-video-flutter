import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pb.dart';
import 'package:stream_video/src/push_notification/push_notification_manager.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  final streamVideo = StreamVideoMock();
  final callNotificationWrapper = CallNotificationWrapperMock();
  var sut = PushNotificationManager(
      client: streamVideo, callNotification: callNotificationWrapper);
  var call = CallEnvelope(users: {
    '0': User(id: '0', name: "Jc", imageUrl: 'https://domain.com/jc.jpg')
  });
  when(() => streamVideo.getOrCreateCall(
      type: any(named: 'type'),
      id: any(named: 'id'))).thenAnswer((_) => Future.value(call));
  when(() => callNotificationWrapper.showCallNotification(
        callId: any(named: 'callId'),
        callers: any(named: 'callers'),
        isVideoCall: any(named: 'isVideoCall'),
        avatarUrl: any(named: 'avatarUrl'),
        onCallAccepted: any(named: 'onCallAccepted'),
        onCallRejected: any(named: 'onCallRejected'),
      )).thenAnswer((invocation) => Future.value());

  test('A valid RemoteMessage should be handled', () async {
    const remoteMessage = RemoteMessage(data: {
      'sender': 'stream.video',
      'type': 'call_incoming',
      'call_cid': 'call:123',
    });

    final result = await sut.handlePushNotification(remoteMessage);

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

  test("A RemoteMessage without stream.video as sender shouldn't be handled",
      () async {
    const remoteMessage = RemoteMessage(data: {
      'type': 'call_incoming',
      'call_cid': 'call:123',
    });

    final result = await sut.handlePushNotification(remoteMessage);

    expect(result, false);
  });

  test("A RemoteMessage without call_incoming as type shouldn't be handled",
      () async {
    const remoteMessage = RemoteMessage(data: {
      'sender': 'stream.video',
      'call_cid': 'call:123',
    });

    final result = await sut.handlePushNotification(remoteMessage);

    expect(result, false);
  });

  test("A RemoteMessage without a valid call_cid shouldn't be handled",
      () async {
    const remoteMessage = RemoteMessage(data: {
      'sender': 'stream.video',
      'type': 'call_incoming',
    });

    final result = await sut.handlePushNotification(remoteMessage);

    expect(result, false);
  });
}
