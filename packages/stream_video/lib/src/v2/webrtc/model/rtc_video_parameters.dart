import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../types/video_dimensions.dart';
import '../../../types/video_encoding.dart';
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

  @override
  List<Object?> get props => [description, dimension, encoding];

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

  // TODO: Return constraints that will work for all platforms (Web & Mobile)
  // https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
  Map<String, dynamic> toMediaConstraintsMap() => <String, dynamic>{
        'width': dimension.width,
        'height': dimension.height,
        'frameRate': encoding.maxFramerate,
      };
}

extension RtcVideoParametersPresets on RtcVideoParameters {
  // 16:9 default
  static final defaultSimulcast169 = [
    h180_169,
    h360_169,
    h720_169,
  ];

  // 4:3 default
  static final defaultSimulcast43 = [
    h180_43,
    h360_43,
    h720_43,
  ];

  // screen share default
  static final defaultSimulcastScreenShare = [
    screenShareH360FPS3,
    screenShareH720FPS5,
  ];

  // 16:9 Presets
  static const h180_169 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h180_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 120 * 1000,
      maxFramerate: 15,
    ),
  );

  static const h360_169 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h360_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 300 * 1000,
      maxFramerate: 20,
    ),
  );

  static const h720_169 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h720_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 2 * 1000 * 1000,
      maxFramerate: 30,
    ),
  );

  // 4:3 presets
  static const h180_43 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h180_43,
    encoding: RtcVideoEncoding(
      maxBitrate: 100 * 1000,
      maxFramerate: 15,
    ),
  );

  static const h360_43 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h360_43,
    encoding: RtcVideoEncoding(
      maxBitrate: 225 * 1000,
      maxFramerate: 20,
    ),
  );

  static const h720_43 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h720_43,
    encoding: RtcVideoEncoding(
      maxBitrate: 1 * 500 * 1000,
      maxFramerate: 30,
    ),
  );

  // Screen share
  static const screenShareH360FPS3 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h360_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 200 * 1000,
      maxFramerate: 3,
    ),
  );

  static const screenShareH720FPS5 = RtcVideoParameters(
    dimension: RtcVideoDimensionPresets.h720_169,
    encoding: RtcVideoEncoding(
      maxBitrate: 400 * 1000,
      maxFramerate: 5,
    ),
  );
}
