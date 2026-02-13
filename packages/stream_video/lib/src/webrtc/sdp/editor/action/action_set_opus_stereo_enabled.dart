import '../../../../logger/impl/tagged_logger.dart';
import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:SetOpusStereoEnabled');

// Temp SDP munging to add stereo=1 parameter before SFU switch is set for Flutter SDK
class SetOpusStereoEnabledAction implements SdpEditAction {
  const SetOpusStereoEnabledAction({
    required this.enabled,
    required this.rtpmapParser,
    required this.fmtpParser,
  });

  final bool enabled;
  final RtpmapParser rtpmapParser;
  final FmtpParser fmtpParser;

  @override
  void execute(List<SdpLine> sdpLines) {
    String? opusPayloadType;
    for (var index = 0; index < sdpLines.length; index++) {
      final sdpLine = sdpLines[index];
      if (sdpLine.isRtpmap) {
        final rtpmap = rtpmapParser.parse(sdpLine);
        if (rtpmap == null) continue;
        if (rtpmap.encodingName.toUpperCase() ==
            AudioCodec.opus.alias.toUpperCase()) {
          opusPayloadType = rtpmap.payloadType;
        }
      } else if (opusPayloadType != null && sdpLine.isFmtp) {
        final original = fmtpParser.parse(sdpLine);
        if (original == null || original.payloadType != opusPayloadType) {
          _logger.w(
            () => '[setOpusStereoEnabled] rejected (not opus): "$original"',
          );
          continue;
        }
        final modified = original.setStereoEnabled(enabled);
        _logger.v(() => '[setOpusStereoEnabled] original: "$original"');
        _logger.v(() => '[setOpusStereoEnabled] modified: "$modified"');
        sdpLines[index] = modified.toSdpLine();
      }
    }
  }
}

extension on Fmtp {
  Fmtp setStereoEnabled(bool enabled) {
    if (enabled) {
      return copyWith(
        parameters: {
          ...parameters,
          'stereo': '1',
        },
      );
    } else {
      return copyWith(
        parameters: {
          ...parameters,
        }..remove('stereo'),
      );
    }
  }
}
