import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../mocks.dart';

MockCallParticipantState _participant({
  String name = 'Katie Miler',
  bool isAudioEnabled = true,
  bool isVideoEnabled = true,
  bool isSpeaking = false,
  SfuConnectionQuality quality = SfuConnectionQuality.excellent,
}) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(name);
  when(() => participant.image).thenReturn(null);
  when(() => participant.isSpeaking).thenReturn(isSpeaking);
  when(() => participant.isAudioEnabled).thenReturn(isAudioEnabled);
  when(() => participant.isVideoEnabled).thenReturn(isVideoEnabled);
  when(() => participant.connectionQuality).thenReturn(quality);
  when(() => participant.reaction).thenReturn(null);
  return participant;
}

Widget _tile(
  CallParticipantState participant, {
  StreamParticipantTileChromePolicy? chromePolicy,
}) {
  final tile = StreamParticipantTile(
    call: MockCall(),
    participant: participant,
    actions: [
      StreamParticipantTileAction(
        icon: Icons.push_pin,
        label: 'Pin',
        onPressed: () {},
      ),
    ],
    // A real renderer needs a live call. A flat fill stands in for video, and
    // keeps the snapshot off a decoded frame.
    videoRendererBuilder: (_, _, _) =>
        const ColoredBox(color: Color(0xFF6E7A8A)),
  );

  if (chromePolicy == null) return tile;

  return StreamParticipantTileTheme(
    data: StreamParticipantTileThemeData(chromePolicy: chromePolicy),
    child: tile,
  );
}

// One width per level of the ladder, taken from the sizes the layouts produce:
// the design's own small tile is 188, a 3x3 grid cell on a phone is ~130, a 4x4
// is ~97. The heights hold the level the width asks for.
const _sizes = <String, Size>{
  'full 188': Size(188, 200),
  'compact 130': Size(130, 200),
  'compact 96': Size(96, 200),
  'minimal 72': Size(72, 120),
  'bare 40': Size(40, 40),
};

void main() {
  for (final brightness in Brightness.values) {
    // What each level draws, for a participant with nothing else to report.
    streamGoldenTest(
      'StreamParticipantTile steps its chrome down with its size',
      fileName: 'stream_participant_tile_chrome',
      brightness: brightness,
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
      },
      builder: () => GoldenTestGroup(
        columns: 5,
        children: [
          for (final entry in _sizes.entries)
            GoldenTestScenario(
              name: entry.key,
              constraints: BoxConstraints.tight(entry.value),
              child: _tile(_participant()),
            ),
        ],
      ),
    );

    // The state icons are what the name competes with for the row, so each
    // level is snapshotted against every state that adds one.
    for (final state in [
      (name: 'muted', isAudioEnabled: false, isVideoEnabled: true),
      (name: 'camera off', isAudioEnabled: true, isVideoEnabled: false),
      (name: 'muted, camera off', isAudioEnabled: false, isVideoEnabled: false),
    ]) {
      streamGoldenTest(
        'StreamParticipantTile draws a ${state.name} participant per level',
        fileName:
            'stream_participant_tile_chrome_'
            '${state.name.replaceAll(RegExp('[ ,]+'), '_')}',
        brightness: brightness,
        pumpBeforeTest: (tester) async {
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));
        },
        builder: () => GoldenTestGroup(
          columns: 5,
          children: [
            for (final entry in _sizes.entries)
              GoldenTestScenario(
                name: entry.key,
                constraints: BoxConstraints.tight(entry.value),
                child: _tile(
                  _participant(
                    isAudioEnabled: state.isAudioEnabled,
                    isVideoEnabled: state.isVideoEnabled,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // A speaking participant on a poor connection: the two pieces of chrome
    // that report something urgent, at the sizes that decide whether they fit.
    streamGoldenTest(
      'StreamParticipantTile draws a speaking participant per level',
      fileName: 'stream_participant_tile_chrome_speaking',
      brightness: brightness,
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
      },
      builder: () => GoldenTestGroup(
        columns: 5,
        children: [
          for (final entry in _sizes.entries)
            GoldenTestScenario(
              name: entry.key,
              constraints: BoxConstraints.tight(entry.value),
              child: _tile(
                _participant(
                  isSpeaking: true,
                  quality: SfuConnectionQuality.poor,
                ),
              ),
            ),
        ],
      ),
    );

    // The policies an app can set in place of the ladder.
    streamGoldenTest(
      'StreamParticipantTile draws the chrome its policy asks for',
      fileName: 'stream_participant_tile_chrome_policy',
      brightness: brightness,
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
      },
      builder: () => GoldenTestGroup(
        columns: 3,
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 130,
          height: 200,
        ),
        children: [
          GoldenTestScenario(
            name: 'bySize',
            child: _tile(
              _participant(),
              chromePolicy: StreamParticipantTileChromePolicy.bySize,
            ),
          ),
          GoldenTestScenario(
            name: 'always',
            child: _tile(
              _participant(),
              chromePolicy: StreamParticipantTileChromePolicy.always,
            ),
          ),
          GoldenTestScenario(
            name: 'none',
            child: _tile(
              _participant(),
              chromePolicy: StreamParticipantTileChromePolicy.none,
            ),
          ),
        ],
      ),
    );
  }
}
