import '../../sdp.dart';
import 'sdp_munging_rule.dart';

/// Adds `stereo=1` to the Opus fmtp line of every audio section in a local
/// answer, so remote audio is always decoded in stereo.
class EnableOpusStereoRule extends SdpMungingRule {
  const EnableOpusStereoRule({
    super.platforms,
    super.types = const [SdpType.localAnswer],
  });

  @override
  String get key => 'enable-opus-stereo';

  @override
  String toString() {
    return 'EnableOpusStereoRule{types: $types, platforms: $platforms}';
  }
}
