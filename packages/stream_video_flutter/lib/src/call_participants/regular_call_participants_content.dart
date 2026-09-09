import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'layout/call_participants_grid_view.dart';

/// A widget that represents the main area of the call when nobody is
/// sharing their screen.
class RegularCallParticipantsContent extends StatelessWidget {
  /// Creates a new instance of [RegularCallParticipantsContent].
  const RegularCallParticipantsContent({
    super.key,
    required this.call,
    required this.participants,
    this.callParticipantBuilder = _defaultParticipantBuilder,
    this.enableLocalVideo,
    this.localVideoParticipantBuilder,
    this.layoutMode = ParticipantLayoutMode.auto,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Enable local video view for the local participant.
  final bool? enableLocalVideo;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder callParticipantBuilder;

  /// Builder function used to build a local video participant widget.
  final CallParticipantBuilder? localVideoParticipantBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  // The default participant builder.
  static Widget _defaultParticipantBuilder(
    BuildContext context,
    Call call,
    CallParticipantState participant,
  ) {
    return StreamParticipantTile(
      key: ValueKey(participant.uniqueParticipantKey),
      call: call,
      participant: participant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final remoteParticipants = participants.where((e) => !e.isLocal);
    final localParticipant = participants.where((e) => e.isLocal).firstOrNull;

    // ParticipantLayoutMode.auto follows the call: one person on the other end
    // is a conversation and gets their face full-frame, anything else is a
    // group and gets a grid.
    final requested = layoutMode.canonical;
    final isAuto = requested == ParticipantLayoutMode.auto;
    final effective = switch (isAuto) {
      false => requested,
      true when remoteParticipants.length == 1 =>
        ParticipantLayoutMode.speakerOneToOne,
      true => ParticipantLayoutMode.grid,
    };

    // By default we don't show local video on desktop devices — except under
    // speakerOneToOne, where the floating self-view is the layout rather than
    // an addition to it: without it the layout is a lone spotlight, and the
    // local participant, who has no tile either, disappears from the call.
    final showsSelfView = effective == ParticipantLayoutMode.speakerOneToOne;
    final enableLocalVideo =
        this.enableLocalVideo ?? (showsSelfView || !isDesktopDevice);
    // Only the layouts that leave the local participant out of the arrangement
    // float them over it. The grid and the four bar layouts already give them a
    // tile, and a self-view on top of that would show them twice.
    final floatLocalVideo =
        enableLocalVideo &&
        localParticipant != null &&
        remoteParticipants.isNotEmpty &&
        (isAuto || showsSelfView);

    Widget child;
    if (effective.isSpeakerLayout) {
      var spotlight = participants.first;

      // The frame belongs to somebody else whenever the local participant is
      // already accounted for: floating over the layout, or — in a 1-on-1
      // call — because spotlighting yourself is never what was meant.
      if (remoteParticipants.isNotEmpty &&
          (floatLocalVideo || remoteParticipants.length == 1)) {
        spotlight = remoteParticipants.first;
      }

      // speakerOneToOne shows the speaker alone. The spotlight view hides an
      // empty bar and gives the whole frame to the spotlight.
      final barParticipants = effective.barAlignment == null
          ? const <CallParticipantState>[]
          : ([...participants]..remove(spotlight));

      child = CallParticipantsSpotlightView(
        call: call,
        spotlight: spotlight,
        participants: barParticipants,
        participantBuilder: callParticipantBuilder,
        barAlignment: effective.barAlignment ?? ParticipantsBarAlignment.bottom,
      );
    } else {
      final gridParticipants = [...participants];
      if (floatLocalVideo) gridParticipants.remove(localParticipant);

      child = CallParticipantsGridView(
        call: call,
        participants: gridParticipants,
        itemBuilder: callParticipantBuilder,
      );
    }

    if (floatLocalVideo) {
      child = StreamLocalVideo(
        call: call,
        participant: localParticipant,
        participantBuilder: localVideoParticipantBuilder,
        child: child,
      );
    }

    return child;
  }
}
