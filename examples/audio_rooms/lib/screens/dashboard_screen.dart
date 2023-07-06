import 'package:animations/animations.dart';
import 'package:audio_rooms/repositories/audio_repository.dart';
import 'package:audio_rooms/repositories/repository.dart';
import 'package:audio_rooms/screens/audio_room_screen.dart';
import 'package:audio_rooms/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static Route<dynamic> routeTo() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return AudioProvider(
          audioRepo: AudioRepository(StreamVideo.instance),
          child: const DashboardScreen(),
        );
      },
    );
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _createRoom(String title, String desc) async {
    final room = await context.audio.createAudioRoom(
      title: title,
      description: desc,
    );
    await room.connect();
    final metadata = await room.goLive();

    if (mounted) {
      Navigator.of(context).push(
        AudioRoomScreen.routeTo(
          room,
          metadata.getDataOrNull()!.details.custom['name'] as String,
        ),
      );
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: CreateRoomDialog(
            onCreatePressed: (roomInfo) => _createRoom(
              roomInfo.title,
              roomInfo.desc,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRoomTapped(QueriedCall room) async {
    room.callObject.connectOptions = CallConnectOptions(
      camera: TrackOption.disabled(),
      microphone: TrackOption.disabled(),
    );
    final call = room.callObject;
    await call.connect();

    if (mounted) {
      Navigator.of(context).push(
        AudioRoomScreen.routeTo(
          call,
          room.call.details.custom['name'] as String,
        ),
      );
    }
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
                  FutureBuilder<List<QueriedCall>>(
                    future: context.audio.queryCalls(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data ?? [];
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: data.length,
                            (context, index) {
                              final room = data[index];
                              final roomTitle =
                                  room.call.details.custom['name'] as String? ??
                                      room.call.cid.id;
                              return _RoomCard(
                                  roomTitle: roomTitle,
                                  users: room
                                      .callObject.state.value.callParticipants
                                      .map((e) => e.name)
                                      .toList(),
                                  onRoomTap: (_) => _onRoomTapped(room));
                              // return OpenContainer(
                              //   openBuilder: (context, action) =>
                              //       AudioRoomScreen(
                              //     audioRoom: room.callObject,
                              //     name: roomTitle,
                              //   ),
                              //   closedBuilder: (context, action) => _RoomCard(
                              //     roomTitle: roomTitle,
                              //     onRoomTap: (_) => _onRoomTapped(room, action),
                              //     users: room.members
                              //         .map((e) => e.userId)
                              //         .toList(growable: false),
                              //   ),
                              //   closedColor: const Color(0xFFDDDDDD),
                              // );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const SliverToBoxAdapter(
                          child: Text('No Audio rooms online at this time'),
                        );
                      } else {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
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
                onTap: _showDialog,
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => onRoomTap(roomTitle),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomTitle,
                style: theme.textTheme.displayMedium
                    ?.copyWith(color: Colors.black),
              ),
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
                          "${users.length} participants",
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.blueGrey,
                          ),
                        )
                      ],
                    ),
                  ),
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
  const _AudioRoomAvatar({
    Key? key,
    this.imageURl,
  }) : super(key: key);
  final String? imageURl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: imageURl == null ? Colors.blue : null,
      backgroundImage: imageURl != null ? NetworkImage(imageURl!) : null,
      child: imageURl == null ? const Text('🎙️') : null,
    );
  }
}

extension on QueriedCall {
  Call get callObject => StreamVideo.instance.makeCall(
        type: call.cid.type,
        id: call.cid.id,
      );
}

extension on CallMetadata {
  Call get callObject => StreamVideo.instance.makeCall(
        type: cid.type,
        id: cid.id,
      );
}