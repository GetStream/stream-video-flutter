import 'dart:math';

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
    this.enablePip = false,
    this.floatingParticipantTheme,
    Key? key,
  }) : super(key: key);

  /// The list of participants to display.
  final List<Participant> participants;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilder? itemBuilder;

  /// Enable picture-in-picture for current participant
  final bool enablePip;

  /// Theme for participant pip window
  final StreamFloatingCallParticipantTheme? floatingParticipantTheme;

  @override
  State<StatefulWidget> createState() {
    return _StreamCallParticipantsState();
  }
}

class _StreamCallParticipantsState extends State<StreamCallParticipants> {
  var floatingBottomRightDiff = ValueNotifier<Offset>(const Offset(8, 8));

  @override
  Widget build(BuildContext context) {
    final participants = widget.participants;
    final remote = participants.whereType<RemoteParticipant>().toList();
    final local = participants.whereType<LocalParticipant>().toList();

    final List<Participant> participantsToDisplay = [];
    if (local.isEmpty) {
      participantsToDisplay.addAll(remote.take(4).toList());
    } else {
      participantsToDisplay.addAll(remote.take(3).toList());
      if (!widget.enablePip) {
        participantsToDisplay.add(local.first);
      }
    }

    Widget? backgroundWidget;

    switch (participantsToDisplay.length) {
      case 1:
        backgroundWidget =
            StreamCallParticipant(participant: participantsToDisplay[0]);
        break;
      case 2:
        backgroundWidget = Column(
          children: [
            Expanded(child: _buildParticipant(participantsToDisplay, 0)),
            Expanded(child: _buildParticipant(participantsToDisplay, 1)),
          ],
        );
        break;
      case 3:
        backgroundWidget = Column(
          children: [
            Expanded(child: _buildParticipant(participantsToDisplay, 0)),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildParticipant(participantsToDisplay, 1)),
                  Expanded(child: _buildParticipant(participantsToDisplay, 2)),
                ],
              ),
            ),
          ],
        );
        break;
      case 4:
        backgroundWidget = Column(
          children: [
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
          ],
        );
        break;
      default:
        backgroundWidget = Container();
    }

    if (widget.enablePip && local.isNotEmpty) {
      final streamChatTheme =
          StreamVideoTheme.of(context).floatingCallParticipantTheme;
      final floatingTheme = widget.floatingParticipantTheme ?? streamChatTheme;

      return Stack(
        children: [
          backgroundWidget,
          ValueListenableBuilder(
            valueListenable: floatingBottomRightDiff,
            builder: (context, val, child) {
              var offset = floatingBottomRightDiff.value;

              return Positioned(
                right: offset.dx,
                bottom: offset.dy,
                child: GestureDetector(
                  onPanUpdate: (drag) {
                    var dx = drag.delta.dx;
                    var dy = drag.delta.dy;

                    var size = MediaQuery.of(context).size;
                    var maxRight = size.width - floatingTheme.width;
                    var maxTop = size.height - floatingTheme.height;

                    floatingBottomRightDiff.value = Offset(
                      max(0, min(offset.dx - dx, maxRight)),
                      max(0, min(offset.dy - dy, maxTop)),
                    );
                  },
                  child: StreamFloatingCallParticipant(
                    participant: local.first,
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return backgroundWidget;
    }
  }

  Widget _buildParticipant(List<Participant> participants, int index) {
    final participant = participants[index];

    return widget.itemBuilder?.call(context, index, participant) ??
        StreamCallParticipant(participant: participant);
  }
}
