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
    when(() => callState.status).thenReturn(CallStatus.idle());
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

  Finder findDot() => find.descendant(
    of: find.byType(StreamLiveIndicator),
    matching: find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).shape == BoxShape.circle,
    ),
  );

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
      expect(findDot(), findsNothing);
    });

    testWidgets('shows the dot while live', (tester) async {
      await pump(tester, StreamLiveIndicator(call: call));

      expect(findDot(), findsOneWidget);
    });

    testWidgets('puts the dot at the start, right to left too', (
      tester,
    ) async {
      await pump(tester, StreamLiveIndicator(call: call));
      expect(
        tester.getCenter(findDot()).dx,
        lessThan(tester.getCenter(find.text('LIVE')).dx),
      );

      await pump(
        tester,
        Directionality(
          textDirection: TextDirection.rtl,
          child: StreamLiveIndicator(call: call),
        ),
      );
      expect(
        tester.getCenter(findDot()).dx,
        greaterThan(tester.getCenter(find.text('LIVE')).dx),
      );
    });

    testWidgets('shrinks its label in a narrow space', (tester) async {
      when(() => callState.isBackstage).thenReturn(true);

      await pump(
        tester,
        SizedBox(width: 60, child: StreamLiveIndicator(call: call)),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(StreamLiveIndicator)).width, 60);
    });

    testWidgets(
      'the widget style beats the local theme, which beats the video theme',
      (tester) async {
        await pump(
          tester,
          _WithVideoTheme(
            update: (theme) => theme.copyWith(
              liveIndicatorTheme: const StreamLiveIndicatorThemeData(
                style: StreamLiveIndicatorStyle(dotSize: 4, spacing: 2),
              ),
            ),
            child: StreamLiveIndicatorTheme(
              data: const StreamLiveIndicatorThemeData(
                style: StreamLiveIndicatorStyle(spacing: 6, dotSize: 10),
              ),
              child: StreamLiveIndicator(
                call: call,
                style: const StreamLiveIndicatorStyle(dotSize: 12),
              ),
            ),
          ),
        );

        final row = tester.widget<Row>(
          find.descendant(
            of: find.byType(StreamLiveIndicator),
            matching: find.byType(Row),
          ),
        );
        expect(row.spacing, 6);
        expect(tester.getSize(findDot()).width, 12);
      },
    );

    testWidgets('reads the video theme when nothing overrides it', (
      tester,
    ) async {
      await pump(
        tester,
        _WithVideoTheme(
          update: (theme) => theme.copyWith(
            liveIndicatorTheme: const StreamLiveIndicatorThemeData(
              style: StreamLiveIndicatorStyle(dotSize: 4),
            ),
          ),
          child: StreamLiveIndicator(call: call),
        ),
      );

      expect(tester.getSize(findDot()).width, 4);
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

    testWidgets('reads the count out as viewers', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, StreamSpectatorsIndicator(call: call));

      expect(find.bySemanticsLabel('5 viewers'), findsOneWidget);
      semantics.dispose();
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

    testWidgets('does not add anonymous viewers twice once joined', (
      tester,
    ) async {
      // After joining, the participant count already includes them.
      when(() => callState.status).thenReturn(CallStatus.connected());
      when(() => callState.participantCount).thenReturn(5);

      await pump(tester, StreamSpectatorsIndicator(call: call));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('leaves anonymous viewers out once joined when asked', (
      tester,
    ) async {
      when(() => callState.status).thenReturn(CallStatus.connected());
      when(() => callState.participantCount).thenReturn(5);

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

    testWidgets('puts the icon at the start, right to left too', (
      tester,
    ) async {
      await pump(tester, StreamSpectatorsIndicator(call: call));
      expect(
        tester.getCenter(find.byType(Icon)).dx,
        lessThan(tester.getCenter(find.text('5')).dx),
      );

      await pump(
        tester,
        Directionality(
          textDirection: TextDirection.rtl,
          child: StreamSpectatorsIndicator(call: call),
        ),
      );
      expect(
        tester.getCenter(find.byType(Icon)).dx,
        greaterThan(tester.getCenter(find.text('5')).dx),
      );
    });

    testWidgets('shrinks its count in a narrow space', (tester) async {
      when(() => callState.participantCount).thenReturn(123456789);

      await pump(
        tester,
        SizedBox(width: 60, child: StreamSpectatorsIndicator(call: call)),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the widget style beats the local theme, which beats the video theme',
      (tester) async {
        await pump(
          tester,
          _WithVideoTheme(
            update: (theme) => theme.copyWith(
              spectatorsIndicatorTheme:
                  const StreamSpectatorsIndicatorThemeData(
                    style: StreamSpectatorsIndicatorStyle(
                      spacing: 2,
                      iconSize: 14,
                    ),
                  ),
            ),
            child: StreamSpectatorsIndicatorTheme(
              data: const StreamSpectatorsIndicatorThemeData(
                style: StreamSpectatorsIndicatorStyle(spacing: 6, iconSize: 16),
              ),
              child: StreamSpectatorsIndicator(
                call: call,
                style: const StreamSpectatorsIndicatorStyle(iconSize: 18),
              ),
            ),
          ),
        );

        final row = tester.widget<Row>(
          find.descendant(
            of: find.byType(StreamSpectatorsIndicator),
            matching: find.byType(Row),
          ),
        );
        expect(row.spacing, 6);
        expect(tester.widget<Icon>(find.byType(Icon)).size, 18);
      },
    );

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

  group('StreamVideoTheme', () {
    const live = StreamLiveIndicatorThemeData(
      style: StreamLiveIndicatorStyle(dotSize: 4),
    );
    const spectators = StreamSpectatorsIndicatorThemeData(
      style: StreamSpectatorsIndicatorStyle(iconSize: 14),
    );

    test('copyWith carries the indicator themes', () {
      final theme = StreamVideoTheme.light().copyWith(
        liveIndicatorTheme: live,
        spectatorsIndicatorTheme: spectators,
      );

      expect(theme.liveIndicatorTheme.style?.dotSize, 4);
      expect(theme.spectatorsIndicatorTheme.style?.iconSize, 14);
    });

    test('merge carries the indicator themes', () {
      final theme = StreamVideoTheme.light().merge(
        StreamVideoTheme.light().copyWith(
          liveIndicatorTheme: live,
          spectatorsIndicatorTheme: spectators,
        ),
      );

      expect(theme.liveIndicatorTheme.style?.dotSize, 4);
      expect(theme.spectatorsIndicatorTheme.style?.iconSize, 14);
    });
  });
}

/// Replaces the ambient [StreamVideoTheme] with [update] applied to it.
class _WithVideoTheme extends StatelessWidget {
  const _WithVideoTheme({required this.update, required this.child});

  final StreamVideoTheme Function(StreamVideoTheme theme) update;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoTheme = update(StreamVideoTheme.of(context));
    return Theme(
      data: theme.copyWith(
        extensions: [
          ...theme.extensions.values.where((it) => it is! StreamVideoTheme),
          videoTheme,
        ],
      ),
      child: child,
    );
  }
}
