import 'package:meta/meta.dart';

import '../../../../logger/impl/tagged_logger.dart';
import '../../../../utils/list.dart';
import '../../attributes/fmtp.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import '../../specification/media_description.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:SetOpusRedEnabled');

@internal
class SetOpusRedEnabledAction implements SdpEditAction {
  const SetOpusRedEnabledAction({
    required this.enabled,
    required this.mediaDescriptionParser,
    required this.rtpmapParser,
    required this.fmtpParser,
  });

  final bool enabled;

  final MediaDescriptionParser mediaDescriptionParser;

  final RtpmapParser rtpmapParser;

  final FmtpParser fmtpParser;

  AudioCodec get red => AudioCodec.red;

  AudioCodec get opus => AudioCodec.opus;

  @override
  void execute(List<SdpLine> sdpLines) {
    if (enabled) {
      _enable(sdpLines);
    } else {
      _disable(sdpLines);
    }
  }

  void _enable(List<SdpLine> sdpLines) {
    var mdIndex = -1;
    MediaDescription? md;
    for (var index = 0; index < sdpLines.length; index++) {
      final sdpLine = sdpLines[index];
      if (sdpLine.isMediaDescription) {
        final description = mediaDescriptionParser.parse(sdpLine);
        if (description != null && description.isAudio) {
          mdIndex = index;
          md = description;
          _logger.v(() => '[enableOpusRed] original: "$md"');
        }
      } else if (md != null && sdpLine.isRtpmap) {
        final rtpmap = rtpmapParser.parse(sdpLine);
        if (rtpmap != null && rtpmap.hasCodec(red)) {
          final modified = md.copyWith(
            fmt: md.fmt.movedToFront(rtpmap.payloadType),
          );
          _logger.v(() => '[enableOpusRed] modified: "$modified"');
          sdpLines[mdIndex] = modified.toSdpLine();
        }
      }
    }
  }

  void _disable(List<SdpLine> sdpLines) {
    var mdIndex = -1;
    MediaDescription? audioDesc;
    Rtpmap? redRtmp;
    final redIndices = <int>[];
    for (var index = 0; index < sdpLines.length; index++) {
      final sdpLine = sdpLines[index];
      if (sdpLine.isMediaDescription) {
        if (audioDesc != null) {
          _logger.v(() => '[disableOpusRed] stopAt: "$sdpLine"');
          break;
        }
        final description = mediaDescriptionParser.parse(sdpLine);
        if (description != null && description.isAudio) {
          mdIndex = index;
          audioDesc = description;
          _logger.v(() => '[disableOpusRed] original: "$audioDesc"');
        }
      } else if (audioDesc != null && sdpLine.isRtpmap) {
        final rtpmap = rtpmapParser.parse(sdpLine);
        if (rtpmap != null && rtpmap.hasCodec(red)) {
          redIndices.add(index);
          redRtmp = rtpmap;
          final modified = audioDesc.copyWith(
            fmt: [...audioDesc.fmt]..removeWhere(
                (payloadType) => payloadType == rtpmap.payloadType,
              ),
          );
          _logger.v(() => '[disableOpusRed] modified: "$modified"');
          sdpLines[mdIndex] = modified.toSdpLine();
        }
      } else if (audioDesc != null && redRtmp != null && sdpLine.isFmtp) {
        final fmtp = fmtpParser.parse(sdpLine);
        if (fmtp?.payloadType == redRtmp.payloadType) {
          redIndices.add(index);
        }
      }
    }

    for (final index in redIndices.reversed) {
      final removed = sdpLines.removeAt(index);
      _logger.v(() => '[disableOpusRed] removed: "$removed"');
    }
  }
}
