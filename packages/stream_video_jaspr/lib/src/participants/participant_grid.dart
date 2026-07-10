import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

import 'participant_tile.dart';

/// Lays out all call participants in a responsive CSS grid.
///
/// The column count grows with the participant count (mirroring
/// `stream_video_flutter`'s desktop grid: `floor(sqrt(n - 1)) + 1`), so e.g.
/// 5-9 participants form a 3-column grid instead of a cramped 2-column list.
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
    final columnCount = participants.length <= 1
        ? 1
        : sqrt(participants.length - 1).floor() + 1;

    return div(
      classes: 'svj-grid',
      styles: Styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([
            for (var i = 0; i < columnCount; i++)
              const GridTrack(
                TrackSize.minmax(TrackSize(Unit.zero), TrackSize.fr(1)),
              ),
          ]),
        ),
      ),
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
        autoRows: const [
          TrackSize.minmax(TrackSize(Unit.zero), TrackSize.fr(1)),
        ],
        gap: Gap(row: 8.px, column: 8.px),
        width: 100.percent,
        height: 100.percent,
        padding: .all(8.px),
        boxSizing: .borderBox,
        backgroundColor: Colors.black,
      ),
    ]),
  ];
}
