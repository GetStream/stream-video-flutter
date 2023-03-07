import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter_background/model/notification_options.dart';
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
      StreamVideoFlutterBackground.setOnButtonClick((buttonType, callCid) => {
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
    StreamVideoFlutterBackground.setOnButtonClick(null);
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
                      NotificationOptions.from(
                        callCid: "call328",
                        contentTitle: "call328: Connected",
                        contentText: "John & Kevin",
                      ),
                    );
                  }),
              ElevatedButton(
                  child: const Text('Stop Service'),
                  onPressed: () async {
                    await StreamVideoFlutterBackground.stopService();
                  }),
              const SizedBox(height: 20),
              Text('On Button Click: $_buttonType(callCid=$_callCid)\n')
            ],
          ),
        ),
      ),
    );
  }
}
