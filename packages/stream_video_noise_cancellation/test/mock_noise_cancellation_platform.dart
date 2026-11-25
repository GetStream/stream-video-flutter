import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_video_noise_cancellation/stream_video_noise_cancellation_platform_interface.dart';

class FakeNoiseCancellationPlatform extends StreamVideoNoiseCancellationPlatform
    with MockPlatformInterfaceMixin {
  int registerProcessorCallCount = 0;
  bool enabled = false;
  bool advancedAudioProcessing = true;

  /// When set, every call but [registerProcessor] throws it.
  Object? error;

  @override
  Future<void> registerProcessor() async {
    registerProcessorCallCount++;
  }

  @override
  Future<bool?> isEnabled() async {
    if (error case final error?) throw error;
    return enabled;
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    if (error case final error?) throw error;
    this.enabled = enabled;
  }

  @override
  Future<bool?> deviceSupportsAdvancedAudioProcessing() async {
    if (error case final error?) throw error;
    return advancedAudioProcessing;
  }
}
