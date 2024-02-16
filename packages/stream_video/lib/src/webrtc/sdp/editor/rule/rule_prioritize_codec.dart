import 'package:stream_video/src/webrtc/sdp/codec/sdp_codec.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/sdp_munging_rule.dart';
import 'package:stream_video/src/webrtc/sdp/sdp.dart';

class PrioritizeCodecRule extends SdpMungingRule {
  const PrioritizeCodecRule({
    required this.codec,
    super.platforms,
    super.types = const [SdpType.localOffer],
  });

  final SdpCodec codec;

  @override
  String get key => 'prioritize-codec-${codec.type}';

  @override
  String toString() {
    return 'PrioritizeCodecRule{codec: $codec, '
        'types: $types, platforms: $platforms}';
  }
}
