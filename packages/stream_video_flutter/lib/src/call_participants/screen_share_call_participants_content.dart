import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'overlay_app_bar.dart';

/// A widget that represents the main area of the call when somebody is
/// sharing their screen.
class ScreenShareCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [ScreenShareCallParticipantsContent].
  const ScreenShareCallParticipantsContent({
    super.key,
    required this.call,
    required this.screenSharingParticipant,
    required this.participants,
    this.onLeaveCallTap,
    this.onBackPressed,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder,
    this.callControlsBuilder,
    this.overlayAppBarBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant that shares their screen.
  final CallParticipantState screenSharingParticipant;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder? screenShareParticipantBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

  /// Builder used to create a custom call app bar in landscape mode.
  final OverlayAppBarBuilder? overlayAppBarBuilder;

  @override
  Widget build(BuildContext context) {
    if (isMobileLandscape(context)) {
      return LandscapeScreenShareCallParticipantsContent(
        call: call,
        screenSharingParticipant: screenSharingParticipant,
        participants: participants,
        onLeaveCallTap: onLeaveCallTap,
        onBackPressed: onBackPressed,
        screenShareContentBuilder: screenShareContentBuilder,
        screenShareParticipantBuilder: screenShareParticipantBuilder,
        callControlsBuilder: callControlsBuilder,
        overlayAppBarBuilder: overlayAppBarBuilder,
      );
    } else {
      return PortraitScreenShareCallParticipantsContent(
        call: call,
        screenSharingParticipant: screenSharingParticipant,
        participants: participants,
        onLeaveCallTap: onLeaveCallTap,
        screenShareContentBuilder: screenShareContentBuilder,
        screenShareParticipantBuilder: screenShareParticipantBuilder,
      );
    }
  }
}

/// A widget that represents the main area of the call when somebody is
/// sharing their screen.
class PortraitScreenShareCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [PortraitScreenShareCallParticipantsContent].
  const PortraitScreenShareCallParticipantsContent({
    super.key,
    required this.call,
    required this.screenSharingParticipant,
    required this.participants,
    this.onLeaveCallTap,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder,
    this.callControlsBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant that shares their screen.
  final CallParticipantState screenSharingParticipant;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder? screenShareParticipantBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

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
        SizedBox(
          height: 128,
          child: ListView.separated(
            itemCount: participants.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
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
      ],
    );
  }
}

/// A widget that represents the main area of the call when somebody is
/// sharing their screen.
class LandscapeScreenShareCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [LandscapeScreenShareCallParticipantsContent].
  const LandscapeScreenShareCallParticipantsContent({
    super.key,
    required this.call,
    required this.screenSharingParticipant,
    required this.participants,
    this.onLeaveCallTap,
    this.onBackPressed,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder,
    this.callControlsBuilder,
    this.overlayAppBarBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant that shares their screen.
  final CallParticipantState screenSharingParticipant;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder? screenShareParticipantBuilder;

  /// Builder used to create a custom call controls panel.
  final CallControlsBuilder? callControlsBuilder;

  /// Builder used to create a custom call app bar in landscape mode.
  final OverlayAppBarBuilder? overlayAppBarBuilder;

  @override
  Widget build(BuildContext context) {
    final callState = call.state.value;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              screenShareContentBuilder?.call(
                    context,
                    call,
                    screenSharingParticipant,
                  ) ??
                  ScreenShareContent(
                    call: call,
                    participant: screenSharingParticipant,
                  ),
              overlayAppBarBuilder?.call(context, call, callState) ??
                  OverlayAppBar(
                    call: call,
                    onBackPressed: onBackPressed,
                  ),
            ],
          ),
        ),
        SizedBox(
          width: 128,
          child: ListView.separated(
            itemCount: participants.length,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
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
        callControlsBuilder?.call(context, call, callState) ??
            StreamCallControls.withDefaultOptions(
              call: call,
              localParticipant: callState.localParticipant!,
              onLeaveCallTap: onLeaveCallTap,
            )
      ],
    );
  }
}
