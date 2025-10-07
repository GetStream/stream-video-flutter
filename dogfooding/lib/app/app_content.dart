import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

import '../core/model/environment.dart';
import '../di/injector.dart';
import '../router/router.dart';
import '../router/routes.dart';
import '../theme/app_palette.dart';
import '../utils/consts.dart';
import 'custom_video_localizations.dart';
import 'firebase_messaging_handler.dart';
import 'user_auth_controller.dart';

class StreamDogFoodingAppContent extends StatefulWidget {
  const StreamDogFoodingAppContent({super.key});

  @override
  State<StreamDogFoodingAppContent> createState() =>
      _StreamDogFoodingAppContentState();
}

class _StreamDogFoodingAppContentState
    extends State<StreamDogFoodingAppContent> {
  late final _userAuthController = locator.get<UserAuthController>();

  late final _router = initRouter(_userAuthController);

  final _compositeSubscription = CompositeSubscription();
  bool? _microphoneEnabledBeforeInterruption;

  @override
  void initState() {
    super.initState();

    if (_userAuthController.currentUser != null) {
      initPushNotificationManagerIfAvailable();
    }

    _userAuthController.addListener(() {
      if (_userAuthController.currentUser != null) {
        _compositeSubscription.clear();
        initPushNotificationManagerIfAvailable();
        _handleMobileAudioInterruptions();
      } else {
        _compositeSubscription.clear();
      }
    });

    _tryConsumingIncomingCallFromTerminatedState();
  }

  void initPushNotificationManagerIfAvailable() {
    // Return if the video client is not yet registered.
    // i.e. the user is not logged in.
    if (!locator.isRegistered<StreamVideo>()) return;

    // Observe call kit events.
    _observeRingingEvents();
    // Observes deep links.
    _observeDeepLinks();
    // Observe FCM messages.
    _observeFcmMessages();
  }

  void _handleMobileAudioInterruptions() {
    if (!CurrentPlatform.isMobile) return;

    RtcMediaDeviceNotifier.instance.handleCallInterruptionCallbacks(
      onInterruptionStart: () {
        final call = StreamVideo.instance.activeCall;
        _microphoneEnabledBeforeInterruption =
            call?.state.value.localParticipant?.isAudioEnabled;

        call?.setMicrophoneEnabled(enabled: false);
      },
      onInterruptionEnd: () {
        if (_microphoneEnabledBeforeInterruption ?? false) {
          StreamVideo.instance.activeCall?.setMicrophoneEnabled(enabled: true);
        }
        _microphoneEnabledBeforeInterruption = null;
      },
    );
  }

  void _tryConsumingIncomingCallFromTerminatedState() {
    if (!CurrentPlatform.isAndroid) return;

    if (_router.routerDelegate.navigatorKey.currentContext == null) {
      // App is not running yet. Postpone consuming after app is in the foreground
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final streamVideo = locator.get<StreamVideo>();
        streamVideo.consumeAndAcceptActiveCall(
          onCallAccepted: (call) {
            final extra = (
              call: call,
              connectOptions: null,
              effectsManager: null,
            );

            _router.push(CallRoute($extra: extra).location, extra: extra);
          },
        );
      });
    } else {
      // no-op. If the app is already running we'll handle it via events
    }
  }

  void _observeRingingEvents() {
    final streamVideo = locator.get<StreamVideo>();

    // On mobile we depend on call kit notifications.
    // On desktop and web they are (currently) not available, so we depend on a
    // websocket which can receive a call when the app is open.
    if (CurrentPlatform.isMobile) {
      _compositeSubscription.add(
        streamVideo.observeCoreRingingEvents(
          onCallAccepted: (callToJoin) {
            // Navigate to the call screen.
            final extra = (
              call: callToJoin,
              connectOptions: null,
              effectsManager: null,
            );

            _router.push(CallRoute($extra: extra).location, extra: extra);
          },
        ),
      );
    } else {
      _compositeSubscription.add(
        streamVideo.state.incomingCall.listen((call) {
          if (call == null) return;

          // Navigate to the call screen.
          final extra = (
            call: call,
            connectOptions: null,
            effectsManager: null,
          );

          _router.push(CallRoute($extra: extra).location, extra: extra);
        }),
      );
    }
  }

  void _observeFcmMessages() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _compositeSubscription.add(
      FirebaseMessaging.onMessage.listen(handleRemoteMessage),
    );
  }

  Future<void> _observeDeepLinks() async {
    if (kIsWeb) return;

    // The app was in the background.
    final deepLinkSubscription = AppLinks().uriLinkStream.listen((uri) {
      if (mounted) _handleDeepLink(uri);
    });

    _compositeSubscription.add(deepLinkSubscription);

    // The app was terminated.
    try {
      final initialUri = await AppLinks().getInitialLink();
      if (initialUri != null) {
        await _handleDeepLink(initialUri);
      }
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

      await _router.push<void>(LobbyRoute($extra: call).location, extra: call);
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
      return;
    }

    // Navigate to the lobby screen.
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
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
      supportedLocales: const [Locale('en'), Locale('nl')],
      localizationsDelegates: [
        CustomVideoLocalizationsNL.delegate,
        ...StreamVideoFlutterLocalizations.localizationsDelegates,
      ],
      builder: (context, child) {
        return child!;
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
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
              ),
            ],
            backgroundColor: colorTheme.barsBg,
            spacing: 4,
            optionIconColor: Colors.white,
            optionBackgroundColor: AppColorPalette.buttonSecondary,
            inactiveOptionBackgroundColor:
                // ignore: deprecated_member_use
                colorTheme.overlay.withOpacity(0.4),
            optionPadding: const EdgeInsets.all(14),
          ),
          userAvatarTheme: StreamUserAvatarThemeData(
            borderRadius: BorderRadius.circular(20),
            initialsTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColorPalette.primary,
            ),
            initialsBackground: AppColorPalette.avatarBackground,
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
              initialsTextStyle: textTheme.title1.copyWith(
                color: AppColorPalette.primary,
              ),
              initialsBackground: AppColorPalette.avatarBackground,
            ),
          ),
          callParticipantTheme: StreamCallParticipantThemeData(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            speakerBorderColor: colorTheme.accentPrimary,
            backgroundColor: AppColorPalette.buttonSecondary,
            userAvatarTheme: StreamUserAvatarThemeData(
              constraints: const BoxConstraints.tightFor(
                height: 100,
                width: 100,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              initialsTextStyle: textTheme.title1.copyWith(
                color: const Color(0xFF005FFF),
              ),
              initialsBackground: AppColorPalette.avatarBackground,
              selectionColor: colorTheme.accentPrimary,
            ),
            audioLevelIndicatorColor: colorTheme.accentPrimary,
            participantLabelTextStyle: textTheme.footnote.copyWith(
              color: Colors.white,
            ),
            disabledMicrophoneColor: Colors.white,
            connectionLevelActiveColor: const Color(0xFF00FF00),
            participantsGridPadding: const EdgeInsets.all(4),
            participantsGridMainAxisSpacing: 4,
            participantsGridCrossAxisSpacing: 4,
          ),
        ),
      ],
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}
