import 'package:chat_with_video_starter/screen/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  /// TODO: Initialize Stream Chat SDK.

  /// TODO: Initialize Stream Video SDK.

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
