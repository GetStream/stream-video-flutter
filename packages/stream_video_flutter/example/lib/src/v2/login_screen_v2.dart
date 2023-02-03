import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'home_screen_v2.dart';

Widget avatarBuilder(BuildContext context, UserInfo userInfo) {
  final name = userInfo.name;
  final imageUrl = userInfo.imageUrl;

  final avatar = imageUrl != null
      ? CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageUrl),
        )
      : CircleAvatar(
          child: Text(name[0].toUpperCase()),
        );

  return avatar;
}

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
  LoginInfo(
    const UserInfo(
      id: 'marcelo',
      role: 'admin',
      name: 'Marcelo',
      imageUrl:
          'https://getstream.io/static/aaf5fb17dcfd0a3dd885f62bd21b325a/802d2/marcelo-pires.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9tYXJjZWxvIiwiaWF0IjoxNjcwMzM5NDU2LCJ1c2VyX2lkIjoibWFyY2VsbyJ9.-tBPUvyU-XTh04f9-Owv9tB6EG0lEIAyHTsZXYwOTqw',
  ),
  LoginInfo(
    const UserInfo(
      id: 'martin',
      role: 'admin',
      name: 'Martin',
      imageUrl:
          'https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/802d2/martin-mitrevski.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9tYXJ0aW4iLCJpYXQiOjE2NzAzMzkzNDMsInVzZXJfaWQiOiJtYXJ0aW4ifQ.EGMuYyXti8IMCMX4oiLKTkVZe8ZqUJr93Kj214-jCHg',
  ),
  LoginInfo(
    const UserInfo(
      id: 'filip',
      role: 'admin',
      name: 'Filip',
      imageUrl:
          'https://getstream.io/static/76cda49669be38b92306cfc93ca742f1/802d2/filip-babi%C4%87.webp',
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9maWxpcCIsImlhdCI6MTY3MDMzOTQ4MSwidXNlcl9pZCI6ImZpbGlwIn0.rGK-twVawPRItb_xQigYuYVO8UDTCCNPYKM5xP6mpbo',
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
            final user = users[position];
            return ListTile(
              leading: avatarBuilder(context, user.userInfo),
              title: Text(user.userInfo.name),
              subtitle: Text('Role: ${user.userInfo.role}'),
              trailing: const Icon(Icons.chevron_right),
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
