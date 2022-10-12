import 'package:example/views/home_view.dart';
import 'package:example/views/staged_view.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  final client = StreamVideoClient(
    'key1', // see <video>/data/fixtures/apps.yaml for API secret
    coordinatorUrl: //replace with the url obtained with ngrok http 26991
        'http://05a8-2a01-cb20-87c-f00-710c-711a-2bbb-ef5.ngrok.io/rpc',
    coordinatorWs: //replace host with your local ip address
        'ws://192.168.1.17:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    //replace host with your local ip address
    sfuUrl: 'http://192.168.1.17:3031/twirp',
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
              controller: client.room,
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
