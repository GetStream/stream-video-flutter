import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_config.dart';
import '../core/auth_repository.dart';
import 'home_screen.dart';

typedef ConnectUser = Future<Result<None>> Function(
  UserInfo user,
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
  void initState() {
    super.initState();
    restoreLoggedInUser();
  }

  Future<void> restoreLoggedInUser() async {
    final authRepository = await AuthRepository.getInstance();
    final credentials = authRepository.getCredentials();
    if (credentials != null) {
      await _onUserTap(credentials.userInfo);
    }
  }

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
                  leading: StreamUserAvatar(user: user),
                  title: Text(user.name),
                  subtitle: Text('Role: ${user.role}'),
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

  Future<void> _onUserTap(UserInfo user) async {
    if (loggingIn) {
      return;
    }

    setState(() {
      loggingIn = true;
    });

    await widget.connectUser(user);

    setState(() {
      loggingIn = false;
    });

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<dynamic>(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }
}
