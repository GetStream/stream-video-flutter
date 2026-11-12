import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_accent_color.dart';
import '../../app/app_design.dart';
import '../model/environment.dart';
import '../model/user_credentials.dart';

class AppPreferences {
  AppPreferences({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  Environment? _pinnedEnvironment;

  /// On web, every origin path shares one browser storage (`/video`,
  /// `/video/beta`, `/chat`), so the keys carry a `video_` prefix.
  static String _key(String name) => kIsWeb ? 'video_$name' : name;

  /// The login belongs to an environment, so on web it is stored per
  /// environment (`video_pronto_api_key`) and the prod and beta builds, which
  /// use different environments, never read each other's.
  String _authKey(String name) =>
      kIsWeb ? 'video_${environment.name}_$name' : name;

  UserCredentials? get userCredentials {
    final jsonString = _prefs.getString(_authKey('user_credentials'));
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, Object?>;
    return UserCredentials.fromJson(json);
  }

  String? get apiKey => _prefs.getString(_authKey('api_key'));
  Environment get environment =>
      _pinnedEnvironment ??
      Environment.fromSubdomain(
        _prefs.getString(_key('environment')) ?? Environment.pronto.name,
      );

  /// Uses [environment] for this session without storing it, and ignores
  /// [setEnvironment] from here on.
  ///
  /// The prod and beta web builds share browser storage, so prod must not
  /// leave its environment behind for beta to read.
  // ignore: use_setters_to_change_properties
  void pinEnvironment(Environment environment) {
    _pinnedEnvironment = environment;
  }

  /// The language the app is shown in, or null to follow the device.
  String? get languageCode => _prefs.getString(_key('language_code'));

  Future<bool> setLanguageCode(String? languageCode) {
    if (languageCode == null) return _prefs.remove(_key('language_code'));
    return _prefs.setString(_key('language_code'), languageCode);
  }

  /// Whether the app is light, dark or follows the device.
  ThemeMode get themeMode => ThemeMode.values.firstWhere(
    (mode) => mode.name == _prefs.getString(_key('theme_mode')),
    orElse: () => ThemeMode.system,
  );

  Future<bool> setThemeMode(ThemeMode themeMode) {
    return _prefs.setString(_key('theme_mode'), themeMode.name);
  }

  /// The palette the app takes its brand color from.
  AppAccentColor get accentColor => AppAccentColor.values.firstWhere(
    (color) => color.name == _prefs.getString(_key('accent_color')),
    orElse: () => AppAccentColor.designDefault,
  );

  Future<bool> setAccentColor(AppAccentColor accentColor) {
    if (accentColor == AppAccentColor.designDefault) {
      return _prefs.remove(_key('accent_color'));
    }
    return _prefs.setString(_key('accent_color'), accentColor.name);
  }

  /// The design system the app's components are drawn with.
  AppDesign get design => AppDesign.values.firstWhere(
    (design) => design.name == _prefs.getString(_key('design')),
    orElse: () => AppDesign.stream,
  );

  Future<bool> setDesign(AppDesign design) {
    if (design == AppDesign.stream) return _prefs.remove(_key('design'));
    return _prefs.setString(_key('design'), design.name);
  }

  Future<bool> setUserCredentials(UserCredentials? credentials) {
    final jsonString = jsonEncode(credentials?.toJson());
    return _prefs.setString(_authKey('user_credentials'), jsonString);
  }

  Future<bool> setApiKey(String apiKey) {
    return _prefs.setString(_authKey('api_key'), apiKey);
  }

  Future<bool> setEnvironment(Environment environment) async {
    if (_pinnedEnvironment != null) return true;
    return _prefs.setString(_key('environment'), environment.name);
  }

  Future<bool> clearUserCredentials() async {
    return await _prefs.remove(_authKey('user_credentials')) &&
        await _prefs.remove(_authKey('api_key'));
  }
}
