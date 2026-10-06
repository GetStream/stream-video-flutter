import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// A call whose state can be changed from the test. Like the real call, each
// partial-state subscription starts with the current state.
class _FakeCall extends Mock implements Call {
  _FakeCall(CallState callState)
    : _changes = BehaviorSubject.seeded(callState, sync: true),
      _emitter = MutableStateEmitter<CallState>(callState, sync: true);

  final BehaviorSubject<CallState> _changes;
  final MutableStateEmitter<CallState> _emitter;

  set callState(CallState value) {
    _changes.add(value);
    _emitter.value = value;
  }

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      _changes.stream.map(selector).distinct(isSameCallStateSelection);

  @override
  Stream<List<CallParticipantState>> get participantsStream =>
      Stream.value(const []);

  @override
  Stream<Duration> get callDurationStream => Stream.value(Duration.zero);

  @override
  CallConnectOptions get connectOptions => const CallConnectOptions();
}

CallParticipantState _localParticipant({
  bool isScreenShareEnabled = false,
  double audioLevel = 0,
}) {
  return CallParticipantState(
    userId: 'user',
    roles: const [],
    name: 'user',
    custom: const {},
    sessionId: 'user-session',
    trackIdPrefix: 'user-prefix',
    isLocal: true,
    audioLevel: audioLevel,
    publishedTracks: {
      if (isScreenShareEnabled) SfuTrackType.screenShare: TrackState.local(),
    },
  );
}

void main() {
  final callState = CallState(
    currentUserId: 'user',
    callCid: StreamCallCid(cid: 'default:test'),
    preferences: DefaultCallPreferences(),
  );

  CallState withLocal(CallParticipantState participant) =>
      callState.copyWith(callParticipants: [participant]);

  testWidgets(
    'StreamScreenShareButton follows screen sharing and skips audio level changes',
    (tester) async {
      final call = _FakeCall(withLocal(_localParticipant()));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreamScreenShareButton(
              call: call,
              enabledScreenShareIcon: Icons.screen_share,
              disabledScreenShareIcon: Icons.stop_screen_share,
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.stop_screen_share), findsOneWidget);

      call.callState = withLocal(_localParticipant(isScreenShareEnabled: true));
      await tester.pump();
      expect(find.byIcon(Icons.screen_share), findsOneWidget);

      final icon = tester.widget(find.byIcon(Icons.screen_share));
      call.callState = withLocal(
        _localParticipant(isScreenShareEnabled: true, audioLevel: 0.5),
      );
      await tester.pump();

      expect(tester.widget(find.byIcon(Icons.screen_share)), same(icon));
    },
  );

  testWidgets(
    'StreamCallContent shows its call controls only while there is a local participant',
    (tester) async {
      final call = _FakeCall(callState);
      await tester.pumpWidget(
        MaterialApp(
          home: StreamCallContent(
            call: call,
            callAppBarWidgetBuilder: (context, call) => AppBar(),
            callParticipantsWidgetBuilder: (context, call) => const SizedBox(),
            callControlsWidgetBuilder: (context, call) =>
                const Text('controls'),
          ),
        ),
      );
      expect(find.text('controls'), findsNothing);

      call.callState = withLocal(_localParticipant());
      await tester.pump();
      expect(find.text('controls'), findsOneWidget);

      call.callState = callState;
      await tester.pump();
      expect(find.text('controls'), findsNothing);
    },
  );
}
