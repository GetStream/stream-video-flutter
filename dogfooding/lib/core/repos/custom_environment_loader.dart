import 'dart:async';

/// If you want to use dogfooding with your own environment, you can provide a custom environment loader here.
/// This will allow you to use your own tokens and API key.
///
/// You can use https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens to generate tokens and hardcode them.
///
/// Replace the global variable `customEnvironmentLoader` with your own implementation.
///
/// ```dart
/// final customEnvironmentLoader = CustomEnvironmentLoader(
///     tokenLoader: (userId) => '{USER_TOKEN}', apiKey
///     apiKey: '{API_KEY}');
/// ```
class CustomEnvironmentLoader {
  const CustomEnvironmentLoader({
    required this.tokenLoader,
    required this.apiKey,
  });

  final FutureOr<String> Function(String) tokenLoader;
  final String apiKey;
}

// Replace this with your own implementation.
const CustomEnvironmentLoader? customEnvironmentLoader = null;

// Uncomment the following code and replace the values with your own tokens and API key.
// Or use more sophisticated logic to load tokens and API key.
// final customEnvironmentLoader = CustomEnvironmentLoader(
//     tokenLoader: (userId) => '{USER_TOKEN}', apiKey: '{API_KEY}');
