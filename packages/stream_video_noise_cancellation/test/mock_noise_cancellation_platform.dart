import 'package:stream_video_noise_cancellation/stream_video_noise_cancellation_platform_interface.dart';

class FakeNoiseCancellationPlatform
    extends StreamVideoNoiseCancellationPlatform {
  int registerProcessorCallCount = 0;

  @override
  Future<void> registerProcessor() async {
    registerProcessorCallCount++;
  }
}
