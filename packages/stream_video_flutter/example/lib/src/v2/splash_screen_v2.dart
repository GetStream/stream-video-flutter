import 'dart:async';

import 'package:example/src/utils/after_layout.dart';
import 'package:example/src/utils/assets.dart';
import 'package:example/src/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_screen_v2.dart';

class SplashScreenV2 extends StatefulWidget {
  const SplashScreenV2({super.key});

  static const routeName = '/';

  @override
  State<SplashScreenV2> createState() => _SplashScreenStateV2();
}

class _SplashScreenStateV2 extends State<SplashScreenV2> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // Show splash screen for 2 seconds.
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        Navigator.of(context).pushReplacementNamed(LoginScreenV2.routeName);
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
              'Stream UI Example V2',
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
