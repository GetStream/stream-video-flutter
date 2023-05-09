import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class RtcVideoDimension with EquatableMixin {
  const RtcVideoDimension({
    required this.width,
    required this.height,
  }) : area = width * height;

  const RtcVideoDimension.zero()
      : width = 0,
        height = 0,
        area = 0;

  final int width;
  final int height;
  final int area;

  /// Returns true if the area is zero or negative.
  bool get isEmpty => area <= 0;

  RtcVideoDimension copyWith({
    int? width,
    int? height,
  }) {
    return RtcVideoDimension(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  String toString() {
    return 'Dimension{w: $width, h: $height}';
  }

  @override
  List<Object?> get props => [width, height];
}

extension RtcVideoDimensionHelpers on RtcVideoDimension {
  // aspect ratios
  static const aspect_16x9 = 16.0 / 9.0;
  static const aspect_4x3 = 4.0 / 3.0;

  double aspect() => width > height ? width / height : height / width;

  /// Returns the larger value
  int max() => math.max(width, height);

  /// Returns the smaller value
  int min() => math.min(width, height);

  /// Simply returns the area
  int area() => width * height;
}

extension RtcVideoDimensionPresets on RtcVideoDimension {
  // 16:9 aspect ratio presets
  static const h90_169 = RtcVideoDimension(width: 160, height: 90);
  static const h180_169 = RtcVideoDimension(width: 320, height: 180);
  static const h216_169 = RtcVideoDimension(width: 384, height: 216);
  static const h360_169 = RtcVideoDimension(width: 640, height: 360);
  static const h540_169 = RtcVideoDimension(width: 960, height: 540);
  static const h720_169 = RtcVideoDimension(width: 1280, height: 720);
  static const h1080_169 = RtcVideoDimension(width: 1920, height: 1080);
  static const h1440_169 = RtcVideoDimension(width: 2560, height: 1440);
  static const h2160_169 = RtcVideoDimension(width: 3840, height: 2160);

  // 4:3 aspect ratio presets
  static const h120_43 = RtcVideoDimension(width: 160, height: 120);
  static const h180_43 = RtcVideoDimension(width: 240, height: 180);
  static const h240_43 = RtcVideoDimension(width: 320, height: 240);
  static const h360_43 = RtcVideoDimension(width: 480, height: 360);
  static const h480_43 = RtcVideoDimension(width: 640, height: 480);
  static const h540_43 = RtcVideoDimension(width: 720, height: 540);
  static const h720_43 = RtcVideoDimension(width: 960, height: 720);
  static const h1080_43 = RtcVideoDimension(width: 1440, height: 1080);
  static const h1440_43 = RtcVideoDimension(width: 1920, height: 1440);
}
