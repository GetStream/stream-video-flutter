import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

// A call whose state can be changed from the test, counting partial-state
// subscriptions.
class _FakeCall extends Mock implements Call {
  _FakeCall(this._callState) {
    when(() => _emitter.value).thenAnswer((_) => _callState);
  }

  CallState _callState;
  final _emitter = MockStateEmitter<CallState>();
  final _changes = StreamController<CallState>.broadcast();
  int subscriptions = 0;

  set callState(CallState value) {
    _callState = value;
    _changes.add(value);
  }

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) {
    subscriptions++;
    return _changes.stream.map(selector).distinct();
  }
}

void main() {
  final initialState = CallState(
    currentUserId: 'user',
    callCid: StreamCallCid(cid: 'default:test'),
    preferences: DefaultCallPreferences(),
  );

  Widget subject(Call call, {CallStateSelector<String>? selector}) {
    return MaterialApp(
      home: PartialCallStateBuilder<String>(
        call: call,
        selector: selector ?? (state) => 'recording: ${state.isRecording}',
        builder: (context, data) => Text(data),
      ),
    );
  }

  testWidgets(
    'PartialCallStateBuilder keeps one subscription when its parent rebuilds',
    (tester) async {
      final call = _FakeCall(initialState);

      await tester.pumpWidget(subject(call));
      await tester.pumpWidget(subject(call));
      await tester.pumpWidget(subject(call));

      expect(call.subscriptions, 1);
    },
  );

  testWidgets(
    'PartialCallStateBuilder rebuilds when the selected value changes',
    (tester) async {
      final call = _FakeCall(initialState);
      await tester.pumpWidget(subject(call));

      call.callState = initialState.copyWith(isRecording: true);
      await tester.pump();

      expect(find.text('recording: true'), findsOneWidget);
    },
  );

  testWidgets(
    'PartialCallStateBuilder applies a new selector without a state change',
    (tester) async {
      final call = _FakeCall(initialState);
      await tester.pumpWidget(subject(call));

      await tester.pumpWidget(
        subject(call, selector: (state) => 'id: ${state.callCid.id}'),
      );

      expect(find.text('id: test'), findsOneWidget);
    },
  );

  testWidgets('PartialCallStateBuilder cancels its subscription when removed', (
    tester,
  ) async {
    final call = _FakeCall(initialState);
    await tester.pumpWidget(subject(call));

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));

    expect(call._changes.hasListener, isFalse);
  });
}
