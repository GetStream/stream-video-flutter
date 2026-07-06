import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../core/model/environment.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../theme/app_palette.dart';
import '../utils/assets.dart';
import '../utils/consts.dart';
import '../utils/loading_dialog.dart';
import '../widgets/environment_switcher.dart';
import '../widgets/stream_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _appPreferences = locator<AppPreferences>();
  final _usernameController = TextEditingController();

  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleAuthSubscription;
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initGoogleSignIn());
  }

  /// Subscribes to Google auth events so the result of the mobile/macOS
  /// `authenticate()` call is handled. Web uses Firebase Auth's popup flow
  /// instead (see [_loginWithGoogleWeb]), so there is no google_sign_in plugin
  /// to subscribe to there.
  Future<void> _initGoogleSignIn() async {
    if (kIsWeb) return;

    final googleService = await locator.getAsync<GoogleSignIn>();
    _googleAuthSubscription = googleService.authenticationEvents.listen(
      _handleGoogleAuthEvent,
      onError: (Object e) {
        debugPrint('Google auth event error: $e');
        _showSnackBar('Google sign-in failed: $e');
      },
    );
  }

  void _handleGoogleAuthEvent(GoogleSignInAuthenticationEvent event) {
    if (event is! GoogleSignInAuthenticationEventSignIn) return;

    final googleUser = event.user;
    unawaited(
      _completeGoogleLogin(
        email: googleUser.email,
        name: googleUser.displayName ?? '',
        image: googleUser.photoUrl,
      ),
    );
  }

  /// Triggers an interactive Google sign-in from the button tap.
  Future<void> _loginWithGoogle() async {
    try {
      if (kIsWeb) {
        await _loginWithGoogleWeb();
        return;
      }

      final googleService = await locator.getAsync<GoogleSignIn>();
      if (googleService.supportsAuthenticate()) {
        // Result delivered via authenticationEvents -> _handleGoogleAuthEvent.
        await googleService.authenticate();
      }
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
      _showSnackBar('Google sign-in failed: $e');
    }
  }

  /// Web Google sign-in via Firebase Auth's popup flow.
  Future<void> _loginWithGoogleWeb() async {
    try {
      final provider = fb.GoogleAuthProvider()
        // Hints Google to restrict the account chooser to the Stream domain.
        ..setCustomParameters(const {'hd': 'getstream.io'});

      final credential =
          await fb.FirebaseAuth.instance.signInWithPopup(provider);
      final user = credential.user;
      if (user == null) {
        debugPrint('Google sign-in returned no user');
        _showSnackBar('Google sign-in failed: no user returned.');
        return;
      }

      await _completeGoogleLogin(
        email: user.email,
        name: user.displayName ?? '',
        image: user.photoURL,
      );
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
      _showSnackBar('Google sign-in failed: $e');
    }
  }

  Future<void> _completeGoogleLogin({
    required String? email,
    required String name,
    String? image,
  }) async {
    if (email == null || email.isEmpty) {
      debugPrint('Google sign-in returned no email');
      _showSnackBar('Google sign-in failed: no email address returned.');
      return;
    }

    final userInfo = UserInfo(
      id: createValidId(email),
      name: name,
      image: image,
    );

    await _login(User(info: userInfo), _appPreferences.environment);
  }

  Future<void> _loginWithUsername() async {
    final username = _usernameController.text;
    if (username.isEmpty) return debugPrint('Username is empty');

    final userInfo = UserInfo(
      id: createValidId(username),
      name: username,
    );

    return _login(User(info: userInfo), _appPreferences.environment);
  }

  Future<void> _loginAsGuest() async {
    final userId = randomId(size: 6);
    final userInfo = UserInfo(
      id: userId,
      name: userId,
      image:
          'https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg',
    );

    return _login(
      User(info: userInfo, type: UserType.guest),
      _appPreferences.environment,
    );
  }

  Future<void> _login(User user, Environment environment) async {
    if (_isLoggingIn) return;
    _isLoggingIn = true;

    if (mounted) unawaited(showLoadingIndicator(context));

    // Register StreamVideo client with the user.
    final authController = locator.get<UserAuthController>();

    try {
      await authController.login(user, environment);
    } catch (e, _) {
      if (mounted) hideLoadingIndicator(context);
      _showSnackBar('Error: $e');
    } finally {
      _isLoggingIn = false;
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 20),
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_googleAuthSubscription?.cancel());
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = math.min(size.width, kMaxWidthRegularScreen);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorPalette.backgroundColor,
        actions: [
          if (!kIsProd)
            EnvironmentSwitcher(
              currentEnvironment: _appPreferences.environment,
              // Rebuild so the Google button visibility tracks the environment.
              onEnvironmentChanged: (_) => setState(() {}),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxWidthRegularScreen),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'stream_logo',
                    child: Image.asset(
                      streamVideoIconAsset,
                      width: width * 0.8,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text('Stream', style: theme.textTheme.headlineMedium),
                  Text(
                    '[Video Calling]',
                    style: theme.textTheme.headlineMedium?.apply(
                      color: AppColorPalette.appGreen,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _usernameController,
                      style: theme.textTheme.bodyMedium?.apply(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Enter Username',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamButton.active(
                      label: 'Sign up with username',
                      icon: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                      onPressed: _loginWithUsername,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.grey),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('OR'),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  // Google (Stream employee) sign-in is only available on
                  // Pronto environments.
                  if (_appPreferences.environment.isPronto) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GoogleLoginButton(onPressed: _loginWithGoogle),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamButton.tertiary(
                      onPressed: _loginAsGuest,
                      label: 'Join As Guest',
                    ),
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      final platformInfo = snapshot.data;

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Version ${platformInfo?.version}+${platformInfo?.buildNumber}',
                          style: theme.textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({
    super.key,
    required this.onPressed,
    this.label = 'Login with Google',
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Google SignIn plugin is supported on Web, Android, iOS and macOS.
    final isGoogleSignInSupported =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb;

    final currentPlatform = Theme.of(context).platform.name;

    if (!isGoogleSignInSupported) {
      return Text('Google SignIn is not supported on $currentPlatform.');
    }

    return StreamButton.primary(
      onPressed: onPressed,
      label: 'Continue with Google',
      icon: SvgPicture.asset(
        googleLogoAsset,
        width: 24,
        semanticsLabel: 'Google Logo',
      ),
    );
  }
}

// This alphabet uses `A-Za-z0-9_-` symbols. The genetic algorithm helped
// optimize the gzip compression for this alphabet.
const _alphabet =
    'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';

/// Generates a random String id
/// Adopted from: https://github.com/ai/nanoid/blob/main/non-secure/index.js
String randomId({int size = 21}) {
  final buffer = StringBuffer();
  final random = math.Random();

  for (var i = 0; i < size; i++) {
    final index = (random.nextDouble() * _alphabet.length).floor();
    buffer.write(_alphabet[index]);
  }

  return buffer.toString();
}

String createValidId(String id) {
  return id.replaceAll(RegExp(r'[^\w]'), '_');
}
