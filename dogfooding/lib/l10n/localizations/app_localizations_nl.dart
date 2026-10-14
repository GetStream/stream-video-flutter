// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get settingsSystem => 'Systeem';

  @override
  String get languageTab => 'Taal';

  @override
  String get languageTitle => 'Taal wijzigen';

  @override
  String get languageDescription => 'Kies de taal van deze demo.';

  @override
  String get themeTab => 'Thema';

  @override
  String get themeTitle => 'Weergave';

  @override
  String get themeDescription => 'Kies hoe de app eruitziet.';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';
}
