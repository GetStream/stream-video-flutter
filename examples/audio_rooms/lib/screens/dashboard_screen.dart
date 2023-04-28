import 'package:audio_rooms/screens/audio_room_screen.dart';
import 'package:audio_rooms/widgets/stream_audio_appbar.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static Route<dynamic> routeTo() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return const DashboardScreen();
      },
    );
  }

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _handleRoomTap(String room) {
    Navigator.of(context).push(AudioRoomScreen.routeTo());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      appBar: const StreamAudioRoomsAppBar(),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        bottom: 12.0,
                      ),
                      child: Text(
                        'Available Audio Rooms',
                        style: theme.textTheme.displayLarge,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: 12,
                      (context, index) => OpenContainer(
                        openBuilder: (context, action) => AudioRoomScreen(
                          audioRoom: Call.fromCid(
                            callCid: StreamCallCid.from(type: "type", id: "id"),
                          ),
                        ),
                        closedBuilder: (context, action) => _RoomCard(
                          roomTitle: 'Audio Room O1',
                          onRoomTap: (_) => action.call(),
                          users: const [
                            "Deven",
                            "Nash",
                            "Thierry",
                            "Tommaso",
                          ],
                        ),
                        closedColor: const Color(0xFFDDDDDD),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned.fill(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              top: height * 0.72,
              child: const Scrim(
                applied: true,
                child: SizedBox.expand(),
              ),
            ),
            Positioned.fill(
              bottom: 24.0,
              left: 24.0,
              right: 24.0,
              top: height * 0.75,
              child: StreamButton(
                onTap: _createRoom,
                child: const Text(
                  "New Room",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    Key? key,
    required this.roomTitle,
    required this.users,
    required this.onRoomTap,
  }) : super(key: key);

  final String roomTitle;

  //TODO: Replace generic with model
  final List<String> users;
  final ValueChanged<String> onRoomTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onRoomTap(roomTitle),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(roomTitle, style: theme.textTheme.displayMedium),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  const _AudioRoomAvatar(),
                  const SizedBox(width: 24.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final String participant in users)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              participant,
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                        const SizedBox(height: 12.0),
                        Text(
                          "124 participants",
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.blueGrey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioRoomAvatar extends StatelessWidget {
  const _AudioRoomAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: const Offset(0.0, -15.5),
          child: const CircleAvatar(
            backgroundColor: Color(0xFFD9D9D9),
          ),
        ),
        Transform.translate(
          offset: const Offset(-15.0, 5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 222.0),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.amber,
            ),
          ),
        )
      ],
    );
  }
}
