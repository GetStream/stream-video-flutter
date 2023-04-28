import 'package:audio_rooms/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

export './auth_repository.dart';

class AuthProvider extends InheritedWidget {
  const AuthProvider({
    Key? key,
    required this.auth,
    required Widget child,
  }) : super(key: key, child: child);

  final AuthRepo auth;

  static AuthRepo of(BuildContext context) {
    final AuthRepo? result =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>()?.auth;
    assert(result != null, 'No AuthProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AuthProvider oldWidget) =>
      oldWidget.auth != auth || oldWidget.child != child;
}

extension ProviderExtensions on BuildContext {
  AuthRepo get auth => AuthProvider.of(this);
}
