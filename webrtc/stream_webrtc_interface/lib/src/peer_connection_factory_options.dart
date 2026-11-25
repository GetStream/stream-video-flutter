import 'package:meta/meta.dart';

import 'third_party/flutter_webrtc/android_audio_configuration.dart';
import 'third_party/flutter_webrtc/apple_audio_configuration.dart';

/// The audio settings a peer connection factory is built with.
///
/// Android applies [androidAudioConfiguration], iOS applies
/// [appleAudioConfiguration].
@immutable
class PeerConnectionFactoryOptions {
  const PeerConnectionFactoryOptions({
    this.bypassVoiceProcessing = false,
    this.androidAudioConfiguration,
    this.appleAudioConfiguration,
    this.preferStereoPlayout,
    this.additionalOptions = const {},
  });

  /// Whether the audio device module skips echo cancellation, noise
  /// suppression and gain control.
  final bool bypassVoiceProcessing;

  /// The audio mode, focus and attributes Android uses. Null leaves the
  /// platform's defaults.
  final AndroidAudioConfiguration? androidAudioConfiguration;

  /// The audio session category, options and mode iOS uses. Null leaves the
  /// platform's defaults.
  final AppleAudioConfiguration? appleAudioConfiguration;

  /// Whether stereo playout is preferred, which bypasses voice processing.
  /// The preference is app-wide and stays for the factories built after.
  /// Applied on iOS; null leaves it as it is.
  final bool? preferStereoPlayout;

  /// Other options the platform reads when it builds a factory, such as
  /// `forceSWCodec` or `networkIgnoreMask`, sent as they are. The fields
  /// above win over an entry with the same key.
  final Map<String, dynamic> additionalOptions;

  @override
  String toString() =>
      'PeerConnectionFactoryOptions('
      'bypassVoiceProcessing: $bypassVoiceProcessing, '
      'androidAudioConfiguration: ${androidAudioConfiguration?.toMap()}, '
      'appleAudioConfiguration: ${appleAudioConfiguration?.toMap()}, '
      'preferStereoPlayout: $preferStereoPlayout, '
      'additionalOptions: $additionalOptions)';
}
