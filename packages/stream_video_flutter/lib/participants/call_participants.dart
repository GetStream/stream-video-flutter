import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// {@template callParticipantWidgetBuilder}
/// Builder function used to build a participant grid item.
/// {@endtemplate}
typedef CallParticipantWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  Participant participant,
);

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatefulWidget {
  const StreamCallParticipants({
    required this.participants,
    this.itemBuilder,
    Key? key,
  }) : super(key: key);

  /// The list of participants to display.
  final List<Participant> participants;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilder? itemBuilder;

  @override
  State<StatefulWidget> createState() {
    return _StreamCallParticipantsState();
  }
}

class _StreamCallParticipantsState extends State<StreamCallParticipants> {
  @override
  Widget build(BuildContext context) {
    final participants = widget.participants;
    participants.sort(_participantComparator);
    final remote = participants.whereType<RemoteParticipant>().toList();
    final local = participants.whereType<LocalParticipant>().toList();

    final List<Participant> participantsToDisplay = [];
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
          Expanded(child: _buildParticipant(participantsToDisplay, 0)),
          Expanded(child: _buildParticipant(participantsToDisplay, 1)),
        ]);
      case 3:
        return Column(children: [
          Expanded(child: _buildParticipant(participantsToDisplay, 0)),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildParticipant(participantsToDisplay, 1)),
                Expanded(child: _buildParticipant(participantsToDisplay, 2)),
              ],
            ),
          ),
        ]);
      case 4:
        return Column(children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildParticipant(participantsToDisplay, 0)),
                Expanded(child: _buildParticipant(participantsToDisplay, 1)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildParticipant(participantsToDisplay, 2)),
                Expanded(child: _buildParticipant(participantsToDisplay, 3)),
              ],
            ),
          ),
        ]);
      default:
        return Container();
    }
  }

  Widget _buildParticipant(List<Participant> participants, int index) {
    final participant = participants[index];

    return widget.itemBuilder?.call(context, index, participant) ??
        StreamCallParticipant(participant: participant);
  }

  int _participantComparator(Participant a, Participant b) {
    final aLastSpokeAt = a.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
    final bLastSpokeAt = b.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

    if (aLastSpokeAt != bLastSpokeAt) {
      return aLastSpokeAt > bLastSpokeAt ? -1 : 1;
    }

    return a.joinedAt.millisecondsSinceEpoch -
        b.joinedAt.millisecondsSinceEpoch;
  }
}
