import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/credentials.dart';

class AuthRepository {
  // Private constructor
  const AuthRepository._({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  static const String _kAuthCredentialsPref = 'auth_credentials';
  final SharedPreferences _prefs;

  // Singleton instance
  static AuthRepository? _instance;

  // Factory constructor for accessing the singleton instance
  static Future<AuthRepository> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = AuthRepository._(prefs: prefs);
    }
    return _instance!;
  }

  AuthCredentials? getCredentials() {
    final jsonString = _prefs.getString(_kAuthCredentialsPref);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, Object?>;
    return AuthCredentials.fromJson(json);
  }

  Future<bool> setCredentials(AuthCredentials? credentials) {
    final jsonString = jsonEncode(credentials?.toJson());
    return _prefs.setString(_kAuthCredentialsPref, jsonString);
  }

  Future<bool> clearCredentials() async {
    return _prefs.remove(_kAuthCredentialsPref);
  }
}
