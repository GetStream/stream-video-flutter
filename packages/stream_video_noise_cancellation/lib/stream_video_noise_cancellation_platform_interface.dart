import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'stream_video_noise_cancellation_method_channel.dart';

abstract class StreamVideoNoiseCancellationPlatform extends PlatformInterface {
  /// Constructs a StreamVideoNoiseCancellationPlatform.
  StreamVideoNoiseCancellationPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoNoiseCancellationPlatform _instance =
      MethodChannelStreamVideoNoiseCancellation();

  /// The default instance of [StreamVideoNoiseCancellationPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideoNoiseCancellation].
  static StreamVideoNoiseCancellationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoNoiseCancellationPlatform] when
  /// they register themselves.
  static set instance(StreamVideoNoiseCancellationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> registerProcessor() {
    throw UnimplementedError('registerProcessor() has not been implemented.');
  }

  Future<bool?> isEnabled() {
    throw UnimplementedError('isEnabled() has not been implemented.');
  }

  Future<void> setEnabled(bool enabled) {
    throw UnimplementedError('setEnabled() has not been implemented.');
  }

  Future<bool?> deviceSupportsAdvancedAudioProcessing() {
    throw UnimplementedError(
      'deviceSupportsAdvancedAudioProcessing() has not been implemented.',
    );
  }
}
