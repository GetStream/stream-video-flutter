import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_video/stream_video.dart';

import '../../env/env.dart';
import '../../user_repository.dart';
import '../model/user_credentials.dart';
import '../routes/routes.dart';
import '../utils/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _logger = taggedLogger(tag: 'SV:LoginViewState');

  late final _googleSignIn = GoogleSignIn(hostedDomain: 'getstream.io');

  late final _tokenService = TokenService();

  Future<void> _loginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return debugPrint('Google login cancelled');

    final user = UserInfo(
      role: 'admin',
      id: googleUser.email,
      name: googleUser.displayName ?? '',
      image: googleUser.photoUrl,
    );

    return _onLoginSuccess(user);
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text;
    if (email.isEmpty) return debugPrint('Email is empty');

    final user = UserInfo(
      role: 'admin',
      id: email,
      name: email,
    );

    return _onLoginSuccess(user);
  }

  Future<void> _onLoginSuccess(UserInfo user) async {
    final tokenResult = await StreamVideo.instance.connectUser(
      user,
      tokenProvider: TokenProvider.dynamic(_tokenLoader, (token) async {
        _logger.d(() => '[onTokenUpdated] token: $token');
        final userCredentials = UserCredentials(
          user: user,
          token: token,
        );
        await UserRepository.instance.saveUserCredentials(userCredentials);
      }),
    );
    _logger.d(() => '[onLoginSuccess] tokenResult: $tokenResult');
    if (tokenResult is! Success<String>) {
      // TODO show error
      return;
    }

    if (mounted) {
      await Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  Future<String> _tokenLoader(String userId) async {
    return _tokenService.loadToken(
        apiKey: Env.apiKey,
        userId: userId,
    );
  }

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
