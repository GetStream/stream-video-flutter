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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    if (_userAuthController.currentUser != null) {
      initPushNotificationManagerIfAvailable();
    }

    _userAuthController.addListener(() {
      if (_userAuthController.currentUser != null) {
        // Ensure we only initialize and observe events once
        if (!_isInitialized) {
          _compositeSubscription.clear();
          initPushNotificationManagerIfAvailable();
        }
      } else {
        _compositeSubscription.clear();
        _isInitialized = false;
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

    _handleMobileAudioInterruptions();

    _isInitialized = true;
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
        if (!locator.isRegistered<StreamVideo>()) return;

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
    await authController.login(user.toUser(), environment);

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
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
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
    final coreTheme = switch (brightness) {
      .light => StreamTheme.light(),
      .dark => StreamTheme.dark(),
    };
    final videoTheme = switch (brightness) {
      .light => StreamVideoTheme.light(),
      .dark => StreamVideoTheme.dark(),
    };

    final textTheme = videoTheme.textTheme;
    final colorScheme = coreTheme.colorScheme;

    return baseTheme.copyWith(
      scaffoldBackgroundColor: colorScheme.backgroundApp,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: colorScheme.brand,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colorScheme.textPrimary),
      ),
      bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
        backgroundColor: colorScheme.backgroundElevation0,
        dragHandleColor: colorScheme.textPrimary,
      ),
      extensions: <ThemeExtension<dynamic>>[
        coreTheme,
        videoTheme.copyWith(
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
            backgroundColor: colorScheme.backgroundElevation0,
            spacing: 4,
            optionIconColor: colorScheme.textPrimary,
            optionBackgroundColor: colorScheme.backgroundSurface,
            inactiveOptionBackgroundColor: colorScheme.backgroundOverlayDark,
            optionPadding: const EdgeInsets.all(14),
          ),
          userAvatarTheme: StreamUserAvatarThemeData(
            borderRadius: BorderRadius.circular(20),
            initialsTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.brand,
            ),
            initialsBackground: colorScheme.brand.shade100,
          ),
          lobbyViewTheme: StreamLobbyViewThemeData(
            backgroundColor: colorScheme.backgroundApp,
            cardBackgroundColor: colorScheme.backgroundSurface,
            userAvatarTheme: StreamUserAvatarThemeData(
              constraints: const BoxConstraints.tightFor(
                height: 100,
                width: 100,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              initialsTextStyle: textTheme.title1.copyWith(
                color: colorScheme.brand,
              ),
              initialsBackground: colorScheme.brand.shade100,
            ),
          ),
          callParticipantTheme: StreamCallParticipantThemeData(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            speakerBorderColor: colorScheme.accentPrimary,
            backgroundColor: colorScheme.backgroundSurface,
            userAvatarTheme: StreamUserAvatarThemeData(
              constraints: const BoxConstraints.tightFor(
                height: 100,
                width: 100,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              initialsTextStyle: textTheme.title1.copyWith(
                color: colorScheme.brand,
              ),
              initialsBackground: colorScheme.brand.shade100,
              selectionColor: colorScheme.accentPrimary,
            ),
            audioLevelIndicatorColor: colorScheme.accentPrimary,
            participantLabelTextStyle: textTheme.footnote.copyWith(
              color: colorScheme.textOnAccent,
            ),
            disabledMicrophoneColor: colorScheme.textOnAccent,
            connectionLevelActiveColor: const Color(0xFF00FF00),
            participantsGridPadding: const EdgeInsets.all(4),
            participantsGridMainAxisSpacing: 4,
            participantsGridCrossAxisSpacing: 4,
          ),
        ),
      ],
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: colorScheme.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: colorScheme.textPrimary,
        ),
      ),
    );
  }
}
