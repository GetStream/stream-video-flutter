import '../../../../protobuf/video/sfu/models/models.pbenum.dart' as sfu_models;
import 'sfu_track_type.dart';

mixin SfuTrackTypeParser {
  static SfuTrackType parseSfuName(String name) {
    if (name == sfu_models.TrackType.TRACK_TYPE_AUDIO.name) {
      return SfuTrackType.audio;
    } else if (name == sfu_models.TrackType.TRACK_TYPE_VIDEO.name) {
      return SfuTrackType.video;
    } else if (name == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE.name) {
      return SfuTrackType.screenShare;
    } else if (name ==
        sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO.name) {
      return SfuTrackType.screenShareAudio;
    }
    return SfuTrackType.unspecified;
  }

  static SfuTrackType parseRtcName(String? name) {
    if (name == 'audio') {
      return SfuTrackType.audio;
    } else if (name == 'video') {
      return SfuTrackType.video;
    } else if (name == 'screen') {
      return SfuTrackType.screenShare;
    }
    return SfuTrackType.unspecified;
  }
}
