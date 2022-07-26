import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class RoomWidget extends StatefulWidget {
  final VideoRoom room;

  RoomWidget(this.room);

  @override
  State<StatefulWidget> createState() {
    return _RoomState();
  }
}

class _RoomState extends State<RoomWidget> {
  late final StreamEventsListener<StreamRoomEvent> _listener =
      widget.room.createListener();

  @override
  void initState() {
    super.initState();
    // used for generic change updates
    widget.room.addListener(_onChange);

    // used for specific events
    _listener
      ..on<StreamRoomDisconnectedEvent>((_) {
        // handle disconnect
      })
      ..on<StreamParticipantConnectedEvent>((e) {
        print("participant joined: ${e.participant.identity}");
      });
  }

  @override
  void dispose() {
    // be sure to dispose listener to stop listening to further updates
    _listener.dispose();
    widget.room.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    // perform computations and then call setState
    // setState will trigger a build
    setState(() {
      // your updates here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
