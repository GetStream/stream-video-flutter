import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_accent_color.dart';
import '../model/environment.dart';
import '../model/user_credentials.dart';

class AppPreferences {
  const AppPreferences({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _kUserCredentialsPref = 'user_credentials';
  static const String _kApiKeyPref = 'api_key';
  static const String _kEnvironemntPref = 'environment';
  static const String _kLanguageCodePref = 'language_code';
  static const String _kThemeModePref = 'theme_mode';
  static const String _kAccentColorPref = 'accent_color';

  UserCredentials? get userCredentials {
    final jsonString = _prefs.getString(_kUserCredentialsPref);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, Object?>;
    return UserCredentials.fromJson(json);
  }

  String? get apiKey => _prefs.getString(_kApiKeyPref);
  Environment get environment => Environment.fromSubdomain(
    _prefs.getString(_kEnvironemntPref) ?? Environment.pronto.name,
  );

  /// The language the app is shown in, or null to follow the device.
  String? get languageCode => _prefs.getString(_kLanguageCodePref);

  Future<bool> setLanguageCode(String? languageCode) {
    if (languageCode == null) return _prefs.remove(_kLanguageCodePref);
    return _prefs.setString(_kLanguageCodePref, languageCode);
  }

  /// Whether the app is light, dark or follows the device.
  ThemeMode get themeMode => ThemeMode.values.firstWhere(
    (mode) => mode.name == _prefs.getString(_kThemeModePref),
    orElse: () => ThemeMode.system,
  );

  Future<bool> setThemeMode(ThemeMode themeMode) {
    return _prefs.setString(_kThemeModePref, themeMode.name);
  }

  /// The palette the app takes its brand color from.
  AppAccentColor get accentColor => AppAccentColor.values.firstWhere(
    (color) => color.name == _prefs.getString(_kAccentColorPref),
    orElse: () => AppAccentColor.blue,
  );

  Future<bool> setAccentColor(AppAccentColor accentColor) {
    if (accentColor == AppAccentColor.blue) {
      return _prefs.remove(_kAccentColorPref);
    }
    return _prefs.setString(_kAccentColorPref, accentColor.name);
  }

  Future<bool> setUserCredentials(UserCredentials? credentials) {
    final jsonString = jsonEncode(credentials?.toJson());
    return _prefs.setString(_kUserCredentialsPref, jsonString);
  }

  Future<bool> setApiKey(String apiKey) {
    return _prefs.setString(_kApiKeyPref, apiKey);
  }

  Future<bool> setEnvironment(Environment environment) {
    return _prefs.setString(_kEnvironemntPref, environment.name);
  }

  Future<bool> clearUserCredentials() async {
    return await _prefs.remove(_kUserCredentialsPref) &&
        await _prefs.remove(_kApiKeyPref);
  }
}
