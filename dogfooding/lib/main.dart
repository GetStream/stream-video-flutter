import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'firebase_options.dart';
import 'src/routes/app_routes.dart';

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
Call? initialCall;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _initStreamVideo();
  await _handleRemoteMessage(message);
}

Future<void> _handleRemoteMessage(RemoteMessage message) async {
  print('JcLog: Handling Remote Message with payload: ${message.data}');
  await StreamVideo.instance.handlePushNotification(message, (call) {
    print('JcLog: on call ($call) accepted, ${message.messageId}');
    initialCall = call;
  });
}

Future<void> main() async {
  print('JcLog: Initializing main app');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _initStreamVideo();
  runApp(StreamDogFoodingApp());
}

void _initStreamVideo() {
  if (!StreamVideo.isInitialized()) {
    StreamVideo.init(
      'us83cfwuhy8n', // see <video>/data/fixtures/apps.yaml for API secret
      coordinatorRpcUrl: //replace with the url obtained with ngrok http 26991
          'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc',
      // 'http://192.168.1.7:26991/rpc',
      coordinatorWsUrl: //replace host with your local ip address
          'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
      // 'ws://192.168.1.7:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    );
  }
}

class StreamDogFoodingApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StreamDogFoodingApp();
}

class _StreamDogFoodingApp extends State<StreamDogFoodingApp> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    print('JcLog: initialMessage: $initialMessage');

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    if (initialCall != null) {
      print('JcLog: We can navigate to the call screen');
    }
  }

  void _handleMessage(RemoteMessage message) {
    print('JcLog: handling opened PN');
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(
    //     navState.currentContext,
    //     CallScreen.routeName,
    //     arguments: ChatArguments(message),
    //   );
    // }
  }

  @override
  void initState() {
    super.initState();
    print('JcLog: [initState]');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    print('JcLog: Building StreamDogFoodingApp widget');
    final appTheme = StreamVideoTheme.light();
    return MaterialApp(
      title: 'Stream Dog Fooding',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        scaffoldBackgroundColor: appTheme.colorTheme.appBg,
        extensions: <ThemeExtension<dynamic>>[
          appTheme,
        ],
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      navigatorKey: navState,
    );
  }
}
