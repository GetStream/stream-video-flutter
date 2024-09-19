import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

const _tag = 'StreamVideoSdk';

class StreamVideoSdk {
  StreamVideoSdk._();

  static Future<StreamVideo> initialize({
    required String apiKey,
    required UserInfo user,
    required UserToken userToken,
    StreamVideoOptions options = const StreamVideoOptions(),
  }) async {
    if (StreamVideo.isInitialized()) {
      streamLog.d(_tag, () => '[initialize] reset instance');
      await StreamVideo.reset(disconnect: true);
    }
    return StreamVideo(
      apiKey,
      user: User(info: user),
      userToken: userToken.rawValue,
      pushNotificationManagerProvider:
          StreamVideoPushNotificationManager.create(
        iosPushProvider: const StreamVideoPushProvider.apn(
          name: 'flutter-apn',
        ),
        androidPushProvider: const StreamVideoPushProvider.firebase(
          name: 'flutter-firebase',
        ),
        pushParams: const StreamVideoPushParams(
          appName: 'Stream Example',
          ios: IOSParams(iconName: 'IconMask'),
        ),
      ),
      options: options,
    );
  }
}
