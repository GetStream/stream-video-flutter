import '../../../../logger/impl/tagged_logger.dart';
import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:SetOpusDtxEnabled');

class SetOpusDtxEnabledAction implements SdpEditAction {
  const SetOpusDtxEnabledAction({
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
          _logger
              .w(() => '[setOpusDtxEnabled] rejected (not opus): "$original"');
          continue;
        }
        final modified = original.setDtxEnabled(enabled);
        _logger.v(() => '[setOpusDtxEnabled] original: "$original"');
        _logger.v(() => '[setOpusDtxEnabled] modified: "$modified"');
        sdpLines[index] = modified.toSdpLine();
      }
    }
  }
}

extension on Fmtp {
  Fmtp setDtxEnabled(bool enabled) {
    if (enabled) {
      return copyWith(
        parameters: {
          ...parameters,
          'usedtx': '1',
        },
      );
    } else {
      return copyWith(
        parameters: {
          ...parameters,
        }..remove('usedtx'),
      );
    }
  }
}
