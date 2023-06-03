import 'dart:async';

import 'package:audio_rooms/widgets/stream_audio_appbar.dart';
import 'package:audio_rooms/widgets/stream_button.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:stream_video_flutter/stream_video_flutter.dart';

class AudioRoomScreen extends StatefulWidget {
  static Route<dynamic> routeTo(Call audioRoom, String name) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return AudioRoomScreen(
          audioRoom: audioRoom,
          name: name,
        );
      },
    );
  }

  const AudioRoomScreen({
    Key? key,
    required this.audioRoom,
    required this.name,
  }) : super(key: key);

  final Call audioRoom;
  final String name;

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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              child: _RoomScrollBody(
                name: widget.name,
                room: widget.audioRoom,
              ),
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
                    widget.audioRoom.disconnect();
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
                  onTap: () {
                    widget.audioRoom.end();
                    widget.audioRoom.disconnect();
                    Navigator.of(context).pop();
                  },
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

class _RoomScrollBody extends StatefulWidget {
  const _RoomScrollBody({
    Key? key,
    required this.name,
    required this.room,
  }) : super(key: key);

  final String name;
  final Call room;

  @override
  State<_RoomScrollBody> createState() => _RoomScrollBodyState();
}

class _RoomScrollBodyState extends State<_RoomScrollBody> {
  List<CallParticipantState> hosts = [];
  List<CallParticipantState> listeners = [];

  late final StreamSubscription<CallState> callStateSubscription;

  @override
  void initState() {
    super.initState();
    callStateSubscription = widget.room.state.asStream().listen(
      (callState) {
        setState(
          () {
            hosts = callState.callParticipants
                .where((element) => element.role == 'admin')
                .toList(growable: false);
            listeners = callState.callParticipants
                .where((element) => element.role == 'user')
                .toList(growable: false);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    callStateSubscription.cancel();
    super.dispose();
  }

  Widget _buildIndicatorText() {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFF999999),
        ),
        children: [
          TextSpan(text: ' ${hosts.length + listeners.length} '),
          const WidgetSpan(
            alignment: ui.PlaceholderAlignment.middle,
            child: Icon(
              Icons.account_circle,
              size: 16.0,
              color: Color(0xFF999999),
            ),
          ),
          const TextSpan(text: ' / '),
          const TextSpan(text: ' 26 '),
          const WidgetSpan(
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
            child: Text(
              widget.name,
              style: theme.textTheme.displayLarge,
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          SliverToBoxAdapter(
            child: _buildIndicatorText(),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 36.0),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<CallState>(
                stream: widget.call.state.valueStream,
                builder: (context, snapshot) {
                  final numberOfSpeakers = snapshot.data?.callParticipants
                      .where((element) => element.isAudioEnabled)
                      .length;
                  return Text(
                    'Hosts ($numberOfSpeakers)',
                    style: theme.textTheme.displayMedium,
                  );
                }),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 12.0)),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Align(
                  widthFactor: 0.8,
                  child: CircleAvatar(
                    radius: 52,
                    child: StreamCallParticipant(
                      call: widget.room,
                      participant: hosts[index],
                    ),
                  ),
                );
              },
              childCount: hosts.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 36, bottom: 12),
            sliver: SliverToBoxAdapter(
              child: StreamBuilder<CallState>(
                  stream: widget.call.state.valueStream,
                  builder: (context, snapshot) {
                    final numberOfSpeakers = snapshot.data?.callParticipants
                        .where((element) => !element.isAudioEnabled)
                        .length;
                    return Text(
                      'Listeners ($numberOfSpeakers)',
                      style: theme.textTheme.displayMedium,
                    );
                  }),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Align(
                  widthFactor: 0.8,
                  child: CircleAvatar(
                    radius: 36,
                    child: StreamCallParticipant(
                      call: widget.room,
                      backgroundColor: Colors.transparent,
                      participant: listeners[index],
                      showParticipantLabel: false,
                      userAvatarTheme: const StreamUserAvatarThemeData(
                        constraints: BoxConstraints.expand(
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: listeners.length,
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
