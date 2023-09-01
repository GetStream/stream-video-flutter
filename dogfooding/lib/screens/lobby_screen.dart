// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({
    super.key,
    required this.onJoinCallPressed,
    required this.call,
  });

  final ValueChanged<CallConnectOptions> onJoinCallPressed;
  final Call call;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamLobbyViewTheme(
      data: StreamLobbyViewThemeData(
        backgroundColor: theme.scaffoldBackgroundColor,
        cardBackgroundColor: const Color(0xFF4C525C),
      ),
      child: StreamLobbyView(
        call: call,
        onJoinCallPressed: onJoinCallPressed,
      ),
    );
  }
}
