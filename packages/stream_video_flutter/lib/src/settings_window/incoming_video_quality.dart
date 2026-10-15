import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// The name of an [IncomingVideoQuality] for people to read.
extension IncomingVideoQualityLabel on IncomingVideoQuality {
  /// The choice's name in the app's language, for example "HD 720p".
  String label(BuildContext context) {
    final translations = context.translations;
    return switch (this) {
      IncomingVideoQuality.auto => translations.incomingVideoQualityAuto,
      IncomingVideoQuality.p2160 => translations.incomingVideoQuality2160p,
      IncomingVideoQuality.p1080 => translations.incomingVideoQuality1080p,
      IncomingVideoQuality.p720 => translations.incomingVideoQuality720p,
      IncomingVideoQuality.p480 => translations.incomingVideoQuality480p,
      IncomingVideoQuality.p144 => translations.incomingVideoQuality144p,
      IncomingVideoQuality.off => translations.incomingVideoQualityOff,
    };
  }
}
