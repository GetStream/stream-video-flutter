import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../utils/knobs.dart';
import '../../utils/participant_generator.dart';
import '../../utils/stub_provider.dart';
import '../../utils/target_platform_extension.dart';

Widget mobileCallParticipantsSpotlightView(BuildContext context) {
  final count = context.createParticipantCountKnob();

  return Theme(
    // Emulate the IOS platform for the GridView.
    data: Theme.of(context).copyWith(
      platform: TargetPlatform.iOS,
    ),
    child: DefaultCallParticipantsSpotlightView(
      participantCount: count,
    ),
  );
}

Widget desktopCallParticipantsSpotlightView(BuildContext context) {
  final count = context.createParticipantCountKnob();

  return Theme(
    // Emulate the MacOS platform for the GridView.
    data: Theme.of(context).copyWith(
      platform: TargetPlatform.macOS,
    ),
    child: DefaultCallParticipantsSpotlightView(
      participantCount: count,
    ),
  );
}

class DefaultCallParticipantsSpotlightView extends ConsumerStatefulWidget {
  const DefaultCallParticipantsSpotlightView({
    super.key,
    required this.participantCount,
  }) : assert(participantCount > 0);

  final int participantCount;

  @override
  ConsumerState<DefaultCallParticipantsSpotlightView> createState() =>
      _DefaultStreamCallParticipantsState();
}

class _DefaultStreamCallParticipantsState
    extends ConsumerState<DefaultCallParticipantsSpotlightView> {
  late List<CallParticipantState> _participants;

  @override
  void initState() {
    super.initState();
    _participants = [...generateParticipants(widget.participantCount)];
  }

  @override
  void didUpdateWidget(
    covariant DefaultCallParticipantsSpotlightView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participantCount != widget.participantCount) {
      _participants = [...generateParticipants(widget.participantCount)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    final participants = [..._participants]
      ..sort(CallParticipantSortingPresets.speaker);

    final spotlight = participants.first;
    final otherParticipants = participants.sublist(1);

    return CallParticipantsSpotlightView(
      call: ref.read(callProvider),
      spotlight: spotlight,
      participants: otherParticipants,
      padding: EdgeInsets.all(context.createDoubleKnob('Padding')),
      mainAxisSpacing: context.createDoubleKnob('Main Axis Spacing'),
      crossAxisSpacing: context.createDoubleKnob('Cross Axis Spacing'),
      barAlignment: context.knobs.options<ParticipantsBarAlignment>(
        label: 'Bar Alignment',
        options: [
          const Option(label: 'Bottom', value: ParticipantsBarAlignment.bottom),
          const Option(label: 'Top', value: ParticipantsBarAlignment.top),
          if (!platform.isMobile) ...[
            const Option(label: 'Right', value: ParticipantsBarAlignment.right),
            const Option(label: 'Left', value: ParticipantsBarAlignment.left),
          ]
        ],
      ),
    );
  }
}
