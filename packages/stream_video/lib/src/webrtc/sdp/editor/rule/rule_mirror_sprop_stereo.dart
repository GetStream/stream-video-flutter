import '../../sdp.dart';
import 'sdp_munging_rule.dart';

/// Adds `stereo=1` to the Opus fmtp line in a local answer when the
/// corresponding offer contained `sprop-stereo=1`.
class MirrorSpropStereoRule extends SdpMungingRule {
  const MirrorSpropStereoRule({
    super.platforms,
    super.types = const [SdpType.localAnswer],
  });

  @override
  String get key => 'mirror-sprop-stereo';

  @override
  String toString() {
    return 'MirrorSpropStereoRule{types: $types, platforms: $platforms}';
  }
}
