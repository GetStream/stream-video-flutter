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
  String get desktopScreenShareRefresh => 'Vernieuwen';

  @override
  String get desktopScreenShareNoSources => 'Hier valt niets te delen.';

  @override
  String get desktopScreenShareLoadFailed =>
      'Kon de schermen en vensters niet ophalen.';

  @override
  String get desktopScreenShareRetry => 'Opnieuw proberen';

  @override
  String get layoutMenuTitle => 'Indeling';

  @override
  String get layoutSelectTooltip => 'Indeling wijzigen';

  @override
  String get layoutDefault => 'Standaard';

  @override
  String get layoutGrid => 'Raster';

  @override
  String get layoutSpeakerTop => 'Spreker (boven)';

  @override
  String get layoutSpeakerBottom => 'Spreker (onder)';

  @override
  String get layoutSpeakerLeft => 'Spreker (links)';

  @override
  String get layoutSpeakerRight => 'Spreker (rechts)';

  @override
  String get layoutSpeakerOneToOne => 'Spreker 1:1';

  @override
  String get participantsPrevious => 'Vorige deelnemers';

  @override
  String get participantsNext => 'Volgende deelnemers';

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
  String get defaultDevice => 'Standaard';

  @override
  String get lobbySelectAudioDevices => 'Audioapparaten selecteren';

  @override
  String get lobbySelectVideoDevice => 'Video-apparaat selecteren';

  @override
  String get lobbyToggleMicrophone => 'Microfoon aan- of uitzetten';

  @override
  String get lobbyToggleCamera => 'Camera aan- of uitzetten';

  @override
  String get lobbyTitle => 'Voordat je deelneemt';

  @override
  String get lobbyJoinCall => 'Deelnemen';

  @override
  String get lobbyParticipants => 'Deelnemers';

  @override
  String get lobbyMicrophoneNotOpened =>
      'Zet de microfoon aan om een apparaat te kiezen';

  @override
  String get lobbyCameraNotOpened =>
      'Zet de camera aan om een apparaat te kiezen';

  @override
  String get lobbyNoMicrophoneFound => 'Geen microfoon gevonden';

  @override
  String get lobbyNoCameraFound => 'Geen camera gevonden';

  @override
  String get lobbyMicrophonePermissionDenied =>
      'Microfoontoegang is geweigerd — sta het toe in je systeeminstellingen';

  @override
  String get lobbyCameraPermissionDenied =>
      'Cameratoegang is geweigerd — sta het toe in je systeeminstellingen';

  @override
  String get lobbyMicrophoneBusy => 'Een andere app gebruikt de microfoon';

  @override
  String get lobbyCameraBusy => 'Een andere app gebruikt de camera';

  @override
  String get lobbyDevicesUnreadable =>
      'Je apparaten konden niet worden gelezen';

  @override
  String get callEncryptedTooltip => 'Deze oproep is end-to-end versleuteld';

  @override
  String get callRecordingTooltip => 'Deze oproep wordt opgenomen';

  @override
  String get callScreenSharingTooltip => 'Iemand deelt zijn scherm';

  @override
  String callDurationSpoken(String duration) {
    return 'Gespreksduur $duration';
  }

  @override
  String callDurationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uur',
      one: '1 uur',
    );
    return '$_temp0';
  }

  @override
  String callDurationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '1 minuut',
    );
    return '$_temp0';
  }

  @override
  String callDurationSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconden',
      one: '1 seconde',
    );
    return '$_temp0';
  }

  @override
  String get ringingIncomingCall => 'Inkomende oproep';

  @override
  String get ringingCalling => 'Bellen…';

  @override
  String get ringingAccept => 'Opnemen';

  @override
  String get ringingDecline => 'Weigeren';

  @override
  String get ringingNobody => 'Geen deelnemers';

  @override
  String ringingTwoCallers(String first, String second) {
    return '$first en $second';
  }

  @override
  String ringingManyCallers(String first, String second, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anderen',
      one: '1 ander',
    );
    return '$first, $second en $_temp0';
  }

  @override
  String get settingsDeviceTab => 'Apparaat';

  @override
  String get deviceSettingsSelectCamera => 'Camera kiezen';

  @override
  String get deviceSettingsSelectMicrophone => 'Microfoon kiezen';

  @override
  String get deviceSettingsSelectSpeaker => 'Luidspreker kiezen';

  @override
  String get deviceSettingsNoiseCancellation => 'Ruisonderdrukking';

  @override
  String get deviceSettingsNoiseCancellationDescription =>
      'Filtert achtergrondgeluid uit je microfoon.';

  @override
  String get deviceSettingsIncomingVideoQuality =>
      'Kwaliteit van inkomende video';

  @override
  String get deviceSettingsIncomingVideoQualityHelper =>
      'De kwaliteit van inkomende video hangt af van verschillende factoren, waaronder de kwaliteit van de bronvideo en de netwerkomstandigheden.';

  @override
  String get incomingVideoQualityAuto => 'Automatisch';

  @override
  String get incomingVideoQuality2160p => '4K 2160p';

  @override
  String get incomingVideoQuality1080p => 'Full HD 1080p';

  @override
  String get incomingVideoQuality720p => 'HD 720p';

  @override
  String get incomingVideoQuality480p => 'SD 480p';

  @override
  String get incomingVideoQuality144p => 'Databesparing 144p';

  @override
  String get incomingVideoQualityOff => 'Video uitschakelen';

  @override
  String get settingsEffectsTab => 'Effecten';

  @override
  String get effectsSettingsFilters => 'Effecten';

  @override
  String get effectsSettingsBackgrounds => 'Achtergronden';

  @override
  String get effectsSettingsNone => 'Geen effect';

  @override
  String get incomingVideoQualityShortOff => 'Uit';

  @override
  String get settingsCaptionsTab => 'Ondertiteling';

  @override
  String get captionsSettingsTurnOn => 'Ondertiteling aanzetten';

  @override
  String get captionsSettingsTurnOnDescription =>
      'Kies de taal die in de vergadering gesproken wordt. De ondertiteling wordt in deze taal getoond.';

  @override
  String get captionsSettingsLanguage => 'Taal';

  @override
  String get captionsSettingsLanguageDefault => 'Standaard';

  @override
  String get transcriptionLanguageAuto => 'Automatisch';

  @override
  String get transcriptionLanguageEn => 'Engels';

  @override
  String get transcriptionLanguageFr => 'Frans';

  @override
  String get transcriptionLanguageEs => 'Spaans';

  @override
  String get transcriptionLanguageDe => 'Duits';

  @override
  String get transcriptionLanguageIt => 'Italiaans';

  @override
  String get transcriptionLanguageNl => 'Nederlands';

  @override
  String get transcriptionLanguagePt => 'Portugees';

  @override
  String get transcriptionLanguagePl => 'Pools';

  @override
  String get transcriptionLanguageCa => 'Catalaans';

  @override
  String get transcriptionLanguageCs => 'Tsjechisch';

  @override
  String get transcriptionLanguageDa => 'Deens';

  @override
  String get transcriptionLanguageEl => 'Grieks';

  @override
  String get transcriptionLanguageFi => 'Fins';

  @override
  String get transcriptionLanguageId => 'Indonesisch';

  @override
  String get transcriptionLanguageJa => 'Japans';

  @override
  String get transcriptionLanguageRu => 'Russisch';

  @override
  String get transcriptionLanguageSv => 'Zweeds';

  @override
  String get transcriptionLanguageTa => 'Tamil';

  @override
  String get transcriptionLanguageTh => 'Thai';

  @override
  String get transcriptionLanguageTr => 'Turks';

  @override
  String get transcriptionLanguageHu => 'Hongaars';

  @override
  String get transcriptionLanguageRo => 'Roemeens';

  @override
  String get transcriptionLanguageZh => 'Chinees';

  @override
  String get transcriptionLanguageAr => 'Arabisch';

  @override
  String get transcriptionLanguageTl => 'Tagalog';

  @override
  String get transcriptionLanguageHe => 'Hebreeuws';

  @override
  String get transcriptionLanguageHi => 'Hindi';

  @override
  String get transcriptionLanguageHr => 'Kroatisch';

  @override
  String get transcriptionLanguageKo => 'Koreaans';

  @override
  String get transcriptionLanguageMs => 'Maleis';

  @override
  String get transcriptionLanguageNo => 'Noors';

  @override
  String get transcriptionLanguageUk => 'Oekraïens';

  @override
  String get transcriptionLanguageBg => 'Bulgaars';

  @override
  String get transcriptionLanguageEt => 'Estisch';

  @override
  String get transcriptionLanguageSl => 'Sloveens';

  @override
  String get transcriptionLanguageSk => 'Slowaaks';

  @override
  String get settingsRecordingsTab => 'Opnames';

  @override
  String get recordingsName => 'Naam';

  @override
  String get recordingsStartTime => 'Begintijd';

  @override
  String get recordingsEndTime => 'Eindtijd';

  @override
  String recordingsRecordingName(int number) {
    return 'Opname #$number';
  }

  @override
  String get recordingsDownload => 'Downloaden';

  @override
  String get recordingsEmptyTitle => 'Geen opnames beschikbaar';

  @override
  String get recordingsEmptyDescription =>
      'Opnames van dit gesprek verschijnen hier zodra ze klaar zijn.';

  @override
  String get recordingsErrorTitle => 'Opnames laden mislukt';

  @override
  String get recordingsErrorDescription =>
      'Controleer je verbinding en probeer het opnieuw.';

  @override
  String get recordingsRetry => 'Opnieuw proberen';
}
