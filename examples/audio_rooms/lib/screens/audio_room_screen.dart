import 'package:audio_rooms/widgets/stream_audio_appbar.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class AudioRoomScreen extends StatefulWidget {
  static Route<dynamic> routeTo() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return const AudioRoomScreen();
      },
    );
  }

  const AudioRoomScreen({Key? key}) : super(key: key);

  @override
  State<AudioRoomScreen> createState() => _AudioRoomScreenState();
}

class _AudioRoomScreenState extends State<AudioRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamAudioRoomsAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: const [
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            child: _RoomScrollBody(),
          )
        ],
      ),
    );
  }
}

// TODO(Nash): Refactor to slivers and a custom scroll view
class _RoomScrollBody extends StatelessWidget {
  const _RoomScrollBody({Key? key}) : super(key: key);

  Widget _buildIndicatorText() {
    return const Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFF999999),
        ),
        children: [
          TextSpan(text: ' 126 '),
          WidgetSpan(
            alignment: ui.PlaceholderAlignment.middle,
            child: Icon(
              Icons.account_circle,
              size: 16.0,
              color: Color(0xFF999999),
            ),
          ),
          TextSpan(text: ' / '),
          TextSpan(text: ' 26 '),
          WidgetSpan(
            alignment: ui.PlaceholderAlignment.middle,
            child: Icon(
              Icons.message,
              size: 16.0,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Audio Room Number 01', style: theme.textTheme.displayLarge),
            const SizedBox(height: 10.0),
            _buildIndicatorText(),
            const SizedBox(height: 36.0),
            Text(
              'Hosts (3)',
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 12.0),
            Wrap(
              children: List.generate(
                3,
                (index) => Align(
                  widthFactor: 0.8,
                  child: CircleAvatar(
                    radius: 52,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.pink.withOpacity(index / 5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36.0),
            Text(
              'Listeners (123)',
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 12.0),
            ...List.generate(
              124,
              (index) => const CircleAvatar(
                radius: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
