// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'layout/call_participants_grid_view.dart';
import 'screen_share_call_participants_content.dart';

enum LivestreamScreenShareMode {
  /// The screen share video is displayed as a spotlight view.
  spotlight,

  /// The screen share video will be part of the grid view and replace the video of the host.
  grid,
}

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of hosts in a call.
class StreamLivestreamHosts extends StatefulWidget {
  StreamLivestreamHosts({
    super.key,
    required this.call,
    required this.hosts,
    Sort<CallParticipantState>? sort,
    this.callParticipantBuilder = _defaultParticipantBuilder,
    this.screenShareContentBuilder,
    this.layoutMode = ParticipantLayoutMode.grid,
    this.screenShareMode = LivestreamScreenShareMode.spotlight,
  }) : sort = sort ?? layoutMode.sorting;

  /// Represents a call.
  final Call call;

  /// The list of hosts to display.
  final List<CallParticipantState> hosts;

  /// Used for sorting the hosts.
  final Sort<CallParticipantState> sort;

  /// Builder function used to build a host grid item.
  final CallParticipantBuilder callParticipantBuilder;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  /// The screen share mode used to display the screen share host.
  final LivestreamScreenShareMode screenShareMode;

  // The default host builder.
  static Widget _defaultParticipantBuilder(
    BuildContext context,
    Call call,
    CallParticipantState host,
  ) {
    return StreamCallParticipant(
      // We use the sessionId as the key to map the state to the participant.
      key: Key(host.uniqueParticipantKey),
      call: call,
      participant: host,
    );
  }

  @override
  State<StreamLivestreamHosts> createState() => _StreamLivestreamHostsState();
}

class _StreamLivestreamHostsState extends State<StreamLivestreamHosts> {
  List<CallParticipantState> _hosts = [];
  CallParticipantState? _screenShareHost;

  List<String> _sortedParticipantKeys = [];

  @override
  void initState() {
    super.initState();
    _recalculateParticipants(widget.hosts);
  }

  @override
  void didUpdateWidget(covariant StreamLivestreamHosts oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!const ListEquality<CallParticipantState>().equals(
      widget.hosts.toList(),
      oldWidget.hosts.toList(),
    )) {
      _recalculateParticipants(widget.hosts);
    }
  }

  void _recalculateParticipants(List<CallParticipantState> newParticipants) {
    final participants = [
      ...newParticipants,
    ].where((e) => e.isVideoEnabled || e.isScreenShareEnabled).toList();

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

    mergeSort(participants, compare: widget.sort);

    final screenShareParticipant = participants.firstWhereOrNull((it) {
      final screenShareTrack = it.screenShareTrack;
      final isScreenShareEnabled = it.isScreenShareEnabled;

      if (screenShareTrack == null || !isScreenShareEnabled) return false;

      return true;
    });

    _sortedParticipantKeys = participants
        .map((e) => e.uniqueParticipantKey)
        .toList();

    if (mounted) {
      setState(() {
        _hosts = participants.toList();
        _screenShareHost = screenShareParticipant;
      });
    }
  }

  Widget _buildScreenShareContent(CallParticipantState host) {
    return widget.screenShareContentBuilder?.call(context, widget.call, host) ??
        ScreenShareContent(
          key: ValueKey('${host.uniqueParticipantKey} - screenShareContent'),
          call: widget.call,
          participant: host,
        );
  }

  Widget _hostVideoContentBuilder(
    BuildContext context,
    Call call,
    CallParticipantState host,
  ) {
    if (widget.screenShareMode == LivestreamScreenShareMode.grid &&
        _screenShareHost?.userId == host.userId) {
      return _buildScreenShareContent(_screenShareHost!);
    }

    return widget.callParticipantBuilder(context, call, host);
  }

  @override
  Widget build(BuildContext context) {
    final livestreamTheme = StreamLivestreamTheme.of(context);

    if (widget.screenShareMode == LivestreamScreenShareMode.spotlight &&
        _screenShareHost != null) {
      return _buildScreenShareContent(_screenShareHost!);
    }

    if (_hosts.isNotEmpty &&
        (widget.layoutMode == ParticipantLayoutMode.pictureInPicture ||
            widget.layoutMode == ParticipantLayoutMode.spotlight)) {
      return widget.callParticipantBuilder(context, widget.call, _hosts.first);
    }

    return CallParticipantsGridView(
      call: widget.call,
      participants: _hosts,
      itemBuilder: _hostVideoContentBuilder,
      padding: livestreamTheme.hostsGridPadding,
      mainAxisSpacing: livestreamTheme.hostsGridMainAxisSpacing,
      crossAxisSpacing: livestreamTheme.hostsGridCrossAxisSpacing,
    );
  }
}
