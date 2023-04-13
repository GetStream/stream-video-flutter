import 'package:meta/meta.dart';

import '../../attributes/rtpmap.dart';
import '../../policy/sdp_policy.dart';
import '../../specification/media_description.dart';
import 'action_prioritize_codec.dart';
import 'sdp_edit_action.dart';

@internal
class SdpEditActionFactory {
  final _rtpmapParser = RtpmapParser();
  final _mediaDescriptionParser = MediaDescriptionParser();


  SdpEditAction? create(SdpMungingRule rule) {
    if (rule is PrioritizeCodecRule) {
      return PrioritizeCodecAction(
        codec: rule.codec,
        mediaDescriptionParser: _mediaDescriptionParser,
        rtpmapParser: _rtpmapParser,
      );
    }
    return null;
  }
}
