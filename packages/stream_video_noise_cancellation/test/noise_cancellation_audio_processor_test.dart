import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_noise_cancellation/noise_cancellation_audio_processor.dart';
import 'package:stream_video_noise_cancellation/stream_video_noise_cancellation_platform_interface.dart';

import 'mock_noise_cancellation_platform.dart';

void main() {
  test('NoiseCancellationAudioProcessor init registers processor', () async {
    final platform = FakeNoiseCancellationPlatform();
    StreamVideoNoiseCancellationPlatform.instance = platform;

    expect(platform.registerProcessorCallCount, 0);

    final _ = NoiseCancellationAudioProcessor();
    await Future.delayed(const Duration());

    expect(platform.registerProcessorCallCount, 1);
  });
}
