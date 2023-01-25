import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'call_screen_v2.dart';
import 'home_screen_v2.dart';
import 'login_screen_v2.dart';
import 'splash_screen_v2.dart';

mixin RoutesV2 {
  /// Add entry for new route here
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreenV2.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SplashScreenV2.routeName),
          builder: (_) => const SplashScreenV2(),
        );
      case LoginScreenV2.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreenV2.routeName),
          builder: (_) => const LoginScreenV2(),
        );
      case HomeScreenV2.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: HomeScreenV2.routeName),
          builder: (_) => const HomeScreenV2(),
        );
      case CallScreenV2.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: CallScreenV2.routeName),
          builder: (context) {
            final callCid = settings.arguments as StreamCallCid;

            navigateHome() {
              Navigator.of(context)
                  .pushReplacementNamed(HomeScreenV2.routeName);
            }

            return CallScreenV2(
              call: CallV2.fromCid(callCid: callCid),
              onBackPressed: navigateHome,
              onHangUp: navigateHome,
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
