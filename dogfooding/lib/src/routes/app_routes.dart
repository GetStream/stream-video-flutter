import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../screens/call_screen.dart';
import '../screens/home_screen.dart';
import '../screens/lobby_screen.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import '../utils/users_provider.dart';
import 'routes.dart';

mixin AppRoutes {
  /// Add entry for new route here
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.splash),
          builder: (_) => const SplashScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.login),
          builder: (_) => const LoginScreen(),
        );
      case Routes.home:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.home),
          builder: (_) => const HomeScreen(),
        );
      case Routes.call:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.call),
          builder: (context) {
            final call = settings.arguments! as Call;
            return CallScreen(call: call);
          },
        );
      case Routes.lobby:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.lobby),
          builder: (context) {
            final args = settings.arguments! as List;
            return StreamUsersConfiguration(
              usersProvider: MockUsersProvider(),
              child: LobbyScreen(
                call: args[0],
                onJoinCallPressed: args[1],
              ),
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
