import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../call_participants.dart';

const _kSpacing = 16.0;

/// Defines the alignment of the participants bar.
enum ParticipantsBarAlignment { top, bottom, left, right }

class CallParticipantsSpotlightView extends StatelessWidget {
  const CallParticipantsSpotlightView({
    super.key,
    required this.call,
    required this.spotlight,
    CallParticipantBuilder? spotlightBuilder,
    required this.participants,
    required this.participantBuilder,
    this.padding = const EdgeInsets.all(_kSpacing),
    this.barAlignment = ParticipantsBarAlignment.bottom,
  }) : spotlightBuilder = spotlightBuilder ?? participantBuilder;

  /// Represents a call.
  final Call call;

  /// The participant to be spotlighted.
  final CallParticipantState spotlight;

  /// Builder function used to build the spotlight.
  ///
  /// If not provided, the [participantBuilder] will be used.
  final CallParticipantBuilder spotlightBuilder;

  /// The list of other participants to display.
  final Iterable<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder participantBuilder;

  /// Padding around the spotlight and participants bar.
  final EdgeInsets padding;

  /// The alignment of the participants bar.
  final ParticipantsBarAlignment barAlignment;

  @override
  Widget build(BuildContext context) {
    final spotlight = _buildSpotlight(context);
    final participantsBar = _buildParticipantsBar(context);

    Widget child;
    switch (barAlignment) {
      case ParticipantsBarAlignment.top:
        child = Column(children: [participantsBar, spotlight]);
        break;
      case ParticipantsBarAlignment.bottom:
        child = Column(children: [spotlight, participantsBar]);
        break;
      case ParticipantsBarAlignment.left:
        child = Row(children: [participantsBar, spotlight]);
        break;
      case ParticipantsBarAlignment.right:
        child = Row(children: [spotlight, participantsBar]);
        break;
    }

    return Center(child: child);
  }

  Widget _buildSpotlight(BuildContext context) {
    const aspectRatio = 16 / 9;

    var flex = 9;
    // If there are no participants, the spotlight should take up the whole
    // space.
    if (participants.isEmpty) flex = 1;

    return Expanded(
      flex: flex,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Padding(
          padding: padding,
          child: spotlightBuilder.call(context, call, spotlight),
        ),
      ),
    );
  }

  Widget _buildParticipantsBar(BuildContext context) {
    if (participants.isEmpty) return const SizedBox.shrink();

    final scrollDirection = barAlignment.toAxis();
    final spacer = barAlignment.toSpacer(this.padding);
    final padding = barAlignment.toPadding(this.padding);

    const aspectRatio = 4 / 3;

    return Flexible(
      flex: 2,
      child: ListView.separated(
        padding: padding,
        shrinkWrap: true,
        itemCount: participants.length,
        scrollDirection: scrollDirection,
        separatorBuilder: (context, index) => spacer,
        itemBuilder: (context, index) {
          final participant = participants.elementAt(index);
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: participantBuilder.call(context, call, participant),
          );
        },
      ),
    );
  }
}

extension on ParticipantsBarAlignment {
  Axis toAxis() {
    switch (this) {
      case ParticipantsBarAlignment.top:
      case ParticipantsBarAlignment.bottom:
        return Axis.horizontal;
      case ParticipantsBarAlignment.left:
      case ParticipantsBarAlignment.right:
        return Axis.vertical;
    }
  }

  SizedBox toSpacer(EdgeInsets padding) {
    switch (this) {
      case ParticipantsBarAlignment.top:
      case ParticipantsBarAlignment.bottom:
        return SizedBox(width: padding.right);
      case ParticipantsBarAlignment.left:
      case ParticipantsBarAlignment.right:
        return SizedBox(height: padding.bottom);
    }
  }

  EdgeInsets toPadding(EdgeInsets padding) {
    switch (this) {
      case ParticipantsBarAlignment.top:
        return padding - EdgeInsets.only(bottom: padding.bottom);
      case ParticipantsBarAlignment.bottom:
        return padding - EdgeInsets.only(top: padding.top);
      case ParticipantsBarAlignment.left:
        return padding - EdgeInsets.only(right: padding.right);
      case ParticipantsBarAlignment.right:
        return padding - EdgeInsets.only(left: padding.left);
    }
  }
}
