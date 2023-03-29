import '../../sfu/data/models/sfu_track_type.dart';
import 'rtc_video_parameters.dart';

class RtcTrackInfo {
  const RtcTrackInfo({
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
  const RtcVideoLayer({
    required this.rid,
    required this.parameters,
  });

  final String rid;
  final RtcVideoParameters parameters;

  @override
  String toString() {
    return 'RtcVideoLayer{rid: $rid, parameters: $parameters}';
  }
}
