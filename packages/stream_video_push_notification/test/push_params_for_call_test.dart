import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

// Pins `StreamVideoPushParams.forCall`, the one place the manager builds the
// params of a call from the push configuration: which fields the call sets,
// which the configuration keeps, and where the avatar lands.

void main() {
  const configuration = StreamVideoPushConfiguration(
    headers: {'Authorization': 'token'},
    android: AndroidPushConfiguration(
      ringtonePath: 'ring.mp3',
      defaultAvatar: 'default.png',
      incomingCallNotificationChannelName: 'Incoming',
    ),
    ios: IOSPushConfiguration(
      iconName: 'CallIcon',
      supportsHolding: false,
      ringtonePath: 'ring.caf',
    ),
  );

  test('sets the call fields on top of the configuration', () {
    final params = StreamVideoPushParams.forCall(
      configuration,
      uuid: 'call-uuid',
      callCid: 'default:ada',
      avatar: 'ada.png',
      handle: 'ada',
      callerName: 'Ada',
    );

    expect(params.id, 'call-uuid');
    expect(params.handle, 'ada');
    expect(params.callerName, 'Ada');
    expect(params.type, 1);
    expect(params.extra, {'callCid': 'default:ada'});
    // From the configuration.
    expect(params.headers, {'Authorization': 'token'});
    expect(params.android?.ringtonePath, 'ring.mp3');
    expect(params.android?.defaultAvatar, 'default.png');
    expect(params.android?.incomingCallNotificationChannelName, 'Incoming');
    expect(params.ios?.iconName, 'CallIcon');
    expect(params.ios?.supportsHolding, isFalse);
    expect(params.ios?.ringtonePath, 'ring.caf');
  });

  test('the avatar lands in the Android params', () {
    final params = StreamVideoPushParams.forCall(
      configuration,
      uuid: 'call-uuid',
      callCid: 'default:ada',
      avatar: 'ada.png',
    );

    expect(params.android?.avatar, 'ada.png');
  });

  test('without Android configuration there is nowhere for the avatar', () {
    final params = StreamVideoPushParams.forCall(
      const StreamVideoPushConfiguration(ios: IOSPushConfiguration()),
      uuid: 'call-uuid',
      callCid: 'default:ada',
      avatar: 'ada.png',
    );

    expect(params.android, isNull);
    expect(params.ios, isNotNull);
  });

  test('an audio call has type 0 and video is the default', () {
    expect(
      StreamVideoPushParams.forCall(
        configuration,
        uuid: 'u',
        callCid: 'c',
        hasVideo: false,
      ).type,
      0,
    );
    expect(
      StreamVideoPushParams.forCall(
        configuration,
        uuid: 'u',
        callCid: 'c',
      ).type,
      1,
    );
  });

  test(
    'the wire shape carries the id and the call cid where native reads them',
    () {
      final json = StreamVideoPushParams.forCall(
        configuration,
        uuid: 'call-uuid',
        callCid: 'default:ada',
        callerName: 'Ada',
      ).toJson();

      expect(json['id'], 'call-uuid');
      expect(json['callerName'], 'Ada');
      expect((json['extra'] as Map)['callCid'], 'default:ada');
      expect((json['android'] as Map)['ringtonePath'], 'ring.mp3');
      expect((json['ios'] as Map)['iconName'], 'CallIcon');
    },
  );
}
