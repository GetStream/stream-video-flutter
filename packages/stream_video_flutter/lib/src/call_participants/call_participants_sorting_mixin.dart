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
    final participants = [
      ...newParticipants,
    ].where(participantFilter ?? (_) => true).toList();

    for (final participant in participants) {
      final index = _sortedParticipantKeys.indexOf(
        participant.uniqueParticipantKey,
      );
      if (index == -1) {
        _sortedParticipantKeys.add(participant.uniqueParticipantKey);
      }
    }

    // First apply previous sorting on new participants list
    participants.sort(
      (a, b) => _sortedParticipantKeys
          .indexOf(a.uniqueParticipantKey)
          .compareTo(_sortedParticipantKeys.indexOf(b.uniqueParticipantKey)),
    );

    if (participantSort != null) {
      mergeSort(participants, compare: participantSort);
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
