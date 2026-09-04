import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import 'routes.dart';

/// Where a link wanted to go while nobody was logged in.
///
/// A link can arrive before there is a user — the app is opened by it from a
/// terminated state — and the login screen would otherwise drop it. It is
/// consumed the moment login completes.
Uri? _pendingLink;

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

      if (!loggedIn) {
        // Hold on to the link so it survives the trip through login.
        if (state.matchedLocation.startsWith(_joinPrefix)) {
          _pendingLink = state.uri;
        }
        return loggingIn ? null : LoginRoute().location;
      }

      if (loggingIn) {
        // Just logged in: honour a link that was waiting, otherwise go home.
        final pending = _pendingLink;
        _pendingLink = null;
        return pending?.toString() ?? HomeRoute().location;
      }

      // no need to redirect at all
      return null;
    },
    onException: (context, state, router) {
      final callId = _callIdFromLink(state.uri);
      if (callId == null) return router.go(HomeRoute().location);

      // Keep the original scheme and host: the host selects the environment.
      router.go(state.uri.replace(path: '$_joinPrefix/$callId').toString());
    },
  );
}

const _joinPrefix = '/join';

/// Pulls the call id out of a join link, or returns null when the link does not
/// carry one. Accepts a `join` segment anywhere in the path so the web app's
/// nested paths keep working, and falls back to an `id` query parameter.
String? _callIdFromLink(Uri uri) {
  final segments = uri.pathSegments;
  for (final (index, segment) in segments.indexed) {
    if (segment != 'join') continue;
    final next = index + 1;
    if (next < segments.length && segments[next].isNotEmpty) {
      return segments[next];
    }
  }

  final id = uri.queryParameters['id'];
  return (id != null && id.isNotEmpty) ? id : null;
}
