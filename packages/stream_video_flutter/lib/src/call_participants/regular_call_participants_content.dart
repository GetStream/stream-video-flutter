import 'dart:math';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/tile_view.dart';
import 'overlay_app_bar.dart';

/// A widget that represents the main area of the call when nobody is
/// sharing their screen.
class RegularCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [RegularCallParticipantsContent].
  const RegularCallParticipantsContent({
    super.key,
    required this.call,
    required this.participants,
    this.enableLocalVideo,
    this.onLeaveCallTap,
    this.onBackPressed,
    this.callParticipantBuilder,
    this.localVideoBuilder,
    this.callControlsBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Enable local video view for the local participant.
  final bool? enableLocalVideo;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder? callParticipantBuilder;

  /// Builder function used to build a local video widget.
  final LocalVideoBuilder? localVideoBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

  @override
  Widget build(BuildContext context) {
    final remoteParticipants = participants.where((e) => !e.isLocal).toList();
    final localParticipant = participants.where((e) => e.isLocal).first;
    final remoteParticipantCount = remoteParticipants.length;
    // By default we don't show local video on desktop devices.
    final enableLocalVideo = this.enableLocalVideo ?? !isDesktopDevice;

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

    Widget participantsWidget = isDesktopDevice
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

    participantsWidget = !showLocalVideo
        ? participantsWidget
        : localVideoBuilder?.call(
              context,
              call,
              localParticipant,
              participantsWidget,
            ) ??
            StreamLocalVideo(
              call: call,
              localParticipant: localParticipant,
              child: participantsWidget,
            );

    final callState = call.state.value;
    if (isMobileLandscape(context)) {
      return Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                participantsWidget,
                OverlayAppBar(call: call),
              ],
            ),
          ),
          callControlsBuilder?.call(context, call, callState) ??
              StreamCallControls.withDefaultOptions(
                call: call,
                localParticipant: callState.localParticipant!,
                onLeaveCallTap: onLeaveCallTap,
              )
        ],
      );
    } else {
      return participantsWidget;
    }
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
