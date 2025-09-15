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

RouteBase get $homeRoute =>
    GoRouteData.$route(path: '/', name: 'home', factory: $HomeRoute._fromState);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  name: 'login',
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $lobbyRoute => GoRouteData.$route(
  path: '/lobby',
  name: 'lobby',
  factory: $LobbyRoute._fromState,
);

mixin $LobbyRoute on GoRouteData {
  static LobbyRoute _fromState(GoRouterState state) =>
      LobbyRoute($extra: state.extra as Call);

  LobbyRoute get _self => this as LobbyRoute;

  @override
  String get location => GoRouteData.$location('/lobby');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $livestreamRoute => GoRouteData.$route(
  path: '/livestream',
  name: 'livestream',
  factory: $LivestreamRoute._fromState,
);

mixin $LivestreamRoute on GoRouteData {
  static LivestreamRoute _fromState(GoRouterState state) =>
      LivestreamRoute($extra: state.extra as String);

  LivestreamRoute get _self => this as LivestreamRoute;

  @override
  String get location => GoRouteData.$location('/livestream');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $callRoute => GoRouteData.$route(
  path: '/call',
  name: 'call',
  factory: $CallRoute._fromState,
);

mixin $CallRoute on GoRouteData {
  static CallRoute _fromState(GoRouterState state) => CallRoute(
    $extra:
        state.extra
            as ({
              Call call,
              CallConnectOptions? connectOptions,
              StreamVideoEffectsManager? effectsManager,
            }),
  );

  CallRoute get _self => this as CallRoute;

  @override
  String get location => GoRouteData.$location('/call');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $callParticipantsRoute => GoRouteData.$route(
  path: '/call/participants',
  name: 'participants',
  factory: $CallParticipantsRoute._fromState,
);

mixin $CallParticipantsRoute on GoRouteData {
  static CallParticipantsRoute _fromState(GoRouterState state) =>
      CallParticipantsRoute($extra: state.extra as Call);

  CallParticipantsRoute get _self => this as CallParticipantsRoute;

  @override
  String get location => GoRouteData.$location('/call/participants');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $callStatsRoute => GoRouteData.$route(
  path: '/call/stats',
  name: 'stats',
  factory: $CallStatsRoute._fromState,
);

mixin $CallStatsRoute on GoRouteData {
  static CallStatsRoute _fromState(GoRouterState state) =>
      CallStatsRoute($extra: state.extra as Call);

  CallStatsRoute get _self => this as CallStatsRoute;

  @override
  String get location => GoRouteData.$location('/call/stats');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}
