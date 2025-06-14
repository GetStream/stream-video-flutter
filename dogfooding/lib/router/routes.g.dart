// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $loginRoute,
      $lobbyRoute,
      $livestreamRoute,
      $callRoute,
      $callParticipantsRoute,
      $callStatsRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      name: 'home',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      name: 'login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $lobbyRoute => GoRouteData.$route(
      path: '/lobby',
      name: 'lobby',
      factory: $LobbyRouteExtension._fromState,
    );

extension $LobbyRouteExtension on LobbyRoute {
  static LobbyRoute _fromState(GoRouterState state) => LobbyRoute(
        $extra: state.extra as Call,
      );

  String get location => GoRouteData.$location(
        '/lobby',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $livestreamRoute => GoRouteData.$route(
      path: '/livestream',
      name: 'livestream',
      factory: $LivestreamRouteExtension._fromState,
    );

extension $LivestreamRouteExtension on LivestreamRoute {
  static LivestreamRoute _fromState(GoRouterState state) => LivestreamRoute(
        $extra: state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/livestream',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $callRoute => GoRouteData.$route(
      path: '/call',
      name: 'call',
      factory: $CallRouteExtension._fromState,
    );

extension $CallRouteExtension on CallRoute {
  static CallRoute _fromState(GoRouterState state) => CallRoute(
        $extra:
            state.extra as ({Call call, CallConnectOptions? connectOptions}),
      );

  String get location => GoRouteData.$location(
        '/call',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $callParticipantsRoute => GoRouteData.$route(
      path: '/call/participants',
      name: 'participants',
      factory: $CallParticipantsRouteExtension._fromState,
    );

extension $CallParticipantsRouteExtension on CallParticipantsRoute {
  static CallParticipantsRoute _fromState(GoRouterState state) =>
      CallParticipantsRoute(
        $extra: state.extra as Call,
      );

  String get location => GoRouteData.$location(
        '/call/participants',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $callStatsRoute => GoRouteData.$route(
      path: '/call/stats',
      name: 'stats',
      factory: $CallStatsRouteExtension._fromState,
    );

extension $CallStatsRouteExtension on CallStatsRoute {
  static CallStatsRoute _fromState(GoRouterState state) => CallStatsRoute(
        $extra: state.extra as Call,
      );

  String get location => GoRouteData.$location(
        '/call/stats',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
