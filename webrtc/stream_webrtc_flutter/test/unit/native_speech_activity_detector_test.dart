// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/src/native/native_speech_activity_detector.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

void main() {
  late StreamController<SpeechActivity> speech;

  setUp(() => speech = StreamController.broadcast(sync: true));
  tearDown(() => speech.close());

  test('forwards speech only while it runs', () async {
    final detector = NativeSpeechActivityDetector(speech.stream);
    final activity = <SpeechActivity>[];
    detector.activity.listen(activity.add);

    speech.add(SpeechActivity.started);
    await detector.start();
    speech
      ..add(SpeechActivity.started)
      ..add(SpeechActivity.ended);
    await detector.stop();
    speech.add(SpeechActivity.started);
    await pumpEventQueue();

    expect(activity, [SpeechActivity.started, SpeechActivity.ended]);
  });

  test('stop ends ongoing speech', () async {
    final detector = NativeSpeechActivityDetector(speech.stream);
    final activity = <SpeechActivity>[];
    detector.activity.listen(activity.add);

    await detector.start();
    speech.add(SpeechActivity.started);
    await detector.stop();
    await pumpEventQueue();

    expect(activity, [SpeechActivity.started, SpeechActivity.ended]);
  });

  test('stopping one detector leaves another running', () async {
    final first = NativeSpeechActivityDetector(speech.stream);
    final second = NativeSpeechActivityDetector(speech.stream);
    final activity = <SpeechActivity>[];
    second.activity.listen(activity.add);

    await first.start();
    await second.start();
    await first.stop();
    speech.add(SpeechActivity.started);
    await pumpEventQueue();

    expect(activity, [SpeechActivity.started]);
    await second.stop();
  });
}
