/// Platform interface for Stream Video noise cancellation.
library;

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'stream_video_noise_cancellation_method_channel.dart';

/// The interface that platform-specific implementations of noise cancellation
/// must extend.
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

  /// Registers the noise cancellation processor with the native platform.
  Future<void> registerProcessor() {
    throw UnimplementedError('registerProcessor() has not been implemented.');
  }

  /// Returns whether noise cancellation is currently enabled.
  Future<bool?> isEnabled() {
    throw UnimplementedError('isEnabled() has not been implemented.');
  }

  /// Enables or disables noise cancellation.
  Future<void> setEnabled(bool enabled) {
    throw UnimplementedError('setEnabled() has not been implemented.');
  }

  /// Checks if the device supports advanced audio processing.
  Future<bool?> deviceSupportsAdvancedAudioProcessing() {
    throw UnimplementedError(
      'deviceSupportsAdvancedAudioProcessing() has not been implemented.',
    );
  }
}
