import 'package:meta/meta.dart';

import '../../../../logger/impl/tagged_logger.dart';
import '../../../../utils/list.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
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
  void execute(List<String> sdpLines) {
    final mdIndex = indexOfMediaDescription(sdpLines);
    if (mdIndex == -1) {
      return;
    }
    final rtpmapIndex = indexOfRtpmap(sdpLines);
    if (rtpmapIndex == -1) {
      return;
    }
    final mdLine = sdpLines[mdIndex];
    final rtpmapLine = sdpLines[rtpmapIndex];
    final original = mediaDescriptionParser.parse(mdLine);
    if (original == null) {
      return;
    }
    final rtpmap = rtpmapParser.parse(rtpmapLine);
    if (rtpmap == null) {
      return;
    }

    final modified = original.copyWith(
      fmt: original.fmt.movedToFront(rtpmap.payloadType),
    );
    _logger.v(() => '[prioritizeCodec] original: "$original"');
    _logger.v(() => '[prioritizeCodec] modified: "$modified"');
    sdpLines[mdIndex] = modified.toSdpLine();
  }

  int indexOfMediaDescription(List<String> sdpLines) {
    for (var index = 0; index < sdpLines.length; index++) {
      final sdpLine = sdpLines[index];
      if (codec is VideoCodec && MediaDescription.isVideo(sdpLine)) {
        return index;
      } else if (codec is AudioCodec && MediaDescription.isAudio(sdpLine)) {
        return index;
      }
    }
    return -1;
  }

  int indexOfRtpmap(List<String> sdpLines) {
    for (var index = 0; index < sdpLines.length; index++) {
      final line = sdpLines[index];
      final rtpmap = rtpmapParser.parse(line);
      if (rtpmap?.encodingName.toUpperCase() == codec.alias.toUpperCase()) {
        return index;
      }
    }
    return -1;
  }
}
