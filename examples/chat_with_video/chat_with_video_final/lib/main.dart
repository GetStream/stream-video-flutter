import 'package:chat_with_video_final/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'env/env.dart';

void main() {
  /// Initialize Stream Video SDK.
  StreamVideo.init(
    Env.streamVideoApiKey,
    logPriority: Priority.info,
  );

  /// Initialize Stream Chat SDK.
  final client = StreamChatClient(
    Env.streamChatApiKey,
    logLevel: Level.INFO,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: LoginScreen(),
    );
  }
}
