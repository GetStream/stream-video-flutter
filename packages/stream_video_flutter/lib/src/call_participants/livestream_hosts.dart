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

class _StreamLivestreamHostsState extends State<StreamLivestreamHosts>
    with CallParticipantsSortingMixin {
  @override
  Filter<CallParticipantState>? get participantFilter => null;

  @override
  Sort<CallParticipantState>? get participantSort => widget.sort;

  @override
  void initState() {
    super.initState();
    recalculateParticipants(widget.hosts);
  }

  @override
  void didUpdateWidget(covariant StreamLivestreamHosts oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!const ListEquality<CallParticipantState>().equals(
      widget.hosts.toList(),
      oldWidget.hosts.toList(),
    )) {
      recalculateParticipants(widget.hosts);
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
        screenShareParticipant?.uniqueParticipantKey ==
            host.uniqueParticipantKey) {
      return _buildScreenShareContent(screenShareParticipant!);
    }

    return widget.callParticipantBuilder(context, call, host);
  }

  @override
  Widget build(BuildContext context) {
    final livestreamTheme = StreamLivestreamTheme.of(context);

    if (widget.screenShareMode == LivestreamScreenShareMode.spotlight &&
        screenShareParticipant != null) {
      return _buildScreenShareContent(screenShareParticipant!);
    }

    if (sortedParticipants.isNotEmpty &&
        (widget.layoutMode == ParticipantLayoutMode.pictureInPicture ||
            widget.layoutMode == ParticipantLayoutMode.spotlight)) {
      return widget.callParticipantBuilder(
        context,
        widget.call,
        sortedParticipants.first,
      );
    }

    return CallParticipantsGridView(
      call: widget.call,
      participants: sortedParticipants,
      itemBuilder: _hostVideoContentBuilder,
      padding: livestreamTheme.hostsGridPadding,
      mainAxisSpacing: livestreamTheme.hostsGridMainAxisSpacing,
      crossAxisSpacing: livestreamTheme.hostsGridCrossAxisSpacing,
    );
  }
}
