import 'dart:convert';

import 'package:example/src/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:http/http.dart' as http;

import 'home_screen_v2.dart';

final List<LoginInfo> users = [
  LoginInfo(
    const UserInfo(
      id: 'tommaso',
      role: 'admin',
      name: 'Tomasso',
      imageUrl:
          'https://getstream.io/static/712bb5c0bd5ed8d3fa6e5842f6cfbeed/c59de/tommaso.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci90b21tYXNvIiwiaWF0IjoxNjcwMzM5NDQwLCJ1c2VyX2lkIjoidG9tbWFzbyJ9.t5YFZFqm-XjDFJV_z_y-UdT8HjZpOunAm-6L_h_mW7A',
  ),
  LoginInfo(
    const UserInfo(
      id: 'thierry',
      role: 'admin',
      name: 'Thierry',
      imageUrl:
          'https://getstream.io/static/237f45f28690696ad8fff92726f45106/c59de/thierry.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci90aGllcnJ5IiwiaWF0IjoxNjcwMzM5NTAwLCJ1c2VyX2lkIjoidGhpZXJyeSJ9.q8dy763W-ZVOA_1VbNhz0VozuxAI1Ko42HlVl-9mnG8',
  ),
];

class LoginScreenV2 extends StatefulWidget {
  const LoginScreenV2({super.key});

  static const routeName = '/v2/login';

  @override
  State<LoginScreenV2> createState() => _LoginScreenStateV2();
}

class _LoginScreenStateV2 extends State<LoginScreenV2> {
  Future<void> _onLogin(LoginInfo info) async {
    await StreamVideoV2.instance.connectUser(
      info.userInfo,
      token: Token(info.token),
    );

    Navigator.of(context).pushReplacementNamed(HomeScreenV2.routeName);
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
      appBar: AppBar(
        title: const Text('Select a user'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, position) {
            var user = users[position];
            return ListTile(
              title: Text(user.userInfo.name),
              subtitle: Text('Role: ${user.userInfo.role}'),
              onTap: () {
                _onLogin(user);
              },
            );
          },
        ),
      ),
    );
  }
}

class LoginInfo {
  final UserInfo userInfo;
  final String token;

  LoginInfo(this.userInfo, this.token);
}
