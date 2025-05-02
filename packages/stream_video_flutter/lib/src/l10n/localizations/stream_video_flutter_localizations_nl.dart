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
  String get livestreamBackstageStartingSoon => 'Livestream begint binnenkort';

  @override
  String get livestreamBackstageStartingIn => 'Livestream begint over:';

  @override
  String livestreamBackstageParticipants(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deelnemers zijn',
      one: 'Eén deelnemer is',
      zero: 'Nog geen deelnemers  zijn',
    );
    return '$_temp0 vroeg aanwezig';
  }

  @override
  String get livestreamEndedStatus => 'De livestream is afgelopen.';

  @override
  String get livestreamEndedWatchRecordings => 'Bekijk de opnames:';

  @override
  String get livestreamHostNotAvailable =>
      'De video van de host is niet beschikbaar.';

  @override
  String get livestreamBackstage => 'Backstage';

  @override
  String get livestreamLive => 'Live';
}
