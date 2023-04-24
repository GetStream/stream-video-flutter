import 'package:audio_rooms/assets.dart';
import 'package:flutter/material.dart';

class StreamAudioRoomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StreamAudioRoomsAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xFFDDDDDD),
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(kStreamAudioIconAsset),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
