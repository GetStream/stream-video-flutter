import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/floating_view/floating_view_alignment.dart';
import '../widgets/tile_view.dart';
import 'screen_share_item.dart';

/// The maximum number of participants displayed in a grid on mobile.
const maxParticipantCountMobile = 4;

/// The maximum number of participants displayed in a grid on web.
const maxParticipantCountWeb = 24;

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
    this.enableSnappingBehavior = true,
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
  final bool enableSnappingBehavior;

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
      enableSnappingBehavior: enableSnappingBehavior,
    );
  }
}

class RegularCallParticipantsContent extends StatefulWidget {
  const RegularCallParticipantsContent({
    super.key,
    required this.participants,
    this.itemBuilder,
    this.enableFloatingView = true,
    this.enableSnappingBehavior = true,
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
  final bool enableSnappingBehavior;

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

    const maxRemoteParticipantCount =
        kIsWeb ? maxParticipantCountWeb : maxParticipantCountMobile;

    final participantsToDisplay = <Participant>[
      // We are only able to show max 3 remote participants in the grid
      // on mobile and 23 on web.
      ...remote.take(maxRemoteParticipantCount - 1),
    ];
    // Show floating local participant if the feature is enabled and there
    // are one or two remote remote participants. Otherwise show local
    // participant in the grid.
    final showFloatingParticipant =
        widget.enableFloatingView && remote.isNotEmpty && remote.length < 3;

    if (!showFloatingParticipant) {
      participantsToDisplay.add(local.first);
    }

    final participantWidgets = <Widget>[];
    for (var i = 0; i < participantsToDisplay.length; i++) {
      final participantWidget =
          widget.itemBuilder?.call(context, i, participants[i]) ??
              StreamCallParticipant(participant: participants[i]);

      participantWidgets.add(participantWidget);
    }

    final participantGrid = kIsWeb
        ? WebParticipantGrid(participants: participantWidgets)
        : MobileParticipantGrid(participants: participantWidgets);

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
      enableSnappingBehavior: widget.enableSnappingBehavior,
      floatingViewPadding: floatingParticipantPadding,
      floatingViewAlignment: FloatingViewAlignment.topRight,
      floatingView: StreamFloatingCallParticipant(
        participant: local.first,
      ),
      child: participantGrid,
    );
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

/// Represents the arrangement of participants on web.
class WebParticipantGrid extends StatelessWidget {
  /// Constructor for creating [WebParticipantGrid].
  const WebParticipantGrid({
    super.key,
    required this.participants,
  });

  /// The widgets to display.
  final List<Widget> participants;

  @override
  Widget build(BuildContext context) {
    final columnCount = sqrt(participants.length - 1).floor() + 1;

    return TileView(
      columnCount: columnCount,
      itemSpacing: 16,
      edgeInsets: const EdgeInsets.all(16),
      children: participants
          .map(
            (participant) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: participant,
            ),
          )
          .toList(),
    );
  }
}

/// Represents the arrangement of participants on phones.
class MobileParticipantGrid extends StatelessWidget {
  /// Constructor for creating [MobileParticipantGrid].
  const MobileParticipantGrid({
    super.key,
    required this.participants,
  });

  /// The widgets to display.
  final List<Widget> participants;

  @override
  Widget build(BuildContext context) {
    Widget participantGrid = Container();

    final participantsCount = participants.length;
    if (participantsCount == 1) {
      participantGrid = participants[0];
    } else if (participantsCount == 2) {
      participantGrid = Column(
        children: [
          Expanded(child: participants[0]),
          Expanded(child: participants[1]),
        ],
      );
    } else if (participantsCount == 3) {
      participantGrid = Column(
        children: [
          Expanded(child: participants[0]),
          Expanded(
            child: Row(
              children: [
                Expanded(child: participants[1]),
                Expanded(child: participants[2]),
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
                Expanded(child: participants[0]),
                Expanded(child: participants[1]),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: participants[2]),
                Expanded(child: participants[3]),
              ],
            ),
          ),
        ],
      );
    }

    return participantGrid;
  }
}
