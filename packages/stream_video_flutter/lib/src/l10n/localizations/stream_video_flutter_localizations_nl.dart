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

  @override
  String get lobbyMicrophoneSection => 'Microfoon';

  @override
  String get lobbySpeakerSection => 'Luidspreker';

  @override
  String get lobbyCameraSection => 'Camera';

  @override
  String get lobbySystemDefaultDevice => 'Systeemstandaard';

  @override
  String get lobbyDefaultDeviceHint => 'Standaard';

  @override
  String get lobbySelectAudioDevices => 'Audioapparaten selecteren';

  @override
  String get lobbySelectVideoDevice => 'Video-apparaat selecteren';

  @override
  String get lobbyMicrophonePermissionRequired =>
      'Microfoontoegang is vereist om audioapparaten te selecteren';

  @override
  String get lobbyCameraPermissionRequired =>
      'Cameratoegang is vereist om een video-apparaat te selecteren';

  @override
  String get lobbyToggleMicrophone => 'Microfoon aan- of uitzetten';

  @override
  String get lobbyToggleCamera => 'Camera aan- of uitzetten';

  @override
  String get lobbyTitle => 'Voordat je deelneemt';

  @override
  String get lobbySubtitle => 'Stel je audio en video in';

  @override
  String get lobbyJoinCall => 'Deelnemen';

  @override
  String get lobbyParticipants => 'Deelnemers';
}
