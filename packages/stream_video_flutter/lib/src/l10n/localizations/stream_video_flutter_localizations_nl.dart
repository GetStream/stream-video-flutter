// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'stream_video_flutter_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class StreamVideoFlutterLocalizationsNl
    extends StreamVideoFlutterLocalizations {
  StreamVideoFlutterLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get desktopScreenShareChooseDialogTitle => 'Kies wat je wilt delen';

  @override
  String get desktopScreenShareChooseDialogShare => 'Delen';

  @override
  String get desktopScreenShareChooseDialogCancel => 'Annuleren';

  @override
  String get desktopScreenShareEntireScreen => 'Volledig scherm';

  @override
  String get desktopScreenShareWindow => 'Venster';

  @override
  String get livestreamBackstageStartingSoon => 'Livestream will start soon';

  @override
  String get livestreamBackstageStartingIn => 'Livestream will start in:';

  @override
  String livestreamBackstageParticipants(Object count) {
    return '$count paritipants have joined early';
  }

  @override
  String get livestreamEndedStatus => 'The livestream has ended.';

  @override
  String get livestreamEndedWatchRecordings => 'Watch the recordings:';

  @override
  String get livestreamHostNotAvailable =>
      'The host\'s video is not available.';

  @override
  String get livestreamBackstage => 'Backstage';

  @override
  String get livestreamLive => 'Live';
}
