import '../../sfu/data/models/sfu_track_type.dart';
import 'rtc_video_dimension.dart';

class RtcTrackInfo {
  RtcTrackInfo({
    required this.trackId,
    required this.trackType,
    required this.mid,
    required this.layers,
  });

  final String? trackId;
  final SfuTrackType? trackType;
  final String? mid;
  final List<RtcVideoLayer>? layers;

  @override
  String toString() {
    return 'RtcTrackInfo{trackId: $trackId, trackType: $trackType, '
        'layers: $layers}';
  }
}

class RtcVideoLayer {
  RtcVideoLayer({
    required this.rid,
    required this.videoDimension,
    required this.bitrate,
  });

  final String? rid;
  final RtcVideoDimension? videoDimension;
  final int? bitrate;

  @override
  String toString() {
    return 'RtcVideoLayer{rid: $rid, videoDimension: $videoDimension, '
        'bitrate: $bitrate}';
  }
}
