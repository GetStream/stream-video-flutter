import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The incoming video resolutions the sample app offers.
enum IncomingVideoQuality {
  auto('Auto'),
  p2160('2160p'),
  p1080('1080p'),
  p720('720p'),
  p480('480p'),
  p144('144p'),
  off('Off');

  const IncomingVideoQuality(this.name);

  final String name;

  /// The resolution to ask for, or null where the choice is not a resolution:
  /// [auto] leaves it to the SDK and [off] turns incoming video off entirely.
  RtcVideoDimension? get resolution => switch (this) {
    auto || off => null,
    p2160 => const RtcVideoDimension(width: 3840, height: 2160),
    p1080 => const RtcVideoDimension(width: 1920, height: 1080),
    p720 => const RtcVideoDimension(width: 1280, height: 720),
    p480 => const RtcVideoDimension(width: 640, height: 480),
    p144 => const RtcVideoDimension(width: 256, height: 144),
  };

  @override
  String toString() => name;
}

/// The quality [settings] amount to, as one of the offered choices.
///
/// Rounds down to the nearest offered height, so a resolution set from
/// somewhere else still lands on an entry rather than on nothing.
IncomingVideoQuality incomingVideoQualityOf(IncomingVideoSettings? settings) {
  if (settings?.enabled == false) return IncomingVideoQuality.off;

  final height = settings?.preferredResolution?.height;
  return switch (height) {
    null => IncomingVideoQuality.auto,
    >= 2160 => IncomingVideoQuality.p2160,
    >= 1080 => IncomingVideoQuality.p1080,
    >= 720 => IncomingVideoQuality.p720,
    >= 480 => IncomingVideoQuality.p480,
    >= 144 => IncomingVideoQuality.p144,
    _ => IncomingVideoQuality.auto,
  };
}
