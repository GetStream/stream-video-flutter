/// Stream Video noise cancellation utilities.
///
/// Exposes methods to register and control client-side audio noise
/// cancellation when supported by the current platform.
library;

import 'stream_video_noise_cancellation_platform_interface.dart';

/// Provides access to noise cancellation functionality.
///
/// This class serves as the main entry point for interacting with
/// platform-specific noise cancellation features. It delegates all
/// operations to the appropriate platform implementation.
class StreamVideoNoiseCancellation {
  /// Registers the noise cancellation processor with the native platform.
  ///
  /// This must be called before using other noise cancellation features.
  Future<void> registerProcessor() {
    return StreamVideoNoiseCancellationPlatform.instance.registerProcessor();
  }

  /// Returns whether noise cancellation is currently enabled.
  Future<bool?> isEnabled() {
    return StreamVideoNoiseCancellationPlatform.instance.isEnabled();
  }

  /// Enables or disables noise cancellation.
  Future<void> setEnabled(bool enabled) {
    return StreamVideoNoiseCancellationPlatform.instance.setEnabled(enabled);
  }

  /// Checks if the device supports advanced audio processing.
  Future<bool?> deviceSupportsAdvancedAudioProcessing() {
    return StreamVideoNoiseCancellationPlatform.instance
        .deviceSupportsAdvancedAudioProcessing();
  }
}
