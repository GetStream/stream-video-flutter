import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/events/call_closed_captions.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../../logger/impl/test_logger.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  const visibleFor = Duration(seconds: 3);

  late CallClosedCaptions captions;

  CallClosedCaptions createCaptions(Duration visibility) {
    final stateManager = CallStateNotifier(
      createActiveCallState().copyWith(
        preferences: DefaultCallPreferences(
          closedCaptionsVisibilityDurationMs: visibility.inMilliseconds,
        ),
      ),
    );
    return CallClosedCaptions(
      stateManager: stateManager,
      logger: taggedLogger(tag: 'test'),
    );
  }

  setUp(() => captions = createCaptions(visibleFor));

  StreamCallClosedCaptionsEvent caption(String text, {int second = 0}) {
    final start = DateTime(2026, 1, 1, 0, 0, second);
    return StreamCallClosedCaptionsEvent(
      SampleCallData.defaultCid,
      createdAt: start,
      startTime: start,
      endTime: start.add(const Duration(seconds: 1)),
      speakerId: 'speaker1',
      text: text,
      user: SampleCallData.testCallUser1,
      language: 'en',
      translated: false,
    );
  }

  List<String> texts() => [
    for (final c in captions.closedCaptions.value) c.text,
  ];

  test('keeps the newest captions and removes each after it expires', () {
    fakeAsync((async) {
      captions
        ..onClosedCaption(caption('one'))
        ..onClosedCaption(caption('two', second: 1))
        ..onClosedCaption(caption('three', second: 2));
      async.flushMicrotasks();

      expect(texts(), ['two', 'three']);

      async.elapse(visibleFor);

      expect(texts(), isEmpty);
    });
  });

  test('with a zero visibility duration, captions stay until pushed out', () {
    fakeAsync((async) {
      captions = createCaptions(Duration.zero)
        ..onClosedCaption(caption('one'))
        ..onClosedCaption(caption('two', second: 1));
      async.flushMicrotasks();

      expect(texts(), ['one', 'two']);

      async.elapse(const Duration(hours: 1));

      expect(texts(), ['one', 'two']);
      expect(async.pendingTimers, isEmpty);

      captions.onClosedCaption(caption('three', second: 2));
      async.flushMicrotasks();

      expect(texts(), ['two', 'three']);
    });
  });

  test('reset clears the captions and stops their removal', () {
    fakeAsync((async) {
      captions.onClosedCaption(caption('one'));
      async.flushMicrotasks();

      captions.reset();

      expect(texts(), isEmpty);
      expect(async.pendingTimers, isEmpty);
    });
  });

  test('the emitted lists are unmodifiable', () {
    fakeAsync((async) {
      captions.onClosedCaption(caption('one'));
      async.flushMicrotasks();

      final shown = captions.closedCaptions.value.single;
      expect(captions.closedCaptions.value.clear, throwsUnsupportedError);

      captions.reset();

      expect(
        () => captions.closedCaptions.value.add(shown),
        throwsUnsupportedError,
      );
    });
  });

  test('an error while handling a caption is logged', () async {
    final logger = installRecordingLogger();
    final stateManager = _MockCallStateNotifier();
    when(() => stateManager.callState).thenThrow(StateError('boom'));
    captions = CallClosedCaptions(
      stateManager: stateManager,
      logger: taggedLogger(tag: 'test'),
    );

    final uncaught = <Object>[];
    runZonedGuarded(
      () => unawaited(captions.onClosedCaption(caption('one'))),
      (error, _) => uncaught.add(error),
    );
    await pumpEventQueue();

    expect(uncaught, isEmpty);
    expect(logger.errors, [contains('boom')]);
  });
}

class _MockCallStateNotifier extends Mock implements CallStateNotifier {}
