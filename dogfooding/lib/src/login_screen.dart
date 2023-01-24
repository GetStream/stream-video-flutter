import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:stream_video/stream_video.dart';

import 'home_screen.dart';
import 'utils/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

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
      imageUrl: googleUser.photoUrl,
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
    final response = await http.get(Uri.parse(
      'https://stream-calls-dogfood.vercel.app/api/auth/create-token?user_id=$userId',
    ));

    final token = json.decode(response.body)['token'];

    var streamVideoClient = StreamVideo.instance;
    await streamVideoClient.connectUser(
      user,
      token: Token(token),
    );

    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    Key? key,
    this.label = 'Login with Google',
    this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1.0,
        fixedSize: const Size.fromHeight(56.0),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            SvgPicture.asset(
              googleLogoAsset,
              semanticsLabel: 'Google Logo',
            ),
            const SizedBox(width: 24.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16.0,
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
