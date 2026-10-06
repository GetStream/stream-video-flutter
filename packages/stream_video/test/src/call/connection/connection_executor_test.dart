import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/connection/connection_executor.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  group('ReconnectRequest.mergedWith', () {
    final session = _FakeCallSession();

    ReconnectRequest request(
      SfuReconnectionStrategy strategy, {
      String? reason,
      bool network = false,
    }) {
      return ReconnectRequest(
        strategy,
        reason: reason,
        triggeredByNetwork: network,
        session: session,
      );
    }

    test('keeps the stronger strategy, in either order', () {
      final fast = request(SfuReconnectionStrategy.fast, reason: 'fast');
      final migrate = request(
        SfuReconnectionStrategy.migrate,
        reason: 'migrate',
      );
      final rejoin = request(SfuReconnectionStrategy.rejoin, reason: 'rejoin');

      expect(fast.mergedWith(rejoin).strategy, SfuReconnectionStrategy.rejoin);
      expect(rejoin.mergedWith(fast).strategy, SfuReconnectionStrategy.rejoin);
      expect(fast.mergedWith(migrate).reason, 'migrate');
      expect(migrate.mergedWith(rejoin).reason, 'rejoin');
      expect(rejoin.mergedWith(migrate).reason, 'rejoin');
    });

    test('takes the later request on equal strength', () {
      final first = request(SfuReconnectionStrategy.fast, reason: 'first');
      final second = request(SfuReconnectionStrategy.fast, reason: 'second');

      expect(first.mergedWith(second).reason, 'second');
    });

    test('counts as triggered by the network if either request was', () {
      final network = request(SfuReconnectionStrategy.fast, network: true);
      final rejoin = request(SfuReconnectionStrategy.rejoin);

      expect(network.mergedWith(rejoin).triggeredByNetwork, isTrue);
      expect(rejoin.mergedWith(network).triggeredByNetwork, isTrue);
    });

    test('a request for another session replaces this one', () {
      final rejoin = request(SfuReconnectionStrategy.rejoin);
      final other = ReconnectRequest(
        SfuReconnectionStrategy.fast,
        session: _FakeCallSession(),
      );

      final merged = rejoin.mergedWith(other);

      expect(merged, same(other));
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

    test('merges held requests, and takeHeld clears them', () {
      final executor = ConnectionExecutor();
      final session = _FakeCallSession();
      expect(executor.takeHeld(), isNull);

      executor
        ..hold(
          ReconnectRequest(SfuReconnectionStrategy.fast, session: session),
        )
        ..hold(
          ReconnectRequest(SfuReconnectionStrategy.rejoin, session: session),
        );

      expect(executor.takeHeld()?.strategy, SfuReconnectionStrategy.rejoin);
      expect(executor.takeHeld(), isNull);
    });
  });
}

class _FakeCallSession extends Fake implements CallSession {
  @override
  Future<void> dispose() async {}
}
