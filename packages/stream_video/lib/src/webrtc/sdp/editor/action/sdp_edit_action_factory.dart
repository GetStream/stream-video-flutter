import 'package:meta/meta.dart';

import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../sdp.dart';
import '../rule/rule_mirror_sprop_stereo.dart';
import '../rule/sdp_munging_rule.dart';
import 'action_mirror_sprop_stereo.dart';
import 'sdp_edit_action.dart';

@internal
class SdpEditActionFactory {
  final _rtpmapParser = RtpmapParser();
  final _fmtpParser = FmtpParser();

  SdpEditAction create(
    SdpMungingRule rule, {
    Sdp? sdp,
  }) {
    if (rule is MirrorSpropStereoRule) {
      return MirrorSpropStereoAction(
        offerSdp: sdp is LocalAnswerSdp ? sdp.offerSdp : null,
        rtpmapParser: _rtpmapParser,
        fmtpParser: _fmtpParser,
      );
    }
    throw UnsupportedError('Not supported: $rule');
  }
}
