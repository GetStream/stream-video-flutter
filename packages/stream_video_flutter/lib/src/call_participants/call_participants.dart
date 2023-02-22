import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/device_segmentation.dart';
import '../widgets/floating_view/floating_view_alignment.dart';
import '../widgets/tile_view.dart';
import 'screen_share_item.dart';

/// The maximum number of participants displayed in a grid on mobile.
const maxParticipantCountMobile = 4;

/// The maximum number of participants displayed in a grid on web.
const maxParticipantCountWeb = 24;

/// Builder function used to build a participant grid item.
typedef CallParticipantWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  CallParticipantState participant,
);

/// Builder function used to build a screen sharing item.
typedef ScreenShareItemBuilder = Widget Function(
  BuildContext context,
  CallParticipantState participant,
);

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatelessWidget {
  /// Creates a new instance of [StreamCallParticipant].
  const StreamCallParticipants({
    required this.call,
    required this.participants,
    this.screenShareItemBuilder,
    this.itemBuilder,
    this.enableFloatingView = true,
    this.enableSnappingBehavior = true,
    super.key,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a screen sharing item.
  final ScreenShareItemBuilder? screenShareItemBuilder;

  /// Builder function used to build a participant grid item.
  final CallParticipantWidgetBuilder? itemBuilder;

  /// Enable picture-in-picture for the current participant.
  final bool enableFloatingView;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool enableSnappingBehavior;

  @override
  Widget build(BuildContext context) {
    final screenShareParticipant = participants.firstWhereOrNull(
      (element) => element.screenShareTrack != null,
    );

    if (screenShareParticipant != null) {
      return ScreenShareCallParticipantsContent(
        call: call,
        participants: participants,
        screenSharingParticipant: screenShareParticipant,
        screenShareItemBuilder: screenShareItemBuilder,
        itemBuilder: itemBuilder,
      );
    } else {
      return RegularCallParticipantsContent(
        call: call,
        participants: participants,
        itemBuilder: itemBuilder,
        enableFloatingView: enableFloatingView,
        enableSnappingBehavior: enableSnappingBehavior,
      );
    }
  }
}

/// A widget that represents the main area of the call when nobody is
/// sharing their screen.
class RegularCallParticipantsContent extends StatefulWidget {
  /// Creates a new instance of [RegularCallParticipantsContent].
  const RegularCallParticipantsContent({
    super.key,
    required this.call,
    required this.participants,
    this.itemBuilder,
    this.enableFloatingView = true,
    this.enableSnappingBehavior = true,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant grid item.
  final CallParticipantWidgetBuilder? itemBuilder;

  /// Enable picture-in-picture for current participant.
  final bool enableFloatingView;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool enableSnappingBehavior;

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

    final remote = participants.where((element) => !element.isLocal).toList();
    final local = participants.where((element) => element.isLocal).toList();
    assert(local.isNotEmpty, 'Local participant is required');

    final maxRemoteParticipantCount =
        isDesktopDevice ? maxParticipantCountWeb : maxParticipantCountMobile;

    final participantsToDisplay = <CallParticipantState>[
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
          widget.itemBuilder?.call(context, i, participantsToDisplay[i]) ??
              StreamCallParticipant(
                call: widget.call,
                participant: participantsToDisplay[i],
              );

      participantWidgets.add(participantWidget);
    }

    final participantGrid = isDesktopDevice
        ? DesktopParticipantGrid(participants: participantWidgets)
        : MobileParticipantGrid(participants: participantWidgets);

    if (!showFloatingParticipant) {
      return participantGrid;
    }

    final floatingTheme = StreamFloatingCallParticipantTheme.of(context);
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
        call: widget.call,
        participant: local.first,
      ),
      child: participantGrid,
    );
  }
}

/// A widget that represents the main area of the call when somebody is
/// sharing their screen.
class ScreenShareCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [ScreenShareCallParticipantsContent].
  const ScreenShareCallParticipantsContent({
    super.key,
    required this.call,
    required this.screenSharingParticipant,
    required this.participants,
    this.screenShareItemBuilder,
    this.itemBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant that shares their screen.
  final CallParticipantState screenSharingParticipant;

  /// The list of participants to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a screen sharing item.
  final ScreenShareItemBuilder? screenShareItemBuilder;

  /// Builder function used to build a participant grid item.
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
                    child: StreamCallParticipant(
                      call: call,
                      participant: participant,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      connectionLevelAlignment: Alignment.topRight,
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

/// Represents the arrangement of participants on desktop devices.
class DesktopParticipantGrid extends StatelessWidget {
  /// Creates a new instance of [DesktopParticipantGrid].
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
      children: participants,
    );
  }
}

/// Represents the arrangement of participants on phones.
class MobileParticipantGrid extends StatelessWidget {
  /// Creates a new instance of [MobileParticipantGrid].
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
