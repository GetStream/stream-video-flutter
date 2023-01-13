import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart'
    as sfu_models;
import 'package:stream_video/src/v2/sfu/data/models/sfu_track_type.dart';

class SfuTrackTypeParser {
  static SfuTrackType parse(String text) {
    if (text == sfu_models.TrackType.TRACK_TYPE_AUDIO.name) {
      return SfuTrackType.audio;
    } else if (text == sfu_models.TrackType.TRACK_TYPE_VIDEO.name) {
      return SfuTrackType.video;
    } else if (text == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE.name) {
      return SfuTrackType.screenShare;
    } else if (text ==
        sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO.name) {
      return SfuTrackType.screenShareAudio;
    }
    return SfuTrackType.unspecified;
  }
}
