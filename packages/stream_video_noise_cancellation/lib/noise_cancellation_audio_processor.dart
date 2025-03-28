import 'package:stream_video/stream_video.dart';
import 'package:stream_video_noise_cancellation/stream_video_noise_cancellation.dart';

class NoiseCancellationAudioProcessor extends AudioProcessor {
  final _logger = taggedLogger(tag: 'SV:NoiseCancellationAudioProcessor');

  NoiseCancellationAudioProcessor() {
    _init();
  }

  Future<void> _init() async {
    try {
      await StreamVideoNoiseCancellation().registerProcessor();
    } on UnimplementedError catch (e) {
      _logger.w(
        () => 'Noise cancellation is not supported on this platform: $e',
      );
    } catch (err) {
      _logger.e(
        () => err.toString(),
      );
    }
  }

  @override
  Future<Result<bool>> isEnabled() async {
    try {
      final result = await StreamVideoNoiseCancellation().isEnabled() ?? false;
      return Result.success(result);
    } on UnimplementedError catch (e) {
      _logger.w(
        () => 'Noise cancellation is not supported on this platform: $e',
      );

      return Result.success(false);
    } catch (err, stackTrace) {
      return Result.error(err.toString(), stackTrace);
    }
  }

  @override
  Future<Result<None>> setEnabled(bool enabled) async {
    try {
      await StreamVideoNoiseCancellation().setEnabled(enabled);
      return Result.success(none);
    } on UnimplementedError catch (e) {
      _logger.e(
        () => 'Noise cancellation is not supported on this platform: $e',
      );

      return Result.error(
        'Noise cancellation is not supported on this platform',
      );
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
    } on UnimplementedError catch (e) {
      _logger.w(
        () => 'Noise cancellation is not supported on this platform: $e',
      );

      return Result.success(false);
    } catch (err, stackTrace) {
      return Result.error(err.toString(), stackTrace);
    }
  }
}
