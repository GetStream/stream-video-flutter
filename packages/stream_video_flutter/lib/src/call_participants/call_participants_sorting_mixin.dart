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
  Filter<CallParticipantState>? get participantFilter;

  /// The sort comparator to apply to participants.
  ///
  /// Override this getter to provide the sort from your widget.
  Sort<CallParticipantState>? get participantSort;

  /// Call this method whenever the participant list changes, typically from
  /// a stream subscription or in [didUpdateWidget].
  void recalculateParticipants(List<CallParticipantState> newParticipants) {
    final filter = participantFilter;
    final participants = filter == null
        ? newParticipants
        : newParticipants.where(filter).toList();

    // Position of each key in the previous order, so the sort below reads a
    // participant's previous slot in constant time.
    final previousOrder = <String, int>{
      for (var index = 0; index < _sortedParticipantKeys.length; index++)
        _sortedParticipantKeys[index]: index,
    };

    // Participants that weren't in the previous order are appended, in the
    // order they arrived.
    var nextOrder = previousOrder.length;
    final entries = [
      for (final participant in participants)
        (
          key: participant.uniqueParticipantKey,
          order: previousOrder[participant.uniqueParticipantKey] ?? nextOrder++,
          participant: participant,
        ),
    ]..sort((a, b) => a.order.compareTo(b.order));

    final sort = participantSort;
    if (sort != null) {
      mergeSort(
        entries,
        compare: (a, b) => sort(a.participant, b.participant),
      );
    }

    final sortedKeys = [for (final entry in entries) entry.key];
    final sortedParticipants = [for (final entry in entries) entry.participant];

    final screenShareParticipant = sortedParticipants.firstWhereOrNull(
      (it) {
        final screenShareTrack = it.screenShareTrack;
        final isScreenShareEnabled = it.isScreenShareEnabled;

        if (screenShareTrack == null || !isScreenShareEnabled) return false;

        return true;
      },
    );

    _sortedParticipantKeys = sortedKeys;

    // The state layer hands back the same participant instance when an event
    // leaves that participant untouched, so identity is enough to tell whether
    // anything on screen would actually differ.
    final unchanged =
        identical(screenShareParticipant, _screenShareParticipant) &&
        sortedParticipants.length == _participants.length &&
        sortedParticipants.foldIndexed(
          true,
          (index, acc, it) => acc && identical(it, _participants[index]),
        );

    if (unchanged) return;

    if (mounted) {
      setState(() {
        _participants = sortedParticipants;
        _screenShareParticipant = screenShareParticipant;
      });
    }
  }

  void clearParticipantSortingCache() {
    _sortedParticipantKeys = [];
  }
}
