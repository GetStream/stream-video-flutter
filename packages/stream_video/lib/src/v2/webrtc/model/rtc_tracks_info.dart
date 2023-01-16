import 'rtc_video_dimension.dart';

class RtcTracksInfo {
  RtcTracksInfo({
    required this.trackInfoList,
  });
  final List<RtcTrackInfo> trackInfoList;

  @override
  String toString() {
    return 'RtcTracksInfo{trackInfoList: $trackInfoList}';
  }
}

class RtcTrackInfo {
  RtcTrackInfo({
    required this.trackId,
    required this.trackType,
    required this.layers,
  });

  final String? trackId;
  final String? trackType;
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
