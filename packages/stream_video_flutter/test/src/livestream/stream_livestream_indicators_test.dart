import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  late MockCall call;
  late MockCallState callState;

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    when(() => callState.isBackstage).thenReturn(false);
    when(() => callState.participantCount).thenReturn(3);
    when(() => callState.anonymousParticipantCount).thenReturn(2);
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(() => call.partialState<bool>(any())).thenAnswer((invocation) {
      final CallStateSelector<bool> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(callState));
    });
    when(() => call.partialState<int>(any())).thenAnswer((invocation) {
      final CallStateSelector<int> selector = invocation.positionalArguments[0];
      return Stream.value(selector(callState));
    });
  });

  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(TestWrapper(child: Center(child: child)));
    await tester.pumpAndSettle();
  }

  group('StreamLiveIndicator', () {
    testWidgets('shows LIVE on the accent colour while live', (tester) async {
      await pump(tester, StreamLiveIndicator(call: call));

      expect(find.text('LIVE'), findsOneWidget);
      final context = tester.element(find.byType(StreamLiveIndicator));
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(StreamLiveIndicator),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(
        (box.decoration as BoxDecoration).color,
        context.streamColorScheme.accentPrimary,
      );
    });

    testWidgets('shows BACKSTAGE without the dot in backstage', (
      tester,
    ) async {
      when(() => callState.isBackstage).thenReturn(true);

      await pump(tester, StreamLiveIndicator(call: call));

      expect(find.text('BACKSTAGE'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(StreamLiveIndicator),
          matching: find.byType(DecoratedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('is 32 tall, the height of the toolbar buttons', (
      tester,
    ) async {
      await pump(tester, StreamLiveIndicator(call: call));

      expect(tester.getSize(find.byType(StreamLiveIndicator)).height, 32);
    });
  });

  group('StreamSpectatorsIndicator', () {
    testWidgets('counts anonymous viewers by default', (tester) async {
      await pump(tester, StreamSpectatorsIndicator(call: call));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('leaves anonymous viewers out when asked', (tester) async {
      await pump(
        tester,
        StreamSpectatorsIndicator(
          call: call,
          includeAnonymousParticipants: false,
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('uses the mobile tokens for gap, text and icon', (
      tester,
    ) async {
      await pump(tester, StreamSpectatorsIndicator(call: call));

      final context = tester.element(find.byType(StreamSpectatorsIndicator));
      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(StreamSpectatorsIndicator),
          matching: find.byType(Row),
        ),
      );
      final text = tester.widget<Text>(find.text('5'));
      final icon = tester.widget<Icon>(find.byType(Icon));

      expect(row.spacing, context.streamSpacing.xs);
      expect(
        text.style?.fontSize,
        context.streamTextTheme.bodyEmphasis.fontSize,
      );
      expect(
        text.style?.fontWeight,
        context.streamTextTheme.bodyEmphasis.fontWeight,
      );
      expect(icon.size, 20);
      expect(tester.getSize(find.byType(StreamSpectatorsIndicator)).height, 32);
    });

    testWidgets('a themed style overrides the tokens', (tester) async {
      await pump(
        tester,
        StreamSpectatorsIndicatorTheme(
          data: const StreamSpectatorsIndicatorThemeData(
            style: StreamSpectatorsIndicatorStyle(spacing: 12, iconSize: 24),
          ),
          child: StreamSpectatorsIndicator(call: call),
        ),
      );

      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(StreamSpectatorsIndicator),
          matching: find.byType(Row),
        ),
      );
      expect(row.spacing, 12);
      expect(tester.widget<Icon>(find.byType(Icon)).size, 24);
    });
  });
}
