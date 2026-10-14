import 'package:flutter/widgets.dart';

import '../core/repos/app_preferences.dart';

/// How the app is shown, as the user picks it in the settings window, kept in
/// [AppPreferences] so they survive a restart.
class AppDisplaySettings extends ChangeNotifier {
  AppDisplaySettings({required AppPreferences preferences})
    : _preferences = preferences,
      _locale = switch (preferences.languageCode) {
        final code? => Locale(code),
        null => null,
      };

  final AppPreferences _preferences;

  /// The language the app is shown in, or null to follow the device.
  Locale? get locale => _locale;
  Locale? _locale;

  Future<void> setLocale(Locale? locale) async {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
    await _preferences.setLanguageCode(locale?.languageCode);
  }
}
