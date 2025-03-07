import 'package:flutter/widgets.dart';

import 'localizations/stream_video_flutter_localizations.dart';
import 'localizations/stream_video_flutter_localizations_en.dart';

extension LocalizationExtension on BuildContext {
  /// Retrieves current translations according to locale
  /// Defaults to [StreamVideoFlutterLocalizationsEn]
  StreamVideoFlutterLocalizations get translations =>
      StreamVideoFlutterLocalizations.of(this) ??
      StreamVideoFlutterLocalizationsEn();
}
