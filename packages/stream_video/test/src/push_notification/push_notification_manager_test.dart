import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pb.dart';
import 'package:stream_video/src/push_notification/push_notification_manager.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  final streamVideo = StreamVideoMock();
  var sut = PushNotificationManager(client: streamVideo);
  var call = CallEnvelope(users: {'0': User(id: '0', name: "Jc")});
  when(() => streamVideo.getOrCreateCall(
      type: any(named: 'type'),
      id: any(named: 'id'))).thenAnswer((_) => Future.value(call));

  test('A valid RemoteMessage should be handled', () async {
    const remoteMessage = RemoteMessage(data: {
      'sender': 'stream.video',
      'type': 'call_incoming',
      'call_cid': 'call:123',
    });

    final result = await sut.handlePushNotification(remoteMessage);

    expect(result, true);
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
