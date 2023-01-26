import 'package:chat_with_video_starter/app_config.dart';
import 'package:chat_with_video_starter/screen/choose_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video/stream_video.dart';

Future<void> main() async {
  /// Initialize Stream Video SDK.
  StreamVideo.init(
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
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: ChooseUserScreen(),
    );
  }
}
