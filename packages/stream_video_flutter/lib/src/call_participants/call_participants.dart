import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/floating_view/floating_view_alignment.dart';
import 'screen_share_item.dart';

/// {@template callParticipantWidgetBuilder}
/// Builder function used to build a participant grid item.
/// {@endtemplate}
typedef CallParticipantWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  Participant participant,
);

/// {@template screenShareItemBuilder}
/// Builder function used to build a screen sharing item.
/// {@endtemplate}
typedef ScreenShareItemBuilder = Widget Function(
  BuildContext context,
  Participant participant,
);

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatelessWidget {
  const StreamCallParticipants({
    required this.participants,
    this.screenShareItemBuilder,
    this.itemBuilder,
    this.enableFloatingView = true,
    this.isSnappingBehaviorEnabled = true,
    this.floatingParticipantTheme,
    super.key,
  });

  /// The list of participants to display.
  final List<Participant> participants;

  /// {@macro screenShareItemBuilder}
  final ScreenShareItemBuilder? screenShareItemBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilder? itemBuilder;

  /// Enable picture-in-picture for current participant
  final bool enableFloatingView;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool isSnappingBehaviorEnabled;

  /// Theme for participant pip window
  final StreamFloatingCallParticipantTheme? floatingParticipantTheme;

  @override
  Widget build(BuildContext context) {
    final screenSharingParticipant = participants.firstWhereOrNull(
      (p) => p.hasScreenShare,
    );

    if (screenSharingParticipant != null) {
      return ScreenSharingCallParticipantsContent(
        participants: participants,
        screenSharingParticipant: screenSharingParticipant,
        screenShareItemBuilder: screenShareItemBuilder,
        itemBuilder: itemBuilder,
      );
    }

    return RegularCallParticipantsContent(
      participants: participants,
      itemBuilder: itemBuilder,
      enableFloatingView: enableFloatingView,
      floatingParticipantTheme: floatingParticipantTheme,
      isSnappingBehaviorEnabled: isSnappingBehaviorEnabled,
    );
  }
}

class RegularCallParticipantsContent extends StatefulWidget {
  const RegularCallParticipantsContent({
    super.key,
    required this.participants,
    this.itemBuilder,
    this.enableFloatingView = true,
    this.isSnappingBehaviorEnabled = true,
    this.floatingParticipantTheme,
  });

  /// The list of participants to display.
  final List<Participant> participants;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilder? itemBuilder;

  /// Enable picture-in-picture for current participant
  final bool enableFloatingView;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool isSnappingBehaviorEnabled;

  /// Theme for participant pip window
  final StreamFloatingCallParticipantTheme? floatingParticipantTheme;

  @override
  State<RegularCallParticipantsContent> createState() =>
      _RegularCallParticipantsContentState();
}

class _RegularCallParticipantsContentState
    extends State<RegularCallParticipantsContent> {
  final bottomRightOffset =
      ValueNotifier<Offset>(const Offset(0, double.infinity));

  @override
  Widget build(BuildContext context) {
    final participants = widget.participants;
    participants.sort(_participantComparator);
    final remote = participants.whereType<RemoteParticipant>().toList();
    final local = participants.whereType<LocalParticipant>().toList();
    assert(local.isNotEmpty, 'Local participant is required');

    final participantsToDisplay = <Participant>[
      // We are only able to show max 3 remote participants in the grid.
      ...remote.take(3),
    ];
    // Show floating local participant if the feature is enabled and there
    // are one or two remote remote participants. Otherwise show local
    // participant in the grid.
    final showFloatingParticipant =
        widget.enableFloatingView && remote.isNotEmpty && remote.length < 3;

    if (!showFloatingParticipant) {
      participantsToDisplay.add(local.first);
    }

    Widget participantGrid = Container();
    final participantsCount = participantsToDisplay.length;
    if (participantsCount == 1) {
      participantGrid = _buildParticipant(participantsToDisplay, 0);
    } else if (participantsCount == 2) {
      participantGrid = Column(
        children: [
          Expanded(child: _buildParticipant(participantsToDisplay, 0)),
          Expanded(child: _buildParticipant(participantsToDisplay, 1)),
        ],
      );
    } else if (participantsCount == 3) {
      participantGrid = Column(
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
    } else if (participantsCount == 4) {
      participantGrid = Column(
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
    }

    if (!showFloatingParticipant) {
      return participantGrid;
    }

    final streamChatTheme =
        StreamVideoTheme.of(context).floatingCallParticipantTheme;
    final floatingTheme = widget.floatingParticipantTheme ?? streamChatTheme;
    final floatingParticipantWidth = floatingTheme.floatingParticipantWidth;
    final floatingParticipantHeight = floatingTheme.floatingParticipantHeight;
    final floatingParticipantPadding = floatingTheme.floatingParticipantPadding;

    return FloatingViewContainer(
      floatingViewWidth: floatingParticipantWidth,
      floatingViewHeight: floatingParticipantHeight,
      isSnappingBehaviorEnabled: true,
      floatingViewPadding: floatingParticipantPadding,
      floatingViewAlignment: FloatingViewAlignment.topRight,
      floatingView: StreamFloatingCallParticipant(
        participant: local.first,
      ),
      child: participantGrid,
    );
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

class ScreenSharingCallParticipantsContent extends StatelessWidget {
  const ScreenSharingCallParticipantsContent({
    super.key,
    required this.screenSharingParticipant,
    required this.participants,
    this.screenShareItemBuilder,
    this.itemBuilder,
  });

  final Participant screenSharingParticipant;

  /// The list of participants to display.
  final List<Participant> participants;

  final ScreenShareItemBuilder? screenShareItemBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          ' ${screenSharingParticipant.userId} is presenting',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.title3Bold.copyWith(
            color: theme.colorTheme.textHighEmphasis,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: screenShareItemBuilder?.call(
                context,
                screenSharingParticipant,
              ) ??
              ScreenShareItem(
                participant: screenSharingParticipant,
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 125,
          child: ListView.separated(
            itemCount: participants.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final participant = participants[index];
              return itemBuilder?.call(context, index, participant) ??
                  SizedBox(
                    width: 150,
                    child: StreamCallParticipant(
                      participant: participant,
                      theme: const StreamCallParticipantTheme(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        connectionLevelAlignment: Alignment.topRight,
                      ),
                    ),
                  );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
