// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;

import 'custom_environment_loader.dart';

enum Environment {
  pronto(
    'Pronto',
    'pronto',
    'pronto.getstream.io',
    aliases: ['stream-calls-dogfood'],
    baseUrls: [
      'https://pronto.getstream.io',
      'https://stream-calls-dogfood.vercel.app'
    ],
  ),
  prontoStaging(
    'Pronto Staging',
    'pronto',
    'pronto-staging.getstream.io',
    baseUrls: ['https://pronto-staging.getstream.io'],
  ),
  demo(
    'Demo',
    'demo',
    'pronto.getstream.io',
    aliases: [''],
    baseUrls: ['https://getstream.io'],
  ),
  staging(
    'Staging',
    'staging',
    'pronto.getstream.io',
    baseUrls: ['https://staging.getstream.io'],
  ),
  custom(
    'Custom',
    'custom',
    '',
  );

  final String displayName;
  final String envName;
  final String hostName;
  final List<String> aliases;
  final List<String> baseUrls;

  const Environment(
    this.displayName,
    this.envName,
    this.hostName, {
    this.aliases = const [],
    this.baseUrls = const [],
  });

  factory Environment.fromSubdomain(String subdomain) {
    return Environment.values.firstWhere(
      (env) => env.name == subdomain || env.aliases.contains(subdomain),
      orElse: () => Environment.demo,
    );
  }

  factory Environment.fromHost(String host) {
    final hostParts = host.split('.');
    final String envAlias = hostParts.length < 2 ? '' : hostParts[0];

    return Environment.fromSubdomain(envAlias);
  }

  factory Environment.fromBaseUrl(String baseUrl) {
    return Environment.values.firstWhere(
      (env) => env.baseUrls.contains(baseUrl),
    );
  }
}

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
