import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// The choices offered for the resolution of other participants' video.
enum IncomingVideoQuality {
  /// Leaves the resolution to the SDK, which picks it from the size each
  /// video is drawn at.
  auto,

  /// 4K, 2160p.
  p2160,

  /// Full HD, 1080p.
  p1080,

  /// HD, 720p.
  p720,

  /// SD, 480p.
  p480,

  /// 144p, to save data.
  p144,

  /// No incoming video at all.
  off;

  /// The resolution to ask for, or null where the choice is not a resolution:
  /// [auto] leaves it to the SDK and [off] turns incoming video off.
  RtcVideoDimension? get resolution => switch (this) {
    auto || off => null,
    p2160 => const RtcVideoDimension(width: 3840, height: 2160),
    p1080 => const RtcVideoDimension(width: 1920, height: 1080),
    p720 => const RtcVideoDimension(width: 1280, height: 720),
    p480 => const RtcVideoDimension(width: 640, height: 480),
    p144 => const RtcVideoDimension(width: 256, height: 144),
  };

  /// The choice's name in the app's language, for example "HD 720p".
  String label(BuildContext context) {
    final translations = context.translations;
    return switch (this) {
      auto => translations.incomingVideoQualityAuto,
      p2160 => translations.incomingVideoQuality2160p,
      p1080 => translations.incomingVideoQuality1080p,
      p720 => translations.incomingVideoQuality720p,
      p480 => translations.incomingVideoQuality480p,
      p144 => translations.incomingVideoQuality144p,
      off => translations.incomingVideoQualityOff,
    };
  }

  /// The choice [settings] amount to.
  ///
  /// Rounds down to the nearest offered height, so a resolution set some other
  /// way still lands on a choice.
  static IncomingVideoQuality of(IncomingVideoSettings? settings) {
    if (settings?.enabled == false) return off;

    final height = settings?.preferredResolution?.height;
    return switch (height) {
      null => auto,
      >= 2160 => p2160,
      >= 1080 => p1080,
      >= 720 => p720,
      >= 480 => p480,
      >= 144 => p144,
      _ => auto,
    };
  }
}

/// Reads and sets a call's [IncomingVideoQuality].
extension IncomingVideoQualityCall on Call {
  /// The incoming video quality the call is set to.
  IncomingVideoQuality get incomingVideoQuality =>
      IncomingVideoQuality.of(dynascaleManager.incomingVideoSettings);

  /// [incomingVideoQuality], and every change to it.
  ///
  /// Emits the current quality to a new listener first.
  Stream<IncomingVideoQuality> get incomingVideoQualityStream =>
      dynascaleManager.incomingVideoSettingsStream
          .map(IncomingVideoQuality.of)
          .distinct();

  /// Sets the resolution other participants' video is received at.
  ///
  /// [IncomingVideoQuality.off] turns incoming video off; any other choice
  /// turns it back on.
  Future<Result<None>> setIncomingVideoQuality(IncomingVideoQuality quality) {
    if (quality == IncomingVideoQuality.off) {
      return setIncomingVideoEnabled(false);
    }
    return setPreferredIncomingVideoResolution(quality.resolution);
  }
}
