/// Noise cancellation audio processor for Stream Video.
/// This library provides real-time noise cancellation capabilities
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
final class NoiseCancellationAudioProcessor extends AudioProcessor {
  /// Creates a new [NoiseCancellationAudioProcessor] instance, and registers
  /// the native processor.
  NoiseCancellationAudioProcessor() {
    _registration = _register();
  }

  late final Future<void> _registration;

  Future<void> _register() async {
    try {
      await StreamVideoNoiseCancellation().registerProcessor();
    } catch (e, stk) {
      if (_isUnsupported(e)) {
        _log('Noise cancellation is not supported on this platform: $e');
      } else {
        _log(
          'Failed to register noise cancellation: $e',
          error: e,
          stackTrace: stk,
        );
      }
    }
  }

  /// Returns whether noise cancellation is currently enabled.
  @override
  Future<bool> isEnabled() async {
    await _registration;
    try {
      return await StreamVideoNoiseCancellation().isEnabled() ?? false;
    } catch (e, stk) {
      if (_isUnsupported(e)) return false;
      _log('Failed to read noise cancellation: $e', error: e, stackTrace: stk);
      rethrow;
    }
  }

  /// Enables or disables noise cancellation. Throws where it is not
  /// supported.
  @override
  Future<void> setEnabled(bool enabled) async {
    await _registration;
    try {
      await StreamVideoNoiseCancellation().setEnabled(enabled);
    } catch (e, stk) {
      if (!_isUnsupported(e)) {
        _log(
          'Failed to turn noise cancellation ${enabled ? 'on' : 'off'}: $e',
          error: e,
          stackTrace: stk,
        );
      }
      rethrow;
    }
  }

  /// Checks if the current device supports advanced audio processing.
  @override
  Future<bool> deviceSupportsAdvancedAudioProcessing() async {
    await _registration;
    try {
      return await StreamVideoNoiseCancellation()
              .deviceSupportsAdvancedAudioProcessing() ??
          false;
    } catch (e, stk) {
      if (_isUnsupported(e)) return false;
      _log(
        'Failed to read the advanced audio processing support: $e',
        error: e,
        stackTrace: stk,
      );
      rethrow;
    }
  }

  static bool _isUnsupported(Object error) =>
      error is UnsupportedError || error is MissingPluginException;

  static void _log(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'SV:NoiseCancellationAudioProcessor',
      level: error == null ? 800 : 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
