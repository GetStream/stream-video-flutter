import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'firebase_options.dart';
import 'repos/app_repository.dart';
import 'repos/user_repository.dart';
import 'src/routes/app_routes.dart';
import 'src/routes/routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await AppRepository.instance.initStreamVideo();
  await _handleRemoteMessage(message);
}

Future<void> _handleRemoteMessage(RemoteMessage message) async {
  await StreamVideo.instance.handlePushNotification(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppRepository.instance.beginSession();
  runApp(const StreamDogFoodingApp());
}

class StreamDogFoodingApp extends StatefulWidget {
  const StreamDogFoodingApp({super.key});

  @override
  State<StreamDogFoodingApp> createState() => _StreamDogFoodingAppState();
}

class _StreamDogFoodingAppState
    extends State<StreamDogFoodingApp>
    with
        //ignore:prefer_mixin
        WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late StreamSubscription<Uri?> _subscription;
  late final StreamChatClient chatClient;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
    _tryConsumingIncomingCallFromTerminatedState();
    _observeDeepLinks();
    AppRepository.instance.beginSession();
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

    final userCredentials = await UserRepository.instance.getUserCredentials();

    if (userCredentials != null) {
      final user = userCredentials.user;
      final token = userCredentials.token;

      await StreamVideo.instance.connectUser(
        user,
        token,
      );

      final callCid = StreamCallCid.from(type: 'default', id: callId);
      final data = await StreamVideo.instance.getOrCreateCall(cid: callCid);
      final call = Call.fromCreated(data: data.getDataOrNull()!.data);

      await _navigatorKey.currentState?.pushNamed(
        Routes.call,
        arguments: call,
      );
    }
  }

  void _tryConsumingIncomingCallFromTerminatedState() {
    if (_navigatorKey.currentContext == null) {
      // App is not running yet. Postpone consuming after app is in the foreground
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _consumeIncomingCall();
      });
    } else {
      // no-op. If the app is already running we'll handle this in didChangeAppLifecycleState
    }
  }

  Future<void> _consumeIncomingCall() async {
    if (_navigatorKey.currentContext == null) {
      return;
    }
    final incomingCall = await StreamVideo.instance.consumeIncomingCall();
    if (incomingCall != null) {
      await Navigator.of(_navigatorKey.currentContext!).pushReplacementNamed(
        Routes.call,
        arguments: Call.fromCreated(data: incomingCall),
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
    final appTheme = StreamVideoTheme.dark();
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Stream Dog Fooding',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme().copyWith(
          bodyLarge: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          bodyMedium: const TextStyle(
            fontSize: 18,
            color: Color(0xFF979797),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF2C2C2E),
        extensions: <ThemeExtension<dynamic>>[
          appTheme,
        ],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff005FFF),
        ),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (BuildContext context, Widget? child) {
        return StreamChat(
          client: AppRepository.instance.streamChatClient!,
          child: child,
        );
      },
    );
  }
}
