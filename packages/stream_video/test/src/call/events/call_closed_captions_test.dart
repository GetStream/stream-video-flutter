import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/events/call_closed_captions.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  const visibleFor = Duration(seconds: 3);

  late CallClosedCaptions captions;

  setUp(() {
    final stateManager = CallStateNotifier(
      createActiveCallState().copyWith(
        preferences: DefaultCallPreferences(
          closedCaptionsVisibilityDurationMs: visibleFor.inMilliseconds,
        ),
      ),
    );
    captions = CallClosedCaptions(
      stateManager: stateManager,
      logger: taggedLogger(tag: 'test'),
    );
  });

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

  test('cancelTimers keeps captions from being removed', () {
    fakeAsync((async) {
      captions.onClosedCaption(caption('one'));
      async.flushMicrotasks();

      captions.cancelTimers();
      async.elapse(visibleFor * 2);

      expect(texts(), ['one']);
    });
  });
}
