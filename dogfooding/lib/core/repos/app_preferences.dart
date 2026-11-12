import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_accent_color.dart';
import '../../app/app_design.dart';
import '../../utils/consts.dart';
import '../model/environment.dart';
import '../model/user_credentials.dart';

class AppPreferences {
  AppPreferences({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  Environment? _pinnedEnvironment;

  static const String _kUserCredentialsPref = 'user_credentials';
  static const String _kApiKeyPref = 'api_key';
  static const String _kEnvironemntPref = 'environment';
  static const String _kLanguageCodePref = 'language_code';
  static const String _kThemeModePref = 'theme_mode';
  static const String _kAccentColorPref = 'accent_color';
  static const String _kDesignPref = 'design';

  /// On web, every path of the origin shares one browser storage (`/video`,
  /// `/video/beta`, `/chat`), so each build keeps its keys under its own
  /// prefix.
  static String get _webPrefix => kIsProd ? 'video' : 'video_beta';

  static String _key(String name) => kIsWeb ? '${_webPrefix}_$name' : name;

  /// The login belongs to an environment, so on web it is stored per
  /// environment too (`video_pronto_api_key`).
  String _authKey(String name) =>
      kIsWeb ? '${_webPrefix}_${environment.name}_$name' : name;

  UserCredentials? get userCredentials {
    final jsonString = _prefs.getString(_authKey(_kUserCredentialsPref));
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, Object?>;
    return UserCredentials.fromJson(json);
  }

  String? get apiKey => _prefs.getString(_authKey(_kApiKeyPref));
  Environment get environment =>
      _pinnedEnvironment ??
      Environment.fromSubdomain(
        _prefs.getString(_key(_kEnvironemntPref)) ?? Environment.pronto.name,
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
  String? get languageCode => _prefs.getString(_key(_kLanguageCodePref));

  Future<bool> setLanguageCode(String? languageCode) {
    if (languageCode == null) return _prefs.remove(_key(_kLanguageCodePref));
    return _prefs.setString(_key(_kLanguageCodePref), languageCode);
  }

  /// Whether the app is light, dark or follows the device.
  ThemeMode get themeMode => ThemeMode.values.firstWhere(
    (mode) => mode.name == _prefs.getString(_key(_kThemeModePref)),
    orElse: () => ThemeMode.system,
  );

  Future<bool> setThemeMode(ThemeMode themeMode) {
    return _prefs.setString(_key(_kThemeModePref), themeMode.name);
  }

  /// The palette the app takes its brand color from.
  AppAccentColor get accentColor => AppAccentColor.values.firstWhere(
    (color) => color.name == _prefs.getString(_key(_kAccentColorPref)),
    orElse: () => AppAccentColor.designDefault,
  );

  Future<bool> setAccentColor(AppAccentColor accentColor) {
    if (accentColor == AppAccentColor.designDefault) {
      return _prefs.remove(_key(_kAccentColorPref));
    }
    return _prefs.setString(_key(_kAccentColorPref), accentColor.name);
  }

  /// The design system the app's components are drawn with.
  AppDesign get design => AppDesign.values.firstWhere(
    (design) => design.name == _prefs.getString(_key(_kDesignPref)),
    orElse: () => AppDesign.stream,
  );

  Future<bool> setDesign(AppDesign design) {
    if (design == AppDesign.stream) return _prefs.remove(_key(_kDesignPref));
    return _prefs.setString(_key(_kDesignPref), design.name);
  }

  Future<bool> setUserCredentials(UserCredentials? credentials) {
    final jsonString = jsonEncode(credentials?.toJson());
    return _prefs.setString(_authKey(_kUserCredentialsPref), jsonString);
  }

  Future<bool> setApiKey(String apiKey) {
    return _prefs.setString(_authKey(_kApiKeyPref), apiKey);
  }

  Future<bool> setEnvironment(Environment environment) async {
    if (_pinnedEnvironment != null) return true;
    return _prefs.setString(_key(_kEnvironemntPref), environment.name);
  }

  Future<bool> clearUserCredentials() async {
    return await _prefs.remove(_authKey(_kUserCredentialsPref)) &&
        await _prefs.remove(_authKey(_kApiKeyPref));
  }
}
