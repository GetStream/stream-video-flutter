import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import 'routes.dart';

GoRouter initRouter(UserAuthController authNotifier) {
  return GoRouter(
    routes: [
      ShellRoute(
        routes: [
          $homeRoute,
          $lobbyRoute,
          $callRoute,
          $callParticipantsRoute,
          $callStatsRoute,
          $livestreamRoute,
        ],
        builder: (context, state, child) {
          return StreamChat(
            client: locator.get(),
            streamChatThemeData: StreamChatThemeData.dark(),
            child: child,
          );
        },
      ),
      $loginRoute,
    ],
    refreshListenable: authNotifier,
    redirect: (context, state) {
      // get the current user
      final currentUser = authNotifier.currentUser;

      // if the user is not logged in, they need to login
      final loggedIn = currentUser != null;
      final loggingIn = state.matchedLocation == LoginRoute().location;
      if (!loggedIn && !loggingIn) return LoginRoute().location;
      if (loggedIn && loggingIn) return HomeRoute().location;

      // no need to redirect at all
      return null;
    },
  );
}
