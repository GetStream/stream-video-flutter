import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_config.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = sampleUsers;

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
              leading: StreamUserAvatar(user: user.userInfo),
              title: Text(user.userInfo.name),
              subtitle: Text('Role: ${user.userInfo.role}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await StreamVideoV2.instance.connectUser(
                  user.userInfo,
                  token: Token(user.token),
                );

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
