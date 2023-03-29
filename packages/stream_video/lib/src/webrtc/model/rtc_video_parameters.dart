import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'rtc_video_dimension.dart';
import 'rtc_video_encoding.dart';

@immutable
class RtcVideoParameters
    with EquatableMixin
    implements Comparable<RtcVideoParameters> {
  const RtcVideoParameters({
    this.description,
    required this.dimension,
    required this.encoding,
  });

  final String? description;
  final RtcVideoDimension dimension;
  final RtcVideoEncoding encoding;

  RtcVideoParameters copyWith({
    String? description,
    RtcVideoDimension? dimension,
    RtcVideoEncoding? encoding,
  }) {
    return RtcVideoParameters(
      description: description ?? this.description,
      dimension: dimension ?? this.dimension,
      encoding: encoding ?? this.encoding,
    );
  }

  @override
  List<Object?> get props => [dimension, encoding, description];

  @override
  bool? get stringify => true;

  @override
  int compareTo(RtcVideoParameters other) {
    // compare by dimension's area
    final result = dimension.area.compareTo(other.dimension.area);
    // if dimensions have equal area, compare by encoding
    if (result == 0) {
      return encoding.compareTo(other.encoding);
    }

    return result;
  }
}

extension RtcVideoParametersPresets on RtcVideoParameters {
  // 16:9 Presets
  static const h180_16x9 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h180_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 120 * 1000,
      maxFramerate: 15,
    ),
  );

  static const h360_16x9 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h360_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 300 * 1000,
      maxFramerate: 20,
    ),
  );

  static const h720_16x9 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h720_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 2 * 1000 * 1000,
      maxFramerate: 30,
    ),
  );

  // 4:3 presets
  static const h180_4x3 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h180_43,
    encoding: RtcVideoEncoding(
      maxBitrate: 100 * 1000,
      maxFramerate: 15,
    ),
  );

  static const h360_4x3 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h360_43,
    encoding: RtcVideoEncoding(
      maxBitrate: 225 * 1000,
      maxFramerate: 20,
    ),
  );

  static const h720_4x3 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h720_43,
    encoding: RtcVideoEncoding(
      maxBitrate: 1 * 500 * 1000,
      maxFramerate: 30,
    ),
  );
}
