import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  late MockCall call;
  late MockCallState callState;

  setUp(() {
    call = MockCall();
    callState = MockCallState();

    when(() => callState.participantCount).thenReturn(0);
    when(() => callState.callParticipants).thenReturn(const []);
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(() => call.partialState<int>(any())).thenAnswer((invocation) {
      final CallStateSelector<int> selector = invocation.positionalArguments[0];
      return Stream.value(selector(callState));
    });
  });

  Future<void> pump(WidgetTester tester, {Size? size}) async {
    await tester.pumpWidget(
      TestWrapper(
        child: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(size: size ?? MediaQuery.sizeOf(context)),
            child: Center(child: StreamCallParticipantsBadge(call: call)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the reported participant count', (tester) async {
    when(() => callState.participantCount).thenReturn(12);

    await pump(tester);

    expect(find.text('12'), findsOneWidget);
    expect(find.bySemanticsLabel('12 participants'), findsOneWidget);
  });

  testWidgets(
    'counts the participants in state when the reported count lags',
    (tester) async {
      when(() => callState.participantCount).thenReturn(1);
      // Built before the `when`: the mock stubs itself as it is constructed.
      final participants = [
        MockCallParticipantState(),
        MockCallParticipantState(),
      ];
      when(() => callState.callParticipants).thenReturn(participants);

      await pump(tester);

      expect(find.text('2'), findsOneWidget);
    },
  );

  testWidgets(
    'uses captionEmphasis on desktop',
    (tester) async {
      await pump(tester);

      final context = tester.element(find.byType(StreamCallParticipantsBadge));
      final text = tester.widget<Text>(find.text('0'));
      final icon = tester.widget<Icon>(find.byType(Icon));

      expect(
        text.style!.fontSize,
        context.streamTextTheme.captionEmphasis.fontSize,
      );
      expect(icon.size, 16);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'uses bodyEmphasis on mobile',
    (tester) async {
      // A wide window does not change it: the style follows the platform.
      await pump(tester, size: const Size(1440, 900));

      final context = tester.element(find.byType(StreamCallParticipantsBadge));
      final text = tester.widget<Text>(find.text('0'));
      final icon = tester.widget<Icon>(find.byType(Icon));

      expect(
        text.style!.fontSize,
        context.streamTextTheme.bodyEmphasis.fontSize,
      );
      expect(icon.size, 20);
    },
    variant: TargetPlatformVariant.mobile(),
  );
}
