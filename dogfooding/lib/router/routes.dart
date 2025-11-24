import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../screens/call_participants_list.dart';
import '../screens/call_screen.dart';
import '../screens/call_stats_screen.dart';
import '../screens/home_screen.dart';
import '../screens/livestream_demo_screen.dart';
import '../screens/lobby_screen.dart';
import '../screens/login_screen.dart';

part 'routes.g.dart';

@immutable
@TypedGoRoute<HomeRoute>(path: '/', name: 'home')
class HomeRoute extends GoRouteData with $HomeRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@immutable
@TypedGoRoute<LoginRoute>(path: '/login', name: 'login')
class LoginRoute extends GoRouteData with $LoginRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

@immutable
@TypedGoRoute<LobbyRoute>(path: '/lobby', name: 'lobby')
class LobbyRoute extends GoRouteData with $LobbyRoute {
  const LobbyRoute({required this.$extra});

  final Call $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LobbyScreen(
      call: $extra,
      onJoinCallPressed: (connectOptions, effectsManager) {
        // Navigate to the call screen.
        CallRoute(
          $extra: (
            call: $extra,
            connectOptions: connectOptions,
            effectsManager: effectsManager,
          ),
        ).replace(context);
      },
    );
  }
}

@immutable
@TypedGoRoute<LivestreamRoute>(path: '/livestream', name: 'livestream')
class LivestreamRoute extends GoRouteData with $LivestreamRoute {
  const LivestreamRoute({required this.$extra});

  final String $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LivestreamDemoScreen(callId: $extra);
  }
}

@immutable
@TypedGoRoute<CallRoute>(path: '/call', name: 'call')
class CallRoute extends GoRouteData with $CallRoute {
  const CallRoute({required this.$extra});

  final ({
    Call call,
    CallConnectOptions? connectOptions,
    StreamVideoEffectsManager? effectsManager,
  })
  $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CallScreen(
      call: $extra.call,
      connectOptions: $extra.connectOptions,
      videoEffectsManager: $extra.effectsManager,
    );
  }
}

@immutable
@TypedGoRoute<CallParticipantsRoute>(
  path: '/call/participants',
  name: 'participants',
)
class CallParticipantsRoute extends GoRouteData with $CallParticipantsRoute {
  const CallParticipantsRoute({required this.$extra});

  final Call $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CallParticipantsList(call: $extra);
  }
}

@immutable
@TypedGoRoute<CallStatsRoute>(path: '/call/stats', name: 'stats')
class CallStatsRoute extends GoRouteData with $CallStatsRoute {
  const CallStatsRoute({required this.$extra});

  final Call $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CallStatsScreen(call: $extra);
  }
}
