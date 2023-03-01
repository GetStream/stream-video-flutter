import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/tile_view.dart';

/// The maximum number of participants displayed in a grid on mobile.
const maxRemoteParticipantsMobile = 3;

/// The maximum number of participants displayed in a grid on desktop.
const maxRemoteParticipantsDesktop = 24;

/// Builder function used to build a participant item.
typedef CallParticipantBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// Builder function used to build a local video widget.
typedef LocalVideoBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
  Widget localVideoChild,
);

/// Builder function used to build a screen sharing content.
typedef ScreenShareContentBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// Builder function used to build participant item in screen sharing mode.
typedef ScreenShareParticipantBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// A function used to sort the participants.
typedef Filter<T> = bool Function(T element);

/// Comparator used to sort the participants.
typedef Sort<T> = Comparator<T>;

/// The default participant filter.
bool _defaultFilter(CallParticipantState participant) => true;

/// The default participant sort.
///
/// Participants that have recently been dominant speakers go first.
/// The only exception is the local participant who always goes last.
int _defaultSort(CallParticipantState previous, CallParticipantState current) {
  return previous.compareTo(current);
}

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatelessWidget {
  /// Creates a new instance of [StreamCallParticipant].
  const StreamCallParticipants({
    required this.call,
    required this.participants,
    this.filter = _defaultFilter,
    this.sort = _defaultSort,
    this.enableLocalVideo,
    this.callParticipantBuilder,
    this.localVideoBuilder,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder,
    super.key,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Used for filtering the call participants.
  final Filter<CallParticipantState> filter;

  /// Used for sorting the call participants.
  final Sort<CallParticipantState> sort;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder? callParticipantBuilder;

  /// Builder function used to build a local video widget.
  final LocalVideoBuilder? localVideoBuilder;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder? screenShareParticipantBuilder;

  /// Enable local video view for the local participant.
  final bool? enableLocalVideo;

  @override
  Widget build(BuildContext context) {
    final participants = this.participants.where(filter).sorted(sort);

    final screenShareParticipant = participants.firstWhereOrNull(
      (element) => element.screenShareTrack != null,
    );
    // By default we don't show local video on desktop devices.
    final enableLocalVideo = this.enableLocalVideo ?? !isDesktopDevice;

    if (screenShareParticipant != null) {
      return ScreenShareCallParticipantsContent(
        call: call,
        participants: participants,
        screenSharingParticipant: screenShareParticipant,
        screenShareContentBuilder: screenShareContentBuilder,
      );
    } else {
      return RegularCallParticipantsContent(
        call: call,
        participants: participants,
        enableLocalVideo: enableLocalVideo,
        callParticipantBuilder: callParticipantBuilder,
        localVideoBuilder: localVideoBuilder,
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
    this.enableLocalVideo = true,
    this.callParticipantBuilder,
    this.localVideoBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Enable local video view for the local participant.
  final bool enableLocalVideo;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder? callParticipantBuilder;

  /// Builder function used to build a local video widget.
  final LocalVideoBuilder? localVideoBuilder;

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

    final itemBuilder = callParticipantBuilder ??
        (context, call, participant) {
          return StreamCallParticipant(
            call: call,
            participant: participant,
          );
        };

    final participantGrid = isDesktopDevice
        ? DesktopParticipantGrid(
            call: call,
            participants: gridParticipants,
            itemBuilder: itemBuilder,
          )
        : OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return PortraitParticipantGrid(
                  call: call,
                  participants: gridParticipants,
                  itemBuilder: itemBuilder,
                );
              } else {
                return LandscapeParticipantGrid(
                  call: call,
                  participants: gridParticipants,
                  itemBuilder: itemBuilder,
                );
              }
            },
          );

    if (!showLocalVideo) {
      return participantGrid;
    } else {
      return localVideoBuilder?.call(
            context,
            call,
            localParticipant,
            participantGrid,
          ) ??
          StreamLocalVideo(
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
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant that shares their screen.
  final CallParticipantState screenSharingParticipant;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder? screenShareParticipantBuilder;

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
          child: screenShareContentBuilder?.call(
                context,
                call,
                screenSharingParticipant,
              ) ??
              ScreenShareContent(
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
              final participant = participants.elementAt(index);
              return screenShareParticipantBuilder?.call(
                    context,
                    call,
                    participant,
                  ) ??
                  ScreenShareParticipant(
                    call: call,
                    participant: participant,
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
    required this.call,
    required this.participants,
    required this.itemBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final columnCount = sqrt(participants.length - 1).floor() + 1;

    return TileView(
      columnCount: columnCount,
      itemSpacing: 16,
      edgeInsets: const EdgeInsets.all(16),
      children: participants
          .map((participant) => itemBuilder(context, call, participant))
          .toList(),
    );
  }
}

/// Represents the arrangement of participants on mobile phones in portrait
/// mode.
class PortraitParticipantGrid extends StatelessWidget {
  /// Creates a new instance of [PortraitParticipantGrid].
  const PortraitParticipantGrid({
    super.key,
    required this.call,
    required this.participants,
    required this.itemBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final participantsCount = participants.length;
    if (participantsCount == 1) {
      return itemBuilder(context, call, participants[0]);
    } else if (participantsCount == 2) {
      return Column(
        children: [
          Expanded(child: itemBuilder(context, call, participants[0])),
          Expanded(child: itemBuilder(context, call, participants[1])),
        ],
      );
    } else if (participantsCount == 3) {
      return Column(
        children: [
          Expanded(child: itemBuilder(context, call, participants[0])),
          Expanded(
            child: Row(
              children: [
                Expanded(child: itemBuilder(context, call, participants[1])),
                Expanded(child: itemBuilder(context, call, participants[2])),
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
                Expanded(child: itemBuilder(context, call, participants[0])),
                Expanded(child: itemBuilder(context, call, participants[1])),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: itemBuilder(context, call, participants[2])),
                Expanded(child: itemBuilder(context, call, participants[3])),
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
    required this.call,
    required this.participants,
    required this.itemBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: participants
          .map(
            (participant) => Expanded(
              child: itemBuilder(context, call, participant),
            ),
          )
          .toList(),
    );
  }
}
