import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamVideo.create(
    'api_token',
    user: User.guest(userId: 'user_id'),
  );
}
