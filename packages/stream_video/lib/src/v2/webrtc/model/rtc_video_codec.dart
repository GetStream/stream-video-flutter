import 'package:flutter/cupertino.dart';

import 'rtc_video_dimension.dart';

/// Represents a video codec.
@immutable
class RtcVideoCodec {
  const RtcVideoCodec({
    required this.dimension,
    required this.quality,
    required this.maxBitrate,
    required this.scaleDownFactor,
  });

  /// The dimensions of the codec.
  final RtcVideoDimension dimension;

  /// The codec quality.
  final String quality;

  /// The maximum bitrate.
  final int maxBitrate;

  /// Factor that tells how much the resolution should be scaled down.
  final double scaleDownFactor;

  RtcVideoCodec copyWith({
    RtcVideoDimension? dimension,
    String? quality,
    int? maxBitrate,
    double? scaleDownFactor,
  }) {
    return RtcVideoCodec(
      dimension: dimension ?? this.dimension,
      quality: quality ?? this.quality,
      maxBitrate: maxBitrate ?? this.maxBitrate,
      scaleDownFactor: scaleDownFactor ?? this.scaleDownFactor,
    );
  }

  @override
  String toString() {
    return 'RtcVideoCodec{dimension: $dimension, quality: $quality, '
        'maxBitrate: $maxBitrate, scaleDownFactor: $scaleDownFactor}';
  }

  static const defaultCodecs = <String, RtcVideoCodec>{
    'f': full,
    'h': half,
    'q': quarter
  };

  static const full = RtcVideoCodec(
    dimension: RtcVideoDimension.full,
    quality: 'f',
    maxBitrate: 1000000,
    scaleDownFactor: 1,
  );

  static const half = RtcVideoCodec(
    dimension: RtcVideoDimension.half,
    quality: 'h',
    maxBitrate: 500000,
    scaleDownFactor: 2,
  );

  static const quarter = RtcVideoCodec(
    dimension: RtcVideoDimension.quarter,
    quality: 'q',
    maxBitrate: 250000,
    scaleDownFactor: 4,
  );
}
