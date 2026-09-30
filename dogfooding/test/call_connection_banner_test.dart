import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/widgets/call_connection_banner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// A call whose status a test sets, carrying only what the banner reads.
class _FakeCall extends Fake implements Call {
  _FakeCall()
    : _state = MutableStateEmitter(
        CallState(
          callCid: StreamCallCid.from(
            type: StreamCallType.defaultType(),
            id: 'id',
          ),
          currentUserId: 'userId',
          preferences: DefaultCallPreferences(),
        ),
      );

  final MutableStateEmitter<CallState> _state;

  set status(CallStatus status) {
    _state.value = _state.value.copyWith(status: status);
  }

  @override
  StateEmitter<CallState> get state => _state;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      _state.map(selector).distinct();
}

void main() {
  late _FakeCall call;

  setUp(() => call = _FakeCall());

  /// Lets a status change reach the banner, then runs its transition out.
  ///
  /// Not settled: the spinner turns for as long as it is on screen. The first
  /// frame delivers the status and starts the switch; the second finishes it.
  Future<void> pumpSwitch(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> pumpBanner(WidgetTester tester, CallStatus status) async {
    call.status = status;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CallConnectionBanner(call: call)),
      ),
    );
    await pumpSwitch(tester);
  }

  CallStatus reconnecting(
    CallReconnectPhase phase, {
    int attempt = 1,
    bool fast = true,
  }) => CallStatusReconnecting(
    attempt: attempt,
    isFastReconnectAttempt: fast,
    phase: phase,
  );

  testWidgets('says nothing while the call is connected', (tester) async {
    await pumpBanner(tester, CallStatus.connected());

    expect(find.byType(StreamSnackbar), findsNothing);
  });

  testWidgets('says the call is offline while it waits for the network', (
    tester,
  ) async {
    await pumpBanner(tester, reconnecting(CallReconnectPhase.offline));

    expect(find.text("You're offline. Waiting for the network…"), findsOne);
  });

  testWidgets('tells reconnecting from joining', (tester) async {
    await pumpBanner(tester, reconnecting(CallReconnectPhase.waiting));
    expect(find.text('Reconnecting…'), findsOne);

    call.status = reconnecting(CallReconnectPhase.joining);
    await pumpSwitch(tester);
    expect(find.text('Joining…'), findsOne);
    expect(find.text('Reconnecting…'), findsNothing);
  });

  testWidgets('names the attempt once there has been more than one', (
    tester,
  ) async {
    await pumpBanner(
      tester,
      reconnecting(CallReconnectPhase.joining, attempt: 2, fast: false),
    );

    expect(find.text('Joining… (attempt 2)'), findsOne);
  });

  testWidgets('says the call is moving on a migration', (tester) async {
    await pumpBanner(tester, CallStatus.migrating());

    expect(find.text('Moving to another server…'), findsOne);
  });

  testWidgets('goes away once the call is connected again', (tester) async {
    await pumpBanner(tester, reconnecting(CallReconnectPhase.joining));
    expect(find.byType(StreamSnackbar), findsOne);

    call.status = CallStatus.connected();
    await pumpSwitch(tester);

    expect(find.byType(StreamSnackbar), findsNothing);
  });
}
