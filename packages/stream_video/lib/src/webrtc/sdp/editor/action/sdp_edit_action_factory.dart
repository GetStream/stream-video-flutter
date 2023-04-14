import 'package:meta/meta.dart';

import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../policy/sdp_policy.dart';
import '../../specification/media_description.dart';
import 'action_enable_opus_dtx.dart';
import 'action_prioritize_codec.dart';
import 'sdp_edit_action.dart';

@internal
class SdpEditActionFactory {
  final _mediaDescriptionParser = MediaDescriptionParser();
  final _rtpmapParser = RtpmapParser();
  final _fmtpParser = FmtpParser();

  SdpEditAction? create(SdpMungingRule rule) {
    if (rule is PrioritizeCodecRule) {
      return PrioritizeCodecAction(
        codec: rule.codec,
        mediaDescriptionParser: _mediaDescriptionParser,
        rtpmapParser: _rtpmapParser,
      );
    } else if (rule is EnableOpusDtxRule) {
      return EnableOpusDtxAction(
        rtpmapParser: _rtpmapParser,
        fmtpParser: _fmtpParser,
      );
    }
    return null;
  }
}
