import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

// Answers every partial-state request from one fixed call state, counting the
// subscriptions.
class _FakeCall extends Mock implements Call {
  _FakeCall(this._callState) {
    when(() => _emitter.value).thenReturn(_callState);
  }

  final CallState _callState;
  final _emitter = MockStateEmitter<CallState>();
  int subscriptions = 0;

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) {
    subscriptions++;
    return Stream.value(selector(_callState));
  }
}

void main() {
  final callState = CallState(
    currentUserId: 'user',
    callCid: StreamCallCid(cid: 'default:test'),
    preferences: DefaultCallPreferences(),
  );

  final widgets = <String, Widget Function(Call call)>{
    'ToggleRecordingOption': (call) => ToggleRecordingOption(call: call),
    'ToggleClosedCaptionsOption': (call) =>
        ToggleClosedCaptionsOption(call: call),
    'ToggleMicrophoneOption': (call) => ToggleMicrophoneOption(call: call),
    'ToggleCameraOption': (call) => ToggleCameraOption(call: call),
    'FlipCameraOption': (call) => FlipCameraOption(call: call),
    'ToggleScreenShareOption': (call) => ToggleScreenShareOption(call: call),
    'LivestreamInfo': (call) => LivestreamInfo(
      call: call,
      fullscreen: false,
      onFullscreenTapped: () {},
      duration: Duration.zero,
    ),
  };

  for (final MapEntry(key: name, value: build) in widgets.entries) {
    testWidgets('$name keeps its call-state subscriptions when rebuilt', (
      tester,
    ) async {
      final call = _FakeCall(callState);
      Widget subject() => MaterialApp(home: Scaffold(body: build(call)));

      await tester.pumpWidget(subject());
      final subscriptions = call.subscriptions;
      await tester.pumpWidget(subject());

      expect(subscriptions, isPositive);
      expect(call.subscriptions, subscriptions);
    });
  }
}
