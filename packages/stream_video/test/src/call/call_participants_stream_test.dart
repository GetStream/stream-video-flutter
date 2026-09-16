import 'package:flutter_test/flutter_test.dart';
import 'fixtures/call_test_helpers.dart';

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
}
