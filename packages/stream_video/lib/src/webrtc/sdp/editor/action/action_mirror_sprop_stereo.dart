import '../../../../logger/impl/tagged_logger.dart';
import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:MirrorSpropStereo');

/// Adds `stereo=1` to the Opus fmtp line in the answer for audio sections
/// whose offer contained `sprop-stereo=1`.
class MirrorSpropStereoAction implements SdpEditAction {
  const MirrorSpropStereoAction({
    required this.offerSdp,
    required this.rtpmapParser,
    required this.fmtpParser,
  });

  final String? offerSdp;
  final RtpmapParser rtpmapParser;
  final FmtpParser fmtpParser;

  @override
  void execute(List<SdpLine> sdpLines) {
    final offer = offerSdp;
    if (offer == null) {
      _logger.d(() => '[execute] no offerSdp available, skipping');
      return;
    }

    final stereoMids = _findSpropStereoMids(offer);
    if (stereoMids.isEmpty) {
      _logger.d(() => '[execute] no sprop-stereo=1 mids in offer');
      return;
    }

    _logger.d(() => '[execute] sprop-stereo mids from offer: $stereoMids');
    _addStereoToMatchingMids(sdpLines, stereoMids);
  }

  Set<String> _findSpropStereoMids(String offerSdp) {
    final mids = <String>{};
    final lines = offerSdp.split('\n');

    var inAudioSection = false;
    String? currentMid;
    String? opusPayloadType;

    for (final rawLine in lines) {
      final line = rawLine.trimRight();

      if (line.startsWith('m=')) {
        inAudioSection = line.startsWith('m=audio');
        currentMid = null;
        opusPayloadType = null;
        continue;
      }

      if (!inAudioSection) continue;

      if (line.startsWith('a=mid:')) {
        currentMid = line.substring('a=mid:'.length).trim();
      } else if (line.isRtpmap) {
        final rtpmap = rtpmapParser.parse(line);
        if (rtpmap != null &&
            rtpmap.encodingName.toUpperCase() ==
                AudioCodec.opus.alias.toUpperCase()) {
          opusPayloadType = rtpmap.payloadType;
        }
      } else if (opusPayloadType != null && line.isFmtp) {
        final fmtp = fmtpParser.parse(line);
        if (fmtp != null &&
            fmtp.payloadType == opusPayloadType &&
            fmtp.parameters['sprop-stereo'] == '1' &&
            currentMid != null) {
          mids.add(currentMid);
        }
      }
    }

    return mids;
  }

  void _addStereoToMatchingMids(
    List<SdpLine> sdpLines,
    Set<String> stereoMids,
  ) {
    var inAudioSection = false;
    String? currentMid;
    String? opusPayloadType;

    for (var i = 0; i < sdpLines.length; i++) {
      final line = sdpLines[i];

      if (line.startsWith('m=')) {
        inAudioSection = line.startsWith('m=audio');
        currentMid = null;
        opusPayloadType = null;
        continue;
      }

      if (!inAudioSection) continue;

      if (line.startsWith('a=mid:')) {
        currentMid = line.substring('a=mid:'.length).trim();
      } else if (line.isRtpmap) {
        final rtpmap = rtpmapParser.parse(line);
        if (rtpmap != null &&
            rtpmap.encodingName.toUpperCase() ==
                AudioCodec.opus.alias.toUpperCase()) {
          opusPayloadType = rtpmap.payloadType;
        }
      } else if (currentMid != null && opusPayloadType != null && line.isFmtp) {
        final fmtp = fmtpParser.parse(line);
        if (fmtp == null || fmtp.payloadType != opusPayloadType) continue;
        if (!stereoMids.contains(currentMid)) continue;
        if (fmtp.parameters['stereo'] == '1') continue;

        final modified = fmtp.copyWith(
          parameters: {...fmtp.parameters, 'stereo': '1'},
        );

        sdpLines[i] = modified.toSdpLine();
      }
    }
  }
}
