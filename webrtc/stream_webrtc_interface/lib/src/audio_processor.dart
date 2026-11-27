import 'media_stream_filter.dart';

/// Processes the microphone audio of every call, such as noise
/// cancellation.
///
/// A native implementation installs its processing module through the
/// plugin's audio processing hook (`AudioProcessingFactoryProvider` on
/// Android, `AudioManager.audioProcessingModule` on iOS) and turns it on and
/// off here. An implementation that processes the stream itself returns a
/// filter from [toFilter] instead.
///
/// A subclass is itself declared `base`, `final` or `sealed`.
abstract base class AudioProcessor {
  const AudioProcessor();

  /// Whether the processing is on.
  Future<bool> isEnabled();

  /// Turns the processing on or off.
  Future<void> setEnabled(bool enabled);

  /// Whether the device is well suited to the processing: Apple's Neural
  /// Engine on iOS, or the `FEATURE_AUDIO_PRO` feature on Android.
  Future<bool> deviceSupportsAdvancedAudioProcessing();

  /// The filter the call runs on the microphone for this processor, after
  /// the app's own microphone filter. Null for a processor installed
  /// natively.
  ///
  /// Return the same filter each time it is invoked.
  AudioFilter? toFilter() => null;
}
