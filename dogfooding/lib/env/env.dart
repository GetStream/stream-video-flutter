// lib/env/env.dart

// 📦 Package imports:
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../.env')
abstract class Env {
  @EnviedField(varName: 'DOGFOODING_API_KEY')
  static const String apiKey = _Env.apiKey;
}
