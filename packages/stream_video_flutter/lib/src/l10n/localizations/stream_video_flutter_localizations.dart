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
        context, StreamVideoFlutterLocalizations);
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
    Locale('nl')
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
}

class _StreamVideoFlutterLocalizationsDelegate
    extends LocalizationsDelegate<StreamVideoFlutterLocalizations> {
  const _StreamVideoFlutterLocalizationsDelegate();

  @override
  Future<StreamVideoFlutterLocalizations> load(Locale locale) {
    return SynchronousFuture<StreamVideoFlutterLocalizations>(
        lookupStreamVideoFlutterLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_StreamVideoFlutterLocalizationsDelegate old) => false;
}

StreamVideoFlutterLocalizations lookupStreamVideoFlutterLocalizations(
    Locale locale) {
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
      'that was used.');
}
