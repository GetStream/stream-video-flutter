import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

// Answers every partial-state request from one fixed call state.
class _FakeCall extends Mock implements Call {
  _FakeCall(this._callState) {
    when(() => _emitter.value).thenReturn(_callState);
    when(
      () => _emitter.valueStream,
    ).thenAnswer((_) => Stream.value(_callState));
  }

  final CallState _callState;
  final _emitter = MockStateEmitter<CallState>();

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      Stream.value(selector(_callState));

  @override
  Stream<List<CallParticipantState>> get participantsStream =>
      Stream.value(const []);

  @override
  Stream<Duration> get callDurationStream =>
      Stream.value(const Duration(seconds: 5));
}

void main() {
  final liveCall = CallState(
    currentUserId: 'viewer',
    callCid: StreamCallCid(cid: 'livestream:test'),
    preferences: DefaultCallPreferences(),
  ).copyWith(status: CallStatus.connected());

  Future<void> pumpPlayer(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LivestreamPlayer(
          call: _FakeCall(liveCall),
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('LivestreamPlayer paints inside its own repaint boundary', (
    tester,
  ) async {
    await pumpPlayer(tester);

    final boundary = find.ancestor(
      of: find.byType(Scaffold),
      matching: find.byType(RepaintBoundary),
    );
    expect(
      find.descendant(of: find.byType(LivestreamPlayer), matching: boundary),
      findsWidgets,
    );
  });

  testWidgets(
    'LivestreamPlayer paints the default controls apart from the video content',
    (tester) async {
      await pumpPlayer(tester);

      final aroundControls = find
          .ancestor(
            of: find.byType(LivestreamInfo),
            matching: find.byType(RepaintBoundary),
          )
          .evaluate()
          .toSet();
      final aroundContent = find
          .ancestor(
            of: find.byType(LivestreamContent),
            matching: find.byType(RepaintBoundary),
          )
          .evaluate()
          .toSet();
      expect(aroundControls.difference(aroundContent), isNotEmpty);
    },
  );
}
