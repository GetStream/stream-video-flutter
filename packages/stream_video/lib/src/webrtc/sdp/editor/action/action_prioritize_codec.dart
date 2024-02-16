import 'package:meta/meta.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/utils/list.dart';
import 'package:stream_video/src/webrtc/sdp/attributes/rtpmap.dart';
import 'package:stream_video/src/webrtc/sdp/codec/sdp_codec.dart';
import 'package:stream_video/src/webrtc/sdp/editor/action/sdp_edit_action.dart';
import 'package:stream_video/src/webrtc/sdp/sdp.dart';
import 'package:stream_video/src/webrtc/sdp/specification/media_description.dart';

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
