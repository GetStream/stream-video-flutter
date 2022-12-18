import 'package:example/routes.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video/stream_video.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamVideo.init(
    'key10', // see <video>/data/fixtures/apps.yaml for API secret
    coordinatorRpcUrl: //replace with the url obtained with ngrok http 26991
        'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc',
    // 'http://192.168.1.7:26991/rpc',
    coordinatorWsUrl: //replace host with your local ip address
        'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    // 'ws://192.168.1.7:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
  );

  runApp(const StreamUIExampleApp());
}

class StreamUIExampleApp extends StatelessWidget {
  const StreamUIExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Video UI Example',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
      ),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
