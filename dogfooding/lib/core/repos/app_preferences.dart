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

  UserCredentials? get userCredentials {
    final jsonString = _prefs.getString(_kUserCredentialsPref);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, Object?>;
    return UserCredentials.fromJson(json);
  }

  Future<bool> setUserCredentials(UserCredentials? credentials) {
    final jsonString = jsonEncode(credentials?.toJson());
    return _prefs.setString(_kUserCredentialsPref, jsonString);
  }

  Future<bool> clearUserCredentials() => _prefs.remove(_kUserCredentialsPref);
}
