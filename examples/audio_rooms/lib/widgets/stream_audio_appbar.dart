import 'package:audio_rooms/assets.dart';
import 'package:audio_rooms/widgets/stream_button.dart';
import 'package:flutter/material.dart';

class StreamAudioRoomsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const StreamAudioRoomsAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      color: const Color(0xFFDDDDDD),
      child: Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.viewPadding.top + 8.0,
          left: mediaQuery.viewPadding.left + 8.0,
          right: mediaQuery.viewPadding.right + 8.0,
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(kStreamAudioIconAsset),
            ),
            const Spacer(),
            const Icon(
              Icons.settings,
              size: 34,
              color: Color(0xFF4C525C),
            ),
            const SizedBox(width: 24),
            StreamButton(
              height: 18,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Sign out",
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
