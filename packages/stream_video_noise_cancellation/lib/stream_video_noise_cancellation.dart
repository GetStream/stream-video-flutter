import 'stream_video_noise_cancellation_platform_interface.dart';

class StreamVideoNoiseCancellation {
  Future<void> registerProcessor() {
    return StreamVideoNoiseCancellationPlatform.instance.registerProcessor();
  }

  Future<bool?> isEnabled() {
    return StreamVideoNoiseCancellationPlatform.instance.isEnabled();
  }

  Future<void> setEnabled(bool enabled) {
    return StreamVideoNoiseCancellationPlatform.instance.setEnabled(enabled);
  }

  Future<bool?> deviceSupportsAdvancedAudioProcessing() {
    return StreamVideoNoiseCancellationPlatform.instance
        .deviceSupportsAdvancedAudioProcessing();
  }
}
