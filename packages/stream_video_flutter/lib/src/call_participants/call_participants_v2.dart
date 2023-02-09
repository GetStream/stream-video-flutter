import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/src/call_participants/screen_share_item_v2.dart';

import '../../stream_video_flutter.dart';
import '../utils/device_segmentation.dart';
import '../widgets/floating_view/floating_view_alignment.dart';
import '../widgets/tile_view.dart';
import 'call_participant_v2.dart';
import 'floating_call_participant_v2.dart';

/// The maximum number of participants displayed in a grid on mobile.
const maxParticipantCountMobile = 4;

/// The maximum number of participants displayed in a grid on web.
const maxParticipantCountWeb = 24;

/// {@template callParticipantWidgetBuilder}
/// Builder function used to build a participant grid item.
/// {@endtemplate}
typedef CallParticipantWidgetBuilderV2 = Widget Function(
  BuildContext context,
  int index,
  CallParticipantStateV2 participant,
);

/// {@template screenShareItemBuilder}
/// Builder function used to build a screen sharing item.
/// {@endtemplate}
typedef ScreenShareItemBuilderV2 = Widget Function(
  BuildContext context,
  CallParticipantStateV2 participant,
);

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipantsV2 extends StatelessWidget {
  const StreamCallParticipantsV2({
    required this.call,
    required this.participants,
    this.screenShareItemBuilder,
    this.itemBuilder,
    this.enableFloatingView = true,
    this.enableSnappingBehavior = true,
    this.floatingParticipantTheme,
    super.key,
  });

  final CallV2 call;

  /// The list of participants to display.
  final List<CallParticipantStateV2> participants;

  /// {@macro screenShareItemBuilder}
  final ScreenShareItemBuilderV2? screenShareItemBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilderV2? itemBuilder;

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
      (p) => p.publishedTracks.containsKey(SfuTrackType.screenShare),
    );

    if (screenSharingParticipant != null) {
      return ScreenSharingCallParticipantsContentV2(
        call: call,
        participants: participants,
        screenSharingParticipant: screenSharingParticipant,
        screenShareItemBuilder: screenShareItemBuilder,
        itemBuilder: itemBuilder,
      );
    }

    return RegularCallParticipantsContentV2(
      call: call,
      participants: participants,
      itemBuilder: itemBuilder,
      enableFloatingView: enableFloatingView,
      floatingParticipantTheme: floatingParticipantTheme,
      enableSnappingBehavior: enableSnappingBehavior,
    );
  }
}

class RegularCallParticipantsContentV2 extends StatefulWidget {
  const RegularCallParticipantsContentV2({
    super.key,
    required this.call,
    required this.participants,
    this.itemBuilder,
    this.enableFloatingView = true,
    this.enableSnappingBehavior = true,
    this.floatingParticipantTheme,
  });

  final CallV2 call;

  /// The list of participants to display.
  final List<CallParticipantStateV2> participants;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilderV2? itemBuilder;

  /// Enable picture-in-picture for current participant
  final bool enableFloatingView;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool enableSnappingBehavior;

  /// Theme for participant pip window
  final StreamFloatingCallParticipantTheme? floatingParticipantTheme;

  @override
  State<RegularCallParticipantsContentV2> createState() =>
      _RegularCallParticipantsContentStateV2();
}

class _RegularCallParticipantsContentStateV2
    extends State<RegularCallParticipantsContentV2> {
  final bottomRightOffset =
      ValueNotifier<Offset>(const Offset(0, double.infinity));

  @override
  Widget build(BuildContext context) {
    final participants = widget.participants;
    // participants.sort(_participantComparator);

    final remote = participants.where((element) => !element.isLocal).toList();
    final local = participants.where((element) => element.isLocal).toList();
    assert(local.isNotEmpty, 'Local participant is required');

    final maxRemoteParticipantCount =
        isDesktopDevice ? maxParticipantCountWeb : maxParticipantCountMobile;

    final participantsToDisplay = <CallParticipantStateV2>[
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
              StreamCallParticipantV2(
                  call: widget.call, participant: participants[i]);

      participantWidgets.add(participantWidget);
    }

    final participantGrid = isDesktopDevice
        ? DesktopParticipantGrid(participants: participantWidgets)
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
      floatingView: StreamFloatingCallParticipantV2(
        call: widget.call,
        participant: local.first,
      ),
      child: participantGrid,
    );
  }

  // int _participantComparator(CallParticipantStateV2 a, CallParticipantStateV2 b) {
  //   final aLastSpokeAt = a.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
  //   final bLastSpokeAt = b.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
  //
  //   if (aLastSpokeAt != bLastSpokeAt) {
  //     return aLastSpokeAt > bLastSpokeAt ? -1 : 1;
  //   }
  //
  //   return a.joinedAt.millisecondsSinceEpoch -
  //       b.joinedAt.millisecondsSinceEpoch;
  // }
}

class ScreenSharingCallParticipantsContentV2 extends StatelessWidget {
  const ScreenSharingCallParticipantsContentV2({
    super.key,
    required this.call,
    required this.screenSharingParticipant,
    required this.participants,
    this.screenShareItemBuilder,
    this.itemBuilder,
  });

  final CallV2 call;

  final CallParticipantStateV2 screenSharingParticipant;

  /// The list of participants to display.
  final List<CallParticipantStateV2> participants;

  final ScreenShareItemBuilderV2? screenShareItemBuilder;

  /// {@macro callParticipantWidgetBuilder}
  final CallParticipantWidgetBuilderV2? itemBuilder;

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
              ScreenShareItemV2(
                call: call,
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
                    child: StreamCallParticipantV2(
                      call: call,
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

/// Represents the arrangement of participants on desktop.
class DesktopParticipantGrid extends StatelessWidget {
  /// Constructor for creating [DesktopParticipantGrid].
  const DesktopParticipantGrid({
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
