// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/user_auth_controller.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../di/injector.dart';
import '../utils/assets.dart';
import '../utils/loading_dialog.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  Future<void> _loginWithGoogle() async {
    final googleService = locator<GoogleSignIn>();
    final googleUser = await googleService.signIn();
    if (googleUser == null) return debugPrint('Google login cancelled');

    final userInfo = UserInfo(
      role: 'admin',
      id: googleUser.email,
      name: googleUser.displayName ?? '',
      image: googleUser.photoUrl,
    );

    return _login(User(info: userInfo));
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text;
    if (email.isEmpty) return debugPrint('Email is empty');

    final userInfo = UserInfo(
      role: 'admin',
      id: email,
      name: email,
    );

    return _login(User(info: userInfo));
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

    return _login(User(info: userInfo, type: UserType.guest));
  }

  Future<void> _login(User user) async {
    if (mounted) unawaited(showLoadingIndicator(context));

    // Register StreamVideo client with the user.
    final authController = locator.get<UserAuthController>();
    await authController.login(user);

    if (mounted) hideLoadingIndicator(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'stream_logo',
                  child: Image.asset(
                    streamVideoIconAsset,
                    width: size.width * 0.3,
                  ),
                ),
                const SizedBox(height: 36),
                Text('Stream Meetings', style: theme.textTheme.bodyLarge),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Text(
                    'Please sign in with your Google Stream account.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Enter Email',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loginWithEmail,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                      Color(0xff005FFF),
                    ),
                  ),
                  child: const Text('Login with Email'),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('OR'),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GoogleLoginButton(
                    onPressed: _loginWithGoogle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: _loginAsGuest,
                    child: const Text(
                      'Continue As Guest',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
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
    this.label = 'Login with Google',
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // Google SignIn plugin is only supported on Web, Android and iOS.
    final isGoogleSignInSupported =
        defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android ||
            kIsWeb;

    final currentPlatform = Theme.of(context).platform.name;

    if (!isGoogleSignInSupported) {
      return Text('Google SignIn is not supported on $currentPlatform.');
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        fixedSize: const Size.fromHeight(56),
        backgroundColor: const Color(0xff005FFF),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            SvgPicture.asset(
              googleLogoAsset,
              semanticsLabel: 'Google Logo',
            ),
            const SizedBox(width: 24),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ],
        ),
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
  var id = '';
  for (var i = 0; i < size; i++) {
    id += _alphabet[(math.Random().nextDouble() * 64).floor() | 0];
  }
  return id;
}
