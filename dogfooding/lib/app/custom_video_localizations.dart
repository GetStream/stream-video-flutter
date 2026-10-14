import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

/// The SDK's strings, with the ones this app words differently.
///
/// Also shows how an app overrides a string the SDK ships.
class CustomVideoLocalizationsEN extends StreamVideoFlutterLocalizationsEn {
  static LocalizationsDelegate<StreamVideoFlutterLocalizations> get delegate =>
      CustomVideoLocalizationsDelegate('en', CustomVideoLocalizationsEN());

  @override
  String get recordingsEmptyDescription =>
      'Test out our call recording feature, after the recording is ended, it '
      'will be stored here.';
}

/// The Dutch counterpart of [CustomVideoLocalizationsEN].
class CustomVideoLocalizationsNL extends StreamVideoFlutterLocalizationsNl {
  static LocalizationsDelegate<StreamVideoFlutterLocalizations> get delegate =>
      CustomVideoLocalizationsDelegate('nl', CustomVideoLocalizationsNL());

  @override
  String get desktopScreenShareEntireScreen => 'Scherm';

  @override
  String get recordingsEmptyDescription =>
      'Probeer onze opnamefunctie uit: zodra een opname is afgelopen, wordt '
      'die hier bewaard.';
}
