import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/src/utils/none.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_push_notification_event_channel.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:test/test.dart';

import 'mocks.dart';

Future<void> main() async {
  final streamVideo = StreamVideoMock();
  final callNotificationWrapper = CallNotificationWrapperMock();
  final sharedPreferences = SharedPreferencesMock();
  final eventChannelMock = EventChannelMock();
  final streamVideoEventChannel =
      StreamVideoPushNotificationEventChannel(eventChannel: eventChannelMock);
  final StreamCallCid streamCallCid = StreamCallCid(cid: 'call:123');
  final callCreatedData = CallCreated(
    callCid: streamCallCid,
    ringing: true,
    metadata: CallMetadata(
      details: const CallDetails(
        members: {},
        ownCapabilities: [],
        settings: CallSettings.enabled(),
        isBroadcastingEnabled: false,
        isRecordingEnabled: false,
      ),
      info: CallInfo(
        cid: streamCallCid,
        createdByUserId: 'Jc',
      ),
      users: const {
        'jc': CallUser(
            id: "jc",
            name: "Jc",
            role: "role",
            imageUrl: "https://mydomain.io/jc.png",
            teams: []),
        'isa': CallUser(
            id: "isa",
            name: "Isa",
            role: "role",
            imageUrl: "https://mydomain.io/isa.png",
            teams: []),
      },
    ),
  );
  final callReceivedOrCreated = CallReceivedOrCreated(
    wasCreated: true,
    data: callCreatedData,
  );
  when(() => eventChannelMock.receiveBroadcastStream())
      .thenAnswer((_) => const Stream.empty());
  when(() => streamVideo.events)
      .thenAnswer((invocation) => MutableSharedEmitterImpl());
  when(() => streamVideo.getOrCreateCall(cid: streamCallCid))
      .thenAnswer((_) => Future.value(Result.success(callReceivedOrCreated)));
  when(() => streamVideo.acceptCall(cid: streamCallCid))
      .thenAnswer((invocation) => Future.value(Result.success(None())));
  when(() => streamVideo.rejectCall(cid: streamCallCid))
      .thenAnswer((invocation) => Future.value(Result.success(None())));
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

  var sut = await StreamVideoPushNotificationManager.create(
    streamVideo,
    sharedPreferences: sharedPreferences,
    callNotification: callNotificationWrapper,
    eventChannel: streamVideoEventChannel,
  );

  test('A valid RemoteMessage should be handled', () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call_incoming',
      'call_cid': 'call:123',
    };

    final result = await sut.handlePushNotification(data);

    expect(result, true);
    verify(() => streamVideo.getOrCreateCall(cid: streamCallCid)).called(1);
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
      'type': 'call_incoming',
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
    verify(() => streamVideo.getOrCreateCall(
        cid: any(named: 'cid', that: equals(streamCallCid)))).called(1);
    verify(() => streamVideo.acceptCall(
        cid: any(named: 'cid', that: equals(streamCallCid)))).called(1);
  });

  test('When a call is rejected it needs to be rejected on StreamVideo',
      () async {
    const data = {
      'sender': 'stream.video',
      'type': 'call_incoming',
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

    verify(() => streamVideo.rejectCall(
        cid: any(named: 'cid', that: equals(streamCallCid)))).called(1);
    verify(() => streamVideo.getOrCreateCall(
        cid: any(named: 'cid', that: equals(streamCallCid)))).called(1);
  });

  test('When a call was accepted, it should be able to be consumed', () async {
    when(() => sharedPreferences.getString('incomingCallCid'))
        .thenReturn('call:123');
    final result = await sut.consumeIncomingCall();

    expect(result, callCreatedData);
    verify(() => streamVideo.getOrCreateCall(
        cid: any(named: 'cid', that: equals(streamCallCid)))).called(1);
  });

  test("When there aren't any accepted call, it shouldn't consume any call",
      () async {
    when(() => sharedPreferences.getString('incomingCallCid')).thenReturn(null);
    final result = await sut.consumeIncomingCall();

    expect(result, null);
    verifyNever(() => streamVideo.acceptCall(
        cid: any(named: 'cid', that: equals(streamCallCid))));
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
