import '../../../../logger/impl/tagged_logger.dart';
import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:EnableOpusDtx');

class EnableOpusDtxAction implements SdpEditAction {
  const EnableOpusDtxAction({
    required this.rtpmapParser,
    required this.fmtpParser,
  });

  final RtpmapParser rtpmapParser;
  final FmtpParser fmtpParser;

  @override
  void execute(List<String> sdpLines) {
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
      } else if (Fmtp.isFmtp(sdpLine)) {
        final original = fmtpParser.parse(sdpLine);
        if (original == null || original.payloadType != opusPayloadType) {
          _logger.w(() => '[enableOpusDtx] rejected (not opus): "$original"');
          continue;
        }
        final modified = original.copyWith(
          parameters: {
            ...original.parameters,
            'usedtx': '1',
          },
        );
        _logger.v(() => '[enableOpusDtx] original: "$original"');
        _logger.v(() => '[enableOpusDtx] modified: "$modified"');
        sdpLines[index] = modified.toSdpLine();
      }
    }
  }
}
