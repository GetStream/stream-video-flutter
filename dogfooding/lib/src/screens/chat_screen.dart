import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    this.onBackPressed,
  });

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return StreamChatTheme(
      data: StreamChatThemeData.dark(),
      child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: SafeArea(
          child: Column(
            children: const <Widget>[
              Expanded(
                child: StreamMessageListView(),
              ),
              StreamMessageInput(
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
