import 'package:audio_rooms/screens/audio_settings.dart';
import 'package:audio_rooms/widgets/widgets.dart';
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
  Widget _buildCallControls(Call room, CallState callState, double height) {
    final enabled = callState.localParticipant?.isAudioEnabled ?? false;
    return Positioned.fill(
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
          if (callState.localParticipant != null)
            StreamButton(
              backgroundColor: const Color(0xff1E262E),
              borderRadius: 7.0,
              onTap: () async {
                final inputDevice =
                    await RtcMediaDeviceNotifier.instance.audioInputs();
                final devices = inputDevice.getDataOrNull()!;

                print(devices.toString());
                await room.setAudioInputDevice(devices[0]);
                await room.setMicrophoneEnabled(enabled: !enabled);
              },
              child: Icon(
                enabled ? Icons.mic : Icons.mic_off,
                color: enabled ? Colors.blue : Colors.white,
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
    );
  }

  Widget _buildScrim(final double height) {
    return Positioned.fill(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      top: height * 0.75,
      child: const Scrim(
        applied: true,
        child: SizedBox.expand(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: StreamAudioRoomsAppBar(
        onSettingsPressed: () =>
            Navigator.push(context, AudioSettingsScreen.routeTo()),
      ),
      body: CallStateBuilder(
        call: widget.audioRoom,
        builder: (context, callState) {
          print('--------- CALL STATE CHANGE --------------- $callState');
          return Stack(
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
                      participants: callState.otherParticipants,
                      hosts: callState.callParticipants,
                    )),
              ),
              CallDiagnosticsContent(
                call: widget.audioRoom,
              ),
              _buildScrim(height),
              _buildCallControls(widget.audioRoom, callState, height),
            ],
          );
        },
      ),
    );
  }
}

class _RoomScrollBody extends StatefulWidget {
  const _RoomScrollBody({
    Key? key,
    required this.name,
    required this.room,
    required this.participants,
    required this.hosts,
  }) : super(key: key);

  final String name;
  final Call room;
  final List<CallParticipantState> participants;
  final List<CallParticipantState> hosts;

  @override
  State<_RoomScrollBody> createState() => _RoomScrollBodyState();
}

class _RoomScrollBodyState extends State<_RoomScrollBody> {
  List<CallParticipantState> get hosts => widget.participants;

  List<CallParticipantState> get listeners => widget.hosts;

  @override
  void initState() {
    super.initState();
    _configureDevices();
  }

  Future<void> _configureDevices() async {
    final deviceNotifier = RtcMediaDeviceNotifier.instance;
    final outputDevices = await deviceNotifier.audioOutputs();
    final firstDevice = outputDevices.getDataOrNull()!.first;
    await widget.room.setAudioOutputDevice(firstDevice);
    widget.room.stats.listen((value) {
      print(value.toString());
    });
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
          const SliverPadding(padding: EdgeInsets.only(top: 36.0)),
          SliverToBoxAdapter(
            child: Text(
              'Hosts (${hosts.length})',
              style: theme.textTheme.displayMedium,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 12.0)),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Align(
                  widthFactor: 0.8,
                  child: StreamCallParticipant(
                    call: widget.room,
                    backgroundColor: Colors.transparent,
                    participant: listeners[index],
                    showParticipantLabel: false,
                    showConnectionQualityIndicator: false,
                    userAvatarTheme: const StreamUserAvatarThemeData(
                      constraints: BoxConstraints.expand(
                        height: 100,
                        width: 100,
                      ),
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
              child: Text(
                'Listeners (${listeners.length})',
                style: theme.textTheme.displayMedium,
              ),
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
                      showConnectionQualityIndicator: false,
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
