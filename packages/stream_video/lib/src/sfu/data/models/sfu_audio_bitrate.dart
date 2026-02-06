import 'package:meta/meta.dart';

@immutable
class SfuAudioBitrate {
  const SfuAudioBitrate({
    required this.profile,
    this.bitrate,
  });

  final SfuAudioBitrateProfile profile;
  final int? bitrate;

  @override
  String toString() {
    return 'SfuAudioBitrate{profile: $profile, bitrate: $bitrate}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuAudioBitrate &&
          runtimeType == other.runtimeType &&
          profile == other.profile &&
          bitrate == other.bitrate;

  @override
  int get hashCode => profile.hashCode ^ bitrate.hashCode;
}

enum SfuAudioBitrateProfile {
  voiceStandard,
  voiceHighQuality,
  musicHighQuality;

  @override
  String toString() {
    return name;
  }
}
