// The timings are spelled out even where they match the defaults, since the
// assertions count on them.
// ignore_for_file: avoid_redundant_argument_values

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart' as open;
import 'package:stream_video/src/call/ring_state_poller.dart';
import 'package:stream_video/stream_video.dart';

const _settings = RingStatePollingSettings(
  startAfter: Duration(seconds: 15),
  interval: Duration(seconds: 5),
);

const _ringState = open.GetCallRingStateResponse(
  acceptedBy: {},
  callCid: 'default:test-cid',
  createdByUserId: 'caller',
  duration: '1ms',
  missedBy: {},
  rejectedBy: {},
  sessionId: 'session-id',
);

Result<open.GetCallRingStateResponse> _failure(int statusCode) {
  return Result.failure(
    StreamVideoExceptionWithCause(
      message: 'request failed',
      cause: StreamApiException(
        statusCode: statusCode,
        message: 'request failed',
      ),
    ),
  );
}

void main() {
  late int polls;
  late Result<open.GetCallRingStateResponse> nextResult;
  late bool settled;

  RingStatePoller createPoller({
    Duration ringTimeout = const Duration(seconds: 30),
  }) {
    return RingStatePoller(
      settings: _settings,
      ringTimeout: ringTimeout,
      fetchRingState: () async {
        polls++;
        return nextResult;
      },
      onRingState: (_) => settled,
    );
  }

  setUp(() {
    polls = 0;
    nextResult = const Result.success(_ringState);
    settled = false;
  });

  test('stays quiet for the start period, then polls every interval', () {
    fakeAsync((async) {
      createPoller().start();

      async.elapse(const Duration(seconds: 14));
      expect(polls, 0);

      async.elapse(const Duration(seconds: 1));
      expect(polls, 1);

      async.elapse(const Duration(seconds: 5));
      expect(polls, 2);
    });
  });

  test('stops once the ring settled', () {
    fakeAsync((async) {
      final poller = createPoller()..start();
      settled = true;

      async.elapse(const Duration(seconds: 15));
      expect(polls, 1);
      expect(poller.isStopped, isTrue);

      async.elapse(const Duration(seconds: 10));
      expect(polls, 1);
    });
  });

  test('a ring event starts the quiet period over', () {
    fakeAsync((async) {
      final poller = createPoller(
        ringTimeout: const Duration(seconds: 60),
      )..start();

      async.elapse(const Duration(seconds: 16));
      expect(polls, 1);

      poller.restartQuietPeriod();
      async.elapse(const Duration(seconds: 14));
      expect(polls, 1);

      async.elapse(const Duration(seconds: 1));
      expect(polls, 2);
    });
  });

  test('never polls past the ring timeout', () {
    fakeAsync((async) {
      final poller = createPoller()..start();

      async.elapse(const Duration(seconds: 29));
      // At 15s, 20s and 25s.
      expect(polls, 3);

      async.elapse(const Duration(seconds: 1));
      expect(poller.isStopped, isTrue);

      async.elapse(const Duration(seconds: 10));
      expect(polls, 3);
    });
  });

  test('gives up on a session the server does not know', () {
    fakeAsync((async) {
      final poller = createPoller()..start();
      nextResult = _failure(404);

      async.elapse(const Duration(seconds: 15));
      expect(polls, 1);
      expect(poller.isStopped, isTrue);
    });
  });

  test('keeps polling through a transient failure', () {
    fakeAsync((async) {
      final poller = createPoller()..start();
      nextResult = _failure(500);

      async.elapse(const Duration(seconds: 20));
      expect(polls, 2);
      expect(poller.isStopped, isFalse);
    });
  });

  test('stop cancels any polling still scheduled', () {
    fakeAsync((async) {
      createPoller()
        ..start()
        ..stop();

      async.elapse(const Duration(seconds: 30));
      expect(polls, 0);
    });
  });
}
