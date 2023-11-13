// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/di/injector.dart';
import 'package:flutter_dogfooding/screens/splash_screen.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart'
    hide ConnectionState;
import '../core/repos/app_preferences.dart';
import '../firebase_options.dart';
import 'app_content.dart';
import 'user_auth_controller.dart';

class StreamDogFoodingApp extends StatefulWidget {
  const StreamDogFoodingApp({super.key});

  @override
  State<StreamDogFoodingApp> createState() => _StreamDogFoodingAppState();
}

class _StreamDogFoodingAppState extends State<StreamDogFoodingApp> {
  Future<void>? _appLoader;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appLoader ??= Future.wait([
      _loadApp(context),
      // Shows the splash screen for at least 3 seconds.
      Future.delayed(const Duration(seconds: 3)),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    AppInjector.reset();
    _appLoader = null;
  }

  Future<void> _loadApp(BuildContext context) async {
    // Initialise Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure crash handlers
    FlutterError.onError = (errorDetails) {
      if (kDebugMode) {
        // In development mode, simply print to console.
        FlutterError.dumpErrorToConsole(errorDetails);
      } else {
        // In production mode, report all uncaught errors to Crashlytics.
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      }
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter
    // framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Initialise injector
    await AppInjector.init();

    // Check if there are saved credentials. If there are, login with them.
    await _handleSavedLogin();
  }

  Future<void> _handleSavedLogin() async {
    final prefs = locator.get<AppPreferences>();
    final credentials = prefs.userCredentials;
    if (credentials == null) return;

    final authController = locator.get<UserAuthController>();
    await authController.login(User(info: credentials.userInfo));
  }

  @override
  Widget build(BuildContext context) {
    // Wait for app to load before showing anything.
    return FutureBuilder(
      future: _appLoader,
      builder: (context, snapshot) {
        // This means that the app is now ready to use.
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            debugPrint(snapshot.stackTrace.toString());

            return const Directionality(
              textDirection: TextDirection.ltr,
              child: Center(child: Text('Error loading app')),
            );
          }

          return const StreamDogFoodingAppContent();
        }

        // Otherwise, show splash screen whilst waiting for loading
        // to complete.
        return const Directionality(
          textDirection: TextDirection.ltr,
          child: SplashScreen(),
        );
      },
    );
  }
}
