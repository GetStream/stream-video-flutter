import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import 'sdp_munging_rule.dart';

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
