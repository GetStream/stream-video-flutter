import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

import '../utils/knobs.dart';
import '../utils/participant_generator.dart';
import '../utils/stub_provider.dart';
import '../utils/widgets/dummy_video_renderer.dart';

Widget defaultCallParticipant(BuildContext context) {
  return const DefaultCallParticipant();
}

final participant = generateParticipants(1).first;

class DefaultCallParticipant extends ConsumerWidget {
  const DefaultCallParticipant({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final micMuted = context.knobs.boolean(label: 'Mute Mic');
    final isSpeaking = context.knobs.boolean(label: 'Is Speaking');

    final cameraMuted = context.knobs.boolean(
      label: 'Mute Camera',
      initialValue: true,
    );

    return StreamCallParticipant(
      call: ref.read(callProvider),
      participant: participant.copyWith(
        name: context.knobs.text(
          label: 'Name',
          initialValue: participant.name,
        ),
        image: context.knobs.text(
          label: 'Image Url',
          initialValue: participant.image!,
        ),
        connectionQuality: context.knobs.options(
          label: 'Connection Quality',
          options: [
            const Option(label: 'Good', value: SfuConnectionQuality.excellent),
            const Option(label: 'Average', value: SfuConnectionQuality.good),
            const Option(label: 'Bad', value: SfuConnectionQuality.poor),
            const Option(label: 'Off', value: SfuConnectionQuality.unspecified),
          ],
        ),
        isSpeaking: isSpeaking,
        audioLevel: isSpeaking ? 1 : 0,
        isDominantSpeaker: isSpeaking,
        publishedTracks: {
          SfuTrackType.audio: TrackState.local(muted: micMuted),
          SfuTrackType.video: TrackState.local(muted: cameraMuted),
        },
      ),
      videoRendererBuilder: createDummyVideoRenderer,
      showSpeakerBorder: !micMuted &&
          context.knobs.boolean(
            label: 'Show Speaker Border',
            initialValue: true,
          ),
      showParticipantLabel: context.knobs.boolean(
        label: 'Show Participant Label',
        initialValue: true,
      ),
      showConnectionQualityIndicator: context.knobs.boolean(
        label: 'Show Connection Quality Indicator',
        initialValue: true,
      ),
      connectionLevelAlignment: context.createAlignmentKnob(
        'Connection Level Alignment',
        initialAlignment: Alignment.bottomRight,
      ),
      participantLabelAlignment: context.createAlignmentKnob(
        'Participant Label Alignment',
        initialAlignment: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(
        context.createDoubleKnob(
          'Border Radius',
          divisionFactor: 2,
          enableDivision: true,
        ),
      ),
      speakerBorderThickness: context.createDoubleKnob(
        'Speaker Border Thickness',
        initialValue: 4,
        max: 6,
      ),
    );
  }
}
