// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:uni_links/uni_links.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/router/routes.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../router/router.dart';
import '../utils/consts.dart';
import 'user_auth_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // As this runs in a separate isolate, we need to initialize and connect the
  // user to StreamVideo again.

  // If the user is not logged in, we don't need to handle the message.
  final prefs = locator.get<AppPreferences>();
  final credentials = prefs.userCredentials;
  if (credentials == null) return;

  // Login using the stored credentials.
  final authController = locator.get<UserAuthController>();
  await authController.loginWithInfo(credentials.userInfo);

  // Once the setup is done, we can handle the message.
  await _handleRemoteMessage(message);
}

Future<bool> _handleRemoteMessage(RemoteMessage message) {
  return locator.get<StreamVideo>().handlePushNotification(message.data);
}

class StreamDogFoodingAppContent extends StatefulWidget {
  const StreamDogFoodingAppContent({super.key});

  @override
  State<StreamDogFoodingAppContent> createState() =>
      _StreamDogFoodingAppContentState();
}

class _StreamDogFoodingAppContentState extends State<StreamDogFoodingAppContent>
    with WidgetsBindingObserver {
  late final _streamVideo = locator.get<StreamVideo>();
  late final _userAuthController = locator.get<UserAuthController>();

  late final _router = initRouter(_userAuthController);

  @override
  void initState() {
    super.initState();
    // Init push notification manager to handle incoming calls.
    _streamVideo.initPushNotificationManager(
      StreamVideoPushNotificationManager.factory(
        apnsProviderName: 'flutter-apn-video',
        firebaseProviderName: 'firebase',
      ),
    );

    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _consumeIncomingCall();
    _observeDeepLinks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _consumeIncomingCall();
    }
  }

  // Check if there is an incoming call that needs to be consumed.
  Future<void> _consumeIncomingCall() async {
    final call = await StreamVideo.instance.consumeIncomingCall();
    if (call == null) return;

    // Navigate to the lobby screen.
    _router.push(LobbyRoute($extra: call).location, extra: call);
  }

  StreamSubscription<Uri?>? _deepLinkSubscription;

  Future<void> _observeDeepLinks() async {
    // The app was in the background.
    if (!kIsWeb) {
      _deepLinkSubscription = uriLinkStream.listen((uri) {
        if (mounted && uri != null) _handleDeepLink(uri);
      });
    }

    // The app was terminated.
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) _handleDeepLink(initialUri);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _handleDeepLink(Uri uri) async {
    // Parse the call id from the deep link.
    final callId = uri.queryParameters['id'];
    if (callId == null) return;

    // return if the video user is not yet logged in.
    final currentUser = _userAuthController.currentUser;
    if (currentUser == null) return;

    final call = _streamVideo.makeCall(type: kCallType, id: callId);

    try {
      await call.getOrCreate();
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
      return;
    }

    // Navigate to the lobby screen.
    _router.push(LobbyRoute($extra: call).location, extra: call);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkSubscription?.cancel();
    _userAuthController.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: kAppName,
      routerConfig: _router,
      theme: _buildTheme(Brightness.dark),
      builder: (context, child) {
        // Wrap the app in a StreamChat widget to provide it with the
        // StreamChatClient instance.
        return StreamChat(
          client: locator.get(),
          streamChatThemeData: StreamChatThemeData.dark(),
          child: child!,
        );
      },
    );
  }

  ThemeData _buildTheme(brightness) {
    final baseTheme = ThemeData(brightness: brightness);
    final baseTextTheme = GoogleFonts.interTextTheme(baseTheme.textTheme);
    return baseTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF2C2C2E),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xff005FFF),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
      ),
      extensions: <ThemeExtension<dynamic>>[StreamVideoTheme.dark()],
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 18,
          color: const Color(0xFF979797),
        ),
      ),
    );
  }
}
