import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

import '../renderer/stream_video_view.dart';

/// A single participant's video tile with a name/mute-status badge.
class ParticipantTile extends StatelessComponent {
  const ParticipantTile({
    required this.call,
    required this.participant,
    super.key,
  });

  final Call call;
  final CallParticipantState participant;

  @override
  Component build(BuildContext context) {
    return div(
      key: ValueKey(participant.uniqueParticipantKey),
      classes: 'svj-tile',
      [
        StreamVideoView(call: call, participant: participant),
        div(classes: 'svj-tile-badge', [
          .text(
            participant.name.isNotEmpty ? participant.name : participant.userId,
          ),
          .text(participant.isAudioEnabled ? '' : ' \u{1F507}'),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.svj-tile', [
      css('&').styles(
        position: const Position.relative(),
        width: 100.percent,
        height: 100.percent,
        overflow: Overflow.clip,
        radius: .circular(8.px),
        backgroundColor: const Color('#111'),
      ),
    ]),
    css('.svj-tile-badge', [
      css('&').styles(
        position: Position.absolute(bottom: 8.px, left: 8.px),
        padding: .symmetric(horizontal: 8.px, vertical: 4.px),
        radius: .circular(4.px),
        backgroundColor: const Color('#000000A0'),
        color: Colors.white,
        fontSize: 0.85.rem,
      ),
    ]),
  ];
}
