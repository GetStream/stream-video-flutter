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
    this.enableFloatingSelfView,
    this.floatingSelfViewBuilder,
    this.layoutMode = ParticipantLayoutMode.auto,
  });

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Whether the local participant's self-view floats over the layout.
  ///
  /// Only [ParticipantLayoutMode.auto] and
  /// [ParticipantLayoutMode.speakerOneToOne] read it, the layouts that leave
  /// the local participant out of the arrangement. The grid and the four bar
  /// layouts give them a tile, so a self-view would show them twice.
  ///
  /// Defaults to true under `speakerOneToOne`, which `auto` resolves to in a
  /// one-on-one call. Under `auto` in a group call it defaults to true on
  /// mobile and false on desktop.
  final bool? enableFloatingSelfView;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder callParticipantBuilder;

  /// Builder function used to build the floating self-view.
  final CallParticipantBuilder? floatingSelfViewBuilder;

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

    // Only these two layouts leave the local participant out of the
    // arrangement, so only they can float a self-view. An explicitly
    // requested grid and the four bar layouts give them a tile, where a
    // self-view would show them twice, so every other case is false whatever
    // enableFloatingSelfView says. auto's grid still floats one.
    //
    // speakerOneToOne floats on every platform: it shows nobody but the
    // speaker, so without the inset the local participant is absent from the
    // call entirely. auto's grid follows the platform instead.
    final floatsSelfView = switch (effective) {
      ParticipantLayoutMode.speakerOneToOne => enableFloatingSelfView ?? true,
      ParticipantLayoutMode.grid when isAuto =>
        enableFloatingSelfView ?? !isDesktopDevice,
      _ => false,
    };

    final floatLocalVideo =
        floatsSelfView &&
        localParticipant != null &&
        remoteParticipants.isNotEmpty;

    Widget child;
    // A speaker layout has to have somebody to spotlight; with nobody in the
    // call the grid renders its own empty state.
    if (effective.isSpeakerLayout && participants.isNotEmpty) {
      var spotlight = participants.first;

      // Somebody else takes the frame whenever the local participant is
      // already accounted for: floating over the layout, or alone with one
      // other person.
      if (remoteParticipants.isNotEmpty &&
          (floatLocalVideo || remoteParticipants.length == 1)) {
        spotlight = remoteParticipants.first;
      }

      // speakerOneToOne shows the speaker alone. The spotlight view hides an
      // empty bar and gives its space to the spotlight.
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
        participantBuilder: floatingSelfViewBuilder,
        child: child,
      );
    }

    return child;
  }
}
