import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

import 'participant_tile.dart';

/// Lays out all call participants in a responsive CSS grid.
class ParticipantGrid extends StatelessComponent {
  const ParticipantGrid({
    required this.call,
    required this.participants,
    super.key,
  });

  final Call call;
  final List<CallParticipantState> participants;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'svj-grid',
      [
        for (final participant in participants)
          ParticipantTile(call: call, participant: participant),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.svj-grid', [
      css('&').styles(
        display: .grid,
        gridTemplate: const GridTemplate(
          columns: GridTracks([GridTrack(TrackSize.fr(1))]),
        ),
        gap: Gap(row: 8.px, column: 8.px),
        width: 100.percent,
        height: 100.percent,
        padding: .all(8.px),
        boxSizing: .borderBox,
        backgroundColor: Colors.black,
      ),
      css.media(MediaQuery.screen(minWidth: 640.px), [
        css('&').styles(
          gridTemplate: const GridTemplate(
            columns: GridTracks([
              GridTrack(TrackSize.fr(1)),
              GridTrack(TrackSize.fr(1)),
            ]),
          ),
        ),
      ]),
    ]),
  ];
}
