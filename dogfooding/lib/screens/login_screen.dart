import 'dart:async';
import 'dart:math' as math;

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
  final _emailController = TextEditingController();

  Future<void> _loginWithGoogle() async {
    final googleService = locator<GoogleSignIn>();

    GoogleSignInAccount? googleUser;
    try {
      googleUser = await googleService.attemptLightweightAuthentication();
    } catch (e) {
      debugPrint('Google lightweight auth failed: $e');
    }

    if (googleUser == null && googleService.supportsAuthenticate()) {
      try {
        googleUser = await googleService.authenticate();
      } catch (e) {
        return debugPrint('Google sign-in failed: $e');
      }
    }

    if (googleUser == null) {
      return debugPrint('Google login cancelled or unavailable');
    }

    final userInfo = UserInfo(
      role: 'admin',
      id: createValidId(googleUser.email),
      name: googleUser.displayName ?? '',
      image: googleUser.photoUrl,
    );

    return _login(User(info: userInfo), _appPreferences.environment);
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text;
    if (email.isEmpty) return debugPrint('Email is empty');

    final userInfo = UserInfo(
      role: 'admin',
      id: createValidId(email),
      name: email,
    );

    return _login(User(info: userInfo), _appPreferences.environment);
  }

  Future<void> _loginAsGuest() async {
    final userId = randomId(size: 6);
    final userInfo = UserInfo(
      role: 'admin',
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
    if (mounted) unawaited(showLoadingIndicator(context));

    // Register StreamVideo client with the user.
    final authController = locator.get<UserAuthController>();

    try {
      await authController.login(user, environment);
    } catch (e, _) {
      if (mounted) {
        hideLoadingIndicator(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 20),
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                      controller: _emailController,
                      style: theme.textTheme.bodyMedium?.apply(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Enter Email',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamButton.active(
                      label: 'Sign up with email',
                      icon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                      onPressed: _loginWithEmail,
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GoogleLoginButton(onPressed: _loginWithGoogle),
                  ),
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
