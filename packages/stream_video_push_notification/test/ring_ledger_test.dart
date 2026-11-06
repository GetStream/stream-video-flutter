import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/background/ring_ledger.dart';

// Pins the bookkeeping of a background session's rings: when nothing is left
// to wait for, how an end hint from the backend is confirmed against the
// native calls, and how many times a ring that stays shown is checked.

void main() {
  late RingLedger ledger;

  setUp(() {
    ledger = RingLedger(logTag: 'test');
  });

  Future<List<CallData>> showing(List<String> cids) async => [
    for (final cid in cids) CallData(uuid: 'u-$cid', callCid: cid),
  ];

  group('rings and resolutions', () {
    test('is idle until a ring is added', () {
      expect(ledger.isIdle, isTrue);

      ledger.addRing('default:a');

      expect(ledger.isIdle, isFalse);
      expect(ledger.pendingRings, {'default:a'});
    });

    test('resolving the last ring reports idle; another ring does not', () {
      ledger.addRing('default:a');
      ledger.addRing('default:b');

      expect(ledger.resolveRing('default:a'), isFalse);
      expect(ledger.resolveRing('default:b'), isTrue);
    });

    test('a resolution without a cid lets every ring go', () {
      ledger.addRing('default:a');
      ledger.addRing('default:b');

      expect(ledger.resolveRing(null), isTrue);
      expect(ledger.pendingRings, isEmpty);
    });

    test('resolving a ring that is not pending reports whether idle', () {
      expect(ledger.resolveRing('default:zzz'), isTrue);

      ledger.addRing('default:a');
      expect(ledger.resolveRing('default:zzz'), isFalse);
    });
  });

  group('end hints', () {
    test('are kept only for a pending ring', () {
      expect(ledger.markEnded('default:a'), isFalse);
      expect(ledger.markEnded(null), isFalse);

      ledger.addRing('default:a');
      expect(ledger.markEnded('default:a'), isTrue);
      expect(ledger.endedRings, {'default:a': 0});
    });

    test('a fresh hint resets the checks', () async {
      ledger.addRing('default:a');
      ledger.markEnded('default:a');
      await ledger.dropEndedRings(() => showing(['default:a']));
      expect(ledger.endedRings['default:a'], 1);

      ledger.markEnded('default:a');

      expect(ledger.endedRings['default:a'], 0);
    });

    test('ringing again clears an older hint', () {
      ledger.addRing('default:a');
      ledger.markEnded('default:a');

      ledger.addRing('default:a');

      expect(ledger.endedRings, isEmpty);
    });
  });

  group('dropEndedRings', () {
    test(
      'does nothing without a hint, and does not read the native calls',
      () async {
        ledger.addRing('default:a');
        var reads = 0;

        final recheck = await ledger.dropEndedRings(() async {
          reads++;
          return const [];
        });

        expect(recheck, isFalse);
        expect(reads, 0);
        expect(ledger.pendingRings, {'default:a'});
      },
    );

    test('lets a hinted ring go once its native call is gone', () async {
      ledger.addRing('default:a');
      ledger.markEnded('default:a');

      final recheck = await ledger.dropEndedRings(() => showing([]));

      expect(recheck, isFalse);
      expect(ledger.pendingRings, isEmpty);
      expect(ledger.endedRings, isEmpty);
    });

    test(
      'keeps a hinted ring whose native call is still shown and asks again',
      () async {
        ledger.addRing('default:a');
        ledger.markEnded('default:a');

        final recheck = await ledger.dropEndedRings(
          () => showing(['default:a']),
        );

        expect(recheck, isTrue);
        expect(ledger.pendingRings, {'default:a'});
        expect(ledger.endedRings, {'default:a': 1});
      },
    );

    test('gives up on a ring still shown after the last check', () async {
      ledger.addRing('default:a');
      ledger.markEnded('default:a');

      var recheck = true;
      var checks = 0;
      while (recheck) {
        recheck = await ledger.dropEndedRings(() => showing(['default:a']));
        checks++;
      }

      expect(checks, RingLedger.maxEndedRingChecks);
      // The ring stays with its user; only the hint is dropped.
      expect(ledger.pendingRings, {'default:a'});
      expect(ledger.endedRings, isEmpty);
    });

    test('treats an unreadable native list as still shown', () async {
      ledger.addRing('default:a');
      ledger.markEnded('default:a');

      // Rejected asynchronously, as a failed method-channel read is.
      final recheck = await ledger.dropEndedRings(
        () async => throw StateError('x'),
      );

      expect(recheck, isTrue);
      expect(ledger.pendingRings, {'default:a'});
      expect(ledger.endedRings, {'default:a': 1});
    });

    test('only the hinted rings are checked', () async {
      ledger.addRing('default:a');
      ledger.addRing('default:b');
      ledger.markEnded('default:a');

      await ledger.dropEndedRings(() => showing([]));

      expect(ledger.pendingRings, {'default:b'});
    });
  });
}
