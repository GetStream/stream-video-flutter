import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_screen.dart';
import 'utils/after_layout.dart';
import 'utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // Show splash screen for 2 seconds.
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'stream_logo',
              child: SvgPicture.asset(
                streamLogoAsset,
                semanticsLabel: 'Stream Logo',
                width: size.width * 0.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Stream UI Example',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
