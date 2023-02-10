import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video/stream_video.dart';
import 'package:video_with_chat/app_config.dart';
import 'package:video_with_chat/screen/login_screen.dart';

Future<void> main() async {
  /// Initialize Stream Video SDK.
  StreamVideoV2.init(
    videoApiKey,
    logLevel: Level.INFO,
  );

  /// Initialize Stream Chat SDK.
  final client = StreamChatClient(
    chatApiKey,
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
      builder: (context, widget) {
        return StreamChat(
          client: client,
          child: widget,
        );
      },
      home: LoginScreen(),
    );
  }
}
