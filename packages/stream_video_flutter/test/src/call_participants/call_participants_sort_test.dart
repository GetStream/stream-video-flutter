import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// Both participants report themselves visible, which is what separates the
// two presets: `regular` only consults the dominant speaker for a participant
// scrolled out of the viewport, `speaker` always does.
MockCallParticipantState _participant(
  String id, {
  bool isDominantSpeaker = false,
}) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(id);
  when(() => participant.userId).thenReturn(id);
  when(() => participant.sessionId).thenReturn(id);
  when(() => participant.uniqueParticipantKey).thenReturn(id);
  when(() => participant.isLocal).thenReturn(false);
  when(() => participant.isDominantSpeaker).thenReturn(isDominantSpeaker);
  when(() => participant.isPinned).thenReturn(false);
  when(() => participant.isSpeaking).thenReturn(false);
  when(() => participant.isScreenShareEnabled).thenReturn(false);
  when(() => participant.screenShareTrack).thenReturn(null);
  when(
    () => participant.viewportVisibility,
  ).thenReturn(ViewportVisibility.visible);
  return participant;
}

Widget _box(BuildContext _, Call __, CallParticipantState participant) =>
    SizedBox.expand(key: ValueKey('tile-${participant.sessionId}'));

void main() {
  testWidgets('a sort the caller passes inline does not re-sort every build', (
    tester,
  ) async {
    final participants = [
      _participant('first-to-join'),
      _participant('speaker', isDominantSpeaker: true),
    ];
    var comparisons = 0;

    // A fresh closure on every build, the way a call site written inline
    // hands one over. Comparing these would be function identity, so every
    // rebuild would look like a new sort.
    Future<void> pumpAgain() => tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          width: 800,
          height: 600,
          child: StreamCallParticipants(
            call: MockCall(),
            participants: participants,
            sort: (a, b) {
              comparisons++;
              return a.sessionId.compareTo(b.sessionId);
            },
            callParticipantBuilder: _box,
            floatingSelfViewBuilder: _box,
          ),
        ),
      ),
    );

    await pumpAgain();
    expect(comparisons, greaterThan(0), reason: 'sorted once on the way in');

    final afterFirstBuild = comparisons;
    await pumpAgain();
    await pumpAgain();

    expect(comparisons, afterFirstBuild);
  });

  testWidgets('picking a speaker layout re-sorts with the speaker preset', (
    tester,
  ) async {
    final participants = [
      _participant('first-to-join'),
      _participant('speaker', isDominantSpeaker: true),
    ];

    Future<void> pumpWith(ParticipantLayoutMode layoutMode) =>
        tester.pumpWidget(
          TestWrapper(
            child: SizedBox(
              width: 800,
              height: 600,
              child: StreamCallParticipants(
                call: MockCall(),
                participants: participants,
                layoutMode: layoutMode,
                callParticipantBuilder: _box,
                floatingSelfViewBuilder: _box,
              ),
            ),
          ),
        );

    // The grid's own preset leaves a visible dominant speaker where they are.
    await pumpWith(ParticipantLayoutMode.grid);

    // Nothing about the participants changes — only the layout, and with it
    // the preset the list is ordered by.
    await pumpWith(ParticipantLayoutMode.speakerTop);
    await tester.pumpAndSettle();

    final view = tester.widget<CallParticipantsSpotlightView>(
      find.byType(CallParticipantsSpotlightView),
    );
    expect(view.spotlight.sessionId, 'speaker');
  });
}
