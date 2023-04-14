import '../../sdp.dart';
import 'sdp_munging_rule.dart';

class SetOpusDtxEnabledRule extends SdpMungingRule {
  const SetOpusDtxEnabledRule({
    required this.enabled,
    super.platforms,
    super.types = const [SdpType.localOffer],
  });

  final bool enabled;

  @override
  List<Object> get props => [enabled, types, platforms];
}
