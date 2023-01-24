import 'package:chat_with_video/screen/channel_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    channelStateSort: const [SortOption('last_message_at')],
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    final textTheme = chatTheme.textTheme;

    return Scaffold(
      appBar: StreamChannelListHeader(
        titleBuilder: (context, status, client) {
          return Text(
            "Chat with Video",
            style: textTheme.headlineBold,
          );
        },
        actions: [
          IconButton(
            icon: const Icon(
              color: Colors.black,
              Icons.logout,
            ),
            onPressed: () async => _logout(context),
          ),
        ],
      ),
      body: StreamChannelListView(
        controller: _listController,
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  child: ChannelScreen(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Disconnect the currently logged in user from both Video and Chat APIs.
  Future<void> _logout(BuildContext context) async {
    final chatClient = StreamChat.of(context).client;
    await chatClient.disconnectUser();

    final videoClient = StreamVideo.instance;
    await videoClient.disconnectUser();

    Navigator.of(context).pop();
  }
}
