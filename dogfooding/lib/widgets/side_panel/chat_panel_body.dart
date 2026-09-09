import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The call's chat, as the body of a side panel.
class ChatPanelBody extends StatelessWidget {
  /// Creates a chat body for [channel].
  const ChatPanelBody({super.key, required this.channel});

  /// The channel to show the messages of.
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: Column(
        children: <Widget>[
          const Expanded(child: StreamMessageListView()),
          StreamMessageComposer(),
        ],
      ),
    );
  }
}
