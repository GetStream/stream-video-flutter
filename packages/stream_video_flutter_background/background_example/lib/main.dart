import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter_background/model/notification_options.dart';
import 'package:stream_video_flutter_background/model/notification_payload.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _buttonType = '<button_type>';
  String _callCid = '<call_cid>';

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      StreamVideoFlutterBackground.setOnNotificationButtonClick(
          (buttonType, callCid) => {
                setState(() {
                  _buttonType = buttonType;
                  _callCid = callCid;
                })
              });
    } catch (e, stk) {
      print('[initPlatformState] failed: $e; $stk');
    }
  }

  @override
  void dispose() {
    super.dispose();
    StreamVideoFlutterBackground.setOnNotificationButtonClick(null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Start Service'),
                onPressed: () async {
                  await StreamVideoFlutterBackground.startService(
                    _buildPayload(_counter++),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Update Service'),
                onPressed: () async {
                  await StreamVideoFlutterBackground.updateService(
                    _buildPayload(_counter++),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Stop Service'),
                onPressed: () async {
                  await StreamVideoFlutterBackground.stopService();
                },
              ),
              const SizedBox(height: 20),
              Text('On Button Click: $_buttonType(callCid=$_callCid)\n')
            ],
          ),
        ),
      ),
    );
  }

  NotificationPayload _buildPayload(counter) {
    return NotificationPayload(
      callCid: "call328",
      options: NotificationOptions(
        useCustomLayout: true,
        content: NotificationContent(
          title: "call328: Connected($counter)",
          text: "John & Kevin",
        ),
        avatar: const NotificationAvatar(
          url:
              "https://getstream.io/chat/docs/sdk/avatars/jpg/Willard%20Hessel.jpg",
        ),
      ),
    );
  }
}
