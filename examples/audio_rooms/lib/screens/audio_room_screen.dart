import 'package:audio_rooms/widgets/stream_audio_appbar.dart';
import 'package:audio_rooms/widgets/stream_button.dart';
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const StreamAudioRoomsAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              child: _RoomScrollBody(),
            ),
          ),
          Positioned.fill(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            top: height * 0.75,
            child: const Scrim(applied: true, child: SizedBox.expand()),
          ),
          Positioned.fill(
            bottom: 24.0,
            left: 24.0,
            right: 24.0,
            top: height * 0.75,
            child: Row(
              children: [
                StreamButton(
                  child: const Text(
                    "Leave quietly",
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                StreamButton(
                  backgroundColor: const Color(0xff1E262E),
                  borderRadius: 7.0,
                  onTap: () {},
                  child: const Icon(
                    Icons.add_reaction_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12.0),
                StreamButton(
                  backgroundColor: const Color(0xff1E262E),
                  borderRadius: 7.0,
                  onTap: () {},
                  child: const Icon(
                    Icons.back_hand,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
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
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text('Audio Room Number 01',
                style: theme.textTheme.displayLarge),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 10.0)),
          SliverToBoxAdapter(
            child: _buildIndicatorText(),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 36.0)),
          SliverToBoxAdapter(
            child: Text(
              'Hosts (3)',
              style: theme.textTheme.displayMedium,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 12.0)),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Align(
                  widthFactor: 0.8,
                  child: CircleAvatar(
                    radius: 52,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.pink.withOpacity(index / 5),
                    ),
                  ),
                );
              },
              childCount: 3,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 36, bottom: 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Listeners (123)',
                style: theme.textTheme.displayMedium,
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return const Align(
                  widthFactor: 0.8,
                  child: CircleAvatar(
                    radius: 36,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.pink,
                    ),
                  ),
                );
              },
              childCount: 123,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class Scrim extends StatelessWidget {
  final bool applied;
  final Widget child;

  final double opacity;
  final Duration speed;
  final Color color;

  const Scrim({
    Key? key,
    required this.applied,
    required this.child,
    this.opacity = 0.75,
    this.color = Colors.white,
    this.speed = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: applied,
      child: AnimatedContainer(
        duration: speed,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
        foregroundDecoration: BoxDecoration(
          color: color.withOpacity(applied ? opacity : 0.0),
        ),
        child: child,
      ),
    );
  }
}
