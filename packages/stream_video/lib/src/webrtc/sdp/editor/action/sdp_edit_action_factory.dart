import 'package:meta/meta.dart';

import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../specification/media_description.dart';
import '../rule/rule_prioritize_codec.dart';
import '../rule/rule_set_opus_dtx_enabled.dart';
import '../rule/rule_set_opus_red_enabled.dart';
import '../rule/sdp_munging_rule.dart';
import 'action_prioritize_codec.dart';
import 'action_set_opus_dtx_enabled.dart';
import 'action_set_opus_red_enabled.dart';
import 'sdp_edit_action.dart';

@internal
class SdpEditActionFactory {
  final _mediaDescriptionParser = MediaDescriptionParser();
  final _rtpmapParser = RtpmapParser();
  final _fmtpParser = FmtpParser();

  SdpEditAction create(SdpMungingRule rule) {
    if (rule is PrioritizeCodecRule) {
      return PrioritizeCodecAction(
        codec: rule.codec,
        mediaDescriptionParser: _mediaDescriptionParser,
        rtpmapParser: _rtpmapParser,
      );
    } else if (rule is SetOpusDtxEnabledRule) {
      return SetOpusDtxEnabledAction(
        enabled: rule.enabled,
        rtpmapParser: _rtpmapParser,
        fmtpParser: _fmtpParser,
      );
    } else if (rule is SetOpusRedEnabledRule) {
      return SetOpusRedEnabledAction(
        enabled: rule.enabled,
        mediaDescriptionParser: _mediaDescriptionParser,
        rtpmapParser: _rtpmapParser,
        fmtpParser: _fmtpParser,
      );
    }
    throw UnsupportedError('Not supported: $rule');
  }
}
