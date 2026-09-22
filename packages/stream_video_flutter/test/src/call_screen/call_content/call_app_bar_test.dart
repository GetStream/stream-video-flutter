import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

/// The width every case is pumped at, unless it says otherwise.
const _width = 402.0;

void main() {
  // The bar only touches the call for the status it titles itself with and for
  // the leave button's press.
  late MockCall call;

  setUp(() {
    call = MockCall();
    final state = MockCallState();
    when(() => state.status).thenReturn(CallStatus.joined());
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );
  });

  CallAppBar bar({
    Widget? leading,
    Widget? title = const Text('title'),
    List<Widget>? actions = const [],
    CallAppBarStyle? style,
    bool primary = true,
  }) => CallAppBar(
    call: call,
    showBackButton: false,
    leading: leading,
    title: title,
    actions: actions,
    style: style,
    primary: primary,
  );

  Future<void> pumpBar(
    WidgetTester tester,
    CallAppBar appBar, {
    double width = _width,
    FakeViewPadding padding = FakeViewPadding.zero,
  }) async {
    tester.view
      ..devicePixelRatio = 1.0
      ..physicalSize = Size(width, 800)
      ..padding = padding;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        child: Align(alignment: Alignment.topCenter, child: appBar),
      ),
    );
  }

  group('geometry', () {
    // The number the bottom bar already uses. The two ends of a call screen
    // have to agree, or a control sits lower on one side than the other.
    testWidgets('is 72 tall, like the control bar', (tester) async {
      await pumpBar(tester, bar());

      expect(tester.getSize(find.byType(CallAppBar)).height, 72);
    });

    testWidgets('pads its edges by 12', (tester) async {
      await pumpBar(tester, bar(leading: const Text('leading')));

      final barLeft = tester.getTopLeft(find.byType(CallAppBar)).dx;

      expect(tester.getTopLeft(find.text('leading')).dx - barLeft, 12);
    });

    // What the design specifies is the visible inset, not the padding: a
    // control is 40 wide inside a 48 tap target, so the box starts 12 in and
    // the glyph 16 — the same numbers the control bar lands on.
    testWidgets('puts a control at the same offsets as the control bar', (
      tester,
    ) async {
      await pumpBar(
        tester,
        bar(leading: const CallControlButton(icon: Icon(Icons.mic))),
      );

      final button = tester.getRect(find.byType(CallControlButton));
      final appBar = tester.getRect(find.byType(CallAppBar));

      expect(button.left - appBar.left, 12);
      expect(button.width, 48);
      expect(button.height, 48);
      // 72 tall, slots centred: (72 - 48) / 2.
      expect(button.top - appBar.top, 12);
    });

    testWidgets('anchors the actions against the end edge', (tester) async {
      await pumpBar(tester, bar(actions: const [Text('action')]));

      final barRight = tester.getTopRight(find.byType(CallAppBar)).dx;

      expect(barRight - tester.getTopRight(find.text('action')).dx, 12);
    });

    // The toolbar reserves the wider side's width on *both* sides of the
    // middle, so the title holds the bar's centre however lopsided the sides
    // are.
    testWidgets('centres the title against a populated leading', (
      tester,
    ) async {
      await pumpBar(tester, bar(leading: const Text('leading')));

      final title = tester.getCenter(find.text('title'));

      expect(title.dx, _width / 2);
    });

    testWidgets('a style overrides the height and the padding', (tester) async {
      await pumpBar(
        tester,
        bar(
          leading: const Text('leading'),
          style: const CallAppBarStyle(
            height: 96,
            padding: EdgeInsets.all(24),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CallAppBar)).height, 96);
      expect(
        tester.getTopLeft(find.text('leading')).dx -
            tester.getTopLeft(find.byType(CallAppBar)).dx,
        24,
      );
    });
  });

  group('over a top inset', () {
    const inset = 47.0;
    const padding = FakeViewPadding(top: inset);

    testWidgets('a primary bar clears it', (tester) async {
      await pumpBar(tester, bar(), padding: padding);

      expect(tester.getSize(find.byType(CallAppBar)).height, 72 + inset);
    });

    // Something above it has already taken the inset, so taking it again would
    // pad the bar twice.
    testWidgets('a non-primary bar takes none of it', (tester) async {
      await pumpBar(tester, bar(primary: false), padding: padding);

      expect(tester.getSize(find.byType(CallAppBar)).height, 72);
    });

    testWidgets('heightOf agrees with what the bar renders', (tester) async {
      late double reported;

      tester.view
        ..devicePixelRatio = 1.0
        ..physicalSize = const Size(_width, 800)
        ..padding = padding;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        TestWrapper(
          child: Builder(
            builder: (context) {
              reported = CallAppBar.heightOf(context);
              return Align(alignment: Alignment.topCenter, child: bar());
            },
          ),
        ),
      );

      expect(reported, tester.getSize(find.byType(CallAppBar)).height);
    });
  });

  group('theming', () {
    testWidgets('an ambient theme restyles the bar', (tester) async {
      await pumpBar(
        tester,
        bar(leading: const Text('leading')),
      );

      await tester.pumpWidget(
        TestWrapper(
          child: CallAppBarTheme(
            data: const CallAppBarThemeData(
              style: CallAppBarStyle(height: 120),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: bar(leading: const Text('leading')),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CallAppBar)).height, 120);
    });

    // A floating bar paints from `floatingBackgroundColor`, which the
    // constructor argument has to reach as well or it silently does nothing.
    testWidgets('a backgroundColor colours a floating bar', (tester) async {
      await pumpBar(
        tester,
        CallAppBar(
          call: call,
          showBackButton: false,
          title: const Text('title'),
          actions: const [],
          backgroundColor: const Color(0xFFABCDEF),
          style: const CallAppBarStyle(
            surfaceStyle: StreamSurfaceStyle.floating,
          ),
        ),
      );

      final decoration =
          tester
                  .widget<DecoratedBox>(
                    find
                        .descendant(
                          of: find.byType(CallAppBar),
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;

      expect(
        decoration.gradient,
        isA<LinearGradient>().having(
          (it) => it.colors,
          'colors',
          contains(const Color(0xFFABCDEF)),
        ),
      );
    });

    // `Scaffold` reserves `preferredSize.height` for the slot, so a bar that
    // reports a constant is clipped to it however it is themed.
    testWidgets('an instance style survives a Scaffold.appBar slot', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Scaffold(
            appBar: bar(style: const CallAppBarStyle(height: 120)),
            body: const SizedBox(),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CallAppBar)).height, 120);
    });

    // A partial override has to leave the rest of the theme alone, which is
    // what the merging `of` is for.
    testWidgets('an instance style overrides only what it names', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: CallAppBarTheme(
            data: const CallAppBarThemeData(
              style: CallAppBarStyle(height: 120, padding: EdgeInsets.all(24)),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: bar(
                leading: const Text('leading'),
                style: const CallAppBarStyle(height: 96),
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CallAppBar)).height, 96);
      expect(
        tester.getTopLeft(find.text('leading')).dx -
            tester.getTopLeft(find.byType(CallAppBar)).dx,
        24,
      );
    });
  });

  group('defaults', () {
    testWidgets('titles itself with the call status', (tester) async {
      await pumpBar(tester, CallAppBar(call: call, showBackButton: false));

      expect(find.text('Joined'), findsOneWidget);
    });

    testWidgets('falls back to a leave button', (tester) async {
      await pumpBar(tester, CallAppBar(call: call, showBackButton: false));

      expect(find.byType(StreamLeaveCallButton), findsOneWidget);
    });

    testWidgets('draws no leave button when it is turned off', (tester) async {
      await pumpBar(
        tester,
        CallAppBar(
          call: call,
          showBackButton: false,
          showLeaveCallAction: false,
        ),
      );

      expect(find.byType(StreamLeaveCallButton), findsNothing);
    });

    testWidgets('the back button pops the route', (tester) async {
      var popped = false;

      await pumpBar(
        tester,
        CallAppBar(
          call: call,
          showLeaveCallAction: false,
          onBackPressed: () => popped = true,
          title: const Text('title'),
        ),
      );

      await tester.tap(find.byIcon(const StreamIcons().arrowLeft));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
    });
  });
}
