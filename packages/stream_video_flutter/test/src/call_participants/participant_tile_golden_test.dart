import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../mocks.dart';

MockCallParticipantState _participant({
  String name = 'Katie Miler',
  bool isSpeaking = false,
  bool isAudioEnabled = true,
  bool isVideoEnabled = true,
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

Widget _tile({
  required CallParticipantState participant,
  List<StreamParticipantTileAction>? actions,
}) {
  return StreamParticipantTile(
    call: MockCall(),
    participant: participant,
    actions: actions,
    // A real renderer needs a live call. A flat fill stands in for video, and
    // keeps the snapshot from depending on a decoded frame.
    videoRendererBuilder: (_, _, _) =>
        const ColoredBox(color: Color(0xFF6E7A8A)),
  );
}

void main() {
  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamParticipantTile renders its states',
      fileName: 'stream_participant_tile',
      brightness: brightness,
      // onlyPumpAndSettle never returns while the speaking indicator's
      // controller repeats. Pump a fixed distance into it instead; it always
      // starts at zero, so the frame is deterministic.
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
      },
      builder: () => GoldenTestGroup(
        columns: 3,
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 200,
          height: 320,
        ),
        children: [
          GoldenTestScenario(
            name: 'video on',
            child: _tile(participant: _participant()),
          ),
          GoldenTestScenario(
            name: 'speaking',
            child: _tile(participant: _participant(isSpeaking: true)),
          ),
          GoldenTestScenario(
            name: 'muted',
            child: _tile(participant: _participant(isAudioEnabled: false)),
          ),
          // The camera-off icon in the pill. The avatar placeholder behind it
          // cannot be snapshotted here: the stubbed renderer replaces the whole
          // renderer, placeholder included.
          GoldenTestScenario(
            name: 'camera off',
            child: _tile(participant: _participant(isVideoEnabled: false)),
          ),
          GoldenTestScenario(
            name: 'poor connection',
            child: _tile(
              participant: _participant(quality: SfuConnectionQuality.poor),
            ),
          ),
          GoldenTestScenario(
            name: 'with actions',
            child: _tile(
              participant: _participant(),
              actions: [
                StreamParticipantTileAction(
                  icon: Icons.push_pin,
                  label: 'Pin',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );

    streamGoldenTest(
      'StreamParticipantTile keeps a long name clear of the indicator',
      fileName: 'stream_participant_tile_long_name',
      brightness: brightness,
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
      },
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final width in [240.0, 160.0, 120.0])
            GoldenTestScenario(
              name: '${width.toInt()}px',
              constraints: BoxConstraints.tightFor(width: width, height: 200),
              child: _tile(
                participant: _participant(
                  name: 'Bartholomew Fitzgerald-Montgomery III',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
