import 'package:example/views/home_view.dart';
import 'package:example/views/staged_view.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  StreamVideo.init(
    'key10', // see <video>/data/fixtures/apps.yaml for API secret
    coordinatorRpcUrl: //replace with the url obtained with ngrok http 26991
        'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc',
    // 'http://192.168.1.6:26991/rpc',
    coordinatorWsUrl: //replace host with your local ip address
        'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    // 'ws://192.168.1.6:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    //replace host with your local ip address
    // sfuUrl: 'http://192.168.1.10:3031/twirp',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Stream Video Flutter';
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(title: title),
      routes: {
        HomeView.routeName: (context) => HomeView(title: title),
        // StageView.routeName: (context) => StageView(
        //       controller: client.participants,
        //       trackController: client.tracks,
        //     ),
      },
    );
  }
}
