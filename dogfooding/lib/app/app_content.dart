import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/core/repos/token_service.dart';
import 'package:flutter_dogfooding/router/routes.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
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

    final tokenResponse = await locator.get<TokenService>().loadToken(
        userId: credentials.userInfo.id, environment: prefs.environment);

    // Initialise the video client.
    AppInjector.registerStreamVideo(
      tokenResponse,
      User(info: credentials.userInfo),
      prefs.environment,
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
    final user = _userAuthController.currentUser;

    if (user == null) {
      return;
    }

    final environment = Environment.fromHost(uri.host);

    await AppInjector.reset();
    await AppInjector.init(forceEnvironment: environment);

    final authController = locator.get<UserAuthController>();
    await authController.login(User(info: user), environment);

    String? callId;
    for (final segment in uri.pathSegments.indexed) {
      if (segment.$2 == 'join') {
        // Next segment is the callId
        callId = uri.pathSegments[segment.$1 + 1];
        break;
      }
    }

    callId ??= uri.queryParameters['id'];
    if (callId == null) return;

    // return if the video user is not yet logged in.
    final currentUser = _userAuthController.currentUser;
    if (currentUser == null) return;

    try {
      final streamVideo = locator.get<StreamVideo>();
      final call = streamVideo.makeCall(callType: kCallType, id: callId);

      await call.getOrCreate();

      _router.push(LobbyRoute($extra: call).location, extra: call);
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
      return;
    }

    // Navigate to the lobby screen.
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
    final textTheme = StreamVideoTheme.dark().textTheme;
    const colorTheme = StreamColorTheme.dark();

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColorPalette.backgroundColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColorPalette.primary,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
      ),
      bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
        backgroundColor: Colors.black,
        dragHandleColor: Colors.white,
      ),
      extensions: <ThemeExtension<dynamic>>[
        StreamVideoTheme.dark().copyWith(
          callControlsTheme: StreamCallControlsThemeData(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            callReactions: const [
              CallReactionData(
                type: 'Fireworks',
                emojiCode: ':fireworks:',
                icon: '🎉',
              ),
              CallReactionData(
                type: 'Liked',
                emojiCode: ':like:',
                icon: '👍',
              ),
              CallReactionData(
                type: 'Dislike',
                emojiCode: ':dislike:',
                icon: '👎',
              ),
              CallReactionData(
                type: 'Smile',
                emojiCode: ':smile:',
                icon: '😊',
              ),
              CallReactionData(
                type: 'Heart',
                emojiCode: ':heart:',
                icon: '♥️',
              ),
              CallReactionData(
                emojiCode: ':raise-hand:',
                type: 'Raise hand',
                icon: '✋',
              )
            ],
            backgroundColor: colorTheme.barsBg,
            elevation: 8,
            padding: const EdgeInsets.all(14),
            spacing: 4,
            optionIconColor: Colors.white,
            inactiveOptionIconColor: Colors.white,
            optionElevation: 2,
            inactiveOptionElevation: 2,
            optionBackgroundColor: AppColorPalette.buttonSecondary,
            inactiveOptionBackgroundColor: colorTheme.overlay.withOpacity(0.4),
            optionShape: const CircleBorder(),
            optionPadding: const EdgeInsets.all(14),
          ),
          userAvatarTheme: StreamUserAvatarThemeData(
            borderRadius: BorderRadius.circular(20),
            constraints: const BoxConstraints.tightFor(
              height: 40,
              width: 40,
            ),
            initialsTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColorPalette.primary,
            ),
            initialsBackground: AppColorPalette.avatarBackground,
            selectionThickness: 4,
          ),
          lobbyViewTheme: StreamLobbyViewThemeData(
            backgroundColor: AppColorPalette.backgroundColor,
            cardBackgroundColor: AppColorPalette.buttonSecondary,
            userAvatarTheme: StreamUserAvatarThemeData(
              constraints: const BoxConstraints.tightFor(
                height: 100,
                width: 100,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              initialsTextStyle:
                  textTheme.title1.copyWith(color: AppColorPalette.primary),
              initialsBackground: AppColorPalette.avatarBackground,
              selectionThickness: 4,
            ),
          ),
          callParticipantTheme: StreamCallParticipantThemeData(
            showSpeakerBorder: true,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            speakerBorderColor: colorTheme.accentPrimary,
            speakerBorderThickness: 4,
            backgroundColor: AppColorPalette.buttonSecondary,
            userAvatarTheme: StreamUserAvatarThemeData(
              constraints: const BoxConstraints.tightFor(
                height: 100,
                width: 100,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              initialsTextStyle:
                  textTheme.title1.copyWith(color: const Color(0xFF005FFF)),
              initialsBackground: AppColorPalette.avatarBackground,
              selectionColor: colorTheme.accentPrimary,
              selectionThickness: 4,
            ),
            audioLevelIndicatorColor: colorTheme.accentPrimary,
            participantLabelTextStyle:
                textTheme.footnote.copyWith(color: Colors.white),
            disabledMicrophoneColor: Colors.white,
            enabledMicrophoneColor: Colors.white,
            connectionLevelActiveColor: const Color(0xFF00FF00),
            connectionLevelInactiveColor: Colors.white,
            participantsGridPadding: const EdgeInsets.all(4),
            participantsGridMainAxisSpacing: 4,
            participantsGridCrossAxisSpacing: 4,
          ),
        )
      ],
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: Colors.white,
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
