import 'package:audio_rooms/assets.dart';
import 'package:audio_rooms/screens/dashboard_screen.dart';
import 'package:audio_rooms/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'stream_audio_logo',
                  child: Image.asset(
                    kStreamAudioIconAsset,
                    width: size.width * 0.3,
                  ),
                ),
                const SizedBox(height: 36),
                Text('Stream Audio Rooms', style: theme.textTheme.bodyLarge),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Text(
                    'Please sign in with your Google Stream account.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GoogleLoginButton(
                    onPressed: () {
                      Navigator.of(context).push(DashboardScreen.routeTo());
                    },
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
