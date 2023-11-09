import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'stream_video_flutter_method_channel.dart';

abstract class StreamVideoFlutterPlatform extends PlatformInterface {
  /// Constructs a StreamVideoFlutterPlatform.
  StreamVideoFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoFlutterPlatform _instance = MethodChannelStreamVideoFlutter();

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
