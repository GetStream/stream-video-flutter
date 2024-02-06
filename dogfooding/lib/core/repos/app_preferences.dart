// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/core/model/user_credentials.dart';

class AppPreferences {
  const AppPreferences({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _kUserCredentialsPref = 'user_credentials';
  static const String _kApiKeyPref = 'api_key';

  UserCredentials? get userCredentials {
    final jsonString = _prefs.getString(_kUserCredentialsPref);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, Object?>;
    return UserCredentials.fromJson(json);
  }

  String? get apiKey => _prefs.getString(_kApiKeyPref);

  Future<bool> setUserCredentials(UserCredentials? credentials) {
    final jsonString = jsonEncode(credentials?.toJson());
    return _prefs.setString(_kUserCredentialsPref, jsonString);
  }

  Future<bool> setApiKey(String apiKey) {
    return _prefs.setString(_kApiKeyPref, apiKey);
  }

  Future<bool> clearUserCredentials() async {
    return await _prefs.remove(_kUserCredentialsPref) &&
        await _prefs.remove(_kApiKeyPref);
  }
}
