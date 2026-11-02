import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_video/stream_video.dart' show AndroidCallServiceKind;

import '../src/call_background/model/notification_payload.dart';
import '../src/call_background/model/service_type.dart';
import 'stream_video_flutter_method_channel.dart';

abstract class StreamVideoFlutterPlatform extends PlatformInterface {
  /// Constructs a StreamVideoFlutterPlatform.
  StreamVideoFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoFlutterPlatform _instance =
      MethodChannelStreamVideoFlutter();

  /// The default instance of [StreamVideoFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideoFlutter].
  static StreamVideoFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoFlutterPlatform] when
  /// they register themselves.
  static set instance(StreamVideoFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void Function(String callCid)? onBackgroundNotificationContentClick;

  void Function(String buttonType, String callCid, ServiceType serviceType)?
  onBackgroundNotificationButtonClick;

  void Function(String callCid)? onBackgroundNotificationUiLayerDestroyed;

  /// Starts the foreground service of [type] for the call in [payload].
  ///
  /// For [ServiceType.call], [kind] picks which Android service hosts the
  /// call, and so which foreground service types it requests.
  Future<bool> startBackgroundService({
    required NotificationPayload payload,
    required ServiceType type,
    AndroidCallServiceKind kind = AndroidCallServiceKind.call,
  }) {
    throw UnimplementedError('startService() has not been implemented.');
  }

  Future<bool> updateBackgroundService({
    required NotificationPayload payload,
    required ServiceType type,
  }) {
    throw UnimplementedError('updateService() has not been implemented.');
  }

  Future<bool> stopBackgroundService(
    ServiceType type, {
    String? callCid,
  }) {
    throw UnimplementedError('stopService() has not been implemented.');
  }

  Future<bool> isBackgroundServiceRunning(
    ServiceType type, {
    String? callCid,
  }) {
    throw UnimplementedError('isRunningService has not been implemented.');
  }
}
