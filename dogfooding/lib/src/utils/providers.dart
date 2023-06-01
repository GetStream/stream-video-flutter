import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../repos/app_repository.dart';
import '../../repos/auth_repo.dart';

class MockUsersProvider extends StreamUsersProvider {
  @override
  Future<List<UserInfo>> providerUsers() async {
    return List<UserInfo>.generate(
      20,
      (index) => UserInfo(
        id: 'user$index',
        role: 'admin',
        name: 'John $index',
      ),
    );
  }
}

class AuthenticationProvider extends InheritedWidget {
  const AuthenticationProvider({
    super.key,
    required this.auth,
    required super.child,
  });

  final AuthRepository auth;

  static AuthRepository of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<AuthenticationProvider>();
    assert(result != null, 'No AuthenticationProvider found in context');
    return result!.auth;
  }

  @override
  bool updateShouldNotify(AuthenticationProvider oldWidget) =>
      auth != oldWidget.auth || child != oldWidget.child;
}

class AppProvider extends InheritedWidget {
  const AppProvider({
    super.key,
    required this.appRepo,
    required super.child,
  });

  final AppRepository appRepo;

  static AppRepository of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'No AuthenticationProvider found in context');
    return result!.appRepo;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) =>
      appRepo != oldWidget.appRepo || child != oldWidget.child;
}

extension ProviderExtensions on BuildContext {
  AppRepository get appRepo => AppProvider.of(this);

  AuthRepository get authRepo => AuthenticationProvider.of(this);
}
