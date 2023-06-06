import 'package:audio_rooms/repositories/audio_repository.dart';
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

class AudioProvider extends InheritedWidget {
  const AudioProvider({
    Key? key,
    required this.audioRepo,
    required Widget child,
  }) : super(key: key, child: child);

  final AudioRepository audioRepo;

  static AudioRepository of(BuildContext context) {
    final AudioRepository? result =
        context.dependOnInheritedWidgetOfExactType<AudioProvider>()?.audioRepo;
    assert(result != null, 'No AudioProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AudioProvider oldWidget) =>
      oldWidget.audioRepo != audioRepo || oldWidget.child != child;
}

extension ProviderExtensions on BuildContext {
  AuthRepo get auth => AuthProvider.of(this);

  AudioRepository get audio => AudioProvider.of(this);
}
