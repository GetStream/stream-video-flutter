import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// Answers every partial-state request from one fixed call state.
class _FakeCall extends Mock implements Call {
  _FakeCall(this._callState)
    : _emitter = MutableStateEmitter<CallState>(_callState, sync: true);

  final CallState _callState;
  final MutableStateEmitter<CallState> _emitter;

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      Stream.value(selector(_callState));
}

void main() {
  testWidgets(
    'LivestreamBackstageContent shows the server count of early joiners',
    (tester) async {
      // A large call: the client holds details for a few participants only.
      final backstage = CallState(
        currentUserId: 'viewer',
        callCid: StreamCallCid(cid: 'livestream:test'),
        preferences: DefaultCallPreferences(),
      ).copyWith(isBackstage: true, participantCount: 3000);

      await tester.pumpWidget(
        MaterialApp(
          home: LivestreamBackstageContent(call: _FakeCall(backstage)),
        ),
      );
      await tester.pump();

      expect(find.textContaining('3000 participants'), findsOneWidget);
    },
  );
}
