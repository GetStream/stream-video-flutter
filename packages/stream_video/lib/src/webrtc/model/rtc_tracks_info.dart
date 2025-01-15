import '../../sfu/data/models/sfu_codec.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import 'rtc_video_parameters.dart';

class RtcTrackInfo {
  const RtcTrackInfo({
    required this.trackId,
    required this.trackType,
    required this.mid,
    required this.layers,
    required this.codec,
    required this.muted,
    required this.publishOptionId,
  });

  final String? trackId;
  final SfuTrackType? trackType;
  final String? mid;
  final List<RtcVideoLayer>? layers;
  final SfuCodec? codec;
  final bool muted;
  final int publishOptionId;

  @override
  String toString() {
    return 'RtcTrackInfo{trackId: $trackId, trackType: $trackType, '
        'mid: $mid, layers: $layers, codec: $codec, muted: $muted, publishOptionId: $publishOptionId}';
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
