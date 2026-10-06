import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

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
  await call.join();

  runApp(const MaterialApp(home: Scaffold()));
}
