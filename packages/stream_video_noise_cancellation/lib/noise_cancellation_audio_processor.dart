import 'package:stream_video/stream_video.dart';
import 'package:stream_video_noise_cancellation/stream_video_noise_cancellation.dart';

class NoiseCancellationAudioProcessor extends AudioProcessor {
  NoiseCancellationAudioProcessor() {
    StreamVideoNoiseCancellation().registerProcessor();
  }

  @override
  Future<Result<bool>> isEnabled() async {
    try {
      await StreamVideoNoiseCancellation().isEnabled() ?? false;
      return Result.success(true);
    } catch (err, stackTrace) {
      return Result.error(err.toString(), stackTrace);
    }
  }

  @override
  Future<Result<None>> setEnabled(bool enabled) async {
    try {
      await StreamVideoNoiseCancellation().setEnabled(enabled);
      return Result.success(none);
    } catch (err, stackTrace) {
      return Result.error(err.toString(), stackTrace);
    }
  }

  @override
  Future<Result<bool>> deviceSupportsAdvancedAudioProcessing() async {
    try {
      final result = await StreamVideoNoiseCancellation()
              .deviceSupportsAdvancedAudioProcessing() ??
          false;
      return Result.success(result);
    } catch (err, stackTrace) {
      return Result.error(err.toString(), stackTrace);
    }
  }
}
