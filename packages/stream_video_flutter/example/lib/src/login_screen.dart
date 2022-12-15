import 'dart:convert';

import 'package:example/src/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(),
          ],
        ),
      ),
    );
  }
}
