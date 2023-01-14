import 'package:flutter/cupertino.dart';

import 'rtc_video_codec.dart';
import 'rtc_video_dimension.dart';

/// Configuration for the video options for a call.
@immutable
class RtcVideoOptions {
  const RtcVideoOptions({
    this.supportedCodecs = RtcVideoCodec.defaultCodecs,
  });

  /// The supported codecs.
  final Map<String, RtcVideoCodec> supportedCodecs;

  RtcVideoOptions copyWith({
    Map<String, RtcVideoCodec>? supportedCodecs,
  }) {
    return RtcVideoOptions(
      supportedCodecs: supportedCodecs ?? this.supportedCodecs,
    );
  }

  @override
  String toString() {
    return 'RtcVideoOptions{supportedCodecs: $supportedCodecs}';
  }
}
