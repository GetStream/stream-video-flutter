import 'package:example/src/home_screen.dart';
import 'package:example/src/login_screen.dart';
import 'package:example/src/participants_info_screen.dart';
import 'package:example/src/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/call/call_screen.dart';

mixin Routes {
  /// Add entry for new route here
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SplashScreen.routeName),
          builder: (_) => const SplashScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.routeName),
          builder: (_) => const LoginScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: HomeScreen.routeName),
          builder: (_) => const HomeScreen(),
        );
      case CallScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: CallScreen.routeName),
          builder: (context) {
            final call = settings.arguments as Call;

            navigateHome() {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            }

            return CallScreen(
              call: call,
              onBackPressed: navigateHome,
              onHangUp: navigateHome,
              participantsInfoWidgetBuilder: (context, call) =>
                  StreamCallParticipantsInfoScreen(call: call),
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
