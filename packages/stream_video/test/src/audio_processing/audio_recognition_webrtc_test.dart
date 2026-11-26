import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/audio_processing/audio_recognition_webrtc.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart' as rtc;

import '../../fixtures/fake_webrtc_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakePlatformEvents platformEvents;

  setUp(() {
    platformEvents = _FakePlatformEvents();
    PlatformAudioController.instance = PlatformAudioController.withEngine(
      FakeWebRtcEngine(events: platformEvents),
    );
  });

  tearDown(() {
    PlatformAudioController.instance = null;
  });

  /// Feeds [script] into the recognizer on [async]'s fake clock and returns the
  /// `isSpeaking` values it emitted.
  ///
  /// The event controller is built inside the fake zone deliberately: a
  /// broadcast controller schedules delivery in the zone it was created in, so
  /// one built outside would deliver on the real clock and never be flushed by
  /// [FakeAsync].
  List<bool> run(
    FakeAsync async,
    List<(rtc.SpeechActivity, Duration)> script, {
    AudioRecognitionConfig config = const AudioRecognitionConfig(),
    Duration settle = const Duration(seconds: 1),
  }) {
    final events = platformEvents.speech = StreamController.broadcast();
    final sut = AudioRecognitionWebRTC(config: config);
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
          (rtc.SpeechActivity.started, const Duration(milliseconds: 50)),
          (rtc.SpeechActivity.ended, Duration.zero),
        ]);

        expect(emitted, [true, false]);
      });
    });

    test('debounces a brief pause into a single speaking window', () {
      fakeAsync((async) {
        final emitted = run(async, [
          (rtc.SpeechActivity.started, const Duration(milliseconds: 50)),
          // `ended` immediately followed by more speech: the trailing debounce
          // must swallow it instead of flapping the consumer.
          (rtc.SpeechActivity.ended, const Duration(milliseconds: 50)),
          (rtc.SpeechActivity.started, const Duration(milliseconds: 50)),
          (rtc.SpeechActivity.ended, Duration.zero),
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
                rtc.SpeechActivity.started,
                const Duration(milliseconds: 400),
              ),
              (rtc.SpeechActivity.started, Duration.zero),
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
            (rtc.SpeechActivity.started, const Duration(milliseconds: 50)),
            (rtc.SpeechActivity.started, const Duration(milliseconds: 50)),
            (rtc.SpeechActivity.started, Duration.zero),
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
        final events = platformEvents.speech = StreamController.broadcast();
        final sut = AudioRecognitionWebRTC(
          config: const AudioRecognitionConfig(
            speechTimeout: Duration(milliseconds: 50),
          ),
        );
        final emitted = <bool>[];

        unawaited(
          sut.start(
            onSoundStateChanged: (state) => emitted.add(state.isSpeaking),
          ),
        );
        async.flushMicrotasks();

        events.add(rtc.SpeechActivity.started);
        async.flushMicrotasks();
        events.add(rtc.SpeechActivity.ended);
        async.flushMicrotasks();

        unawaited(sut.stop());
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 200));

        unawaited(events.close());
        async.flushMicrotasks();

        expect(emitted, [true]);
      });
    });

    test('keeps speaking without a cap when there is no maximum', () {
      fakeAsync((async) {
        final emitted = run(
          async,
          [
            (rtc.SpeechActivity.started, const Duration(milliseconds: 400)),
            (rtc.SpeechActivity.ended, Duration.zero),
          ],
          config: const AudioRecognitionConfig(
            speechTimeout: Duration(milliseconds: 50),
            maxSpeechDuration: null,
          ),
        );

        expect(emitted, [true, false]);
      });
    });

    test('a `started` during the trailing silence keeps speaking without '
        'a cap', () {
      fakeAsync((async) {
        final emitted = run(
          async,
          [
            (rtc.SpeechActivity.started, const Duration(milliseconds: 50)),
            (rtc.SpeechActivity.ended, const Duration(milliseconds: 20)),
            (rtc.SpeechActivity.started, const Duration(milliseconds: 400)),
          ],
          config: const AudioRecognitionConfig(
            speechTimeout: Duration(milliseconds: 50),
            maxSpeechDuration: null,
          ),
          settle: Duration.zero,
        );

        expect(emitted, [true]);
      });
    });

    test('starts detection on the provided microphone and stops it', () async {
      final sut = AudioRecognitionWebRTC(deviceIdProvider: () => 'mic-2');

      await sut.start(onSoundStateChanged: (_) {});
      expect(platformEvents.started, ['mic-2']);
      expect(platformEvents.stopCount, 0);

      await sut.stop();
      expect(platformEvents.stopCount, 1);
    });

    test('every recognition runs a detector of its own', () async {
      final first = AudioRecognitionWebRTC(deviceIdProvider: () => 'mic-1');
      final second = AudioRecognitionWebRTC(deviceIdProvider: () => 'mic-2');

      await first.start(onSoundStateChanged: (_) {});
      await second.start(onSoundStateChanged: (_) {});
      await first.stop();

      expect(platformEvents.started, ['mic-1', 'mic-2']);
      expect(platformEvents.detectors.map((d) => d.running), [false, true]);
      await second.dispose();
    });

    test('stop() before start() does not stop detection', () async {
      final sut = AudioRecognitionWebRTC();

      await sut.stop();

      expect(platformEvents.stopCount, 0);
    });

    test(
      'a detection that fails to start is rethrown and cleaned up',
      () async {
        platformEvents.startError = StateError('no microphone');
        final sut = AudioRecognitionWebRTC();

        await expectLater(
          sut.start(onSoundStateChanged: (_) {}),
          throwsA(isA<StateError>()),
        );
        expect(platformEvents.stopCount, 1);
        expect(platformEvents.speech.hasListener, isFalse);

        platformEvents.startError = null;
        await sut.start(onSoundStateChanged: (_) {});
        expect(platformEvents.started, [null, null]);
      },
    );
  });
}

// ignore: subtype_of_sealed_class, a fake for the tests
class _FakePlatformEvents implements rtc.WebRtcPlatformEvents {
  StreamController<rtc.SpeechActivity> speech = StreamController.broadcast();

  /// The device ids detection was started with.
  final started = <String?>[];

  int stopCount = 0;

  /// When set, starting detection fails with it.
  Error? startError;

  /// The detectors created, in order.
  final detectors = <_FakeDetector>[];

  @override
  Stream<rtc.SpeechActivity> get onSpeechActivity => const Stream.empty();

  @override
  rtc.SpeechActivityDetector createSpeechActivityDetector() {
    final detector = _FakeDetector(this);
    detectors.add(detector);
    return detector;
  }

  @override
  Stream<rtc.AudioRoute> get onAudioRouteChanged => const Stream.empty();

  @override
  Stream<rtc.AudioProcessingState> get onAudioProcessingStateChanged =>
      const Stream.empty();

  @override
  Stream<void> get onScreenSharingStarted => const Stream.empty();

  @override
  Stream<rtc.ScreenSharingStopped> get onScreenSharingStopped =>
      const Stream.empty();

  @override
  Stream<rtc.AudioInterruption> get onInterruption => const Stream.empty();

  @override
  Future<void> enableInterruptionEvents() async {}
}

// ignore: subtype_of_sealed_class, a fake for the tests
class _FakeDetector implements rtc.SpeechActivityDetector {
  _FakeDetector(this._events);

  final _FakePlatformEvents _events;
  bool running = false;

  @override
  Stream<rtc.SpeechActivity> get activity => _events.speech.stream;

  @override
  Future<void> start({String? deviceId}) async {
    _events.started.add(deviceId);
    if (_events.startError case final error?) throw error;
    running = true;
  }

  @override
  Future<void> stop() async {
    _events.stopCount++;
    running = false;
  }
}
