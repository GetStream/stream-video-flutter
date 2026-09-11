import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_video/stream_video.dart';

import 'call_participants.dart';

/// A mixin that provides participant sorting and filtering logic.
mixin CallParticipantsSortingMixin<T extends StatefulWidget> on State<T> {
  List<CallParticipantState> get sortedParticipants => _participants;
  List<CallParticipantState> _participants = [];

  CallParticipantState? get screenShareParticipant => _screenShareParticipant;
  CallParticipantState? _screenShareParticipant;

  /// Keys used to maintain stable participant ordering across updates.
  List<String> _sortedParticipantKeys = [];

  /// The filter function to apply to participants.
  ///
  /// Override this getter to provide the filter from your widget.
  CallParticipantFilter<CallParticipantState>? get participantFilter;

  /// The sort comparator to apply to participants.
  ///
  /// Override this getter to provide the sort from your widget.
  CallParticipantSort<CallParticipantState>? get participantSort;

  /// Call this method whenever the participant list changes, typically from
  /// a stream subscription or in [didUpdateWidget].
  void recalculateParticipants(List<CallParticipantState> newParticipants) {
    final filter = participantFilter;
    final incoming = <String, CallParticipantState>{
      for (final participant in newParticipants)
        if (filter == null || filter(participant))
          participant.uniqueParticipantKey: participant,
    };

    // The order the tiles are in, which is what the sort below is allowed to
    // keep. Built by walking it rather than by sorting an index of it: this
    // runs on every update, and participants who have since left drop out of
    // the record instead of accumulating in it.
    var participants = <CallParticipantState>[
      for (final key in _sortedParticipantKeys)
        if (incoming.remove(key) case final participant?) participant,
      // Whoever the previous order has never seen, in the order they arrived.
      ...incoming.values,
    ];

    final sort = participantSort;
    if (sort != null) {
      // Not a plain sort: `sortParticipants` leaves the tiles that are on
      // screen where the order above has them.
      participants = sortParticipants(participants, sort: sort);
    }

    final screenShareParticipant = participants.firstWhereOrNull(
      (it) {
        final screenShareTrack = it.screenShareTrack;
        final isScreenShareEnabled = it.isScreenShareEnabled;

        if (screenShareTrack == null || !isScreenShareEnabled) return false;

        return true;
      },
    );

    _sortedParticipantKeys = participants
        .map((e) => e.uniqueParticipantKey)
        .toList();

    if (mounted) {
      setState(() {
        _participants = participants.toList();
        _screenShareParticipant = screenShareParticipant;
      });
    }
  }

  void clearParticipantSortingCache() {
    _sortedParticipantKeys = [];
  }
}
