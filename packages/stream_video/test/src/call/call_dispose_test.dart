import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';

/// Pins that a `Call` is joined once, and what `Call.dispose` releases.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  /// Completes once every stream of [call] is done.
  Future<void> streamsDone(Call call) {
    const limit = Duration(seconds: 5);
    return Future.wait(
      [
        call.state.drain<void>(),
        call.partialState((state) => state.status).drain<void>(),
        call.participantsStream.drain<void>(),
        call.callEvents.drain<void>(),
        call.stats.drain<void>(),
        call.closedCaptions.drain<void>(),
        call.callDurationStream.drain<void>(),
      ].map((done) => done.timeout(limit)),
    );
  }

  test('a join after leave fails with CallLeftException', () async {
    final call = harness.buildCall();
    await call.join();
    await call.leave();

    final result = await call.join();

    expect(result.getErrorOrNull(), isA<CallLeftException>());
  });

  test('dispose leaves a joined call and completes its streams', () async {
    final call = harness.buildCall();
    await call.join();
    final done = streamsDone(call);

    await call.dispose();

    await done;
    expect(call.state.value.status, isA<CallStatusDisconnected>());
    verify(
      () => harness.session.leave(reason: any(named: 'reason')),
    ).called(1);
    verify(harness.session.dispose).called(1);
  });

  test('dispose after leave does not leave again', () async {
    final call = harness.buildCall();
    await call.join();
    await call.leave();

    await call.dispose();

    verify(
      () => harness.session.leave(reason: any(named: 'reason')),
    ).called(1);
    verify(harness.session.dispose).called(1);
  });

  test('dispose during a leave waits for the leave to finish', () async {
    final call = harness.buildCall();
    await call.join();
    final gate = Completer<void>();
    when(harness.session.dispose).thenAnswer((_) => gate.future);

    final left = call.leave();
    await pumpEventQueue();
    var disposed = false;
    final disposing = call.dispose().then((_) => disposed = true);
    await pumpEventQueue();

    expect(disposed, isFalse);

    gate.complete();
    await left;
    await disposing;
    expect(call.state.value.status, isA<CallStatusDisconnected>());
    verify(harness.session.dispose).called(1);
  });

  test('a state change after dispose is dropped', () async {
    final call = harness.buildCall();
    await call.join();
    await call.dispose();
    final last = call.state.value;

    call.updateCallPreferences(
      DefaultCallPreferences(connectTimeout: const Duration(seconds: 1)),
    );

    expect(call.state.value, same(last));
  });

  test('a second dispose does nothing', () async {
    final call = harness.buildCall();
    await call.join();

    await call.dispose();
    await call.dispose();

    verify(
      () => harness.session.leave(reason: any(named: 'reason')),
    ).called(1);
    verify(harness.session.dispose).called(1);
  });

  test('a join after dispose fails with CallLeftException', () async {
    final call = harness.buildCall();
    await call.dispose();

    final result = await call.join();

    expect(result.getErrorOrNull(), isA<CallLeftException>());
  });

  test('dispose on a call never joined completes its streams', () async {
    final call = harness.buildCall();
    final done = streamsDone(call);

    await call.dispose();

    await done;
    harness.verifyMakeCallSessionCount(0);
  });
}
