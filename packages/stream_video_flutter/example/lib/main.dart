import 'package:example/views/home_view.dart';
import 'package:example/views/staged_view.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  final client = StreamVideoClient(
    'key1', // see <video>/data/fixtures/apps.yaml for API secret
  );
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final StreamVideoClient client;
  const MyApp({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Stream Video Flutter';
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(title: title),
      routes: {
        HomeView.routeName: (context) => HomeView(title: title),
        StageView.routeName: (context) => StageView(
              controller: client.participants,
            ),
      },
      builder: (context, child) {
        return StreamVideoProvider(
          client: client,
          child: child!,
        );
      },
    );
  }
}
