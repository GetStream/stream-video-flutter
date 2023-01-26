import 'package:chat_with_video_starter/sample_user.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide StreamUserAvatar;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_config.dart';
import '../user_mapper.dart';
import 'channel_list_screen.dart';

class ChooseUserScreen extends StatelessWidget {
  const ChooseUserScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = defaultUsers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your user'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, position) {
            var user = users[position];
            return ListTile(
              leading: StreamUserAvatar(user: user.toVideoUser()),
              title: Text(user.name),
              onTap: () async => _login(context, user),
            );
          },
        ),
      ),
    );
  }

  /// Connects the current user to both Video and Chat APIs and
  /// navigates the user to the home screen.
  Future<void> _login(BuildContext context, SampleUser user) async {
    _connectVideoUser(user);
    _connectChatUser(context, user);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChannelListScreen(
                onLogout: () {
                  _logout(context);
                },
              )),
    );
  }

  /// Connects the current user to the Video API.
  Future<void> _connectVideoUser(SampleUser user) async {
    final videoClient = StreamVideo.instance;

    await videoClient.connectUser(
      user.toVideoUser(),
      token: Token(user.videoToken),
    );
  }

  /// Connects the current user to the Chat API.
  Future<void> _connectChatUser(BuildContext context, SampleUser user) async {
    final chatClient = StreamChat.of(context).client;

    await chatClient.connectUser(
      user.toChatUser(),
      user.chatToken,
    );
  }

  /// Disconnects the currently logged in user from both Video and Chat APIs
  /// and navigates back to the previous screen.
  Future<void> _logout(BuildContext context) async {
    _disconnectChatUser(context);
    _disconnectVideoUser();

    Navigator.of(context).pop();
  }

  /// Disconnects the currently logged in user from the Chat API.
  Future<void> _disconnectChatUser(BuildContext context) async {
    final chatClient = StreamChat.of(context).client;

    await chatClient.disconnectUser();
  }

  /// Disconnects the currently logged in user from the Video API.
  Future<void> _disconnectVideoUser() async {
    final videoClient = StreamVideo.instance;

    await videoClient.disconnectUser();
  }
}
