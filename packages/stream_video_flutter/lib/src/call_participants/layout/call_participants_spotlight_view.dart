import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../call_participant.dart';
import '../call_participants.dart';

const _kSpacing = 8.0;

/// Defines the alignment of the participants bar.
enum ParticipantsBarAlignment { top, bottom, left, right }

class CallParticipantsSpotlightView extends StatelessWidget {
  const CallParticipantsSpotlightView({
    super.key,
    required this.call,
    required this.spotlight,
    CallParticipantBuilder? spotlightBuilder,
    required this.participants,
    this.participantBuilder = _defaultParticipantBuilder,
    this.padding = const EdgeInsets.all(_kSpacing),
    this.mainAxisSpacing = _kSpacing,
    this.crossAxisSpacing = _kSpacing,
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

  /// Spacing between the [spotlight] and [participants].
  final double mainAxisSpacing;

  /// Space between the [participants] in the cross axis.
  final double crossAxisSpacing;

  /// The alignment of the participants bar.
  final ParticipantsBarAlignment barAlignment;

  // The default participant builder.
  static Widget _defaultParticipantBuilder(
    BuildContext context,
    Call call,
    CallParticipantState participant,
  ) {
    return StreamCallParticipant(
      // We use the sessionId as the key to avoid rebuilding the widget
      // when the participant changes.
      key: ValueKey(participant.sessionId),
      call: call,
      participant: participant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final spotlight = _buildSpotlight(context);
    final participantsBar = _buildParticipantsBar(context);
    final spacing = barAlignment.toMainAxisSpacing(mainAxisSpacing);

    Widget child;
    switch (barAlignment) {
      case ParticipantsBarAlignment.top:
        child = Column(children: [participantsBar, spacing, spotlight]);
        break;
      case ParticipantsBarAlignment.bottom:
        child = Column(children: [spotlight, spacing, participantsBar]);
        break;
      case ParticipantsBarAlignment.left:
        child = Row(children: [participantsBar, spacing, spotlight]);
        break;
      case ParticipantsBarAlignment.right:
        child = Row(children: [spotlight, spacing, participantsBar]);
        break;
    }

    return Center(
      child: child,
    );
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
          padding: barAlignment.toSpotlightPadding(padding),
          child: spotlightBuilder.call(context, call, spotlight),
        ),
      ),
    );
  }

  Widget _buildParticipantsBar(BuildContext context) {
    if (participants.isEmpty) return const SizedBox.shrink();

    final scrollDirection = barAlignment.toAxis();
    final padding = barAlignment.toBarPadding(this.padding);
    final spacer = barAlignment.toCrossAxisSpacing(crossAxisSpacing);

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
  SizedBox toCrossAxisSpacing(double spacing) {
    switch (toAxis()) {
      case Axis.horizontal:
        return SizedBox(width: spacing);
      case Axis.vertical:
        return SizedBox(height: spacing);
    }
  }

  SizedBox toMainAxisSpacing(double spacing) {
    switch (this) {
      case ParticipantsBarAlignment.top:
      case ParticipantsBarAlignment.bottom:
        return SizedBox(height: spacing);
      case ParticipantsBarAlignment.left:
      case ParticipantsBarAlignment.right:
        return SizedBox(width: spacing);
    }
  }

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

  EdgeInsets toBarPadding(EdgeInsets padding) {
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

  EdgeInsets toSpotlightPadding(EdgeInsets padding) {
    switch (this) {
      case ParticipantsBarAlignment.top:
        return padding - EdgeInsets.only(top: padding.top);
      case ParticipantsBarAlignment.bottom:
        return padding - EdgeInsets.only(bottom: padding.bottom);
      case ParticipantsBarAlignment.left:
        return padding - EdgeInsets.only(left: padding.left);
      case ParticipantsBarAlignment.right:
        return padding - EdgeInsets.only(right: padding.right);
    }
  }
}
