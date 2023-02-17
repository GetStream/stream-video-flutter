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

  @override
  int compareTo(RtcVideoEncoding other) {
    final result = maxBitrate.compareTo(other.maxBitrate);
    if (result == 0) {
      return maxFramerate.compareTo(other.maxFramerate);
    }
    return result;
  }
}
