import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video/stream_video.dart';

import 'src/routes/app_routes.dart';
import 'src/v2/routes_v2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /* TODO
  StreamVideo.init(
    'key10', // see <video>/data/fixtures/apps.yaml for API secret
    coordinatorRpcUrl: //replace with the url obtained with ngrok http 26991
        'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc',
    // 'http://192.168.1.7:26991/rpc',
    coordinatorWsUrl: //replace host with your local ip address
        'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    // 'ws://192.168.1.7:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
  );
  */

  StreamLog()
    ..logger = ConsoleStreamLogger()
    ..validator = (priority, tag) => true;
  StreamVideoV2.init(
    'us83cfwuhy8n', // see <video>/data/fixtures/apps.yaml for API secret
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
  const StreamUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Video UI Example',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
      ),
      // onGenerateRoute: AppRoutes.generateRoute,
      onGenerateRoute: RoutesV2.generateRoute,
    );
  }
}
