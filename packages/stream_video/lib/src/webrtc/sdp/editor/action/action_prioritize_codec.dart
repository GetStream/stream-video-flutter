import 'package:meta/meta.dart';

import '../../../../logger/impl/tagged_logger.dart';
import '../../../../utils/list.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import '../../sdp.dart';
import '../../specification/media_description.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:PrioritizeCodec');

@internal
class PrioritizeCodecAction implements SdpEditAction {
  const PrioritizeCodecAction({
    required this.codec,
    required this.mediaDescriptionParser,
    required this.rtpmapParser,
  });

  final SdpCodec codec;

  final MediaDescriptionParser mediaDescriptionParser;

  final RtpmapParser rtpmapParser;

  @override
  void execute(List<SdpLine> sdpLines) {
    var mdIndex = -1;
    MediaDescription? md;
    for (var index = 0; index < sdpLines.length; index++) {
      final sdpLine = sdpLines[index];
      if (sdpLine.isMediaDescription) {
        final description = mediaDescriptionParser.parse(sdpLine);
        if (description != null && description.isTypeOf(codec.type)) {
          mdIndex = index;
          md = description;
          _logger.v(() => '[prioritizeCodec] #$codec; original: "$md"');
        }
      } else if (md != null && sdpLine.isRtpmap) {
        final rtpmap = rtpmapParser.parse(sdpLine);
        if (rtpmap != null && rtpmap.hasCodec(codec)) {
          final modified = md.copyWith(
            fmt: md.fmt.movedToFront(rtpmap.payloadType),
          );
          _logger.v(() => '[prioritizeCodec] #$codec; modified: "$modified"');
          sdpLines[mdIndex] = modified.toSdpLine();
        }
      }
    }
  }
}
