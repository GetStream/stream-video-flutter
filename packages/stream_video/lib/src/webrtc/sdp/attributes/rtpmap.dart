import 'package:equatable/equatable.dart';

import '../codec/sdp_codec.dart';
import '../sdp.dart';

/// Represents 'rtpmap' attribute
/// Reference: https://www.rfc-editor.org/rfc/rfc4566#section-6.
/// Format: a=rtpmap:<payload type> <encoding name>/<clock rate> [/<encoding parameters>]
class Rtpmap with EquatableMixin {
  Rtpmap({
    required this.payloadType,
    required this.encodingName,
    required this.clockRate,
    this.encodingParameters,
  });

  final String payloadType;
  final String encodingName;
  final String clockRate;
  final String? encodingParameters;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        payloadType,
        encodingName,
        clockRate,
        encodingParameters,
      ];
}

extension RtpmapUtils on Rtpmap {
  bool hasCodec(SdpCodec codec) =>
      encodingName.toUpperCase() == codec.alias.toUpperCase();
}

extension RtpmapSdpUtils on SdpLine {
  bool get isRtpmap => startsWith('a=rtpmap');
}

class RtpmapParser {
  final _regex = RegExp(r'^a=rtpmap:(\d+) ([\w-]+)/(\d+)(?:/([\w-]+))?$');
  final _groupPayloadType = 1;
  final _groupEncodingName = 2;
  final _groupClockRate = 3;
  final _groupEncodingParameters = 4;

  Rtpmap? parse(SdpLine sdpLine) {
    final match = _regex.firstMatch(sdpLine);
    if (match == null) {
      return null;
    }
    final payloadType = match.group(_groupPayloadType);
    final encodingName = match.group(_groupEncodingName);
    final clockRate = match.group(_groupClockRate);
    final encodingParameters = match.group(_groupEncodingParameters);
    if (payloadType == null || encodingName == null || clockRate == null) {
      return null;
    }
    return Rtpmap(
      payloadType: payloadType,
      encodingName: encodingName,
      clockRate: clockRate,
      encodingParameters: encodingParameters,
    );
  }
}
