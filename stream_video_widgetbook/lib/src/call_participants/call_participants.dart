import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

import '../utils/knobs.dart';
import '../utils/participant_generator.dart';
import '../utils/stub_provider.dart';

Widget defaultStreamCallParticipants(BuildContext context) {
  final count = context.createParticipantCountKnob();

  final screenShare = context.knobs.boolean(label: 'Enable Screen Share');

  return DefaultStreamCallParticipants(
    participantCount: count,
    enableScreenShare: screenShare,
  );
}

class DefaultStreamCallParticipants extends ConsumerStatefulWidget {
  const DefaultStreamCallParticipants({
    super.key,
    required this.participantCount,
    this.enableScreenShare = false,
  }) : assert(participantCount > 0);

  final int participantCount;
  final bool enableScreenShare;

  @override
  ConsumerState<DefaultStreamCallParticipants> createState() =>
      _DefaultStreamCallParticipantsState();
}

class _DefaultStreamCallParticipantsState
    extends ConsumerState<DefaultStreamCallParticipants> {
  late List<CallParticipantState> _participants;

  @override
  void initState() {
    super.initState();
    _participants = [
      ...generateParticipants(
        widget.participantCount,
        screenShare: widget.enableScreenShare,
      ),
    ];
  }

  @override
  void didUpdateWidget(covariant DefaultStreamCallParticipants oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participantCount != widget.participantCount ||
        oldWidget.enableScreenShare != widget.enableScreenShare) {
      _participants = [
        ...generateParticipants(
          widget.participantCount,
          screenShare: widget.enableScreenShare,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamCallParticipants(
      call: ref.read(callProvider),
      participants: _participants,
      padding: EdgeInsets.all(context.createDoubleKnob('Padding')),
      mainAxisSpacing: context.createDoubleKnob('Main Axis Spacing'),
      crossAxisSpacing: context.createDoubleKnob('Cross Axis Spacing'),
      enableLocalVideo: context.knobs.boolean(label: 'Enable Local Video'),
      layoutMode: context.knobs.options(
        label: 'Layout Mode',
        options: [
          const Option(
            label: 'Grid',
            value: ParticipantLayoutMode.grid,
          ),
          const Option(
            label: 'Spotlight',
            value: ParticipantLayoutMode.spotlight,
          ),
        ],
      ),
    );
  }
}
