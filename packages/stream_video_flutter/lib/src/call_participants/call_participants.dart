// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'regular_call_participants_content.dart';
import 'screen_share_call_participants_content.dart';

final _logger = taggedLogger(tag: 'SV:CallParticipants');

/// Builder function used to build a participant item.
typedef CallParticipantBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallParticipantState participant,
    );

/// Builder function used to build a screen sharing content.
typedef ScreenShareContentBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallParticipantState participant,
    );

/// Builder function used to build participant item in screen sharing mode.
typedef ScreenShareParticipantBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallParticipantState participant,
    );

/// A function used to sort the participants.
typedef CallParticipantFilter<T> = bool Function(T element);

/// A comparator for participants, and what says when it has changed.
///
/// [StreamCallParticipants] orders the list again when the sort it was given
/// is no longer the one it has, which it decides with `==`. A comparator on its
/// own cannot answer that — a closure written inline is a new function on every
/// build, and comparing those would reorder the list every time. So the
/// comparator is paired with an [identity]: two sorts carrying equal identities
/// are the same sort, whatever functions they hold.
///
/// ```dart
/// StreamCallParticipants(
///   sort: CallParticipantSort(
///     (a, b) => a.name.compareTo(b.name),
///     identity: 'by-name',
///   ),
/// )
/// ```
///
/// Without an [identity] a sort is only ever equal to itself, so one built
/// inline reorders the list on every build. Give it an identity, or hold onto
/// the instance.
@immutable
class CallParticipantSort<T> {
  /// Creates a sort from [compare], identified by [identity].
  const CallParticipantSort(this.compare, {this.identity});

  /// Orders two participants, as [Comparator] does.
  final Comparator<T> compare;

  /// What tells this sort apart from another.
  ///
  /// Anything with a meaningful `==` — a string naming the sort is the usual
  /// choice. Null means the sort cannot be told apart from another, so it is
  /// only equal to itself.
  final Object? identity;

  /// Orders two participants, so that this can be passed wherever a
  /// [Comparator] is expected.
  int call(T a, T b) => compare(a, b);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallParticipantSort<T> &&
        identity != null &&
        other.identity == identity;
  }

  @override
  int get hashCode => identity?.hashCode ?? identityHashCode(this);
}

/// The sorts the SDK's own layouts order their participants with.
///
/// Each wraps the matching [CallParticipantSortingPresets] comparator and is
/// held once, so a layout that has not changed hands back the same sort and
/// nothing is reordered for it.
abstract final class CallParticipantSorts {
  /// Orders participants the way the grid and the default layout want them.
  static final regular = CallParticipantSort(
    CallParticipantSortingPresets.regular,
    identity: 'stream:regular',
  );

  /// Orders participants the way the speaker layouts want them.
  static final speaker = CallParticipantSort(
    CallParticipantSortingPresets.speaker,
    identity: 'stream:speaker',
  );

  /// Orders participants the way picture-in-picture wants them.
  static final pictureInPicture = CallParticipantSort(
    CallParticipantSortingPresets.pictureInPicture,
    identity: 'stream:picture-in-picture',
  );

  /// Orders participants the way livestreams and audio rooms want them.
  static final livestreamOrAudioRoom = CallParticipantSort(
    CallParticipantSortingPresets.livestreamOrAudioRoom,
    identity: 'stream:livestream-or-audio-room',
  );
}

/// Widget that renders all the [StreamParticipantTile], based on the number
/// of people in a call.
class StreamCallParticipants extends StatefulWidget {
  /// Creates a new instance of [StreamCallParticipants].
  StreamCallParticipants({
    super.key,
    required this.call,
    this.participants,
    this.filter = _defaultFilter,
    CallParticipantSort<CallParticipantState>? sort,
    this.enableFloatingSelfView,
    this.callParticipantBuilder = _defaultParticipantBuilder,
    this.floatingSelfViewBuilder,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder = _defaultParticipantBuilder,
    this.layoutMode = ParticipantLayoutMode.auto,
  }) : sort = sort ?? layoutMode.sorting;

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  /// If provided these [participants] will be used, otherwise the participants of the [call] will be used.
  final List<CallParticipantState>? participants;

  /// Used for filtering the call participants.
  final CallParticipantFilter<CallParticipantState> filter;

  /// Used for sorting the call participants.
  ///
  /// Defaults to [layoutMode]'s own sort. Replacing it reorders the list on the
  /// spot when the new sort is not equal to the old one, which
  /// [CallParticipantSort.identity] is what decides.
  final CallParticipantSort<CallParticipantState> sort;

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

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder screenShareParticipantBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  // The default participant filter.
  static bool _defaultFilter(CallParticipantState participant) => true;

  // The default participant builder.
  static Widget _defaultParticipantBuilder(
    BuildContext context,
    Call call,
    CallParticipantState participant,
  ) {
    return StreamParticipantTile(
      // We use the sessionId as the key to map the state to the participant.
      key: Key(participant.uniqueParticipantKey),
      call: call,
      participant: participant,
    );
  }

  @override
  State<StreamCallParticipants> createState() => _StreamCallParticipantsState();
}

class _StreamCallParticipantsState extends State<StreamCallParticipants>
    with CallParticipantsSortingMixin {
  StreamSubscription<List<CallParticipantState>?>? _participantsSubscription;

  @override
  CallParticipantFilter<CallParticipantState> get participantFilter =>
      widget.filter;

  @override
  CallParticipantSort<CallParticipantState> get participantSort => widget.sort;

  @override
  void initState() {
    super.initState();
    recalculateParticipants(
      widget.participants ?? widget.call.state.value.callParticipants,
    );

    if (widget.participants == null) {
      _subscribeToParticipants();
    }
  }

  /// Subscribes to the call's own participant list.
  ///
  /// [Call.participantsStream] carries an error when a custom
  /// [CallPreferences.participantsThrottleIntervalResolver] throws. Without an
  /// `onError` that would go to the zone as an uncaught async error, once per
  /// event, so it is logged here and the last known list stays on screen.
  void _subscribeToParticipants() {
    _participantsSubscription = widget.call.participantsStream.listen(
      recalculateParticipants,
      onError: (Object error, StackTrace stackTrace) {
        _logger.e(
          () =>
              '[StreamCallParticipants] participantsStream error: $error; '
              '$stackTrace',
        );
      },
    );
  }

  @override
  void dispose() {
    _participantsSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StreamCallParticipants oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A sort carries an identity, so this is a change of sorting rather than
    // the new closure every build would otherwise produce. Picking a layout
    // swaps the sort too, since `sort` defaults to the layout's own.
    final orderingChanged =
        widget.sort != oldWidget.sort || widget.filter != oldWidget.filter;

    if (widget.participants != null) {
      _participantsSubscription?.cancel();
      _participantsSubscription = null;

      if (orderingChanged ||
          !const ListEquality<CallParticipantState>().equals(
            widget.participants!.toList(),
            oldWidget.participants?.toList(),
          )) {
        recalculateParticipants(widget.participants!);
      }
    } else if (widget.call != oldWidget.call ||
        // Going back to the call's own list after a controlled one: the
        // subscription was cancelled above and has to be re-taken.
        _participantsSubscription == null) {
      _participantsSubscription?.cancel();
      _subscribeToParticipants();

      recalculateParticipants(widget.call.state.value.callParticipants);
    } else if (orderingChanged) {
      // Nothing re-sorts on its own: the stream only emits when the list
      // changes, so in a quiet call a new comparator would otherwise wait for
      // the next join or speaker. Sorting an unchanged list is cheap here —
      // `recalculateParticipants` skips the `setState` when the result is the
      // same, which is also what absorbs a `sort` closure built in `build`.
      recalculateParticipants(widget.call.state.value.callParticipants);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (screenShareParticipant != null) {
      return ScreenShareCallParticipantsContent(
        call: widget.call,
        participants: sortedParticipants,
        screenSharingParticipant: screenShareParticipant!,
        screenShareContentBuilder: widget.screenShareContentBuilder,
        screenShareParticipantBuilder: widget.screenShareParticipantBuilder,
      );
    }

    return RegularCallParticipantsContent(
      call: widget.call,
      participants: sortedParticipants,
      layoutMode: widget.layoutMode,
      enableFloatingSelfView: widget.enableFloatingSelfView,
      callParticipantBuilder: widget.callParticipantBuilder,
      floatingSelfViewBuilder: widget.floatingSelfViewBuilder,
    );
  }
}
