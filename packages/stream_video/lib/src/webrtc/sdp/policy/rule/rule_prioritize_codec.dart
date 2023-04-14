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
  List<Object> get props => [types, platforms, codec];
}
