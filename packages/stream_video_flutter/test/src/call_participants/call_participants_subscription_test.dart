import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
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

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    stateEmitter = MockStateEmitter<CallState>();
    participants = StreamController<List<CallParticipantState>>.broadcast();

    when(() => callState.callParticipants).thenReturn([_participant('alice')]);
    when(() => stateEmitter.value).thenReturn(callState);
    when(() => call.state).thenAnswer((_) => stateEmitter);
    when(() => call.participantsStream).thenAnswer((_) => participants.stream);
  });

  tearDown(() => participants.close());

  testWidgets('follows the call again after a controlled list is removed', (
    tester,
  ) async {
    late StateSetter setControlled;
    List<CallParticipantState>? controlled = [_participant('carol')];
    final rendered = <String>[];

    await tester.pumpWidget(
      TestWrapper(
        child: StatefulBuilder(
          builder: (context, setState) {
            setControlled = setState;
            return StreamCallParticipants(
              call: call,
              participants: controlled,
              callParticipantBuilder: (context, _, participant) {
                rendered.add(participant.userId);
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );

    expect(rendered, ['carol'], reason: 'the controlled list wins while set');

    // Handing control back to the call: the subscription was cancelled when
    // the controlled list arrived, so it has to be taken again here.
    rendered.clear();
    setControlled(() => controlled = null);
    await tester.pump();

    expect(rendered, ['alice'], reason: 'falls back to the current call state');

    rendered.clear();
    participants.add([_participant('bob')]);
    await tester.pump();
    await tester.pump();

    expect(
      rendered,
      ['bob'],
      reason:
          'without re-subscribing the list freezes silently on the last '
          'state it had, and no participant update ever lands again',
    );
  });

  testWidgets('keeps the last list when participantsStream errors', (
    tester,
  ) async {
    final rendered = <String>[];

    await tester.pumpWidget(
      TestWrapper(
        child: StreamCallParticipants(
          call: call,
          callParticipantBuilder: (context, _, participant) {
            rendered.add(participant.userId);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    participants.add([_participant('bob')]);
    await tester.pump();
    await tester.pump();
    rendered.clear();

    // A custom `participantsThrottleIntervalResolver` that throws surfaces
    // here. Without an `onError` this reaches the zone uncaught, which
    // `testWidgets` reports as a failure — which is the point of the test.
    participants.addError(StateError('resolver blew up'));
    await tester.pump();
    await tester.pump();

    expect(
      find.byType(StreamCallParticipants),
      findsOneWidget,
      reason: 'the error is logged, not rethrown at the app',
    );

    rendered.clear();
    participants.add([_participant('carol')]);
    await tester.pump();
    await tester.pump();

    expect(
      rendered,
      ['carol'],
      reason: 'the subscription survives the error and keeps delivering',
    );
  });

  testWidgets('re-sorts when the sort comparator changes', (tester) async {
    late StateSetter setSort;
    var descending = false;
    final rendered = <String>[];

    when(
      () => callState.callParticipants,
    ).thenReturn([_participant('alice'), _participant('bob')]);

    await tester.pumpWidget(
      TestWrapper(
        child: StatefulBuilder(
          builder: (context, setState) {
            setSort = setState;
            return StreamCallParticipants(
              call: call,
              sort: descending
                  ? (a, b) => b.userId.compareTo(a.userId)
                  : (a, b) => a.userId.compareTo(b.userId),
              callParticipantBuilder: (context, _, participant) {
                rendered.add(participant.userId);
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );

    expect(rendered, ['alice', 'bob']);

    // No participant update follows, which is the whole point: the throttled
    // stream is silent in a quiet call, so nothing else would re-sort.
    rendered.clear();
    setSort(() => descending = true);
    await tester.pump();

    expect(
      rendered,
      ['bob', 'alice'],
      reason:
          'a new comparator has to be applied on the spot, not on the next '
          'join or audio level change',
    );
  });

  testWidgets('re-filters when the filter changes', (tester) async {
    late StateSetter setFilter;
    var hideBob = false;
    final rendered = <String>[];

    when(
      () => callState.callParticipants,
    ).thenReturn([_participant('alice'), _participant('bob')]);

    await tester.pumpWidget(
      TestWrapper(
        child: StatefulBuilder(
          builder: (context, setState) {
            setFilter = setState;
            return StreamCallParticipants(
              call: call,
              filter: hideBob ? (p) => p.userId != 'bob' : (_) => true,
              callParticipantBuilder: (context, _, participant) {
                rendered.add(participant.userId);
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );

    expect(rendered, ['alice', 'bob']);

    rendered.clear();
    setFilter(() => hideBob = true);
    await tester.pump();

    expect(rendered, ['alice']);
  });
}
