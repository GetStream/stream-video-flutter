import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/connection/connection_executor.dart';
import 'package:stream_video/src/call/connection/reconnect_trigger.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  ReconnectRequest request(
    SfuReconnectionStrategy strategy, {
    String? reason,
    CallSession? session,
  }) {
    return ReconnectRequest(
      strategy,
      trigger: const SfuRequested(),
      reason: reason,
      session: session,
    );
  }

  group('ReconnectRequest.strongest', () {
    test('picks the strongest strategy, in any order', () {
      final fast = request(SfuReconnectionStrategy.fast, reason: 'fast');
      final migrate = request(
        SfuReconnectionStrategy.migrate,
        reason: 'migrate',
      );
      final rejoin = request(SfuReconnectionStrategy.rejoin, reason: 'rejoin');

      expect(ReconnectRequest.strongest([fast, rejoin, migrate]), rejoin);
      expect(ReconnectRequest.strongest([rejoin, migrate, fast]), rejoin);
      expect(ReconnectRequest.strongest([fast, migrate]), migrate);
    });

    test('takes the later request on equal strength', () {
      final first = request(SfuReconnectionStrategy.fast, reason: 'first');
      final second = request(SfuReconnectionStrategy.fast, reason: 'second');

      expect(ReconnectRequest.strongest([first, second]), second);
    });

    test('is null for no requests', () {
      expect(ReconnectRequest.strongest(const []), isNull);
    });

    test('counts as triggered by the network for a network trigger', () {
      const network = ReconnectRequest(
        SfuReconnectionStrategy.fast,
        trigger: NetworkLost(),
      );

      expect(network.triggeredByNetwork, isTrue);
      expect(request(SfuReconnectionStrategy.fast).triggeredByNetwork, isFalse);
    });
  });

  group('ConnectionExecutor', () {
    test('runs tasks one at a time, in order', () async {
      final executor = ConnectionExecutor();
      final gate = Completer<void>();
      final order = <String>[];

      final first = executor.run(() async {
        order.add('first started');
        await gate.future;
        order.add('first done');
      });
      final second = executor.run(() async => order.add('second'));
      await pumpEventQueue();
      expect(order, ['first started']);

      gate.complete();
      await Future.wait([first, second]);

      expect(order, ['first started', 'first done', 'second']);
    });

    test('is busy while a task runs or is queued', () async {
      final executor = ConnectionExecutor();
      expect(executor.isBusy, isFalse);

      final gate = Completer<void>();
      final first = executor.run(() => gate.future);
      final second = executor.run(() async {});
      expect(executor.isBusy, isTrue);

      gate.complete();
      await first;
      expect(executor.isBusy, isTrue, reason: 'second is still queued');
      await second;
      expect(executor.isBusy, isFalse);
    });

    test('holds every request for the same session, and takeHeld clears '
        'them', () {
      final executor = ConnectionExecutor();
      final session = _FakeCallSession();
      expect(executor.takeHeld(), isEmpty);

      final fast = request(SfuReconnectionStrategy.fast, session: session);
      final rejoin = request(SfuReconnectionStrategy.rejoin, session: session);
      executor
        ..hold(fast)
        ..hold(rejoin);

      expect(executor.takeHeld(), [fast, rejoin]);
      expect(executor.takeHeld(), isEmpty);
    });

    test('drops held requests for another session', () {
      final executor = ConnectionExecutor();
      final older = request(
        SfuReconnectionStrategy.rejoin,
        session: _FakeCallSession(),
      );
      final newer = request(
        SfuReconnectionStrategy.fast,
        session: _FakeCallSession(),
      );

      executor
        ..hold(older)
        ..hold(newer);

      expect(executor.takeHeld(), [newer]);
    });
  });
}

class _FakeCallSession extends Fake implements CallSession {
  @override
  Future<void> dispose() async {}
}
