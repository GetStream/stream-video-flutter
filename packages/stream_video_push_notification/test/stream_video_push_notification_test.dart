import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/src/utils/none.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_push_notification_event_channel.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:test/test.dart';

import 'mocks.dart';

Future<void> main() async {
  final client = CoordinatorClientMock();
  final callNotificationWrapper = CallNotificationWrapperMock();
  final sharedPreferences = SharedPreferencesMock();
  final eventChannelMock = EventChannelMock();
  final streamVideoEventChannel =
      StreamVideoPushNotificationEventChannel(eventChannel: eventChannelMock);
  final StreamCallCid streamCallCid = StreamCallCid(cid: 'call:123');
  final callCreatedData = CallCreatedData(
    callCid: streamCallCid,
    metadata: CallMetadata(
      cid: streamCallCid,
      details: const CallDetails(
        hlsPlaylistUrl: '',
        createdBy: CallUser(
          id: "jc",
          name: "JC M",
          role: 'admin',
          image: '',
        ),
        team: '',
        ownCapabilities: [],
        blockedUserIds: [],
        broadcasting: false,
        recording: false,
        backstage: false,
        transcribing: false,
        custom: {},
        rtmpIngress: '',
      ),
      settings: const CallSettings(),
      users: const {
        'jc': CallUser(
          id: "jc",
          name: "Jc",
          role: "role",
          image: "https://mydomain.io/jc.png",
        ),
        'isa': CallUser(
          id: "isa",
          name: "Isa",
          role: "role",
          image: "https://mydomain.io/isa.png",
        ),
      },
      members: const {},
    ),
  );
  final callReceivedOrCreated = CallReceivedOrCreatedData(
    wasCreated: true,
    data: callCreatedData,
  );
  when(() => eventChannelMock.receiveBroadcastStream())
      .thenAnswer((_) => const Stream.empty());
  when(() => client.events)
      .thenAnswer((invocation) => MutableSharedEmitterImpl());
  when(() => client.getOrCreateCall(
        callCid: streamCallCid,
      )).thenAnswer((_) => Future.value(Result.success(callReceivedOrCreated)));
  when(() => client.acceptCall(cid: streamCallCid))
      .thenAnswer((invocation) => Future.value(const Result.success(none)));
  when(() => client.rejectCall(cid: streamCallCid))
      .thenAnswer((invocation) => Future.value(const Result.success(none)));
  registerFallbackValue(streamCallCid);
  when(() => callNotificationWrapper.showCallNotification(
        streamCallCid: any(named: 'streamCallCid'),
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

  final factory = StreamVideoPushNotificationManager.factory(
    sharedPreferences: sharedPreferences,
    callNotification: callNotificationWrapper,
    eventChannel: streamVideoEventChannel,
  );
  final sut = await factory(client);

  test('A valid RemoteMessage should be handled', () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call.incoming',
      'call_cid': 'call:123',
    };

    final result = await sut.handlePushNotification(data);

    expect(result, true);
    verify(() => client.getOrCreateCall(callCid: streamCallCid,
        )).called(1);
    verify(() => callNotificationWrapper.showCallNotification(
          streamCallCid:
              any(named: 'streamCallCid', that: equals(streamCallCid)),
          callers: any(named: 'callers', that: equals("Jc, Isa")),
          isVideoCall: any(named: 'isVideoCall', that: equals(true)),
          avatarUrl: any(
              named: 'avatarUrl', that: equals("https://mydomain.io/jc.png")),
          onCallAccepted: any(named: 'onCallAccepted'),
          onCallRejected: any(named: 'onCallRejected'),
        )).called(1);
  });

  test('When a call is accepted the cid should be stored on sharedpreferences',
      () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call.incoming',
      'call_cid': 'call:123',
    };
    when(() => callNotificationWrapper.showCallNotification(
          streamCallCid:
              any(named: 'streamCallCid', that: equals(streamCallCid)),
          callers: any(named: 'callers'),
          isVideoCall: any(named: 'isVideoCall'),
          avatarUrl: any(named: 'avatarUrl'),
          onCallAccepted: any(named: 'onCallAccepted'),
          onCallRejected: any(named: 'onCallRejected'),
        )).thenAnswer((invocation) {
      final onCallAccepted =
          invocation.namedArguments[const Symbol('onCallAccepted')] as void
              Function(StreamCallCid streamCallCid);
      final callId = invocation.namedArguments[const Symbol('streamCallCid')];
      onCallAccepted(callId);
      return Future.value();
    });

    await sut.handlePushNotification(data);

    verify(() => sharedPreferences.setString('incomingCallCid', 'call:123'))
        .called(1);
    verify(() => client.getOrCreateCall(callCid: streamCallCid,
        )).called(1);
    verify(() => client.acceptCall(cid: streamCallCid)).called(1);
  });

  test('When a call is rejected it needs to be rejected on StreamVideo',
      () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call.incoming',
      'call_cid': 'call:123',
    };
    when(() => callNotificationWrapper.showCallNotification(
          streamCallCid:
              any(named: 'streamCallCid', that: equals(streamCallCid)),
          callers: any(named: 'callers'),
          isVideoCall: any(named: 'isVideoCall'),
          avatarUrl: any(named: 'avatarUrl'),
          onCallAccepted: any(named: 'onCallAccepted'),
          onCallRejected: any(named: 'onCallRejected'),
        )).thenAnswer((invocation) {
      final onCallRejected =
          invocation.namedArguments[const Symbol('onCallRejected')] as void
              Function(StreamCallCid streamCallCid);
      final callId = invocation.namedArguments[const Symbol('streamCallCid')];
      onCallRejected(callId);
      return Future.value();
    });

    await sut.handlePushNotification(data);

    verify(() => client.rejectCall(cid: streamCallCid)).called(1);
    verify(() => client.getOrCreateCall(callCid: streamCallCid,
        )).called(1);
  });

  test('When a call was accepted, it should be able to be consumed', () async {
    when(() => sharedPreferences.getString('incomingCallCid'))
        .thenReturn('call:123');
    final result = await sut.consumeIncomingCall();

    expect(result, callCreatedData);
    verify(
      () => client.getOrCreateCall(callCid: streamCallCid,
      ),
    ).called(1);
  });

  test("When there aren't any accepted call, it shouldn't consume any call",
      () async {
    when(() => sharedPreferences.getString('incomingCallCid')).thenReturn(null);
    final result = await sut.consumeIncomingCall();

    expect(result, null);
    verifyNever(() => client.acceptCall(cid: streamCallCid));
  });

  test("A RemoteMessage without stream.video as sender shouldn't be handled",
      () async {
    const data = {
      'type': 'call.incoming',
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
      'type': 'call.incoming',
    };

    final result = await sut.handlePushNotification(data);

    expect(result, false);
  });
}
