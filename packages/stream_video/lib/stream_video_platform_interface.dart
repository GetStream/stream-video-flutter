import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'stream_video_method_channel.dart';

abstract class StreamVideoPlatform extends PlatformInterface {
  /// Constructs a StreamVideoPlatform.
  StreamVideoPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoPlatform _instance = MethodChannelStreamVideo();

  /// The default instance of [StreamVideoPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideo].
  static StreamVideoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoPlatform] when
  /// they register themselves.
  static set instance(StreamVideoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getDevicePushTokenVoIP() {
    throw UnimplementedError(
        'getDevicePushTokenVoIP() has not been implemented.');
  }
}
