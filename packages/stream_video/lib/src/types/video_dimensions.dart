import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A simple class that represents dimensions of video.
@immutable
class VideoDimension with EquatableMixin {
  const VideoDimension(
    this.width,
    this.height,
  );

  final int width;
  final int height;

  @override
  List<Object?> get props => [width, height];

  @override
  bool? get stringify => true;

  VideoDimension copyWith({
    int? width,
    int? height,
  }) {
    return VideoDimension(
      width ?? this.width,
      height ?? this.height,
    );
  }
}

extension VideoDimensionHelpers on VideoDimension {
  // aspect ratios
  static const aspect169 = 16.0 / 9.0;
  static const aspect43 = 4.0 / 3.0;

  double aspect() => width > height ? width / height : height / width;

  /// Returns the larger value
  int max() => math.max(width, height);

  /// Returns the smaller value
  int min() => math.min(width, height);

  /// Simply returns the area
  int area() => width * height;
}

extension VideoDimensionPresets on VideoDimension {
  // 16:9 aspect ratio presets
  static const h90_169 = VideoDimension(160, 90);
  static const h180_169 = VideoDimension(320, 180);
  static const h216_169 = VideoDimension(384, 216);
  static const h360_169 = VideoDimension(640, 360);
  static const h540_169 = VideoDimension(960, 540);
  static const h720_169 = VideoDimension(1280, 720);
  static const h1080_169 = VideoDimension(1920, 1080);
  static const h1440_169 = VideoDimension(2560, 1440);
  static const h2160_169 = VideoDimension(3840, 2160);

  // 4:3 aspect ratio presets
  static const h120_43 = VideoDimension(160, 120);
  static const h180_43 = VideoDimension(240, 180);
  static const h240_43 = VideoDimension(320, 240);
  static const h360_43 = VideoDimension(480, 360);
  static const h480_43 = VideoDimension(640, 480);
  static const h540_43 = VideoDimension(720, 540);
  static const h720_43 = VideoDimension(960, 720);
  static const h1080_43 = VideoDimension(1440, 1080);
  static const h1440_43 = VideoDimension(1920, 1440);
}
