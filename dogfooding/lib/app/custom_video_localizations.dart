import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

class CustomVideoLocalizationsNL extends StreamVideoFlutterLocalizationsNl {
  static LocalizationsDelegate<StreamVideoFlutterLocalizations> get delegate =>
      CustomVideoLocalizationsDelegate('nl', CustomVideoLocalizationsNL());

  @override
  String get desktopScreenShareEntireScreen => 'Scherm';
}
