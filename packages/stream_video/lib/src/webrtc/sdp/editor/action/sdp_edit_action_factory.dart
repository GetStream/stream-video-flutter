import 'package:meta/meta.dart';

import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../sdp.dart';
import '../rule/rule_enable_opus_stereo.dart';
import '../rule/sdp_munging_rule.dart';
import 'action_enable_opus_stereo.dart';
import 'sdp_edit_action.dart';

@internal
class SdpEditActionFactory {
  final _rtpmapParser = RtpmapParser();
  final _fmtpParser = FmtpParser();

  SdpEditAction create(
    SdpMungingRule rule, {
    Sdp? sdp,
  }) {
    if (rule is EnableOpusStereoRule) {
      return EnableOpusStereoAction(
        rtpmapParser: _rtpmapParser,
        fmtpParser: _fmtpParser,
      );
    }
    throw UnsupportedError('Not supported: $rule');
  }
}
