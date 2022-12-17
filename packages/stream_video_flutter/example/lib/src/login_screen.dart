import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'home_screen.dart';

final List<LoginInfo> users = [
  LoginInfo(
    const UserInfo(
      id: 'sahil',
      role: 'admin',
      name: 'Sahil',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWhpbCIsImlhdCI6MTY2OTcyNjkxNSwidXNlcl9pZCI6InNhaGlsIn0.aOOWXDmX-8hG57N7R3w320XZzxAj256Lm2YZj_sqCuQ',
  ),
  LoginInfo(
    const UserInfo(
      id: 'deven',
      role: 'admin',
      name: 'Deven',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9kZXZlbiIsImlhdCI6MTY2OTcyNjk1MSwidXNlcl9pZCI6ImRldmVuIn0.u5c-MHdpV2UNKYpD0fkc5cML66Bifx_Q2hV9ueRMjpI',
  ),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _onLogin(LoginInfo info) async {
    final streamVideoClient = StreamVideo.instance;
    await streamVideoClient.connectUser(
      info.userInfo,
      token: Token(info.token),
    );

    await Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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
            final user = users[position];
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
  LoginInfo(this.userInfo, this.token);
  final UserInfo userInfo;
  final String token;
}
