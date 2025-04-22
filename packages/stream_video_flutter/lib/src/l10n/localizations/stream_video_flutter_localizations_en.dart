// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'stream_video_flutter_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StreamVideoFlutterLocalizationsEn extends StreamVideoFlutterLocalizations {
  StreamVideoFlutterLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get desktopScreenShareChooseDialogTitle => 'Choose what to share';

  @override
  String get desktopScreenShareChooseDialogShare => 'Share';

  @override
  String get desktopScreenShareChooseDialogCancel => 'Cancel';

  @override
  String get desktopScreenShareEntireScreen => 'Entire Screen';

  @override
  String get desktopScreenShareWindow => 'Window';

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
  String get livestreamHostNotAvailable => 'The host\'s video is not available.';

  @override
  String get livestreamBackstage => 'Backstage';

  @override
  String get livestreamLive => 'Live';
}
