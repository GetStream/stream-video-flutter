import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'localizations/stream_video_flutter_localizations.dart';

class CustomVideoLocalizationsDelegate
    extends LocalizationsDelegate<StreamVideoFlutterLocalizations> {
  CustomVideoLocalizationsDelegate(this.language, this.localizations);

  final String language;
  final StreamVideoFlutterLocalizations localizations;

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == language;
  }

  @override
  Future<StreamVideoFlutterLocalizations> load(Locale locale) {
    return SynchronousFuture<StreamVideoFlutterLocalizations>(localizations);
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<StreamVideoFlutterLocalizations> old,
  ) => false;
}
