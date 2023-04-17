import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../utils/knobs.dart';
import '../../utils/participant_generator.dart';
import '../../utils/stub_provider.dart';
import '../../utils/target_platform_extension.dart';

Widget mobileCallParticipantsGridView(BuildContext context) {
  final count = context.createParticipantCountKnob();

  return Theme(
    // Emulate the IOS platform for the GridView.
    data: Theme.of(context).copyWith(
      platform: TargetPlatform.iOS,
    ),
    child: DefaultCallParticipantsGridView(
      participantCount: count,
    ),
  );
}

Widget desktopCallParticipantsGridView(BuildContext context) {
  final count = context.createParticipantCountKnob();

  return Theme(
    // Emulate the MacOS platform for the GridView.
    data: Theme.of(context).copyWith(
      platform: TargetPlatform.macOS,
    ),
    child: DefaultCallParticipantsGridView(
      participantCount: count,
    ),
  );
}

class DefaultCallParticipantsGridView extends ConsumerStatefulWidget {
  const DefaultCallParticipantsGridView({
    super.key,
    required this.participantCount,
  }) : assert(participantCount > 0);

  final int participantCount;

  @override
  ConsumerState<DefaultCallParticipantsGridView> createState() =>
      _DefaultStreamCallParticipantsState();
}

class _DefaultStreamCallParticipantsState
    extends ConsumerState<DefaultCallParticipantsGridView> {
  late List<CallParticipantState> _participants;

  @override
  void initState() {
    super.initState();
    _participants = [...generateParticipants(widget.participantCount)];
  }

  @override
  void didUpdateWidget(covariant DefaultCallParticipantsGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participantCount != widget.participantCount) {
      _participants = [...generateParticipants(widget.participantCount)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    var pageSize = 16.0;
    if (!platform.isMobile) {
      // On web and desktop, we want to be able to test the grid view with
      // different page sizes.
      pageSize = context.knobs.slider(
        label: 'Page Size',
        initialValue: 16,
        min: 1,
        max: 16,
        divisions: 15,
      );
    }

    return CallParticipantsGridView(
      call: ref.read(callProvider),
      participants: _participants,
      pageSize: pageSize.toInt(),
      padding: EdgeInsets.all(context.createDoubleKnob('Padding')),
      mainAxisSpacing: context.createDoubleKnob('Main Axis Spacing'),
      crossAxisSpacing: context.createDoubleKnob('Cross Axis Spacing'),
    );
  }
}
