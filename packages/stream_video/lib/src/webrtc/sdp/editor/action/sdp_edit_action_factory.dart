import 'package:meta/meta.dart';
import 'package:stream_video/src/webrtc/sdp/attributes/fmtp.dart';
import 'package:stream_video/src/webrtc/sdp/attributes/rtpmap.dart';
import 'package:stream_video/src/webrtc/sdp/editor/action/action_prioritize_codec.dart';
import 'package:stream_video/src/webrtc/sdp/editor/action/action_set_opus_dtx_enabled.dart';
import 'package:stream_video/src/webrtc/sdp/editor/action/action_set_opus_red_enabled.dart';
import 'package:stream_video/src/webrtc/sdp/editor/action/sdp_edit_action.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/rule_prioritize_codec.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/rule_set_opus_dtx_enabled.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/rule_set_opus_red_enabled.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/sdp_munging_rule.dart';
import 'package:stream_video/src/webrtc/sdp/specification/media_description.dart';

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
