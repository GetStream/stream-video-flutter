import 'package:meta/meta.dart';

@immutable
class VideoDimension {
  /// Returns a new [VideoDimension] instance.
  const VideoDimension({
    required this.height,
    required this.width,
  });

  final int height;

  final int width;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoDimension && other.height == height && other.width == width;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (height.hashCode) + (width.hashCode);

  @override
  String toString() => 'VideoDimension[height=$height, width=$width]';
}
