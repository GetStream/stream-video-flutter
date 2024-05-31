// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;

class TokenResponse {
  const TokenResponse(this.token, this.apiKey);

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      TokenResponse(json['token'], json['apiKey']);

  final String token;
  final String apiKey;
}

class TokenService {
  const TokenService();

  Future<TokenResponse> loadToken({
    required String userId,
    required Environment environment,
    Duration? expiresIn,
  }) async {
    final queryParameters = <String, dynamic>{
      'environment': environment.alias,
      'user_id': userId,
    };
    if (expiresIn != null) {
      queryParameters['exp'] = expiresIn.inSeconds.toString();
    }

    final uri = Uri(
      scheme: 'https',
      host: 'pronto.getstream.io',
      path: '/api/auth/create-token',
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);
    final body = json.decode(response.body) as Map<String, dynamic>;
    return TokenResponse.fromJson(body);
  }
}

enum Environment {
  prontoStaging('pronto-staging'),
  pronto('pronto'),
  demo('demo');

  const Environment(this.alias);

  final String alias;
}
