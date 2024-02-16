import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/webrtc/sdp/attributes/fmtp.dart';
import 'package:stream_video/src/webrtc/sdp/attributes/rtpmap.dart';
import 'package:stream_video/src/webrtc/sdp/codec/sdp_codec.dart';
import 'package:stream_video/src/webrtc/sdp/editor/action/sdp_edit_action.dart';
import 'package:stream_video/src/webrtc/sdp/sdp.dart';

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
