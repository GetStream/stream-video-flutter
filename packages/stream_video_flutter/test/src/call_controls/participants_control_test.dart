import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

const _participants = [
  UserInfo(id: 'a', name: 'Rene iPad'),
  UserInfo(id: 'b', name: 'rebe'),
];

void main() {
  Future<void> pump(
    WidgetTester tester, {
    List<UserInfo> participants = _participants,
    VoidCallback? onTap,
    TargetPlatform platform = TargetPlatform.macOS,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        platform: platform,
        child: StreamParticipantsControl.forParticipants(
          participants: participants,
          onTap: onTap,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('badges how many people there are', (tester) async {
    await pump(tester);

    expect(find.byType(StreamBadgeNotification), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('drops the badge when there is nobody', (tester) async {
    await pump(tester, participants: const []);

    expect(find.byType(StreamBadgeNotification), findsNothing);
  });

  testWidgets('opens the built-in list when no onTap is given', (tester) async {
    await pump(tester);

    await tester.tap(find.byType(CallControlButton));
    await tester.pumpAndSettle();

    expect(find.text('Rene iPad'), findsOneWidget);
    expect(find.text('rebe'), findsOneWidget);
  });

  // What a call screen wants: the count, but its own panel behind the press.
  testWidgets('calls onTap instead of opening the list', (tester) async {
    var tapped = 0;
    await pump(tester, onTap: () => tapped++);

    await tester.tap(find.byType(CallControlButton));
    await tester.pumpAndSettle();

    expect(tapped, 1);
    expect(find.text('Rene iPad'), findsNothing);
    expect(find.byType(StreamAdaptiveMenuAnchor), findsNothing);
  });

  testWidgets('is disabled with nobody to list and nothing to call', (
    tester,
  ) async {
    await pump(tester, participants: const []);

    expect(
      tester
          .widget<CallControlButton>(find.byType(CallControlButton))
          .onPressed,
      isNull,
    );
  });

  // An empty call still has a panel worth opening.
  testWidgets('stays pressable with onTap even with nobody to list', (
    tester,
  ) async {
    var tapped = 0;
    await pump(tester, participants: const [], onTap: () => tapped++);

    await tester.tap(find.byType(CallControlButton));
    await tester.pump();

    expect(tapped, 1);
  });

  // A name is something to read, not something that is unavailable. The
  // design system's `enabled: false` paints the label in `textDisabled`, so
  // deriving it from "there is nothing to press" greyed out every person in
  // the call. Goldens cannot catch this: the CI capture path drops overlays.
  testWidgets('lists the people without greying their names out', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byType(CallControlButton));
    await tester.pumpAndSettle();

    final rows = tester
        .widgetList<StreamContextMenuAction<void>>(
          find.byType(StreamContextMenuAction<void>),
        )
        .toList();
    expect(rows, hasLength(_participants.length));
    for (final row in rows) {
      expect(row.props.enabled, isTrue);
      // Still inert: there is nothing to pick in a list that only shows.
      expect(row.props.onTap, isNull);
    }
  });

  testWidgets('lists the people in a sheet without greying them out', (
    tester,
  ) async {
    await pump(tester, platform: TargetPlatform.iOS);
    await tester.tap(find.byType(CallControlButton));
    await tester.pumpAndSettle();

    final rows = tester
        .widgetList<StreamListTile>(find.byType(StreamListTile))
        .toList();
    expect(rows, hasLength(_participants.length));
    for (final row in rows) {
      expect(row.props.enabled, isTrue);
      expect(row.props.onTap, isNull);
    }
  });

  // The call-driven constructor is what a call screen reaches for, so the
  // mapping from participants to the badge and the list is the SDK's job
  // rather than something every app repeats.
  group('over a call', () {
    late MockCall call;
    late MockCallState callState;

    CallParticipantState participant(String id, String name) {
      final it = MockCallParticipantState();
      when(() => it.userId).thenReturn(id);
      when(() => it.name).thenReturn(name);
      when(() => it.image).thenReturn(null);
      return it;
    }

    void givenParticipants(List<CallParticipantState> participants) {
      when(() => callState.callParticipants).thenReturn(participants);
    }

    setUp(() {
      call = MockCall();
      callState = MockCallState();

      final emitter = MutableStateEmitter<CallState>(callState, sync: true);
      when(() => call.state).thenAnswer((_) => emitter);
      when(
        () => call.partialState<List<CallParticipantState>>(any()),
      ).thenAnswer((invocation) {
        final CallStateSelector<List<CallParticipantState>> selector =
            invocation.positionalArguments[0];
        return Stream.value(selector(callState));
      });
    });

    Future<void> pumpCall(WidgetTester tester, {VoidCallback? onTap}) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: TargetPlatform.macOS,
          child: StreamParticipantsControl(call: call, onTap: onTap),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("badges the call's participants", (tester) async {
      givenParticipants([
        participant('a', 'Rene iPad'),
        participant('b', 'rebe'),
      ]);

      await pumpCall(tester);

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('lists them by name', (tester) async {
      givenParticipants([participant('a', 'Rene iPad')]);

      await pumpCall(tester);
      await tester.tap(find.byType(CallControlButton));
      await tester.pumpAndSettle();

      expect(find.text('Rene iPad'), findsOneWidget);
    });

    // A row labelled with an empty string is a row of nothing, so somebody
    // the call has no name for is listed by id instead.
    testWidgets('falls back to the id of a nameless participant', (
      tester,
    ) async {
      givenParticipants([participant('user-7', '')]);

      await pumpCall(tester);
      await tester.tap(find.byType(CallControlButton));
      await tester.pumpAndSettle();

      expect(find.text('user-7'), findsOneWidget);
    });

    testWidgets('is disabled in an empty call with nothing to open', (
      tester,
    ) async {
      givenParticipants(const []);

      await pumpCall(tester);

      expect(
        tester
            .widget<CallControlButton>(find.byType(CallControlButton))
            .onPressed,
        isNull,
      );
    });

    testWidgets('calls onTap instead of opening the list', (tester) async {
      givenParticipants([participant('a', 'Rene iPad')]);
      var tapped = 0;

      await pumpCall(tester, onTap: () => tapped++);
      await tester.tap(find.byType(CallControlButton));
      await tester.pumpAndSettle();

      expect(tapped, 1);
      expect(find.text('Rene iPad'), findsNothing);
    });
  });
}
