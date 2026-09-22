import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Not exported from the barrel — the grid is internal to the default call
// content — so it is reached directly.
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/layout/call_participants_grid_view.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../mocks.dart';

const _names = [
  'Tammy Byrnes',
  'Katie Miler',
  'Mary Davis',
  'Gary Liu',
  'Ann Marks',
  'Alex Cole',
];

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

Widget _tile(BuildContext _, Call call, CallParticipantState participant) =>
    StreamParticipantTile(
      call: call,
      participant: participant,
      // A real renderer needs a live call. A flat fill stands in for video, and
      // keeps the snapshot from depending on a decoded frame.
      videoRendererBuilder: (_, _, _) =>
          const ColoredBox(color: Color(0xFF6E7A8A)),
    );

/// The grid at [size], holding [count] people.
///
/// StreamScreenSize reads MediaQuery.sizeOf, so the size the case is about has
/// to be handed down as well as given to the box — it is what decides the page
/// size.
Widget _grid(Size size, {required int count}) => MediaQuery(
  data: MediaQueryData(size: size),
  child: SizedBox.fromSize(
    size: size,
    child: CallParticipantsGridView(
      call: MockCall(),
      participants: [for (var i = 0; i < count; i++) _participant(_names[i])],
      itemBuilder: _tile,
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
      'CallParticipantsGridView stacks and squares on a narrow window',
      fileName: 'stream_call_participants_grid_small',
      brightness: brightness,
      pumpBeforeTest: pumpBeforeTest,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: '2 participants',
            child: _grid(const Size(400, 560), count: 2),
          ),
          GoldenTestScenario(
            name: '4 participants',
            child: _grid(const Size(400, 560), count: 4),
          ),
        ],
      ),
    );

    streamGoldenTest(
      'CallParticipantsGridView fills a roomier window',
      fileName: 'stream_call_participants_grid_wide',
      brightness: brightness,
      pumpBeforeTest: pumpBeforeTest,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: '3 participants',
            child: _grid(const Size(1000, 560), count: 3),
          ),
          GoldenTestScenario(
            name: '5 participants',
            child: _grid(const Size(1000, 560), count: 5),
          ),
        ],
      ),
    );

    streamGoldenTest(
      'CallParticipantsGridView puts four in a row when the window is short',
      fileName: 'stream_call_participants_grid_short',
      brightness: brightness,
      pumpBeforeTest: pumpBeforeTest,
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          GoldenTestScenario(
            name: '4 participants',
            child: _grid(const Size(1400, 300), count: 4),
          ),
        ],
      ),
    );
  }
}
