import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_screen.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({Key? key, required this.onLogout}) : super(key: key);

  final VoidCallback onLogout;

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
    return Scaffold(
      appBar: StreamChannelListHeader(
        titleBuilder: (context, status, client) {
          return Text(
            "Chat with Video",
            style: StreamChatTheme.of(context).textTheme.headlineBold,
          );
        },
        actions: [
          IconButton(
            icon: const Icon(
              color: Colors.black,
              Icons.logout,
            ),
            onPressed: () async => widget.onLogout.call(),
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
}
