import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';

import 'src/adm_sample.dart';
import 'src/capture_frame_sample.dart';
import 'src/device_enumeration_sample.dart';
import 'src/get_display_media_sample.dart';
import 'src/get_user_media_sample.dart'
    if (dart.library.js_interop) 'src/get_user_media_sample_web.dart';
import 'src/loopback_data_channel_sample.dart';
import 'src/loopback_sample_with_get_stats.dart';
import 'src/route_item.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Future<bool> startForegroundService() async {
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: 'Title of the notification',
    notificationText: 'Text of the notification',
    notificationIcon: AndroidResource(
      name: 'background_icon',
    ), // Default is ic_launcher from folder mipmap
  );
  await FlutterBackground.initialize(androidConfig: androidConfig);
  return FlutterBackground.enableBackgroundExecution();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<RouteItem> items;

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  ListBody _buildRow(context, item) {
    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text(item.title),
          onTap: () => item.push(context),
          trailing: const Icon(Icons.arrow_right),
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter-WebRTC example'),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemCount: items.length,
          itemBuilder: (context, i) {
            return _buildRow(context, items[i]);
          },
        ),
      ),
    );
  }

  void _initItems() {
    items = <RouteItem>[
      RouteItem(
        title: 'GetUserMedia',
        push: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const GetUserMediaSample(),
            ),
          );
        },
      ),
      RouteItem(
        title: 'Device Enumeration',
        push: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  const DeviceEnumerationSample(),
            ),
          );
        },
      ),
      RouteItem(
        title: 'GetDisplayMedia',
        push: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const GetDisplayMediaSample(),
            ),
          );
        },
      ),
      RouteItem(
        title: 'LoopBack Sample (with GetStats)',
        push: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  const LoopBackSampleWithGetStats(),
            ),
          );
        },
      ),
      RouteItem(
        title: 'DataChannelLoopBackSample',
        push: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  const DataChannelLoopBackSample(),
            ),
          );
        },
      ),
      RouteItem(
        title: 'Capture Frame',
        push: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const CaptureFrameSample(),
            ),
          );
        },
      ),
      RouteItem(
        title: 'ADM Sample',
        push: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AdmSample(),
            ),
          );
        },
      ),
    ];
  }
}
