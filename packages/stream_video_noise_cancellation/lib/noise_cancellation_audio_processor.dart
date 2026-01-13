/// This library provides [NoiseCancellationAudioProcessor], an [AudioProcessor]
/// implementation that applies real-time noise cancellation to audio streams
/// during video calls.
library;

import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';
import 'stream_video_noise_cancellation.dart';

/// An [AudioProcessor] implementation that provides real-time noise cancellation.
///
/// Note: Noise cancellation is only supported on iOS and Android platforms.
/// On unsupported platforms, methods will return appropriate fallback values.
class NoiseCancellationAudioProcessor extends AudioProcessor {
  /// Creates a new [NoiseCancellationAudioProcessor] instance.
  NoiseCancellationAudioProcessor() {
    _init();
  }

  final _logger = taggedLogger(tag: 'SV:NoiseCancellationAudioProcessor');

  Future<void> _init() async {
    try {
      await StreamVideoNoiseCancellation().registerProcessor();
    } on PlatformException catch (e) {
      _logger.w(
        () => 'Noise cancellation is not supported on this platform: $e',
      );
    } catch (err) {
      _logger.e(err.toString);
    }
  }

  /// Returns whether noise cancellation is currently enabled.
  @override
  Future<Result<bool>> isEnabled() async {
    try {
      final result = await StreamVideoNoiseCancellation().isEnabled() ?? false;
      return Result.success(result);
    } on PlatformException catch (e) {
      _logger.w(
        () => 'Noise cancellation is not supported on this platform: $e',
      );

      return const Result.success(false);
    } catch (err, stackTrace) {
      return Result.error(err.toString(), stackTrace);
    }
  }

  /// Enables or disables noise cancellation.
  @override
  Future<Result<None>> setEnabled(bool enabled) async {
    try {
      await StreamVideoNoiseCancellation().setEnabled(enabled);
      return const Result.success(none);
    } on PlatformException catch (e) {
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

  /// Checks if the current device supports advanced audio processing.
  @override
  Future<Result<bool>> deviceSupportsAdvancedAudioProcessing() async {
    try {
      final result =
          await StreamVideoNoiseCancellation()
              .deviceSupportsAdvancedAudioProcessing() ??
          false;
      return Result.success(result);
    } on PlatformException catch (e) {
      _logger.w(
        () => 'Noise cancellation is not supported on this platform: $e',
      );

      return const Result.success(false);
    } catch (err, stackTrace) {
      return Result.error(err.toString(), stackTrace);
    }
  }
}
