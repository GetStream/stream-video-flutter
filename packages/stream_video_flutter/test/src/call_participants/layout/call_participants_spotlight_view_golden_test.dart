import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../mocks.dart';

MockCallParticipantState _participant(String name) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(name);
  when(() => participant.userId).thenReturn(name);
  when(() => participant.sessionId).thenReturn(name);
  when(() => participant.uniqueParticipantKey).thenReturn(name);
  when(() => participant.image).thenReturn(null);
  when(() => participant.isLocal).thenReturn(false);
  when(() => participant.isSpeaking).thenReturn(false);
  when(() => participant.isAudioEnabled).thenReturn(true);
  when(() => participant.isVideoEnabled).thenReturn(true);
  when(
    () => participant.connectionQuality,
  ).thenReturn(SfuConnectionQuality.excellent);
  when(() => participant.reaction).thenReturn(null);
  return participant;
}

const _names = [
  'Tammy Byrnes',
  'Katie Miler',
  'Mary Davis',
  'Gary Liu',
  'Ann Marks',
  'Alex Cole',
];

Widget _tile(BuildContext _, Call call, CallParticipantState participant) =>
    StreamParticipantTile(
      call: call,
      participant: participant,
      // A real renderer needs a live call. A flat fill stands in for video, and
      // keeps the snapshot from depending on a decoded frame.
      videoRendererBuilder: (_, _, _) =>
          const ColoredBox(color: Color(0xFF6E7A8A)),
    );

/// The layout at [size], with [others] people in the bar.
///
/// StreamScreenSize reads MediaQuery.sizeOf, so the size the case is about has
/// to be handed down as well as given to the box — the alchemist surface alone
/// would leave every scenario reporting the same breakpoint.
Widget _layout(
  Size size, {
  required int others,
  ParticipantsBarAlignment barAlignment = ParticipantsBarAlignment.bottom,
}) => MediaQuery(
  data: MediaQueryData(size: size),
  child: SizedBox.fromSize(
    size: size,
    child: CallParticipantsSpotlightView(
      call: MockCall(),
      spotlight: _participant(_names.first),
      participants: [
        for (var i = 0; i < others; i++) _participant(_names[i + 1]),
      ],
      participantBuilder: _tile,
      barAlignment: barAlignment,
    ),
  ),
);

void main() {
  // The label's sound indicator repeats, so onlyPumpAndSettle would never
  // return. Pump a fixed distance instead; it always starts at zero, so the
  // frame is deterministic.
  Future<void> pumpBeforeTest(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallParticipantsSpotlightView gives the stage what the bar leaves',
      fileName: 'stream_call_participants_spotlight_small',
      brightness: brightness,
      pumpBeforeTest: pumpBeforeTest,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: '2 participants',
            child: _layout(const Size(400, 560), others: 1),
          ),
          GoldenTestScenario(
            name: '6 participants',
            child: _layout(const Size(400, 560), others: 5),
          ),
        ],
      ),
    );

    streamGoldenTest(
      'CallParticipantsSpotlightView fills a view taller than 16:9',
      fileName: 'stream_call_participants_spotlight_medium',
      brightness: brightness,
      pumpBeforeTest: pumpBeforeTest,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          // Taller than 16:9 once the bar has its edge, so the stage is
          // taller than the ratio rather than letterboxed into it.
          GoldenTestScenario(
            name: 'bar below',
            child: _layout(const Size(768, 760), others: 2),
          ),
          GoldenTestScenario(
            name: 'bar to the right',
            child: _layout(
              const Size(768, 520),
              others: 2,
              barAlignment: ParticipantsBarAlignment.right,
            ),
          ),
        ],
      ),
    );

    streamGoldenTest(
      'CallParticipantsSpotlightView offers the bar it cannot fit',
      fileName: 'stream_call_participants_spotlight_bar_buttons',
      brightness: brightness,
      pumpBeforeTest: pumpBeforeTest,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          // More people than either bar has room for, so each carries the
          // button that leads to the rest of them.
          GoldenTestScenario(
            name: 'bar below',
            child: _layout(const Size(560, 520), others: 5),
          ),
          GoldenTestScenario(
            name: 'bar to the right',
            child: _layout(
              const Size(768, 400),
              others: 5,
              barAlignment: ParticipantsBarAlignment.right,
            ),
          ),
        ],
      ),
    );

    streamGoldenTest(
      'CallParticipantsSpotlightView stops the stage at 16:9',
      fileName: 'stream_call_participants_spotlight_large',
      brightness: brightness,
      pumpBeforeTest: pumpBeforeTest,
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          GoldenTestScenario(
            name: '4 participants',
            child: _layout(const Size(1280, 560), others: 3),
          ),
        ],
      ),
    );
  }
}
