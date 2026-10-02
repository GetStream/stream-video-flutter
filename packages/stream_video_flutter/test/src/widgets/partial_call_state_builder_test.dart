import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

// A call whose state can be changed from the test, counting partial-state
// subscriptions. Like the real call, each subscription starts with the current
// state.
class _FakeCall extends Mock implements Call {
  _FakeCall(CallState callState)
    : _changes = BehaviorSubject.seeded(callState, sync: true) {
    when(() => _emitter.value).thenAnswer((_) => _changes.value);
  }

  final BehaviorSubject<CallState> _changes;
  final _emitter = MockStateEmitter<CallState>();
  int subscriptions = 0;

  set callState(CallState value) => _changes.add(value);

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) {
    subscriptions++;
    return _changes.stream.map(selector).distinct();
  }
}

// Records the messages of every log call.
class _RecordingLogger extends StreamLogger {
  final messages = <String>[];

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    messages.add(message());
  }
}

void main() {
  final initialState = CallState(
    currentUserId: 'user',
    callCid: StreamCallCid(cid: 'default:test'),
    preferences: DefaultCallPreferences(),
  );

  String recording(CallState state) => 'recording: ${state.isRecording}';

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
    'PartialCallStateBuilder keeps one subscription when its parent rebuilds with the same selector',
    (tester) async {
      final call = _FakeCall(initialState);

      await tester.pumpWidget(subject(call, selector: recording));
      await tester.pumpWidget(subject(call, selector: recording));
      await tester.pumpWidget(subject(call, selector: recording));

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
    'PartialCallStateBuilder does not rebuild for the current value it receives on subscribing',
    (tester) async {
      final call = _FakeCall(initialState);
      var builds = 0;
      var listBuilds = 0;
      var mapBuilds = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              PartialCallStateBuilder<String>(
                call: call,
                selector: recording,
                builder: (context, data) {
                  builds++;
                  return Text(data);
                },
              ),
              PartialCallStateBuilder<List<String>>(
                call: call,
                selector: (state) => [state.callCid.id],
                builder: (context, data) {
                  listBuilds++;
                  return Text(data.join());
                },
              ),
              PartialCallStateBuilder<Map<String, List<String>>>(
                call: call,
                selector: (state) => {
                  'ids': [state.callCid.id],
                },
                builder: (context, data) {
                  mapBuilds++;
                  return Text('${data['ids']}');
                },
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(builds, 1);
      expect(listBuilds, 1);
      expect(mapBuilds, 1);
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

  testWidgets(
    'PartialCallStateBuilder moves to a new call with the same selector',
    (tester) async {
      final callA = _FakeCall(initialState);
      final callB = _FakeCall(initialState.copyWith(isRecording: true));

      await tester.pumpWidget(subject(callA, selector: recording));
      await tester.pumpWidget(subject(callB, selector: recording));

      expect(find.text('recording: true'), findsOneWidget);
      expect(callA._changes.hasListener, isFalse);

      callB.callState = initialState.copyWith(isRecording: false);
      await tester.pump();

      expect(find.text('recording: false'), findsOneWidget);
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

  testWidgets(
    'PartialCallStateBuilder shows a change that a new selector selects',
    (tester) async {
      final call = _FakeCall(initialState);
      String recording(CallState state) => state.isRecording ? 'x' : 'y';
      String broadcasting(CallState state) => state.isBroadcasting ? 'x' : 'y';

      await tester.pumpWidget(subject(call, selector: recording));
      call.callState = initialState.copyWith(isRecording: true);
      await tester.pump();
      await tester.pumpWidget(subject(call, selector: broadcasting));
      expect(find.text('y'), findsOneWidget);

      call.callState = call.state.value.copyWith(isBroadcasting: true);
      await tester.pump();

      expect(find.text('x'), findsOneWidget);
    },
  );

  testWidgets(
    'PartialCallStateBuilder reports a throwing selector once, keeps its value and keeps listening',
    (tester) async {
      final logger = _RecordingLogger();
      StreamLog()
        ..logger = logger
        ..priority = Priority.error;
      addTearDown(() {
        StreamLog()
          ..logger = const SilentStreamLogger()
          ..priority = Priority.none;
      });
      String broadcasting(CallState state) {
        if (state.isRecording) throw StateError('selector failed');
        return 'broadcasting: ${state.isBroadcasting}';
      }

      final call = _FakeCall(initialState);
      await tester.pumpWidget(subject(call, selector: broadcasting));

      call.callState = initialState.copyWith(isRecording: true);
      await tester.pump();
      call.callState = initialState.copyWith(
        isRecording: true,
        isBroadcasting: true,
      );
      await tester.pump();

      expect(tester.takeException(), isA<StateError>());
      expect(tester.takeException(), isNull);
      expect(find.text('broadcasting: false'), findsOneWidget);
      expect(logger.messages, hasLength(2));
      expect(logger.messages.first, contains('selector failed'));

      call.callState = initialState.copyWith(isBroadcasting: true);
      await tester.pump();

      expect(find.text('broadcasting: true'), findsOneWidget);
    },
  );
}
