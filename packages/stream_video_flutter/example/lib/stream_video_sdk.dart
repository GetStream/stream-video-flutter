import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

const _tag = 'StreamVideoSdk';

class StreamVideoSdk {
  StreamVideoSdk._();

  static Future<StreamVideo> initialize({
    required String apiKey,
    required UserInfo user,
    required UserToken userToken,
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
          appName: 'Stream Dogfooding',
          ios: IOSParams(iconName: 'IconMask'),
        ),
      ),
      options: const StreamVideoOptions(
        // coordinatorRpcUrl: 'http://192.168.1.73:3030/video',
        // coordinatorWsUrl: 'ws://192.168.1.73:8800/video/connect',

        // iOS
        // coordinatorRpcUrl: 'http://localhost:3030/video',
        // coordinatorWsUrl: 'ws://localhost:8800/video/connect',

        // Android
        coordinatorRpcUrl: 'http://10.0.2.2:3030/video',
        coordinatorWsUrl: 'ws://10.0.2.2:8800/video/connect',
      ),
    );
  }
}
