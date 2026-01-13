// ignore_for_file: unused_local_variable

import 'package:stream_video/stream_video.dart';
import 'package:stream_video_noise_cancellation/noise_cancellation_audio_processor.dart';

void main() {
  // Initialize StreamVideo with noise cancellation audio processor
  final client = StreamVideo(
    'your-api-key',
    user: User.regular(userId: 'user-id'),
    userToken: 'your-user-token',
    options: StreamVideoOptions(
      audioProcessor: NoiseCancellationAudioProcessor(),
    ),
  );
}
