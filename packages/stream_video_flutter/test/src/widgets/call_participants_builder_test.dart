import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

CallParticipantState _participant(String userId) {
  return CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
  );
}

void main() {
  late MockCall call;
  late MockCallState callState;
  late MockStateEmitter<CallState> stateEmitter;
  late StreamController<List<CallParticipantState>> participants;
  late int streamAccesses;

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    stateEmitter = MockStateEmitter<CallState>();
    participants = StreamController<List<CallParticipantState>>.broadcast();
    streamAccesses = 0;

    when(() => callState.callParticipants).thenReturn(const []);
    when(() => stateEmitter.value).thenReturn(callState);
    when(() => call.state).thenAnswer((_) => stateEmitter);
    // Count how often the widget reaches for the stream: it must take one and
    // keep it, whatever `Call.participantsStream` does internally.
    when(() => call.participantsStream).thenAnswer((_) {
      streamAccesses++;
      return participants.stream;
    });
  });

  tearDown(() => participants.close());

  testWidgets('takes its stream once, not on every rebuild', (tester) async {
    late StateSetter rebuildParent;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setState) {
            rebuildParent = setState;
            return CallParticipantsBuilder(
              call: call,
              builder: (context, _) => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );

    expect(streamAccesses, 1);

    for (var i = 0; i < 5; i++) {
      rebuildParent(() {});
      await tester.pump();
    }

    expect(
      streamAccesses,
      1,
      reason: 'a subscription must span rebuilds, not restart on each one',
    );
  });

  testWidgets('keeps delivering updates while an ancestor rebuilds', (
    tester,
  ) async {
    late StateSetter rebuildParent;
    List<CallParticipantState>? rendered;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setState) {
            rebuildParent = setState;
            return CallParticipantsBuilder(
              call: call,
              builder: (context, value) {
                rendered = value;
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );

    expect(rendered, isEmpty, reason: 'seeded from the current call state');

    for (var i = 1; i <= 3; i++) {
      participants.add([for (var n = 0; n < i; n++) _participant('u$n')]);
      await tester.pump();
      rebuildParent(() {});
      await tester.pump();
    }

    expect(
      rendered,
      hasLength(3),
      reason: 'a rebuilding ancestor must not starve the list',
    );
  });

  testWidgets('takes a new stream when the call changes', (tester) async {
    final otherCall = MockCall();
    final otherParticipants =
        StreamController<List<CallParticipantState>>.broadcast();
    addTearDown(otherParticipants.close);

    when(() => otherCall.state).thenAnswer((_) => stateEmitter);
    when(
      () => otherCall.participantsStream,
    ).thenAnswer((_) => otherParticipants.stream);

    late StateSetter setCall;
    var useOther = false;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setState) {
            setCall = setState;
            return CallParticipantsBuilder(
              call: useOther ? otherCall : call,
              builder: (context, _) => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );

    setCall(() => useOther = true);
    await tester.pump();

    verify(() => otherCall.participantsStream).called(1);
  });

  testWidgets('falls back to the current state when the stream errors', (
    tester,
  ) async {
    when(() => callState.callParticipants).thenReturn([_participant('alice')]);

    var built = <CallParticipantState>[];
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CallParticipantsBuilder(
          call: call,
          builder: (context, participants) {
            built = participants;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    participants.addError('boom');
    await tester.pump();

    expect(
      built.map((it) => it.userId),
      ['alice'],
      reason:
          'an error snapshot carries no data, so the widget has to fall '
          'back rather than throw a null check over the real error',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not show the previous call on the frame the call changes', (
    tester,
  ) async {
    final otherCall = MockCall();
    final otherState = MockCallState();
    final otherEmitter = MockStateEmitter<CallState>();
    final otherParticipants =
        StreamController<List<CallParticipantState>>.broadcast();
    addTearDown(otherParticipants.close);

    when(() => callState.callParticipants).thenReturn([_participant('alice')]);
    when(() => otherState.callParticipants).thenReturn([_participant('bob')]);
    when(() => otherEmitter.value).thenReturn(otherState);
    when(() => otherCall.state).thenAnswer((_) => otherEmitter);
    when(
      () => otherCall.participantsStream,
    ).thenAnswer((_) => otherParticipants.stream);

    late StateSetter setCall;
    var useOther = false;
    var built = <CallParticipantState>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setState) {
            setCall = setState;
            return CallParticipantsBuilder(
              call: useOther ? otherCall : call,
              builder: (context, participants) {
                built = participants;
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );

    expect(built.map((it) => it.userId), ['alice']);

    setCall(() => useOther = true);
    await tester.pump();

    expect(
      built.map((it) => it.userId),
      ['bob'],
      reason:
          '`StreamBuilder` carries its snapshot across a stream swap, so '
          'without a new key the previous call renders until the new stream '
          'emits',
    );
  });
}
