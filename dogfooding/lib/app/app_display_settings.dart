import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

import '../core/repos/app_preferences.dart';

/// How the app is shown, as the user picks it in the settings window, kept in
/// [AppPreferences] so they survive a restart.
class AppDisplaySettings extends ChangeNotifier {
  AppDisplaySettings({required AppPreferences preferences})
    : _preferences = preferences,
      _locale = switch (preferences.languageCode) {
        // A language no longer offered falls back to the device's.
        final code?
            when StreamVideoFlutterLocalizations.supportedLocales.any(
              (it) => it.languageCode == code,
            ) =>
          Locale(code),
        _ => null,
      },
      _themeMode = preferences.themeMode;

  final AppPreferences _preferences;

  /// The language the app is shown in, or null to follow the device.
  Locale? get locale => _locale;
  Locale? _locale;

  Future<void> setLocale(Locale? locale) async {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
    final saved = await _preferences.setLanguageCode(locale?.languageCode);
    if (!saved) debugPrint('Could not save the language $locale');
  }

  /// Whether the app is light, dark or follows the device.
  ThemeMode get themeMode => _themeMode;
  ThemeMode _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (themeMode == _themeMode) return;
    _themeMode = themeMode;
    notifyListeners();
    await _preferences.setThemeMode(themeMode);
  }
}
