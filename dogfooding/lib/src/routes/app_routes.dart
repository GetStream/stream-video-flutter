import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../home_screen.dart';
import '../join_screen.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import '../utils/users_provider.dart';
import 'routes.dart';

mixin AppRoutes {
  /// Add entry for new route here
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SPLASH:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.SPLASH),
          builder: (_) => const SplashScreen(),
        );
      case Routes.LOGIN:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.LOGIN),
          builder: (_) => const LoginScreen(),
        );
      case Routes.HOME:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.HOME),
          builder: (_) => const HomeScreen(),
        );
      case Routes.CALL:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.CALL),
          builder: (context) {
            final call = settings.arguments as Call;

            void navigateHome() {
              Navigator.of(context).pushReplacementNamed(Routes.HOME);
            }

            return StreamUsersConfiguration(
              usersProvider: MockUsersProvider(),
              child: StreamCallScreen(
                call: call,
                onBackPressed: navigateHome,
                onHangUp: navigateHome,
              ),
            );
          },
        );
      case Routes.JOIN:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.JOIN),
          builder: (context) {
            final callId = settings.arguments as String;

            return JoinScreen(
              callId: callId,
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
