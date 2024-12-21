import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A type that represents video encoding information.
@immutable
class RtcVideoEncoding
    with EquatableMixin
    implements Comparable<RtcVideoEncoding> {
  const RtcVideoEncoding({
    required this.maxFramerate,
    required this.maxBitrate,
    required this.quality,
  });

  final int maxFramerate;
  final int maxBitrate;
  final RtcVideoQuality quality;

  RtcVideoEncoding copyWith({
    int? maxFramerate,
    int? maxBitrate,
    RtcVideoQuality? quality,
  }) {
    return RtcVideoEncoding(
      maxFramerate: maxFramerate ?? this.maxFramerate,
      maxBitrate: maxBitrate ?? this.maxBitrate,
      quality: quality ?? this.quality,
    );
  }

  @override
  List<Object?> get props => [maxFramerate, maxBitrate, quality];

  @override
  int compareTo(RtcVideoEncoding other) {
    final result = maxBitrate.compareTo(other.maxBitrate);
    if (result == 0) {
      return maxFramerate.compareTo(other.maxFramerate);
    }

    return result;
  }

  @override
  String toString() {
    return 'Encoding{maxFramerate: $maxFramerate, maxBitrate: $maxBitrate, quality: $quality}';
  }
}

enum RtcVideoQuality { lowUnspecified, mid, high, off }
