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
  });

  /// Whether the audio device module skips echo cancellation, noise
  /// suppression and gain control.
  final bool bypassVoiceProcessing;

  final AndroidAudioConfiguration? androidAudioConfiguration;

  final AppleAudioConfiguration? appleAudioConfiguration;

  @override
  String toString() =>
      'PeerConnectionFactoryOptions('
      'bypassVoiceProcessing: $bypassVoiceProcessing, '
      'androidAudioConfiguration: ${androidAudioConfiguration?.toMap()}, '
      'appleAudioConfiguration: ${appleAudioConfiguration?.toMap()})';
}
