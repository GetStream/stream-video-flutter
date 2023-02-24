import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/device_segmentation.dart';
import '../widgets/tile_view.dart';
import 'screen_share_item.dart';

/// The maximum number of participants displayed in a grid on mobile.
const maxRemoteParticipantsMobile = 3;

/// The maximum number of participants displayed in a grid on desktop.
const maxRemoteParticipantsDesktop = 24;

/// Builder function used to build a participant grid item.
typedef CallParticipantWidgetBuilder = Widget Function(
  BuildContext context,
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
    this.enableLocalVideo = true,
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
  final bool enableLocalVideo;

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
        enableLocalVideo: enableLocalVideo,
      );
    }
  }
}

/// A widget that represents the main area of the call when nobody is
/// sharing their screen.
class RegularCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [RegularCallParticipantsContent].
  const RegularCallParticipantsContent({
    super.key,
    required this.call,
    required this.participants,
    this.itemBuilder,
    this.enableLocalVideo = true,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant grid item.
  final CallParticipantWidgetBuilder? itemBuilder;

  /// Enable picture-in-picture for current participant.
  final bool enableLocalVideo;

  @override
  Widget build(BuildContext context) {
    final remoteParticipants = participants.where((e) => !e.isLocal).toList();
    final localParticipant = participants.where((e) => e.isLocal).first;
    final remoteParticipantCount = remoteParticipants.length;

    final showLocalVideo = enableLocalVideo &&
        (isDesktopDevice
            ? (remoteParticipantCount >= 1)
            : (remoteParticipantCount == 1 || remoteParticipantCount == 2));

    final gridParticipants = <CallParticipantState>[
      ...remoteParticipants.take(
        isDesktopDevice
            ? maxRemoteParticipantsDesktop
            : maxRemoteParticipantsMobile,
      ),
      if (!showLocalVideo) localParticipant
    ];

    final itemBuilder = this.itemBuilder ??
        (context, participant) {
          return StreamCallParticipant(
            call: call,
            participant: participant,
          );
        };

    final participantGrid = isDesktopDevice
        ? DesktopParticipantGrid(
            participants: gridParticipants,
            itemBuilder: itemBuilder,
          )
        : OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return PortraitParticipantGrid(
                  participants: gridParticipants,
                  itemBuilder: itemBuilder,
                );
              } else {
                return LandscapeParticipantGrid(
                  participants: gridParticipants,
                  itemBuilder: itemBuilder,
                );
              }
            },
          );

    if (!showLocalVideo) {
      return participantGrid;
    } else {
      return StreamLocalVideo(
        call: call,
        localParticipant: localParticipant,
        child: participantGrid,
      );
    }
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
              return itemBuilder?.call(context, participant) ??
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
    required this.itemBuilder,
  });

  /// The list of participants display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final columnCount = sqrt(participants.length - 1).floor() + 1;

    return TileView(
      columnCount: columnCount,
      itemSpacing: 16,
      edgeInsets: const EdgeInsets.all(16),
      children: participants.map((e) => itemBuilder(context, e)).toList(),
    );
  }
}

/// Represents the arrangement of participants on mobile phones in portrait
/// mode.
class PortraitParticipantGrid extends StatelessWidget {
  /// Creates a new instance of [PortraitParticipantGrid].
  const PortraitParticipantGrid({
    super.key,
    required this.participants,
    required this.itemBuilder,
  });

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final participantsCount = participants.length;
    if (participantsCount == 1) {
      return itemBuilder(context, participants[0]);
    } else if (participantsCount == 2) {
      return Column(
        children: [
          Expanded(child: itemBuilder(context, participants[0])),
          Expanded(child: itemBuilder(context, participants[1])),
        ],
      );
    } else if (participantsCount == 3) {
      return Column(
        children: [
          Expanded(child: itemBuilder(context, participants[0])),
          Expanded(
            child: Row(
              children: [
                Expanded(child: itemBuilder(context, participants[1])),
                Expanded(child: itemBuilder(context, participants[2])),
              ],
            ),
          ),
        ],
      );
    } else if (participantsCount == 4) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: itemBuilder(context, participants[0])),
                Expanded(child: itemBuilder(context, participants[1])),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: itemBuilder(context, participants[2])),
                Expanded(child: itemBuilder(context, participants[3])),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

/// Represents the arrangement of participants on mobile phones in landscape
/// mode.
class LandscapeParticipantGrid extends StatelessWidget {
  /// Creates a new instance of [LandscapeParticipantGrid].
  const LandscapeParticipantGrid({
    super.key,
    required this.participants,
    required this.itemBuilder,
  });

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: participants
          .map(
            (e) => Expanded(
              child: itemBuilder(context, e),
            ),
          )
          .toList(),
    );
  }
}
