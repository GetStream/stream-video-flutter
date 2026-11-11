import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../mocks.dart';

void main() {
  MockCall call({bool backstage = false, int viewers = 1}) {
    final state = MockCallState();
    when(() => state.isBackstage).thenReturn(backstage);
    when(() => state.participantCount).thenReturn(viewers);
    when(() => state.anonymousParticipantCount).thenReturn(0);

    final it = MockCall();
    when(() => it.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );
    when(() => it.partialState<bool>(any())).thenAnswer((invocation) {
      final CallStateSelector<bool> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(state));
    });
    when(() => it.partialState<int>(any())).thenAnswer((invocation) {
      final CallStateSelector<int> selector = invocation.positionalArguments[0];
      return Stream.value(selector(state));
    });
    return it;
  }

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'Livestream indicators',
      fileName: 'stream_livestream_indicators',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: 'live',
            child: StreamLiveIndicator(call: call()),
          ),
          GoldenTestScenario(
            name: 'backstage',
            child: StreamLiveIndicator(call: call(backstage: true)),
          ),
          GoldenTestScenario(
            name: 'one viewer',
            child: StreamSpectatorsIndicator(call: call()),
          ),
          GoldenTestScenario(
            name: 'many viewers',
            child: StreamSpectatorsIndicator(call: call(viewers: 1284)),
          ),
        ],
      ),
    );
  }
}
