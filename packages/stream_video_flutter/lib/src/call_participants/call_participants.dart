import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'regular_call_participants_content.dart';
import 'screen_share_call_participants_content.dart';

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
    this.onLeaveCallTap,
    this.onBackPressed,
    this.callParticipantBuilder,
    this.localVideoBuilder,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder,
    this.callControlsBuilder,
    this.overlayAppBarBuilder,
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
    final participants = this.participants.where(filter).sorted(sort);

    final screenShareParticipant = participants.firstWhereOrNull(
      (element) => element.screenShareTrack != null,
    );

    if (screenShareParticipant == null) {
      return RegularCallParticipantsContent(
        call: call,
        participants: participants,
        enableLocalVideo: enableLocalVideo,
        onLeaveCallTap: onLeaveCallTap,
        onBackPressed: onBackPressed,
        callParticipantBuilder: callParticipantBuilder,
        localVideoBuilder: localVideoBuilder,
        callControlsBuilder: callControlsBuilder,
        overlayAppBarBuilder: overlayAppBarBuilder,
      );
    } else {
      return ScreenShareCallParticipantsContent(
        call: call,
        participants: participants,
        screenSharingParticipant: screenShareParticipant,
        onLeaveCallTap: onLeaveCallTap,
        onBackPressed: onBackPressed,
        screenShareContentBuilder: screenShareContentBuilder,
        callControlsBuilder: callControlsBuilder,
        overlayAppBarBuilder: overlayAppBarBuilder,
      );
    }
  }
}
