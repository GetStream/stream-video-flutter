// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/user_auth_controller.dart';
import 'package:flutter_dogfooding/core/repos/token_service.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/widgets/stream_button.dart';

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
      appBar: AppBar(
        backgroundColor: AppColorPalette.backgroundColor,
        actions: [
          EnvironmentSwitcher(
            currentEnvironment: TokenService.environment,
          )
        ],
      ),
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
                    width: size.width * 0.8,
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
                    style:
                        theme.textTheme.bodyMedium?.apply(color: Colors.white),
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
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GoogleLoginButton(
                    onPressed: _loginWithGoogle,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StreamButton.tertiary(
                    onPressed: _loginAsGuest,
                    label: 'Join As Guest',
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
    required this.onPressed,
    this.label = 'Login with Google',
  });

  final String label;
  final VoidCallback onPressed;

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
  var id = '';
  for (var i = 0; i < size; i++) {
    id += _alphabet[(math.Random().nextDouble() * 64).floor() | 0];
  }
  return id;
}

class EnvironmentSwitcher extends StatefulWidget {
  const EnvironmentSwitcher({
    super.key,
    required this.currentEnvironment,
  });

  final Environment currentEnvironment;

  @override
  State<EnvironmentSwitcher> createState() => _EnvironmentSwitcherState();
}

class _EnvironmentSwitcherState extends State<EnvironmentSwitcher> {
  late Environment selectedEnvironment;

  @override
  void initState() {
    selectedEnvironment = widget.currentEnvironment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColorPalette.appGreen,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                selectedEnvironment.displayName,
                style: streamVideoTheme.textTheme.footnoteBold
                    .apply(color: AppColorPalette.appGreen),
              ),
            ),
          ),
          MenuAnchor(
            style: const MenuStyle(
              alignment: Alignment.bottomLeft,
              backgroundColor:
                  MaterialStatePropertyAll(AppColorPalette.backgroundColor),
            ),
            alignmentOffset: const Offset(-70, 0),
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              );
            },
            menuChildren: [
              ...Environment.values
                  .map(
                    (env) => MenuItemButton(
                      onPressed: () {
                        TokenService.environment = env;

                        setState(() {
                          selectedEnvironment = env;
                        });
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedEnvironment == env
                                ? AppColorPalette.appGreen
                                : Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            env.displayName,
                            style: TextStyle(
                                color: selectedEnvironment == env
                                    ? AppColorPalette.appGreen
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ],
      ),
    );
  }
}
