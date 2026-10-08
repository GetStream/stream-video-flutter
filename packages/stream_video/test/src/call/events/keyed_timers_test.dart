import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/events/keyed_timers.dart';

void main() {
  const duration = Duration(seconds: 1);

  test('starting a key again replaces its pending timer', () {
    fakeAsync((async) {
      final fired = <String>[];
      final timers = KeyedTimers()
        ..start('a', duration, () => fired.add('first'));
      async.elapse(duration ~/ 2);
      timers.start('a', duration, () => fired.add('second'));
      async.elapse(duration * 2);

      expect(fired, ['second']);
    });
  });

  test('a fired timer does not drop the timer that replaced it', () {
    fakeAsync((async) {
      final fired = <String>[];
      final timers = KeyedTimers();
      // The first timer fires and starts the key again from its callback.
      timers.start('a', duration, () {
        fired.add('first');
        timers.start('a', duration, () => fired.add('second'));
      });
      async.elapse(duration);
      timers.cancel('b');
      async.elapse(duration);

      expect(fired, ['first', 'second']);
    });
  });

  test('cancel and cancelAll stop pending timers', () {
    fakeAsync((async) {
      final fired = <String>[];
      KeyedTimers()
        ..start('a', duration, () => fired.add('a'))
        ..start('b', duration, () => fired.add('b'))
        ..start('c', duration, () => fired.add('c'))
        ..cancel('a')
        ..cancelAll();
      async.elapse(duration * 2);

      expect(fired, isEmpty);
    });
  });
}
