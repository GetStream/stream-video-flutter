import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamVideo(
    'api-key',
    user: User.anonymous(),
    userToken: 'user-token',
  );
  await client.connect();

  final call = client.makeCall(
    callType: StreamCallType.defaultType(),
    id: 'sdk-size',
  );
  await call.getOrCreate();

  runApp(
    MaterialApp(
      theme: ThemeData(extensions: [StreamVideoTheme.light()]),
      darkTheme: ThemeData(extensions: [StreamVideoTheme.dark()]),
      home: StreamCallContainer(call: call),
    ),
  );
}
