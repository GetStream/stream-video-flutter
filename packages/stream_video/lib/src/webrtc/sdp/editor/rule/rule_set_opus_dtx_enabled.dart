import 'package:stream_video/src/webrtc/sdp/editor/rule/sdp_munging_rule.dart';
import 'package:stream_video/src/webrtc/sdp/sdp.dart';

class SetOpusDtxEnabledRule extends SdpMungingRule {
  const SetOpusDtxEnabledRule({
    required this.enabled,
    super.platforms,
    super.types = const [SdpType.localOffer],
  });

  final bool enabled;

  @override
  String get key => 'set-opus-dtx-enabled';

  @override
  String toString() {
    return 'SetOpusDtxEnabledRule{enabled: $enabled, '
        'types: $types, platforms: $platforms}';
  }
}
