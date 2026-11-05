// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute, $loginRoute, $livestreamRoute];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  name: 'home',
  factory: $HomeRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'join/:callId',
      name: 'join',
      factory: $JoinRoute._fromState,
    ),
  ],
);

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

mixin $JoinRoute on GoRouteData {
  static JoinRoute _fromState(GoRouterState state) =>
      JoinRoute(callId: state.pathParameters['callId']!);

  JoinRoute get _self => this as JoinRoute;

  @override
  String get location =>
      GoRouteData.$location('/join/${Uri.encodeComponent(_self.callId)}');

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

RouteBase get $livestreamRoute => GoRouteData.$route(
  path: '/livestream/:callId',
  name: 'livestream',
  factory: $LivestreamRoute._fromState,
);

mixin $LivestreamRoute on GoRouteData {
  static LivestreamRoute _fromState(GoRouterState state) =>
      LivestreamRoute(callId: state.pathParameters['callId']!);

  LivestreamRoute get _self => this as LivestreamRoute;

  @override
  String get location =>
      GoRouteData.$location('/livestream/${Uri.encodeComponent(_self.callId)}');

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
