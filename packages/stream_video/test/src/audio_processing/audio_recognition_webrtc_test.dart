import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/audio_processing/audio_recognition_webrtc.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Feeds [script] into the recognizer on [async]'s fake clock and returns the
  /// `isSpeaking` values it emitted.
  ///
  /// The event controller is built inside the fake zone deliberately: a
  /// broadcast controller schedules delivery in the zone it was created in, so
  /// one built outside would deliver on the real clock and never be flushed by
  /// [FakeAsync].
  List<bool> run(
    FakeAsync async,
    List<(SpeechActivityEvent, Duration)> script, {
    AudioRecognitionConfig config = const AudioRecognitionConfig(),
    Duration settle = const Duration(seconds: 1),
  }) {
    final events = StreamController<SpeechActivityEvent>.broadcast();
    final sut = AudioRecognitionWebRTC(
      config: config,
      speechActivityStream: events.stream,
    );
    final emitted = <bool>[];

    unawaited(
      sut.start(onSoundStateChanged: (state) => emitted.add(state.isSpeaking)),
    );
    async.flushMicrotasks();

    for (final (event, delay) in script) {
      events.add(event);
      async.flushMicrotasks();
      async.elapse(delay);
    }

    async.elapse(settle);
    unawaited(sut.dispose());
    unawaited(events.close());
    async.flushMicrotasks();

    return emitted;
  }

  group('AudioRecognitionWebRTC', () {
    test('reports a started/ended pair as one speaking window', () {
      fakeAsync((async) {
        final emitted = run(async, [
          (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
          (const SpeechActivityEnded(), Duration.zero),
        ]);

        expect(emitted, [true, false]);
      });
    });

    test('debounces a brief pause into a single speaking window', () {
      fakeAsync((async) {
        final emitted = run(async, [
          (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
          // `ended` immediately followed by more speech: the trailing debounce
          // must swallow it instead of flapping the consumer.
          (const SpeechActivityEnded(), const Duration(milliseconds: 50)),
          (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
          (const SpeechActivityEnded(), Duration.zero),
        ]);

        expect(emitted, [true, false]);
      });
    });

    test(
      'ends the speaking state when the platform never sends `ended`, so a '
      'later utterance is reported again',
      () {
        fakeAsync((async) {
          // iOS/macOS can deliver `started` without a matching `ended`. Without
          // the fallback the speaking state latches and no consumer sees
          // another transition until the user unmutes and mutes again.
          final emitted = run(
            async,
            [
              (
                const SpeechActivityStarted(),
                const Duration(milliseconds: 400),
              ),
              (const SpeechActivityStarted(), Duration.zero),
            ],
            config: const AudioRecognitionConfig(
              speechTimeout: Duration(milliseconds: 50),
              maxSpeechDuration: Duration(milliseconds: 200),
            ),
            settle: const Duration(milliseconds: 400),
          );

          expect(emitted, [true, false, true, false]);
        });
      },
    );

    test('a repeated `started` keeps one speaking window open', () {
      fakeAsync((async) {
        final emitted = run(
          async,
          [
            (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
            (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
            (const SpeechActivityStarted(), Duration.zero),
          ],
          config: const AudioRecognitionConfig(
            speechTimeout: Duration(milliseconds: 50),
            maxSpeechDuration: Duration(milliseconds: 200),
          ),
          settle: const Duration(milliseconds: 400),
        );

        expect(
          emitted,
          [true, false],
          reason:
              'each `started` re-arms the fallback rather than re-reporting',
        );
      });
    });

    test('stop() cancels a pending end so no event lands after it', () {
      fakeAsync((async) {
        final events = StreamController<SpeechActivityEvent>.broadcast();
        final sut = AudioRecognitionWebRTC(
          config: const AudioRecognitionConfig(
            speechTimeout: Duration(milliseconds: 50),
          ),
          speechActivityStream: events.stream,
        );
        final emitted = <bool>[];

        unawaited(
          sut.start(
            onSoundStateChanged: (state) => emitted.add(state.isSpeaking),
          ),
        );
        async.flushMicrotasks();

        events.add(const SpeechActivityStarted());
        async.flushMicrotasks();
        events.add(const SpeechActivityEnded());
        async.flushMicrotasks();

        unawaited(sut.stop());
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 200));

        unawaited(events.close());
        async.flushMicrotasks();

        expect(emitted, [true]);
      });
    });
  });
}
