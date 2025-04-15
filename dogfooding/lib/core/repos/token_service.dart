// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_dogfooding/core/model/environment.dart';
import 'package:http/http.dart' as http;

import 'custom_environment_loader.dart';

class TokenResponse {
  final String token;
  final String apiKey;

  const TokenResponse(this.token, this.apiKey);

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      TokenResponse(json['token'], json['apiKey']);
}

class TokenService {
  final CustomEnvironmentLoader? customEnvironmentLoader;

  const TokenService({this.customEnvironmentLoader});

  Future<TokenResponse> loadToken({
    required String userId,
    required Environment environment,
    Duration? expiresIn,
  }) async {
    if (environment == Environment.custom) {
      if (customEnvironmentLoader == null) {
        throw Exception(
            'Custom environment is not configured. Provide customEnvironmentLoader to AppInjector.init method to use it.');
      }

      final userToken = await customEnvironmentLoader!.tokenLoader(userId);

      return TokenResponse(
        userToken,
        customEnvironmentLoader!.apiKey,
      );
    }

    final queryParameters = <String, dynamic>{
      'environment': environment.envName,
      'user_id': userId,
    };

    if (expiresIn != null) {
      queryParameters['exp'] = expiresIn.inSeconds.toString();
    }

    final uri = Uri(
      scheme: 'https',
      host: environment.hostName,
      path: '/api/auth/create-token',
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);
    final body = json.decode(response.body) as Map<String, dynamic>;
    return TokenResponse.fromJson(body);
  }
}
