// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'STREAM_VIDEO_API_KEY')
  static const streamVideoApiKey = _Env.streamVideoApiKey;
  @EnviedField(varName: 'STREAM_CHAT_API_KEY')
  static const streamChatApiKey = _Env.streamChatApiKey;
}
