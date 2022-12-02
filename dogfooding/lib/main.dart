import 'package:dogfooding/routes.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video/stream_video.dart';
import 'firebase_options.dart';

// TODO: Use DI to scope the client
final streamVideoClient = StreamVideoClient(
  'key10', // see <video>/data/fixtures/apps.yaml for API secret
  coordinatorRpcUrl: //replace with the url obtained with ngrok http 26991
  // 'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc',
  'http://192.168.1.56:26991/rpc',
  coordinatorWsUrl: //replace host with your local ip address
  // 'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
  'ws://192.168.1.56:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const StreamDogFoodingApp());
}

class StreamDogFoodingApp extends StatelessWidget {
  const StreamDogFoodingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Dog Fooding',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
      ),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
