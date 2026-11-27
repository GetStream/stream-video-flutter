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
    this.foldPlaceholderBuilder,
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
  /// mobile while at most two other people are in the call, and to false
  /// otherwise.
  final bool? enableFloatingSelfView;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder callParticipantBuilder;

  /// Builder function used to build the floating self-view.
  final CallParticipantBuilder? floatingSelfViewBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  /// Builds what fills the empty side of a fold while the local participant
  /// is alone in the call.
  ///
  /// Defaults to [StreamWaitingForParticipants].
  final WidgetBuilder? foldPlaceholderBuilder;

  /// The most other participants [ParticipantLayoutMode.auto] floats a
  /// self-view over on mobile.
  ///
  /// A grid past this many tiles is crowded enough on a phone that the inset
  /// would cover one, so the local participant takes a tile of their own.
  static const _maxRemotesBehindSelfView = 2;

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

    final hasFold = StreamDisplayFold.maybeOf(context) != null;
    final isAuto = layoutMode.canonical == ParticipantLayoutMode.auto;
    final effective = _effectiveLayout(
      layoutMode.canonical,
      remoteCount: remoteParticipants.length,
      oneToOneAvoidsFold:
          hasFold &&
          _avoidsFold(context, ParticipantLayoutMode.speakerOneToOne),
    );
    final folded = hasFold && _avoidsFold(context, effective);

    final floatLocalVideo =
        _floatsSelfView(
          effective,
          isAuto: isAuto,
          folded: folded,
          remoteCount: remoteParticipants.length,
        ) &&
        localParticipant != null &&
        remoteParticipants.isNotEmpty;

    // A speaker layout has to have somebody to spotlight; with nobody in the
    // call the grid renders its own empty state.
    final Widget layout;
    if (effective.isSpeakerLayout && participants.isNotEmpty) {
      layout = _speakerLayout(
        effective,
        remoteParticipants: remoteParticipants,
        localParticipant: localParticipant,
        folded: folded,
      );
    } else {
      layout = CallParticipantsGridView(
        call: call,
        participants: [
          for (final participant in participants)
            if (!floatLocalVideo || participant != localParticipant)
              participant,
        ],
        itemBuilder: callParticipantBuilder,
        foldPlaceholderBuilder: foldPlaceholderBuilder,
      );
    }

    if (!floatLocalVideo) return layout;
    return StreamLocalVideo(
      call: call,
      participant: localParticipant,
      participantBuilder: floatingSelfViewBuilder,
      child: layout,
    );
  }

  /// The layout [requested] resolves to.
  ///
  /// [ParticipantLayoutMode.auto] follows the call: one person on the other
  /// end is a conversation and gets their face full-frame, anything else is a
  /// group and gets a grid. When [oneToOneAvoidsFold], a full-frame face, or
  /// a self-view floating over the grid, would sit on the fold, so auto gives
  /// everybody a tile.
  static ParticipantLayoutMode _effectiveLayout(
    ParticipantLayoutMode requested, {
    required int remoteCount,
    required bool oneToOneAvoidsFold,
  }) => switch (requested) {
    ParticipantLayoutMode.auto when remoteCount == 1 && !oneToOneAvoidsFold =>
      ParticipantLayoutMode.speakerOneToOne,
    ParticipantLayoutMode.auto => ParticipantLayoutMode.grid,
    _ => requested,
  };

  /// Whether [effective] floats the local participant over the layout.
  ///
  /// Only speakerOneToOne and auto's grid leave the local participant out of
  /// the arrangement, so only they can float a self-view. An explicitly
  /// requested grid and the four bar layouts give them a tile, where a
  /// self-view would show them twice, so every other case is false whatever
  /// [enableFloatingSelfView] says.
  ///
  /// speakerOneToOne floats on every platform: it shows nobody but the
  /// speaker, so without the inset the local participant is absent from the
  /// call entirely. auto's grid follows the platform and the size of the call
  /// instead.
  bool _floatsSelfView(
    ParticipantLayoutMode effective, {
    required bool isAuto,
    required bool folded,
    required int remoteCount,
  }) => switch (effective) {
    _ when folded => false,
    ParticipantLayoutMode.speakerOneToOne => enableFloatingSelfView ?? true,
    ParticipantLayoutMode.grid when isAuto =>
      enableFloatingSelfView ??
          (!isDesktopDevice && remoteCount <= _maxRemotesBehindSelfView),
    _ => false,
  };

  /// The spotlight view for a speaker layout.
  Widget _speakerLayout(
    ParticipantLayoutMode effective, {
    required Iterable<CallParticipantState> remoteParticipants,
    required CallParticipantState? localParticipant,
    required bool folded,
  }) {
    // A layout with no bar shows nobody but the spotlight, so it goes to a
    // remote whenever there is one. A bar layout can spotlight whoever the
    // sort put first, the local participant included, since everybody else
    // is still in the bar — unless there is only one other person.
    final spotlightsRemote =
        remoteParticipants.isNotEmpty &&
        (effective.barAlignment == null || remoteParticipants.length == 1);
    final spotlight = spotlightsRemote
        ? remoteParticipants.first
        : participants.first;

    // speakerOneToOne shows the speaker alone. The spotlight view hides an
    // empty bar and gives its space to the spotlight. Under a fold it has no
    // self-view to float, so the local participant takes the other side.
    final barParticipants = switch (effective.barAlignment) {
      null when folded && localParticipant != null =>
        spotlight == localParticipant
            ? const <CallParticipantState>[]
            : [localParticipant],
      null => const <CallParticipantState>[],
      _ => [...participants]..remove(spotlight),
    };

    return CallParticipantsSpotlightView(
      call: call,
      spotlight: spotlight,
      participants: barParticipants,
      participantBuilder: callParticipantBuilder,
      barAlignment: effective.barAlignment ?? ParticipantsBarAlignment.bottom,
    );
  }

  /// Whether [layout] keeps its tiles off a fold: the spotlight theme decides
  /// for a speaker layout, the grid theme for the grid.
  static bool _avoidsFold(BuildContext context, ParticipantLayoutMode layout) {
    final foldStyle = layout.isSpeakerLayout
        ? StreamCallParticipantsSpotlightTheme.of(context).foldStyle
        : StreamCallParticipantsGridTheme.of(context).foldStyle;
    return foldStyle?.avoidFold ?? true;
  }
}
