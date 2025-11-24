import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'stream_video_filters_method_channel.dart';

abstract class StreamVideoFiltersPlatform extends PlatformInterface {
  /// Constructs a StreamVideoFiltersPlatform.
  StreamVideoFiltersPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoFiltersPlatform _instance =
      MethodChannelStreamVideoFilters();

  /// The default instance of [StreamVideoFiltersPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideoFilters].
  static StreamVideoFiltersPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoFiltersPlatform] when
  /// they register themselves.
  static set instance(StreamVideoFiltersPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isBackgroundEffectSupported() {
    throw UnimplementedError(
      'isBackgroundEffectSupported has not been implemented.',
    );
  }

  Future<void> registerBlurEffectProcessors() {
    throw UnimplementedError(
      'registerBlurEffectProcessors has not been implemented.',
    );
  }

  Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) {
    throw UnimplementedError(
      'registerImageEffectProcessors has not been implemented.',
    );
  }
}
