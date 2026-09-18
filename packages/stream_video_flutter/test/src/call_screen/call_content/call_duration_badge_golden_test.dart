import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../mocks.dart';

typedef _Status = ({bool encrypted, bool recording, bool presenting});

void main() {
  /// A call reporting [elapsed] on the wire, with the states given.
  MockCall call({
    required Duration elapsed,
    bool encrypted = false,
    bool recording = false,
    bool presenting = false,
  }) {
    final presenter = MockCallParticipantState();
    when(() => presenter.isScreenShareEnabled).thenReturn(presenting);

    final state = MockCallState();
    when(() => state.isE2eeEnabled).thenReturn(encrypted);
    when(() => state.isRecording).thenReturn(recording);
    when(() => state.callParticipants).thenReturn([presenter]);

    final it = MockCall();
    when(() => it.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );
    when(() => it.partialState<_Status>(any())).thenAnswer((invocation) {
      final CallStateSelector<_Status> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(state));
    });
    when(() => it.callDurationStream).thenAnswer((_) => Stream.value(elapsed));
    return it;
  }

  // The states the design calls out, plus the two ends of the dimming rule.
  final scenarios = <String, MockCall>{
    'resting': call(elapsed: const Duration(minutes: 2, seconds: 3)),
    'nothing elapsed': call(elapsed: Duration.zero),
    'seconds only': call(elapsed: const Duration(seconds: 8)),
    'past an hour': call(
      elapsed: const Duration(hours: 1, minutes: 3, seconds: 5),
    ),
    'encrypted': call(elapsed: const Duration(seconds: 33), encrypted: true),
    'all three': call(
      elapsed: const Duration(minutes: 12, seconds: 40),
      encrypted: true,
      recording: true,
      presenting: true,
    ),
  };

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallDurationBadge across its states',
      fileName: 'call_duration_badge',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          for (final MapEntry(key: name, value: it) in scenarios.entries)
            GoldenTestScenario(
              name: name,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CallDurationBadge(call: it),
              ),
            ),
        ],
      ),
    );
  }
}
