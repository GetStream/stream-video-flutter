import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

CallParticipantState _participant(String userId) {
  return CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
  );
}

CallStateNotifier _stateManager(
  ParticipantsThrottleIntervalResolver? resolver,
) {
  return CallStateNotifier(
    CallState(
      preferences: DefaultCallPreferences(
        participantsThrottleIntervalResolver: resolver,
      ),
      currentUserId: SampleCallData.defaultUserInfo.id,
      callCid: SampleCallData.defaultCid,
    ),
  );
}

void _setParticipants(CallStateNotifier manager, List<String> userIds) {
  manager.state = manager.state.copyWith(
    callParticipants: userIds.map(_participant).toList(),
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('Call.participantsStream', () {
    test('hands every listener the same stream', () {
      final call = createTestCall();

      expect(
        identical(call.participantsStream, call.participantsStream),
        isTrue,
        reason: 'a fresh stream per access resubscribes on every rebuild',
      );
    });

    test('replays the latest value to a late listener', () async {
      final call = createTestCall();

      final first = <int>[];
      final subscription = call.participantsStream.listen(
        (value) => first.add(value.length),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(first, isNotEmpty);

      final joinedLate = <int>[];
      final lateSubscription = call.participantsStream.listen(
        (value) => joinedLate.add(value.length),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(
        joinedLate,
        isNotEmpty,
        reason: 'a late listener must not wait for the list to change',
      );

      await subscription.cancel();
      await lateSubscription.cancel();
    });

    test('gives two listeners the same values', () async {
      final call = createTestCall();

      final a = <int>[];
      final b = <int>[];
      final subA = call.participantsStream.listen((v) => a.add(v.length));
      final subB = call.participantsStream.listen((v) => b.add(v.length));

      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(a, b, reason: 'one shared window, so no listener drifts');

      await subA.cancel();
      await subB.cancel();
    });
  });

  group('Call.participantsStream throttling', () {
    test('collapses several updates in one window into one emission', () async {
      final manager = _stateManager((_) => const Duration(milliseconds: 150));
      final call = createTestCall(stateManager: manager);

      final seen = <int>[];
      final subscription = call.participantsStream.listen(
        (value) => seen.add(value.length),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      seen.clear();

      _setParticipants(manager, ['alice']);
      _setParticipants(manager, ['alice', 'bob']);
      _setParticipants(manager, ['alice', 'bob', 'carol']);

      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(
        seen,
        [3],
        reason: 'one window, so only the last list of the three lands',
      );

      await subscription.cancel();
    });

    test('a null resolver emits every change', () async {
      final manager = _stateManager(null);
      final call = createTestCall(stateManager: manager);

      final seen = <int>[];
      final subscription = call.participantsStream.listen(
        (value) => seen.add(value.length),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      seen.clear();

      _setParticipants(manager, ['alice']);
      _setParticipants(manager, ['alice', 'bob']);
      _setParticipants(manager, ['alice', 'bob', 'carol']);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(seen, [1, 2, 3]);

      await subscription.cancel();
    });

    test('a listener joining mid-window starts from the live state', () async {
      final manager = _stateManager((_) => const Duration(milliseconds: 300));
      final call = createTestCall(stateManager: manager);

      final early = <int>[];
      final earlySubscription = call.participantsStream.listen(
        (value) => early.add(value.length),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // Opens a window. Until it closes, the shared subject still carries the
      // empty list this call started on.
      _setParticipants(manager, ['alice', 'bob']);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final late = <int>[];
      final lateSubscription = call.participantsStream.listen(
        (value) => late.add(value.length),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(
        late,
        [2],
        reason:
            'replaying the last closed window here would walk the list '
            'backwards and drop both participants off screen',
      );

      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(late, [2], reason: 'and the window close must not repeat it');
      expect(early.last, 2);

      await earlySubscription.cancel();
      await lateSubscription.cancel();
    });

    test('delivers the next value after an error is replayed', () async {
      // A throwing resolver is the integrator-supplied path that puts an error
      // into the stream; the subject underneath caches it for the next
      // listener.
      var resolverThrows = false;
      final manager = _stateManager((_) {
        if (resolverThrows) throw 'boom';
        return const Duration(milliseconds: 1);
      });
      final call = createTestCall(stateManager: manager);

      final early = call.participantsStream.listen((_) {}, onError: (_) {});
      await Future<void>.delayed(const Duration(milliseconds: 20));

      resolverThrows = true;
      _setParticipants(manager, ['alice', 'bob']);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      resolverThrows = false;

      // A listener arriving now is opened with the cached error rather than a
      // value, so the flag that drops the replay must be set by either.
      final seen = <int>[];
      final errors = <Object>[];
      final late = call.participantsStream.listen(
        (value) => seen.add(value.length),
        onError: errors.add,
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      seen.clear();

      _setParticipants(manager, ['alice']);
      await Future<void>.delayed(const Duration(milliseconds: 40));

      expect(
        seen,
        [1],
        reason:
            'the first value after a replayed error must not be eaten as '
            'if it were the replay',
      );
      expect(errors, isNotEmpty);

      await early.cancel();
      await late.cancel();
    });
  });
}
