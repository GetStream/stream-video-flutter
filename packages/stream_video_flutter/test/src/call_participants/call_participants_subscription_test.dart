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
    when(() => call.state).thenReturn(stateEmitter);
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
}
