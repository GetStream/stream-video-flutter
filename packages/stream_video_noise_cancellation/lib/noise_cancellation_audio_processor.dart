/// This library provides [NoiseCancellationAudioProcessor], an [AudioProcessor]
/// implementation that applies real-time noise cancellation to audio streams
/// during video calls.
library;

import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'stream_video_noise_cancellation.dart';

/// An [AudioProcessor] implementation that provides real-time noise cancellation.
///
/// Noise cancellation runs natively on Android and iOS. Elsewhere
/// [isEnabled] and [deviceSupportsAdvancedAudioProcessing] report false and
/// [setEnabled] throws.
class NoiseCancellationAudioProcessor extends AudioProcessor {
  /// Creates a new [NoiseCancellationAudioProcessor] instance.
  NoiseCancellationAudioProcessor() {
    _init();
  }

  Future<void> _init() async {
    try {
      await StreamVideoNoiseCancellation().registerProcessor();
    } catch (e) {
      _log('Noise cancellation is not supported on this platform: $e');
    }
  }

  /// Returns whether noise cancellation is currently enabled.
  @override
  Future<bool> isEnabled() async {
    try {
      return await StreamVideoNoiseCancellation().isEnabled() ?? false;
    } on Object catch (e) {
      if (!_isUnsupported(e)) rethrow;
      return false;
    }
  }

  /// Enables or disables noise cancellation. Throws where it is not
  /// supported.
  @override
  Future<void> setEnabled(bool enabled) {
    return StreamVideoNoiseCancellation().setEnabled(enabled);
  }

  /// Checks if the current device supports advanced audio processing.
  @override
  Future<bool> deviceSupportsAdvancedAudioProcessing() async {
    try {
      return await StreamVideoNoiseCancellation()
              .deviceSupportsAdvancedAudioProcessing() ??
          false;
    } on Object catch (e) {
      if (!_isUnsupported(e)) rethrow;
      return false;
    }
  }

  static bool _isUnsupported(Object error) =>
      error is UnsupportedError ||
      error is MissingPluginException ||
      error is PlatformException;

  static void _log(String message) {
    developer.log(message, name: 'SV:NoiseCancellationAudioProcessor');
  }
}
