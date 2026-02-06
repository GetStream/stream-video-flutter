import '../../sfu/data/models/sfu_audio_bitrate.dart';

class RtcTrackPublishOptions {
  const RtcTrackPublishOptions({
    this.audioBitrateProfile = SfuAudioBitrateProfile.voiceStandard,
  });

  final SfuAudioBitrateProfile audioBitrateProfile;
}
