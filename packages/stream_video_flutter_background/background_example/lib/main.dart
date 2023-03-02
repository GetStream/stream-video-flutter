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
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await StreamVideoFlutterBackground.getPlatformVersion() ??
              'Unknown platform version';
      print('[initPlatformState] platformVersion: $platformVersion');
      StreamVideoFlutterBackground.setOnButtonClick((buttonType, callCid) => {
            setState(() {
              _buttonType = buttonType;
              _callCid = callCid;
            })
          });
    } catch (e, stk) {
      print('[initPlatformState] failed: $e; $stk');
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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
                      const NotificationOptions(
                        appId: 'xyz123',
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
              Text('Running on: $_platformVersion\n'),
              Text('On Button Click: $_buttonType(callCid=$_callCid)\n')
            ],
          ),
        ),
      ),
    );
  }
}
