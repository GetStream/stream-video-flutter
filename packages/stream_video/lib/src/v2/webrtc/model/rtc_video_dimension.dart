import 'package:flutter/cupertino.dart';

@immutable
class RtcVideoDimension {
  const RtcVideoDimension({
    required this.width,
    required this.height,
  }) : area = width * height;

  final int width;
  final int height;
  final int area;

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
    return 'RtcVideoDimension{width: $width, height: $height, area: $area}';
  }

  static const full = RtcVideoDimension(width: 1280, height: 720);
  static const half = RtcVideoDimension(width: 640, height: 480);
  static const quarter = RtcVideoDimension(width: 480, height: 360);
}
