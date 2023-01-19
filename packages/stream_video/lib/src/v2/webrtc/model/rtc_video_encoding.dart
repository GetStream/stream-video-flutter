import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';

/// A type that represents video encoding information.
@immutable
class RtcVideoEncoding
    with EquatableMixin
    implements Comparable<RtcVideoEncoding> {
  const RtcVideoEncoding({
    required this.maxFramerate,
    required this.maxBitrate,
  });

  final int maxFramerate;
  final int maxBitrate;

  @override
  List<Object?> get props => [maxFramerate, maxBitrate];

  // ----------------------------------------------------------------------
  // Comparable

  @override
  int compareTo(RtcVideoEncoding other) {
    // compare bitrates
    final result = maxBitrate.compareTo(other.maxBitrate);
    // if bitrates are the same, compare by fps
    if (result == 0) {
      return maxFramerate.compareTo(other.maxFramerate);
    }

    return result;
  }
}

/// Convenience extension for [RtcVideoEncoding].
extension VideoEncodingExt on RtcVideoEncoding {
  rtc.RTCRtpEncoding toRTCRtpEncoding({
    String? rid,
    double? scaleResolutionDownBy = 1.0,
    int? numTemporalLayers,
  }) {
    return rtc.RTCRtpEncoding(
      rid: rid,
      scaleResolutionDownBy: scaleResolutionDownBy,
      maxFramerate: maxFramerate,
      maxBitrate: maxBitrate,
      numTemporalLayers: numTemporalLayers,
    );
  }
}
