// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../.env')
abstract class Env {
  @EnviedField(varName: 'DOGFOODING_API_KEY')
  static const apiKey = _Env.apiKey;
  @EnviedField(varName: 'DOGFOODING_COORDINATOR_RPC_URL')
  static const coordinatorRpcUrl = _Env.coordinatorRpcUrl;
  @EnviedField(varName: 'DOGFOODING_COORDINATOR_WS_URL')
  static const coordinatorWsUrl = _Env.coordinatorWsUrl;
}
