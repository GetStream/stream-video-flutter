import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_config.dart';
import '../sample_user.dart';
import 'home_screen.dart';

typedef ConnectUser = Future<Result<None>> Function(
  UserInfo user,
  String token,
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.connectUser,
  });

  final ConnectUser connectUser;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loggingIn = false;

  @override
  Widget build(BuildContext context) {
    final users = sampleUsers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a user'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, position) {
                final user = users[position];
                return ListTile(
                  leading: StreamUserAvatar(user: user.userInfo),
                  title: Text(user.userInfo.name),
                  subtitle: Text('Role: ${user.userInfo.role}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await _onUserTap(user);
                  },
                );
              },
            ),
            Visibility(
              visible: loggingIn,
              child: const ColoredBox(
                color: Colors.white60,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUserTap(SampleUser user) async {
    if (loggingIn) {
      return;
    }
    setState(() {
      loggingIn = true;
    });
    await widget.connectUser(user.userInfo, user.token);
    setState(() {
      loggingIn = false;
    });

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
