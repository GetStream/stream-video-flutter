import 'package:meta/meta.dart';

import '../../../../logger/impl/tagged_logger.dart';
import '../../../../utils/list.dart';
import '../../attributes/rtpmap.dart';
import '../../codec/sdp_codec.dart';
import '../../specification/media_description.dart';
import 'sdp_edit_action.dart';

final _logger = taggedLogger(tag: 'SV:PreferCodec');

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
    final mediaDescription = mediaDescriptionParser.parse(mdLine);
    if (mediaDescription == null) {
      return;
    }
    final rtpmap = rtpmapParser.parse(rtpmapLine);
    if (rtpmap == null) {
      return;
    }

    final modifiedMediaDescription = mediaDescription.copyWith(
        fmt: mediaDescription.fmt.movedToFront(rtpmap.payloadType));
    _logger.v(() => '[preferCodec] mediaDescription: "$mediaDescription"');
    _logger.v(() =>
        '[preferCodec] modifiedMediaDescription: "$modifiedMediaDescription"');
    sdpLines[mdIndex] = modifiedMediaDescription.toSdpLine();
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
      if (rtpmap?.encodingName.toUpperCase() == codec.alias) {
        return index;
      }
    }
    return -1;
  }
}