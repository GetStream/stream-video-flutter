import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/audio_processing/audio_recognition_webrtc.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StreamController<SpeechActivityEvent> events;

  setUp(() {
    events = StreamController<SpeechActivityEvent>.broadcast();
  });

  tearDown(() async => events.close());

  /// Feeds [script] into the recognizer and returns the `isSpeaking` values it
  /// emitted.
  Future<List<bool>> run(
    List<(SpeechActivityEvent, Duration)> script, {
    AudioRecognitionConfig config = const AudioRecognitionConfig(),
    Duration settle = const Duration(seconds: 1),
  }) async {
    final sut = AudioRecognitionWebRTC(
      config: config,
      speechActivityStream: events.stream,
    );
    final emitted = <bool>[];

    await sut.start(
      onSoundStateChanged: (state) => emitted.add(state.isSpeaking),
    );

    for (final (event, delay) in script) {
      events.add(event);
      await Future<void>.delayed(delay);
    }

    await Future<void>.delayed(settle);
    await sut.dispose();

    return emitted;
  }

  group('AudioRecognitionWebRTC', () {
    test('reports a started/ended pair as one speaking window', () async {
      final emitted = await run([
        (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
        (const SpeechActivityEnded(), Duration.zero),
      ]);

      expect(emitted, [true, false]);
    });

    test('debounces a brief pause into a single speaking window', () async {
      final emitted = await run([
        (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
        // `ended` immediately followed by more speech: the trailing debounce
        // must swallow it instead of flapping the consumer.
        (const SpeechActivityEnded(), const Duration(milliseconds: 50)),
        (const SpeechActivityStarted(), const Duration(milliseconds: 50)),
        (const SpeechActivityEnded(), Duration.zero),
      ]);

      expect(emitted, [true, false]);
    });

    test(
      'ends the speaking state when the platform never sends `ended`, so a '
      'later utterance is reported again',
      () async {
        // iOS/macOS can deliver `started` without a matching `ended`. Without
        // the fallback the speaking state latches and no consumer sees another
        // transition until the user unmutes and mutes again.
        final emitted = await run(
          [
            (const SpeechActivityStarted(), const Duration(milliseconds: 400)),
            (const SpeechActivityStarted(), Duration.zero),
          ],
          config: const AudioRecognitionConfig(
            speechTimeout: Duration(milliseconds: 50),
            maxSpeechDuration: Duration(milliseconds: 200),
          ),
          settle: const Duration(milliseconds: 400),
        );

        expect(emitted, [true, false, true, false]);
      },
    );

    test('a repeated `started` keeps one speaking window open', () async {
      final emitted = await run(
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
        reason: 'each `started` re-arms the fallback rather than re-reporting',
      );
    });

    test('stop() cancels a pending end so no event lands after it', () async {
      final sut = AudioRecognitionWebRTC(
        config: const AudioRecognitionConfig(
          speechTimeout: Duration(milliseconds: 50),
        ),
        speechActivityStream: events.stream,
      );
      final emitted = <bool>[];

      await sut.start(
        onSoundStateChanged: (state) => emitted.add(state.isSpeaking),
      );

      events.add(const SpeechActivityStarted());
      await Future<void>.delayed(Duration.zero);
      events.add(const SpeechActivityEnded());

      await sut.stop();
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(emitted, [true]);
    });
  });
}
