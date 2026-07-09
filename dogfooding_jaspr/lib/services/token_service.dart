import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';

class TokenResponse {
  const TokenResponse(this.token, this.apiKey);

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(json['token'] as String, json['apiKey'] as String);
  }

  final String token;
  final String apiKey;
}

/// Fetches a token + apiKey from the same endpoint the Flutter dogfooding
/// app uses, so both clients can join the same Stream app/environment.
class TokenService {
  const TokenService();

  Future<TokenResponse> loadToken(String userId) async {
    final uri = Uri(
      scheme: 'https',
      host: kTokenHost,
      path: '/api/auth/create-token',
      queryParameters: {'environment': kEnvironmentName, 'user_id': userId},
    );

    final response = await http.get(uri);
    final body = json.decode(response.body) as Map<String, dynamic>;
    return TokenResponse.fromJson(body);
  }
}
