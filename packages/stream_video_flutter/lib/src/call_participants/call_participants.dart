// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'regular_call_participants_content.dart';
import 'screen_share_call_participants_content.dart';

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
typedef Filter<T> = bool Function(T element);

/// Comparator used to sort the participants.
typedef Sort<T> = Comparator<T>;

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatefulWidget {
  /// Creates a new instance of [StreamCallParticipant].
  StreamCallParticipants({
    super.key,
    required this.call,
    this.participants,
    this.filter = _defaultFilter,
    Sort<CallParticipantState>? sort,
    this.enableLocalVideo,
    this.callParticipantBuilder = _defaultParticipantBuilder,
    this.localVideoParticipantBuilder,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder = _defaultParticipantBuilder,
    this.layoutMode = ParticipantLayoutMode.grid,
  }) : sort = sort ?? layoutMode.sorting;

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  /// If provided these [participants] will be used, otherwise the participants of the [call] will be used.
  final List<CallParticipantState>? participants;

  /// Used for filtering the call participants.
  final Filter<CallParticipantState> filter;

  /// Used for sorting the call participants.
  final Sort<CallParticipantState> sort;

  /// Enable local video view for the local participant.
  final bool? enableLocalVideo;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder callParticipantBuilder;

  /// Builder function used to build a local video participant widget.
  final CallParticipantBuilder? localVideoParticipantBuilder;

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
    return StreamCallParticipant(
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
  Filter<CallParticipantState> get participantFilter => widget.filter;

  @override
  Sort<CallParticipantState> get participantSort => widget.sort;

  @override
  void initState() {
    super.initState();
    recalculateParticipants(
      widget.participants ?? widget.call.state.value.callParticipants,
    );

    if (widget.participants == null) {
      _participantsSubscription = widget.call
          .partialState((state) => state.callParticipants)
          .listen(recalculateParticipants);
    }
  }

  @override
  void dispose() {
    _participantsSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StreamCallParticipants oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.participants != null) {
      _participantsSubscription?.cancel();

      if (!const ListEquality<CallParticipantState>().equals(
        widget.participants!.toList(),
        oldWidget.participants?.toList(),
      )) {
        recalculateParticipants(widget.participants!);
      }
    } else if (widget.call != oldWidget.call) {
      _participantsSubscription?.cancel();
      _participantsSubscription = widget.call
          .partialState((state) => state.callParticipants)
          .listen(recalculateParticipants);

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
      enableLocalVideo: widget.enableLocalVideo,
      callParticipantBuilder: widget.callParticipantBuilder,
      localVideoParticipantBuilder: widget.localVideoParticipantBuilder,
    );
  }
}
