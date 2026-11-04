import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/call_route_page.dart';
import '../screens/home_screen.dart';
import '../screens/livestream_demo_screen.dart';
import '../screens/login_screen.dart';

part 'routes.g.dart';

@immutable
@TypedGoRoute<HomeRoute>(
  path: '/',
  name: 'home',
  routes: [TypedGoRoute<JoinRoute>(path: 'join/:callId', name: 'join')],
)
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
class JoinRoute extends GoRouteData with $JoinRoute {
  const JoinRoute({required this.callId});

  final String callId;

  /// [location] with the shared passphrase of an encrypted call, carried the
  /// way invite links carry it.
  String locationWithKey(String? encryptionKey) {
    if (encryptionKey == null || encryptionKey.isEmpty) return location;

    return Uri(
      path: location,
      queryParameters: {_encryptionKeyParameter: encryptionKey},
    ).toString();
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CallRoutePage(
      callId: callId,
      linkHost: state.uri.host,
      encryptionKey: state.uri.queryParameters[_encryptionKeyParameter],
    );
  }
}

const _encryptionKeyParameter = 'encryption_key';

@immutable
@TypedGoRoute<LivestreamRoute>(
  path: '/livestream/:callId',
  name: 'livestream',
)
class LivestreamRoute extends GoRouteData with $LivestreamRoute {
  const LivestreamRoute({required this.callId});

  final String callId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LivestreamDemoScreen(callId: callId);
  }
}
