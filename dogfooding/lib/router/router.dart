// 📦 Package imports:
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/router/routes.dart';
import '../app/user_auth_controller.dart';

GoRouter initRouter(UserAuthController authNotifier) {
  return GoRouter(
    routes: $appRoutes,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      // get the current user
      final currentUser = authNotifier.currentUser;

      // if the user is not logged in, they need to login
      final bool loggedIn = currentUser != null;
      final bool loggingIn = state.matchedLocation == LoginRoute().location;
      if (!loggedIn && !loggingIn) return LoginRoute().location;
      if (loggedIn && loggingIn) return HomeRoute().location;

      // no need to redirect at all
      return null;
    },
  );
}
