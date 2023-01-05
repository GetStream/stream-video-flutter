import 'package:flutter/material.dart';
import 'package:stream_video_flutter/participants/call_participant.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatefulWidget {
  const StreamCallParticipants({
    required this.participants,
    Key? key,
  }) : super(key: key);

  /// The list of participants to display.
  final List<Participant> participants;

  @override
  State<StatefulWidget> createState() {
    return _StreamCallParticipantsState();
  }
}

class _StreamCallParticipantsState extends State<StreamCallParticipants> {
  @override
  Widget build(BuildContext context) {
    final participants = widget.participants;
    final remote = participants.whereType<RemoteParticipant>().toList();
    final local = participants.whereType<LocalParticipant>().toList();

    final participantsToDisplay = [];
    if (local.isEmpty) {
      participantsToDisplay.addAll(remote.take(4).toList());
    } else {
      participantsToDisplay.addAll(remote.take(3).toList());
      participantsToDisplay.add(local.first);
    }

    switch (participantsToDisplay.length) {
      case 1:
        return StreamCallParticipant(participant: participantsToDisplay[0]);
      case 2:
        return Column(children: [
          Expanded(
            child: StreamCallParticipant(participant: participantsToDisplay[0]),
          ),
          Expanded(
            child: StreamCallParticipant(participant: participantsToDisplay[1]),
          ),
        ]);
      case 3:
        return Column(children: [
          Expanded(
            child: StreamCallParticipant(participant: participantsToDisplay[0]),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: StreamCallParticipant(
                      participant: participantsToDisplay[1]),
                ),
                Expanded(
                  child: StreamCallParticipant(
                      participant: participantsToDisplay[2]),
                ),
              ],
            ),
          ),
        ]);
      case 4:
        return Column(children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: StreamCallParticipant(
                      participant: participantsToDisplay[0]),
                ),
                Expanded(
                  child: StreamCallParticipant(
                      participant: participantsToDisplay[1]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: StreamCallParticipant(
                      participant: participantsToDisplay[2]),
                ),
                Expanded(
                  child: StreamCallParticipant(
                      participant: participantsToDisplay[3]),
                ),
              ],
            ),
          ),
        ]);
      default:
        return Container();
    }
  }
}
