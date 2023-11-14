import 'stream_video_push_notification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class StreamVideoPushNotificationPlatform extends PlatformInterface {
  StreamVideoPushNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoPushNotificationPlatform _instance =
      MethodChannelStreamVideoPushNotification();

  /// The default instance of [StreamVideoPushNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideoPushNotification].
  static StreamVideoPushNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoPushNotificationPlatform] when
  /// they register themselves.
  static set instance(StreamVideoPushNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initData(Map<String, dynamic> data) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
