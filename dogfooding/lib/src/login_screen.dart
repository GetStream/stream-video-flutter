import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:stream_video/stream_video.dart';

import '../env/env.dart';
import 'model/user_credentials.dart';
import 'routes/routes.dart';
import 'user_repository.dart';
import 'utils/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final _googleSignIn = GoogleSignIn(hostedDomain: 'getstream.io');

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
    final userId = user.id;
    final response = await http.get(
      Uri.parse(
        'https://stream-calls-dogfood.vercel.app/api/auth/create-token?user_id=$userId&api_key=${Env.apiKey}',
      ),
    );

    final token = (json.decode(response.body) as Map<String, dynamic>)['token'];

    await StreamVideo.instance.connectUser(
      user,
      token: Token(token),
    );

    final userCredentials = UserCredentials(
      user: user,
      token: token,
    );
    await UserRepository.instance.saveUserCredentials(userCredentials);

    if (mounted) {
      await Navigator.of(context).pushReplacementNamed(Routes.home);
    }
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'stream_logo',
              child: SvgPicture.asset(
                streamLogoAsset,
                semanticsLabel: 'Stream Logo',
                width: size.width * 0.3,
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _emailController,
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
        backgroundColor: Colors.white,
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
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
