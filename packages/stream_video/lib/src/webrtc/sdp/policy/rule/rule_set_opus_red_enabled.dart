import '../../sdp.dart';
import 'sdp_munging_rule.dart';

class SetOpusRedEnabledRule extends SdpMungingRule {
  const SetOpusRedEnabledRule({
    required this.enabled,
    super.platforms,
    super.types = const [SdpType.localOffer],
  });

  final bool enabled;

  @override
  String get key => 'set-opus-red-enabled';

  @override
  String toString() {
    return 'SetOpusRedEnabledRule{enabled: $enabled, '
        'types: $types, platforms: $platforms}';
  }
}
