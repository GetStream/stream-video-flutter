// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY')
  static const apiKey = _Env.apiKey;
  @EnviedField(varName: 'COORDINATOR_RPC_URL')
  static const coordinatorRpcUrl = _Env.coordinatorRpcUrl;
  @EnviedField(varName: 'COORDINATOR_WS_URL')
  static const coordinatorWsUrl = _Env.coordinatorWsUrl;
}
