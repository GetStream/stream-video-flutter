// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'stream_video_flutter_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StreamVideoFlutterLocalizationsEn
    extends StreamVideoFlutterLocalizations {
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
  String get desktopScreenShareRefresh => 'Refresh';

  @override
  String get desktopScreenShareNoSources => 'Nothing to share here.';

  @override
  String get desktopScreenShareLoadFailed =>
      'Couldn\'t read the screens and windows to share.';

  @override
  String get desktopScreenShareRetry => 'Try again';

  @override
  String get layoutMenuTitle => 'Layout';

  @override
  String get layoutSelectTooltip => 'Change layout';

  @override
  String get layoutDefault => 'Default';

  @override
  String get layoutGrid => 'Grid';

  @override
  String get layoutSpeakerTop => 'Speaker (Top)';

  @override
  String get layoutSpeakerBottom => 'Speaker (Bottom)';

  @override
  String get layoutSpeakerLeft => 'Speaker (Left)';

  @override
  String get layoutSpeakerRight => 'Speaker (Right)';

  @override
  String get layoutSpeakerOneToOne => 'Speaker 1:1';

  @override
  String get participantsPrevious => 'Previous participants';

  @override
  String get participantsNext => 'Next participants';

  @override
  String get livestreamBackstageStartingSoon => 'Livestream will start soon';

  @override
  String get livestreamBackstageStartingIn => 'Livestream will start in:';

  @override
  String livestreamBackstageParticipants(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants have',
      one: 'One participant has',
      zero: 'No participants have',
    );
    return '$_temp0 joined early';
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

  @override
  String get lobbyMicrophoneSection => 'Microphone';

  @override
  String get lobbySpeakerSection => 'Speaker';

  @override
  String get lobbyCameraSection => 'Camera';

  @override
  String get defaultDevice => 'Default';

  @override
  String get lobbySelectAudioDevices => 'Select audio devices';

  @override
  String get lobbySelectVideoDevice => 'Select video device';

  @override
  String get lobbyToggleMicrophone => 'Toggle microphone';

  @override
  String get lobbyToggleCamera => 'Toggle camera';

  @override
  String get lobbyTitle => 'Before joining';

  @override
  String get lobbyJoinCall => 'Join call';

  @override
  String get lobbyParticipants => 'Participants';

  @override
  String get lobbyMicrophoneNotOpened =>
      'Turn the microphone on to choose a device';

  @override
  String get lobbyCameraNotOpened => 'Turn the camera on to choose a device';

  @override
  String get lobbyNoMicrophoneFound => 'No microphone found';

  @override
  String get lobbyNoCameraFound => 'No camera found';

  @override
  String get lobbyMicrophonePermissionDenied =>
      'Microphone access was refused — allow it in your system settings';

  @override
  String get lobbyCameraPermissionDenied =>
      'Camera access was refused — allow it in your system settings';

  @override
  String get lobbyMicrophoneBusy => 'Another app is using the microphone';

  @override
  String get lobbyCameraBusy => 'Another app is using the camera';

  @override
  String get lobbyDevicesUnreadable => 'Your devices could not be read';

  @override
  String get callEncryptedTooltip => 'This call is end-to-end encrypted';

  @override
  String get callRecordingTooltip => 'This call is being recorded';

  @override
  String get callScreenSharingTooltip => 'Someone is sharing their screen';

  @override
  String callDurationSpoken(String duration) {
    return 'Call duration $duration';
  }

  @override
  String callDurationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String callDurationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String callDurationSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds',
      one: '1 second',
    );
    return '$_temp0';
  }

  @override
  String get ringingIncomingCall => 'Incoming call';

  @override
  String get ringingCalling => 'Calling…';

  @override
  String get ringingAccept => 'Accept';

  @override
  String get ringingDecline => 'Decline';

  @override
  String get ringingNobody => 'No participants';

  @override
  String ringingTwoCallers(String first, String second) {
    return '$first and $second';
  }

  @override
  String ringingManyCallers(String first, String second, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count others',
      one: '1 other',
    );
    return '$first, $second, and $_temp0';
  }

  @override
  String get settingsDeviceTab => 'Device';

  @override
  String get deviceSettingsSelectCamera => 'Select Camera';

  @override
  String get deviceSettingsSelectMicrophone => 'Select Microphone';

  @override
  String get deviceSettingsSelectSpeaker => 'Select Speaker';

  @override
  String get deviceSettingsNoiseCancellation => 'Noise Cancellation';

  @override
  String get deviceSettingsNoiseCancellationDescription =>
      'Filters out background noise from your microphone.';

  @override
  String get deviceSettingsIncomingVideoQuality => 'Incoming Video Quality';

  @override
  String get deviceSettingsIncomingVideoQualityHelper =>
      'The quality of incoming video is influenced by various factors, including the source video\'s quality and the network conditions.';

  @override
  String get incomingVideoQualityAuto => 'Auto';

  @override
  String get incomingVideoQuality2160p => '4K 2160p';

  @override
  String get incomingVideoQuality1080p => 'Full HD 1080p';

  @override
  String get incomingVideoQuality720p => 'HD 720p';

  @override
  String get incomingVideoQuality480p => 'SD 480p';

  @override
  String get incomingVideoQuality144p => 'Data saver 144p';

  @override
  String get incomingVideoQualityOff => 'Disable video';

  @override
  String get settingsEffectsTab => 'Effects';

  @override
  String get effectsSettingsFilters => 'Effects';

  @override
  String get effectsSettingsBackgrounds => 'Backgrounds';

  @override
  String get effectsSettingsNone => 'No effect';

  @override
  String get incomingVideoQualityShortOff => 'Off';

  @override
  String get settingsCaptionsTab => 'Captions';

  @override
  String get captionsSettingsTurnOn => 'Turn On Captions';

  @override
  String get captionsSettingsTurnOnDescription =>
      'Select the language people will use in the meeting. Captions will be displayed in this language.';

  @override
  String get captionsSettingsLanguage => 'Language';

  @override
  String get transcriptionLanguageAuto => 'Automatic';

  @override
  String get transcriptionLanguageEn => 'English';

  @override
  String get transcriptionLanguageFr => 'French';

  @override
  String get transcriptionLanguageEs => 'Spanish';

  @override
  String get transcriptionLanguageDe => 'German';

  @override
  String get transcriptionLanguageIt => 'Italian';

  @override
  String get transcriptionLanguageNl => 'Dutch';

  @override
  String get transcriptionLanguagePt => 'Portuguese';

  @override
  String get transcriptionLanguagePl => 'Polish';

  @override
  String get transcriptionLanguageCa => 'Catalan';

  @override
  String get transcriptionLanguageCs => 'Czech';

  @override
  String get transcriptionLanguageDa => 'Danish';

  @override
  String get transcriptionLanguageEl => 'Greek';

  @override
  String get transcriptionLanguageFi => 'Finnish';

  @override
  String get transcriptionLanguageId => 'Indonesian';

  @override
  String get transcriptionLanguageJa => 'Japanese';

  @override
  String get transcriptionLanguageRu => 'Russian';

  @override
  String get transcriptionLanguageSv => 'Swedish';

  @override
  String get transcriptionLanguageTa => 'Tamil';

  @override
  String get transcriptionLanguageTh => 'Thai';

  @override
  String get transcriptionLanguageTr => 'Turkish';

  @override
  String get transcriptionLanguageHu => 'Hungarian';

  @override
  String get transcriptionLanguageRo => 'Romanian';

  @override
  String get transcriptionLanguageZh => 'Chinese';

  @override
  String get transcriptionLanguageAr => 'Arabic';

  @override
  String get transcriptionLanguageTl => 'Tagalog';

  @override
  String get transcriptionLanguageHe => 'Hebrew';

  @override
  String get transcriptionLanguageHi => 'Hindi';

  @override
  String get transcriptionLanguageHr => 'Croatian';

  @override
  String get transcriptionLanguageKo => 'Korean';

  @override
  String get transcriptionLanguageMs => 'Malay';

  @override
  String get transcriptionLanguageNo => 'Norwegian';

  @override
  String get transcriptionLanguageUk => 'Ukrainian';

  @override
  String get transcriptionLanguageBg => 'Bulgarian';

  @override
  String get transcriptionLanguageEt => 'Estonian';

  @override
  String get transcriptionLanguageSl => 'Slovenian';

  @override
  String get transcriptionLanguageSk => 'Slovak';
}
