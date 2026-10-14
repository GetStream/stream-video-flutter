import '../../../../logger/impl/tagged_logger.dart';
import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:EnableOpusStereo');

/// Adds `stereo=1` to the Opus fmtp line of every audio section.
///
/// In a local answer this tells the remote sender that we can receive stereo,
/// which makes WebRTC decode Opus in stereo. Mono streams still decode
/// correctly, so this is applied regardless of what the offer contains.
class EnableOpusStereoAction implements SdpEditAction {
  const EnableOpusStereoAction({
    required this.rtpmapParser,
    required this.fmtpParser,
  });

  final RtpmapParser rtpmapParser;
  final FmtpParser fmtpParser;

  @override
  void execute(List<SdpLine> sdpLines) {
    var inAudioSection = false;
    String? opusPayloadType;

    for (var i = 0; i < sdpLines.length; i++) {
      final line = sdpLines[i];

      if (line.startsWith('m=')) {
        inAudioSection = line.startsWith('m=audio');
        opusPayloadType = null;
        continue;
      }

      if (!inAudioSection) continue;

      if (line.isRtpmap) {
        final rtpmap = rtpmapParser.parse(line);
        if (rtpmap != null &&
            rtpmap.encodingName.toUpperCase() ==
                AudioCodec.opus.alias.toUpperCase()) {
          opusPayloadType = rtpmap.payloadType;
        }
      } else if (opusPayloadType != null && line.isFmtp) {
        final fmtp = fmtpParser.parse(line);
        if (fmtp == null || fmtp.payloadType != opusPayloadType) continue;
        if (fmtp.parameters['stereo'] == '1') continue;

        final modified = fmtp.copyWith(
          parameters: {...fmtp.parameters, 'stereo': '1'},
        );

        _logger.v(() => '[execute] enabled stereo: $line');
        sdpLines[i] = modified.toSdpLine();
      }
    }
  }
}
