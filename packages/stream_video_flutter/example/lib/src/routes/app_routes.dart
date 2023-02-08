import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../utils/users_provider.dart';
import '../v2/home_screen_v2.dart';
import '../v2/login_screen_v2.dart';
import 'routes.dart';

mixin AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.LOGIN:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.LOGIN),
          builder: (_) => const LoginScreenV2(),
        );
      case Routes.HOME:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.HOME),
          builder: (_) => const HomeScreenV2(),
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
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
