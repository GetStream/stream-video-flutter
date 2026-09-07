import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../sfu/data/models/sfu_codec.dart';
import '../../sfu/data/models/sfu_track_type.dart';

extension SfuCodecE2EE on SfuCodec {
  /// The codec pin for this track's frame transform, lowercased and exact.
  String? get e2eeCodecPin {
    final normalized = name.toLowerCase().trim();
    return normalized.isEmpty ? null : normalized;
  }
}

extension SfuTrackTypeE2EE on SfuTrackType {
  /// The replay-window grouping for this track.
  ///
  /// Screenshare maps explicitly rather than collapsing into video, so a
  /// screen share and a camera from the same user never share one window.
  /// Returns `null` for [SfuTrackType.unspecified], letting native pick audio
  /// vs video from the RTP sender or receiver.
  rtc.E2eeTrackType? get e2eeTrackType {
    if (this == SfuTrackType.audio) return rtc.E2eeTrackType.audio;
    if (this == SfuTrackType.video) return rtc.E2eeTrackType.video;
    if (this == SfuTrackType.screenShare) return rtc.E2eeTrackType.screenShare;
    if (this == SfuTrackType.screenShareAudio) {
      return rtc.E2eeTrackType.screenShareAudio;
    }
    return null;
  }
}
