// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;

class TokenService {
  const TokenService({required this.apiKey});

  final String apiKey;

  Future<String> loadToken({
    required String userId,
    Duration? expiresIn,
  }) async {
    final queryParameters = <String, dynamic>{
      'api_key': apiKey,
      'user_id': userId,
    };
    if (expiresIn != null) {
      queryParameters['exp'] = expiresIn.inSeconds.toString();
    }

    final uri = Uri(
      scheme: 'https',
      host: 'stream-calls-dogfood.vercel.app',
      path: '/api/auth/create-token',
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);
    final body = json.decode(response.body) as Map<String, dynamic>;
    return body['token'];
  }
}
