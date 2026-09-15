import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../mocks.dart';

// The label pill and the connection quality indicator sit on top of video, so
// they are snapshotted over a mid-grey rather than the page background — on a
// white one their overlay fill would be indistinguishable from a solid chip.
Widget _onVideo(Widget child) => ColoredBox(
  color: const Color(0xFF6E7A8A),
  child: Padding(padding: const EdgeInsets.all(12), child: child),
);

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

Future<void> _pumpPastTheFirstFrame(WidgetTester tester) async {
  // onlyPumpAndSettle never returns while the sound indicator is animating.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamParticipantLabel renders its states',
      fileName: 'stream_participant_label',
      brightness: brightness,
      pumpBeforeTest: _pumpPastTheFirstFrame,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: 'idle',
            child: _onVideo(
              StreamParticipantLabel.fromParticipant(
                participant: _participant(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'speaking',
            child: _onVideo(
              StreamParticipantLabel.fromParticipant(
                participant: _participant(isSpeaking: true),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'muted, camera off',
            child: _onVideo(
              StreamParticipantLabel.fromParticipant(
                participant: _participant(
                  isAudioEnabled: false,
                  isVideoEnabled: false,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'no name',
            child: _onVideo(
              StreamParticipantLabel.fromParticipant(
                participant: _participant(isAudioEnabled: false),
                showName: false,
              ),
            ),
          ),
        ],
      ),
    );

    streamGoldenTest(
      'StreamConnectionQualityIndicator renders every level',
      fileName: 'stream_connection_quality_indicator',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 4,
        scenarioConstraints: const BoxConstraints.tightFor(width: 80),
        children: [
          for (final quality in SfuConnectionQuality.values)
            GoldenTestScenario(
              name: quality.name,
              child: _onVideo(
                Center(
                  child: StreamConnectionQualityIndicator(
                    connectionQuality: quality,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    streamGoldenTest(
      'StreamFloatingParticipantTile renders the self-view',
      fileName: 'stream_floating_participant_tile',
      brightness: brightness,
      pumpBeforeTest: _pumpPastTheFirstFrame,
      builder: () => GoldenTestGroup(
        columns: 2,
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 180,
          height: 268,
        ),
        children: [
          GoldenTestScenario(
            name: 'video on',
            child: Center(
              child: StreamFloatingParticipantTile(
                call: MockCall(),
                participant: _participant(),
                // A real renderer needs a live call.
                participantBuilder: (_, _, _) =>
                    const ColoredBox(color: Color(0xFF6E7A8A)),
              ),
            ),
          ),
          // The composition that ships: the surface's own tile, which this used
          // to stand in for with a hand-built one — and so snapshotted a tile
          // stepping its chrome down with its size, where the self-view pins
          // the full chrome because the indicator is all it draws. The renderer
          // is stubbed through the factory instead, which the surface's tile
          // reads like any other.
          GoldenTestScenario(
            name: 'default tile inside',
            child: Center(
              child: StreamComponentFactory(
                builders: StreamComponentBuilders(
                  extensions: streamVideoComponentBuilders(
                    participantVideo: (context, props) =>
                        const ColoredBox(color: Color(0xFF6E7A8A)),
                  ),
                ),
                child: StreamFloatingParticipantTile(
                  call: MockCall(),
                  participant: _participant(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
