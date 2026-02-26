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
    required this.dtx,
    required this.stereo,
    required this.red,
  });

  final String? trackId;
  final SfuTrackType? trackType;
  final String? mid;
  final List<RtcVideoLayer>? layers;
  final SfuCodec? codec;
  final bool muted;
  final int publishOptionId;
  final bool stereo;

  /// When true, the call will optimize bandwidth usage by disabling audio when participants are not speaking via discontinuous transmission (DTX).
  final bool dtx;

  /// When true, the call will send additional audio streams to ensure calls are more resistant to poor network conditions.
  final bool red;

  @override
  String toString() {
    return 'RtcTrackInfo{trackId: $trackId, trackType: $trackType, '
        'mid: $mid, layers: $layers, codec: $codec, muted: $muted, publishOptionId: $publishOptionId, '
        'dtx: $dtx, stereo: $stereo, red: $red}';
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
