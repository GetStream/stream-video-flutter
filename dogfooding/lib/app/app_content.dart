import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent show FluentLocalizations;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shad/shad.dart' show GlobalShadLocalizations;
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide CurrentPlatform;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

import '../di/injector.dart';
import '../l10n/localizations/app_localizations.dart';
import '../router/router.dart';
import '../router/routes.dart';
import '../screens/call_route_page.dart';
import '../utils/consts.dart';
import '../widgets/dogfooding_participant_tile.dart';
import 'app_design.dart';
import 'app_display_settings.dart';
import 'app_theme.dart';
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
  late final _appSettings = locator.get<AppDisplaySettings>();

  late final _router = initRouter(_userAuthController);

  // Keeps the screens' state when a design adds or removes a wrapper above
  // them, as switching to or from a design library with its own scope does.
  final _contentKey = GlobalKey(debugLabel: 'app content');

  /// The component builders that customise the Stream Video UI components,
  /// for the design they were built for.
  ///
  /// Built once per design so their identity stays stable across rebuilds: a
  /// newly created [StreamComponentBuilders] is never equal to the previous
  /// one, so building them inline would rebuild every widget depending on the
  /// [StreamComponentFactory] every time the surrounding widget rebuilds.
  ({AppDesign design, StreamComponentBuilders builders})? _componentBuilders;

  StreamComponentBuilders _componentBuildersFor(AppDesign design) {
    final cached = _componentBuilders;
    if (cached != null && cached.design == design) return cached.builders;
    final builders = design.spec.builders([
      ...streamVideoComponentBuilders(
        participantTile: (context, props) =>
            DogfoodingParticipantTile(props: props),
      ),
      // You can combine both chat and video component builders.
      ...streamChatComponentBuilders(),
    ]);
    _componentBuilders = (design: design, builders: builders);
    return builders;
  }

  final _compositeSubscription = CompositeSubscription();
  bool? _microphoneEnabledBeforeInterruption;
  bool _isInitialized = false;
  String? _routedCallCid;

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

  /// Opens the call screen for [call], at most once per call.
  void _showCallScreen(Call call) {
    if (_routedCallCid == call.callCid.value) return;

    // The call may already be over. A ringing call the caller cancels while
    // this app is in the background never gets a screen, and routing to one
    // now would only build a screen that tears itself straight back down.
    if (call.state.value.status.isDisconnected) return;

    _routedCallCid = call.callCid.value;

    CallRoutePage.handOff(call);
    final location = JoinRoute(callId: call.id).locationFor(
      callType: call.type,
    );
    _router.push<void>(location).whenComplete(() {
      if (_routedCallCid == call.callCid.value) _routedCallCid = null;
    });
  }

  void _tryConsumingIncomingCallFromTerminatedState() {
    if (!CurrentPlatform.isAndroid) return;

    if (_router.routerDelegate.navigatorKey.currentContext == null) {
      // App is not running yet. Postpone consuming after app is in the foreground
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!locator.isRegistered<StreamVideo>()) return;

        final streamVideo = locator.get<StreamVideo>();
        streamVideo.ringing.consumeAndAcceptActiveCall(
          onCallAccepted: _showCallScreen,
        );
      });
    } else {
      // no-op. If the app is already running we'll handle it via events
    }
  }

  void _observeRingingEvents() {
    final streamVideo = locator.get<StreamVideo>();

    if (CurrentPlatform.isMobile) {
      // Answered on the platform call UI (CallKit, or the Android notification).
      _compositeSubscription.add(
        streamVideo.ringing.observeCoreRingingEvents(
          onCallAccepted: _showCallScreen,
        ),
      );
    }

    // The in-app incoming call UI.
    _compositeSubscription.add(
      streamVideo.state.incomingCall.listen((call) {
        if (call == null) return;

        // Only while the app is on screen. In the background the platform
        // notification is the incoming call UI, and routing here would queue
        // a screen that is not built until the app resumes - by which time
        // the call can be long over. Answering from the notification brings
        // the screen up through `onCallAccepted` instead.
        if (WidgetsBinding.instance.lifecycleState !=
            AppLifecycleState.resumed) {
          return;
        }

        _showCallScreen(call);
      }),
    );
  }

  void _observeFcmMessages() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _compositeSubscription.add(
      FirebaseMessaging.onMessage.listen(
        (message) => unawaited(
          StreamVideo.instance.ringing.handleRingingFlowNotifications(
            message.data,
          ),
        ),
      ),
    );
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
    return ListenableBuilder(
      listenable: _appSettings,
      builder: (context, _) => MaterialApp.router(
        title: kAppName,
        routerConfig: _router,
        theme: buildAppTheme(
          design: _appSettings.design,
          brightness: Brightness.light,
          accent: _appSettings.accentColor,
        ),
        darkTheme: buildAppTheme(
          design: _appSettings.design,
          brightness: Brightness.dark,
          accent: _appSettings.accentColor,
        ),
        themeMode: _appSettings.themeMode,
        locale: _appSettings.locale,
        // Every language the SDK is translated into.
        supportedLocales: appSupportedLocales,
        localizationsDelegates: [
          CustomVideoLocalizationsEN.delegate,
          CustomVideoLocalizationsNL.delegate,
          AppLocalizations.delegate,
          GlobalShadLocalizations.delegate,
          fluent.FluentLocalizations.delegate,
          ...StreamVideoFlutterLocalizations.localizationsDelegates,
        ],
        builder: (context, child) {
          final design = _appSettings.design;
          return design.spec.wrap(
            context,
            _appSettings.accentColor,
            StreamComponentFactory(
              key: _contentKey,
              builders: _componentBuildersFor(design),
              // Above the router, so a snackbar shown from any route has a
              // messenger to reach and outlives the screen that showed it.
              child: StreamSnackbarScope(child: child!),
            ),
          );
        },
      ),
    );
  }
}
