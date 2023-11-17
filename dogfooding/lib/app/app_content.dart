import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/core/repos/token_service.dart';
import 'package:flutter_dogfooding/router/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:uni_links/uni_links.dart';

import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../firebase_options.dart';
import '../router/router.dart';
import '../utils/consts.dart';
import 'user_auth_controller.dart';

// As this runs in a separate isolate, we need to setup the app again.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialise the app.
  await AppInjector.init();

  try {
    // Return if the user is not logged in.
    final prefs = locator.get<AppPreferences>();
    final credentials = prefs.userCredentials;
    if (credentials == null) return;

    final tokenResponse = await locator
        .get<TokenService>()
        .loadToken(userId: credentials.userInfo.id);

    // Initialise the video client.
    AppInjector.registerStreamVideo(
      tokenResponse,
      User(info: credentials.userInfo),
    );

    // Handle the message.
    await _handleRemoteMessage(message);
  } catch (e, stk) {
    debugPrint('Error handling remote message: $e');
    debugPrint(stk.toString());
  }

  // Reset the injector once the message is handled.
  return AppInjector.reset();
}

Future<bool> _handleRemoteMessage(RemoteMessage message) async {
  final streamVideo = locator.get<StreamVideo>();
  return streamVideo.handleVoipPushNotification(message.data);
}

class StreamDogFoodingAppContent extends StatefulWidget {
  const StreamDogFoodingAppContent({super.key});

  @override
  State<StreamDogFoodingAppContent> createState() =>
      _StreamDogFoodingAppContentState();
}

class _StreamDogFoodingAppContentState
    extends State<StreamDogFoodingAppContent> {
  late final _userAuthController = locator.get<UserAuthController>();

  late final _logger = taggedLogger(tag: 'StreamDogFoodingAppContent');
  late final _router = initRouter(_userAuthController);

  @override
  void initState() {
    super.initState();
    initPushNotificationManagerIfAvailable();
  }

  void initPushNotificationManagerIfAvailable() {
    // Return if the video client is not yet registered.
    // i.e. the user is not logged in.
    if (!locator.isRegistered<StreamVideo>()) return;

    // Observes deep links.
    _observeDeepLinks();
    // Observe FCM messages.
    _observeFcmMessages();
    // Observe call kit events.
    _observeCallKitEvents();
  }

  final _callKitEventSubscriptions = Subscriptions();

  void _observeCallKitEvents() {
    final streamVideo = locator.get<StreamVideo>();
    _callKitEventSubscriptions.addAll([
      streamVideo.onCallKitEvent<ActionCallAccept>(_onCallAccept),
      streamVideo.onCallKitEvent<ActionCallDecline>(_onCallDecline),
      streamVideo.onCallKitEvent<ActionCallEnded>(_onCallEnded),
    ]);
  }

  StreamSubscription<RemoteMessage>? _fcmSubscription;

  _observeFcmMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _fcmSubscription = FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
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

    final streamVideo = locator.get<StreamVideo>();
    final call = streamVideo.makeCall(type: kCallType, id: callId);

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

  void _onCallAccept(ActionCallAccept event) async {
    _logger.d(() => '[onCallAccept] event: $event');
    final streamVideo = locator.get<StreamVideo>();

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = await streamVideo.consumeIncomingCall(uuid: uuid, cid: cid);
    final callToJoin = call.getDataOrNull();
    if (callToJoin == null) return;

    var acceptResult = await callToJoin.accept();

    // Return if cannot accept call
    if (acceptResult.isFailure) {
      debugPrint('Error accepting call: $call');
      return;
    }

    // Navigate to the call screen.
    final extra = (
      call: callToJoin,
      connectOptions: const CallConnectOptions(),
    );
    _router.push(CallRoute($extra: extra).location, extra: extra);
  }

  void _onCallDecline(ActionCallDecline event) async {
    _logger.d(() => '[onCallDecline] event: $event');
    final streamVideo = locator.get<StreamVideo>();

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = await streamVideo.consumeIncomingCall(uuid: uuid, cid: cid);
    final callToReject = call.getDataOrNull();
    if (callToReject == null) return;

    final result = await callToReject.reject();
    if (result is Failure) {
      debugPrint('Error rejecting call: ${result.error}');
    }
  }

  void _onCallEnded(ActionCallEnded event) async {
    final streamVideo = locator.get<StreamVideo>();

    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = streamVideo.activeCall;
    if (call == null || call.callCid.value != cid) return;

    final result = await call.leave();
    if (result is Failure) {
      debugPrint('Error leaving call: ${result.error}');
    }
  }

  @override
  void dispose() {
    _fcmSubscription?.cancel();
    _deepLinkSubscription?.cancel();
    _callKitEventSubscriptions.cancelAll();
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
        return child!;
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

extension on Subscriptions {
  void addAll<T>(Iterable<StreamSubscription<T>?> subscriptions) {
    for (var i = 0; i < subscriptions.length; i++) {
      final subscription = subscriptions.elementAt(i);
      if (subscription == null) continue;

      add(i + 100, subscription);
    }
  }
}
