import 'dart:async';

import 'package:dogfooding/src/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'firebase_options.dart';
import 'src/routes/app_routes.dart';

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
Call? initialCall;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _initStreamVideo();
  print('JcLog: PN received in background');
  await _handleRemoteMessage(message);
}

Future<void> _handleRemoteMessage(RemoteMessage message) async {
  print('JcLog: Handling Remote Message with payload: ${message.data}');
  await StreamVideo.instance.handlePushNotification(message, (call) async {
    print(
        'JcLog: on call ($call) accepted, ${message.messageId}, navState.currentContext: ${navState.currentContext}');

    // 1. Application is terminated - storing something in shared preferences and handle in DogfoodingApp
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool("callReceived", true);
    // StreamInstance.consumeActiveCall() - return and clean

    // 2. Application is in the foreground. Let's check if we need to store
    if (navState.currentContext != null) {
      // We can know the app is alive
      // Do navigation
    }

    // 3. Application is in the bg - simillar to 2.
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
  print("JcLog: ${StreamVideo.instance.hashCode}");
}

class StreamDogFoodingApp extends StatefulWidget {
  const StreamDogFoodingApp({super.key});

  @override
  State<StreamDogFoodingApp> createState() => _StreamDogFoodingAppState();
}

class _StreamDogFoodingAppState extends State<StreamDogFoodingApp>
    with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late StreamSubscription<Uri?> _subscription;
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.

    //TODO: getInitialMessage() will always return null if not FCM notification is clicked. We cannot use it
    // final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // print('JcLog: initialMessage: $initialMessage');
    //
    // // If the message also contains a data property with a "type" of "chat",
    // // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);

    // 1.Application terminated - call StreamInstance.getAcceptedCAll, get a call and navigate
    final prefs = await SharedPreferences.getInstance();
    print('JcLog: callReceived: ${prefs.getBool("callReceived")}');
    await prefs.remove("callReceived");

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // https://pub.dev/documentation/firebase_messaging/latest/firebase_messaging/FirebaseMessaging/onMessageOpenedApp.html
    // Only works with FCM notifications!!!!
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    // if (initialCall != null) {
    //   print('JcLog: We can navigate to the call screen');
    // }
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

    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
    _tryConsumingIncomingCallFromTerminatedState();
    _observeDeepLinks();
  }

  Future<void> _observeDeepLinks() async {
    // The app was terminated.
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        await _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // The app was in the background.
    if (!kIsWeb) {
      _subscription = uriLinkStream.listen((Uri? uri) {
        if (mounted && uri != null) {
          _handleDeepLink(uri);
        }
      });
    }
  }

  Future<void> _handleDeepLink(Uri uri) async {
    final callId = uri.pathSegments.last;
    await _navigatorKey.currentState?.pushReplacementNamed(
      Routes.JOIN,
      arguments: callId,
    );
  }

  void _tryConsumingIncomingCallFromTerminatedState() {
    print('JcLog: [_tryConsumingIncomingCallFromTerminatedState]');
    if (_navigatorKey.currentContext == null) {
      // App is not running yet. Postpone consuming after app is in the foreground
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print('JcLog: Postponing consuming incoming call');
        _consumeIncomingCall();
      });
    } else {
      // no-op. If the app is already running we'll handle this in didChangeAppLifecycleState
    }
  }

  Future<void> _consumeIncomingCall() async {
    if (_navigatorKey.currentContext == null) {
      print('JcLog: _navigatorKey.currentContext is null!');
      return;
    }
    print('JcLog: Consuming call');
    final incomingCall = await StreamVideo.instance.consumeIncomingCall();
    if (incomingCall != null) {
      print('JcLog: Call is not null');
      Navigator.of(_navigatorKey.currentContext!).pushReplacementNamed(
        Routes.CALL,
        arguments: incomingCall,
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('JcLog: AppLifecycleState.resumed');
        _consumeIncomingCall();
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('JcLog: Building StreamDogFoodingApp widget');
    final appTheme = StreamVideoTheme.light();
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Stream Dog Fooding',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        scaffoldBackgroundColor: appTheme.colorTheme.appBg,
        extensions: <ThemeExtension<dynamic>>[
          appTheme,
        ],
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
