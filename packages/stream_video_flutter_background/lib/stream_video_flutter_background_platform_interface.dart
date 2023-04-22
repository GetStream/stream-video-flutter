import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'model/notification_payload.dart';
import 'stream_video_flutter_background_method_channel.dart';

abstract class StreamVideoFlutterBackgroundPlatform extends PlatformInterface {
  /// Constructs a StreamVideoFlutterBackgroundPlatform.
  StreamVideoFlutterBackgroundPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoFlutterBackgroundPlatform _instance =
      MethodChannelStreamVideoFlutterBackground();

  /// The default instance of [StreamVideoFlutterBackgroundPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideoFlutterBackground].
  static StreamVideoFlutterBackgroundPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoFlutterBackgroundPlatform] when
  /// they register themselves.
  static set instance(StreamVideoFlutterBackgroundPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Function(String callCid)? onContentClick;

  Function(String buttonType, String callCid)? onButtonClick;

  Function(String callCid)? onUiLayerDestroyed;

  Future<bool> startService(NotificationPayload payload) {
    throw UnimplementedError('startService() has not been implemented.');
  }

  Future<bool> updateService(NotificationPayload payload) {
    throw UnimplementedError('updateService() has not been implemented.');
  }

  Future<bool> stopService() {
    throw UnimplementedError('stopService() has not been implemented.');
  }

  Future<bool> get isServiceRunning {
    throw UnimplementedError('isRunningService has not been implemented.');
  }
}
