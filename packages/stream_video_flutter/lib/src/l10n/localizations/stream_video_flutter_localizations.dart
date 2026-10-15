import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'stream_video_flutter_localizations_en.dart';
import 'stream_video_flutter_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of StreamVideoFlutterLocalizations
/// returned by `StreamVideoFlutterLocalizations.of(context)`.
///
/// Applications need to include `StreamVideoFlutterLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localizations/stream_video_flutter_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: StreamVideoFlutterLocalizations.localizationsDelegates,
///   supportedLocales: StreamVideoFlutterLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the StreamVideoFlutterLocalizations.supportedLocales
/// property.
abstract class StreamVideoFlutterLocalizations {
  StreamVideoFlutterLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static StreamVideoFlutterLocalizations? of(BuildContext context) {
    return Localizations.of<StreamVideoFlutterLocalizations>(
      context,
      StreamVideoFlutterLocalizations,
    );
  }

  static const LocalizationsDelegate<StreamVideoFlutterLocalizations> delegate =
      _StreamVideoFlutterLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// Title for dialog to choose for a window or screen to share
  ///
  /// In en, this message translates to:
  /// **'Choose what to share'**
  String get desktopScreenShareChooseDialogTitle;

  /// Share action to start sharing
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get desktopScreenShareChooseDialogShare;

  /// Cancel action to go back without sharing
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get desktopScreenShareChooseDialogCancel;

  /// Tab to select a screen to share
  ///
  /// In en, this message translates to:
  /// **'Entire Screen'**
  String get desktopScreenShareEntireScreen;

  /// Tab to select a single window to share
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get desktopScreenShareWindow;

  /// Tooltip of the action that re-reads the screens and windows on offer
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get desktopScreenShareRefresh;

  /// Shown in place of the grid when the platform offers no screen or window of the selected type
  ///
  /// In en, this message translates to:
  /// **'Nothing to share here.'**
  String get desktopScreenShareNoSources;

  /// Shown in place of the grid when the sources could not be read
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read the screens and windows to share.'**
  String get desktopScreenShareLoadFailed;

  /// Action that reads the screens and windows again after a failure
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get desktopScreenShareRetry;

  /// Title of the sheet that picks how participants are laid out
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get layoutMenuTitle;

  /// Tooltip of the call control that picks a participant layout
  ///
  /// In en, this message translates to:
  /// **'Change layout'**
  String get layoutSelectTooltip;

  /// The participant layout that follows the call instead of being fixed
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get layoutDefault;

  /// The participant layout giving everybody an equal tile
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get layoutGrid;

  /// The participant layout with the speaker above the other participants
  ///
  /// In en, this message translates to:
  /// **'Speaker (Top)'**
  String get layoutSpeakerTop;

  /// The participant layout with the speaker below the other participants
  ///
  /// In en, this message translates to:
  /// **'Speaker (Bottom)'**
  String get layoutSpeakerBottom;

  /// The participant layout with the speaker left of the other participants
  ///
  /// In en, this message translates to:
  /// **'Speaker (Left)'**
  String get layoutSpeakerLeft;

  /// The participant layout with the speaker right of the other participants
  ///
  /// In en, this message translates to:
  /// **'Speaker (Right)'**
  String get layoutSpeakerRight;

  /// The participant layout showing only the speaker and the local participant
  ///
  /// In en, this message translates to:
  /// **'Speaker 1:1'**
  String get layoutSpeakerOneToOne;

  /// Tooltip of the button that moves a participant layout back — the bar towards its first tile, the grid to the page before
  ///
  /// In en, this message translates to:
  /// **'Previous participants'**
  String get participantsPrevious;

  /// Tooltip of the button that moves a participant layout on — the bar towards its last tile, the grid to the page after
  ///
  /// In en, this message translates to:
  /// **'Next participants'**
  String get participantsNext;

  /// Label for livestream backstage when live stream will soon start
  ///
  /// In en, this message translates to:
  /// **'Livestream will start soon'**
  String get livestreamBackstageStartingSoon;

  /// Label for livestream backstage when live stream counter is shown
  ///
  /// In en, this message translates to:
  /// **'Livestream will start in:'**
  String get livestreamBackstageStartingIn;

  /// Label for livestream backstage showing participants count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{No participants have} one{One participant has} other{{count} participants have}} joined early'**
  String livestreamBackstageParticipants(num count);

  /// Label shown when the livestream has already ended.
  ///
  /// In en, this message translates to:
  /// **'The livestream has ended.'**
  String get livestreamEndedStatus;

  /// Label shown when the livestream has already ended listing the recordings.
  ///
  /// In en, this message translates to:
  /// **'Watch the recordings:'**
  String get livestreamEndedWatchRecordings;

  /// Label shown when the host of the livestream is not available.
  ///
  /// In en, this message translates to:
  /// **'The host\'s video is not available.'**
  String get livestreamHostNotAvailable;

  /// The badge text shown when the call mode is backstage
  ///
  /// In en, this message translates to:
  /// **'Backstage'**
  String get livestreamBackstage;

  /// The badge text shown when the call mode is live
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get livestreamLive;

  /// Heading of the microphone group in the lobby's device menu
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get lobbyMicrophoneSection;

  /// Heading of the speaker group in the lobby's device menu
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get lobbySpeakerSection;

  /// Heading of the camera group in the lobby's device menu
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get lobbyCameraSection;

  /// The device option that leaves the choice to the platform, and the placeholder on a device field while it is the one in effect
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultDevice;

  /// Tooltip of the lobby control that picks a microphone and speaker
  ///
  /// In en, this message translates to:
  /// **'Select audio devices'**
  String get lobbySelectAudioDevices;

  /// Tooltip of the lobby control that picks a camera
  ///
  /// In en, this message translates to:
  /// **'Select video device'**
  String get lobbySelectVideoDevice;

  /// Tooltip of the lobby's microphone toggle
  ///
  /// In en, this message translates to:
  /// **'Toggle microphone'**
  String get lobbyToggleMicrophone;

  /// Tooltip of the lobby's camera toggle
  ///
  /// In en, this message translates to:
  /// **'Toggle camera'**
  String get lobbyToggleCamera;

  /// Heading of the lobby screen
  ///
  /// In en, this message translates to:
  /// **'Before joining'**
  String get lobbyTitle;

  /// Label of the button that joins the call from the lobby
  ///
  /// In en, this message translates to:
  /// **'Join call'**
  String get lobbyJoinCall;

  /// Tooltip and sheet title of the lobby's participants control
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get lobbyParticipants;

  /// Tooltip on the lobby's audio picker while the microphone has never been opened
  ///
  /// In en, this message translates to:
  /// **'Turn the microphone on to choose a device'**
  String get lobbyMicrophoneNotOpened;

  /// Tooltip on the lobby's camera picker while the camera has never been opened
  ///
  /// In en, this message translates to:
  /// **'Turn the camera on to choose a device'**
  String get lobbyCameraNotOpened;

  /// Tooltip on the lobby's audio picker when the platform reports no microphone
  ///
  /// In en, this message translates to:
  /// **'No microphone found'**
  String get lobbyNoMicrophoneFound;

  /// Tooltip on the lobby's camera picker when the platform reports no camera
  ///
  /// In en, this message translates to:
  /// **'No camera found'**
  String get lobbyNoCameraFound;

  /// Tooltip on the lobby's audio picker when microphone permission was refused
  ///
  /// In en, this message translates to:
  /// **'Microphone access was refused — allow it in your system settings'**
  String get lobbyMicrophonePermissionDenied;

  /// Tooltip on the lobby's camera picker when camera permission was refused
  ///
  /// In en, this message translates to:
  /// **'Camera access was refused — allow it in your system settings'**
  String get lobbyCameraPermissionDenied;

  /// Tooltip on the lobby's audio picker when another application holds the microphone
  ///
  /// In en, this message translates to:
  /// **'Another app is using the microphone'**
  String get lobbyMicrophoneBusy;

  /// Tooltip on the lobby's camera picker when another application holds the camera
  ///
  /// In en, this message translates to:
  /// **'Another app is using the camera'**
  String get lobbyCameraBusy;

  /// Tooltip on a lobby device picker when the platform could not be asked for its devices
  ///
  /// In en, this message translates to:
  /// **'Your devices could not be read'**
  String get lobbyDevicesUnreadable;

  /// Tooltip on the encryption indicator in the call duration badge
  ///
  /// In en, this message translates to:
  /// **'This call is end-to-end encrypted'**
  String get callEncryptedTooltip;

  /// Tooltip on the recording indicator in the call duration badge
  ///
  /// In en, this message translates to:
  /// **'This call is being recorded'**
  String get callRecordingTooltip;

  /// Tooltip on the screen share indicator in the call duration badge
  ///
  /// In en, this message translates to:
  /// **'Someone is sharing their screen'**
  String get callScreenSharingTooltip;

  /// Accessible label for the call duration badge, read in place of the digits
  ///
  /// In en, this message translates to:
  /// **'Call duration {duration}'**
  String callDurationSpoken(String duration);

  /// Hours part of the spoken call duration
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 hour} other{{count} hours}}'**
  String callDurationHours(int count);

  /// Minutes part of the spoken call duration
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 minute} other{{count} minutes}}'**
  String callDurationMinutes(int count);

  /// Seconds part of the spoken call duration
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 second} other{{count} seconds}}'**
  String callDurationSeconds(int count);

  /// Status line on the incoming ringing screen, under the caller's name
  ///
  /// In en, this message translates to:
  /// **'Incoming call'**
  String get ringingIncomingCall;

  /// Status line on the outgoing ringing screen, while the other side is being rung
  ///
  /// In en, this message translates to:
  /// **'Calling…'**
  String get ringingCalling;

  /// Label under the button that answers an incoming call
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get ringingAccept;

  /// Label under the button that rejects an incoming call
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get ringingDecline;

  /// Shown in place of a name on a ringing screen when the call has no members yet
  ///
  /// In en, this message translates to:
  /// **'No participants'**
  String get ringingNobody;

  /// The name line on a ringing screen with exactly two members
  ///
  /// In en, this message translates to:
  /// **'{first} and {second}'**
  String ringingTwoCallers(String first, String second);

  /// The name line on a ringing screen with three or more members: two names and a count of the rest
  ///
  /// In en, this message translates to:
  /// **'{first}, {second}, and {count, plural, =1{1 other} other{{count} others}}'**
  String ringingManyCallers(String first, String second, int count);

  /// Banner shown while a call joins for the first time
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get callConnectionConnecting;

  /// Banner shown while a call gets its connection back
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get callConnectionReconnecting;

  /// Banner shown while a call gets its connection back, from its second attempt on
  ///
  /// In en, this message translates to:
  /// **'Reconnecting… (attempt {attempt})'**
  String callConnectionReconnectingAttempt(int attempt);

  /// Banner shown while a reconnecting call joins again
  ///
  /// In en, this message translates to:
  /// **'Joining…'**
  String get callConnectionJoining;

  /// Banner shown while a reconnecting call joins again, from its second attempt on
  ///
  /// In en, this message translates to:
  /// **'Joining… (attempt {attempt})'**
  String callConnectionJoiningAttempt(int attempt);

  /// Banner shown while a reconnecting call waits for the network to come back
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Waiting for the network…'**
  String get callConnectionOffline;

  /// Banner shown while a call moves to another server
  ///
  /// In en, this message translates to:
  /// **'Moving to another server…'**
  String get callConnectionMigrating;

  /// Banner shown when a call gave up reconnecting, until it has left
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reconnect to the call'**
  String get callConnectionReconnectFailed;

  /// The label of the device settings tab in the settings window
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get settingsDeviceTab;

  /// Heading of the camera picker in the device settings
  ///
  /// In en, this message translates to:
  /// **'Select Camera'**
  String get deviceSettingsSelectCamera;

  /// Heading of the microphone picker in the device settings
  ///
  /// In en, this message translates to:
  /// **'Select Microphone'**
  String get deviceSettingsSelectMicrophone;

  /// Heading of the speaker picker in the device settings
  ///
  /// In en, this message translates to:
  /// **'Select Speaker'**
  String get deviceSettingsSelectSpeaker;

  /// Title of the noise cancellation switch in the device settings
  ///
  /// In en, this message translates to:
  /// **'Noise Cancellation'**
  String get deviceSettingsNoiseCancellation;

  /// Explains the noise cancellation switch in the device settings
  ///
  /// In en, this message translates to:
  /// **'Filters out background noise from your microphone.'**
  String get deviceSettingsNoiseCancellationDescription;

  /// Heading of the incoming video quality picker in the device settings
  ///
  /// In en, this message translates to:
  /// **'Incoming Video Quality'**
  String get deviceSettingsIncomingVideoQuality;

  /// Helper text under the incoming video quality picker
  ///
  /// In en, this message translates to:
  /// **'The quality of incoming video is influenced by various factors, including the source video\'s quality and the network conditions.'**
  String get deviceSettingsIncomingVideoQualityHelper;

  /// Incoming video quality choice that leaves the resolution to the SDK
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get incomingVideoQualityAuto;

  /// Incoming video quality choice
  ///
  /// In en, this message translates to:
  /// **'4K 2160p'**
  String get incomingVideoQuality2160p;

  /// Incoming video quality choice
  ///
  /// In en, this message translates to:
  /// **'Full HD 1080p'**
  String get incomingVideoQuality1080p;

  /// Incoming video quality choice
  ///
  /// In en, this message translates to:
  /// **'HD 720p'**
  String get incomingVideoQuality720p;

  /// Incoming video quality choice
  ///
  /// In en, this message translates to:
  /// **'SD 480p'**
  String get incomingVideoQuality480p;

  /// Incoming video quality choice
  ///
  /// In en, this message translates to:
  /// **'Data saver 144p'**
  String get incomingVideoQuality144p;

  /// Incoming video quality choice that turns other participants' video off
  ///
  /// In en, this message translates to:
  /// **'Disable video'**
  String get incomingVideoQualityOff;

  /// The label of the video effects tab in the settings window
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get settingsEffectsTab;

  /// Heading of the row of video effects, such as blurs, in the effects settings
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get effectsSettingsFilters;

  /// Heading of the grid of background images in the effects settings
  ///
  /// In en, this message translates to:
  /// **'Backgrounds'**
  String get effectsSettingsBackgrounds;

  /// Tooltip of the button that turns video effects off
  ///
  /// In en, this message translates to:
  /// **'No effect'**
  String get effectsSettingsNone;

  /// Shown on the incoming video quality button while other participants' video is turned off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get incomingVideoQualityShortOff;

  /// The label of the captions tab in the settings window
  ///
  /// In en, this message translates to:
  /// **'Captions'**
  String get settingsCaptionsTab;

  /// Title of the switch that turns closed captions on and off
  ///
  /// In en, this message translates to:
  /// **'Turn On Captions'**
  String get captionsSettingsTurnOn;

  /// Explains the closed captions switch
  ///
  /// In en, this message translates to:
  /// **'Select the language people will use in the meeting. Captions will be displayed in this language.'**
  String get captionsSettingsTurnOnDescription;

  /// Heading of the picker for the language spoken in the call
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get captionsSettingsLanguage;

  /// The captions language of a call that never set one, which the backend picks
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get captionsSettingsLanguageDefault;

  /// The spoken language choice that lets the transcriber detect the language
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get transcriptionLanguageAuto;

  /// The name of a language the call can be transcribed in (en)
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get transcriptionLanguageEn;

  /// The name of a language the call can be transcribed in (fr)
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get transcriptionLanguageFr;

  /// The name of a language the call can be transcribed in (es)
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get transcriptionLanguageEs;

  /// The name of a language the call can be transcribed in (de)
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get transcriptionLanguageDe;

  /// The name of a language the call can be transcribed in (it)
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get transcriptionLanguageIt;

  /// The name of a language the call can be transcribed in (nl)
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get transcriptionLanguageNl;

  /// The name of a language the call can be transcribed in (pt)
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get transcriptionLanguagePt;

  /// The name of a language the call can be transcribed in (pl)
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get transcriptionLanguagePl;

  /// The name of a language the call can be transcribed in (ca)
  ///
  /// In en, this message translates to:
  /// **'Catalan'**
  String get transcriptionLanguageCa;

  /// The name of a language the call can be transcribed in (cs)
  ///
  /// In en, this message translates to:
  /// **'Czech'**
  String get transcriptionLanguageCs;

  /// The name of a language the call can be transcribed in (da)
  ///
  /// In en, this message translates to:
  /// **'Danish'**
  String get transcriptionLanguageDa;

  /// The name of a language the call can be transcribed in (el)
  ///
  /// In en, this message translates to:
  /// **'Greek'**
  String get transcriptionLanguageEl;

  /// The name of a language the call can be transcribed in (fi)
  ///
  /// In en, this message translates to:
  /// **'Finnish'**
  String get transcriptionLanguageFi;

  /// The name of a language the call can be transcribed in (id)
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get transcriptionLanguageId;

  /// The name of a language the call can be transcribed in (ja)
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get transcriptionLanguageJa;

  /// The name of a language the call can be transcribed in (ru)
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get transcriptionLanguageRu;

  /// The name of a language the call can be transcribed in (sv)
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get transcriptionLanguageSv;

  /// The name of a language the call can be transcribed in (ta)
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get transcriptionLanguageTa;

  /// The name of a language the call can be transcribed in (th)
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get transcriptionLanguageTh;

  /// The name of a language the call can be transcribed in (tr)
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get transcriptionLanguageTr;

  /// The name of a language the call can be transcribed in (hu)
  ///
  /// In en, this message translates to:
  /// **'Hungarian'**
  String get transcriptionLanguageHu;

  /// The name of a language the call can be transcribed in (ro)
  ///
  /// In en, this message translates to:
  /// **'Romanian'**
  String get transcriptionLanguageRo;

  /// The name of a language the call can be transcribed in (zh)
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get transcriptionLanguageZh;

  /// The name of a language the call can be transcribed in (ar)
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get transcriptionLanguageAr;

  /// The name of a language the call can be transcribed in (tl)
  ///
  /// In en, this message translates to:
  /// **'Tagalog'**
  String get transcriptionLanguageTl;

  /// The name of a language the call can be transcribed in (he)
  ///
  /// In en, this message translates to:
  /// **'Hebrew'**
  String get transcriptionLanguageHe;

  /// The name of a language the call can be transcribed in (hi)
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get transcriptionLanguageHi;

  /// The name of a language the call can be transcribed in (hr)
  ///
  /// In en, this message translates to:
  /// **'Croatian'**
  String get transcriptionLanguageHr;

  /// The name of a language the call can be transcribed in (ko)
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get transcriptionLanguageKo;

  /// The name of a language the call can be transcribed in (ms)
  ///
  /// In en, this message translates to:
  /// **'Malay'**
  String get transcriptionLanguageMs;

  /// The name of a language the call can be transcribed in (no)
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get transcriptionLanguageNo;

  /// The name of a language the call can be transcribed in (uk)
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get transcriptionLanguageUk;

  /// The name of a language the call can be transcribed in (bg)
  ///
  /// In en, this message translates to:
  /// **'Bulgarian'**
  String get transcriptionLanguageBg;

  /// The name of a language the call can be transcribed in (et)
  ///
  /// In en, this message translates to:
  /// **'Estonian'**
  String get transcriptionLanguageEt;

  /// The name of a language the call can be transcribed in (sl)
  ///
  /// In en, this message translates to:
  /// **'Slovenian'**
  String get transcriptionLanguageSl;

  /// The name of a language the call can be transcribed in (sk)
  ///
  /// In en, this message translates to:
  /// **'Slovak'**
  String get transcriptionLanguageSk;
}

class _StreamVideoFlutterLocalizationsDelegate
    extends LocalizationsDelegate<StreamVideoFlutterLocalizations> {
  const _StreamVideoFlutterLocalizationsDelegate();

  @override
  Future<StreamVideoFlutterLocalizations> load(Locale locale) {
    return SynchronousFuture<StreamVideoFlutterLocalizations>(
      lookupStreamVideoFlutterLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_StreamVideoFlutterLocalizationsDelegate old) => false;
}

StreamVideoFlutterLocalizations lookupStreamVideoFlutterLocalizations(
  Locale locale,
) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return StreamVideoFlutterLocalizationsEn();
    case 'nl':
      return StreamVideoFlutterLocalizationsNl();
  }

  throw FlutterError(
    'StreamVideoFlutterLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
