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
    when(
      () => _emitter.valueStream,
    ).thenAnswer((_) => Stream.value(_callState));
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

  @override
  Stream<List<CallParticipantState>> get participantsStream =>
      Stream.value(const []);

  @override
  Stream<Duration> get callDurationStream => Stream.value(Duration.zero);

  @override
  CallConnectOptions get connectOptions => const CallConnectOptions();
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
    'ToggleSpeakerphoneOption': (call) => ToggleSpeakerphoneOption(call: call),
    'LivestreamInfo': (call) => LivestreamInfo(
      call: call,
      fullscreen: false,
      onFullscreenTapped: () {},
      duration: Duration.zero,
    ),
    'LivestreamBackstageContent': (call) =>
        LivestreamBackstageContent(call: call),
    'LivestreamPlayer': (call) => LivestreamPlayer(
      call: call,
      joinBehaviour: LivestreamJoinBehaviour.manualJoin,
    ),
    'StreamCallContent': (call) => StreamCallContent(
      call: call,
      callAppBarWidgetBuilder: (context, call) => AppBar(),
      callParticipantsWidgetBuilder: (context, call) => const SizedBox(),
      callControlsWidgetBuilder: (context, call) => const SizedBox(),
    ),
    'StreamIncomingCallContent': (call) =>
        StreamIncomingCallContent(call: call),
    'StreamOutgoingCallContent': (call) =>
        StreamOutgoingCallContent(call: call),
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

  testWidgets('LivestreamPlayer builds the livestream widgets it covers', (
    tester,
  ) async {
    final call = _FakeCall(
      callState.copyWith(status: CallStatus.connected()),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(LivestreamContent), findsOneWidget);
    expect(find.byType(LivestreamInfo), findsOneWidget);
    expect(find.byType(LivestreamSpeakerphoneOption), findsOneWidget);
  });
}
