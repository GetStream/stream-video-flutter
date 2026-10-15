import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../../test_utils/test_wrapper.dart';

void main() {
  /// Three tabs, each drawing its name as its content.
  List<StreamModalWindowTab> tabs({List<String>? built}) => [
    for (final (name, icon) in [
      ('Device', const StreamIcons().settingsFill),
      ('Effects', const StreamIcons().blurFill),
      ('Captions', const StreamIcons().captionFill),
    ])
      StreamModalWindowTab(
        icon: Icon(icon),
        label: Text(name),
        builder: (context) {
          built?.add(name);
          return Text('$name content');
        },
      ),
  ];

  /// Pumps [window] in a surface of [size], as if it had been opened in an app
  /// window that big.
  Future<void> pumpWindow(
    WidgetTester tester,
    Widget window, {
    Size size = const Size(1024, 768),
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        child: Directionality(textDirection: textDirection, child: window),
      ),
    );
  }

  /// A window on iOS whose one tab is a menu anchor, wrapped by [wrap].
  Widget windowWithMenu({Widget Function(Widget child)? wrap}) {
    final Widget menu = StreamAdaptiveMenuAnchor(
      title: 'Microphone',
      sections: [
        StreamMenuSection(
          options: [StreamMenuOption(label: 'Jabra', onSelected: () {})],
        ),
      ],
      builder: (context, handle) => TextButton(
        onPressed: handle.toggle,
        child: const Text('open'),
      ),
    );

    return TestWrapper(
      platform: TargetPlatform.iOS,
      child: StreamModalWindow(
        tabs: [
          StreamModalWindowTab(
            icon: Icon(const StreamIcons().settingsFill),
            label: const Text('Device'),
            builder: (context) => wrap?.call(menu) ?? menu,
          ),
        ],
      ),
    );
  }

  group('StreamModalWindow', () {
    testWidgets('a menu in a tab opens anchored on a phone platform', (
      tester,
    ) async {
      await tester.pumpWidget(windowWithMenu());

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamSheetHeader), findsNothing);
      expect(find.text('Jabra'), findsOneWidget);
    });

    testWidgets('a tab can ask its menus for a sheet', (tester) async {
      await tester.pumpWidget(
        windowWithMenu(
          wrap: (child) => StreamAdaptiveMenuAnchorTheme(
            data: const StreamAdaptiveMenuAnchorThemeData(useSheet: true),
            child: child,
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamSheetHeader), findsOneWidget);
    });

    testWidgets('shows the first tab with its label as the title', (
      tester,
    ) async {
      await pumpWindow(tester, StreamModalWindow(tabs: tabs()));

      expect(find.text('Device content'), findsOneWidget);
      // Once in the sidebar, once as the header's title.
      expect(find.text('Device'), findsNWidgets(2));
      expect(find.text('Effects'), findsOneWidget);
    });

    testWidgets('selecting a tab shows it and reports it', (tester) async {
      final changes = <int>[];
      await pumpWindow(
        tester,
        StreamModalWindow(tabs: tabs(), onTabChanged: changes.add),
      );

      await tester.tap(find.text('Effects'));
      await tester.pump();

      expect(find.text('Effects content'), findsOneWidget);
      expect(find.text('Device content'), findsNothing);
      expect(find.text('Effects'), findsNWidgets(2));
      expect(changes, [1]);

      // Selecting the selected tab again changes nothing.
      await tester.tap(find.text('Effects').first);
      await tester.pump();
      expect(changes, [1]);
    });

    testWidgets('builds only the selected tab, again each time', (
      tester,
    ) async {
      final built = <String>[];
      await pumpWindow(tester, StreamModalWindow(tabs: tabs(built: built)));

      expect(built, ['Device']);

      await tester.tap(find.text('Captions'));
      await tester.pump();
      await tester.tap(find.text('Device').first);
      await tester.pump();

      expect(built, ['Device', 'Captions', 'Device']);
    });

    testWidgets('opens on initialIndex', (tester) async {
      await pumpWindow(
        tester,
        StreamModalWindow(tabs: tabs(), initialIndex: 2),
      );
      expect(find.text('Captions content'), findsOneWidget);
    });

    test('an initialIndex outside the tabs asserts', () {
      expect(
        () => StreamModalWindow(tabs: tabs(), initialIndex: 3),
        throwsAssertionError,
      );
      expect(
        () => StreamModalWindow(tabs: tabs(), initialIndex: -1),
        throwsAssertionError,
      );
    });

    testWidgets('losing the selected tab selects the last one left', (
      tester,
    ) async {
      await pumpWindow(
        tester,
        StreamModalWindow(tabs: tabs(), initialIndex: 2),
      );
      expect(find.text('Captions content'), findsOneWidget);

      await pumpWindow(
        tester,
        StreamModalWindow(tabs: tabs().take(2).toList()),
      );
      expect(find.text('Effects content'), findsOneWidget);
    });

    testWidgets('the title is read out as a heading', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpWindow(tester, StreamModalWindow(tabs: tabs()));

      expect(
        find.semantics.byPredicate(
          (node) => node.label == 'Device' && node.flagsCollection.isHeader,
        ),
        findsOne,
      );
      semantics.dispose();
    });

    testWidgets('the selected tab is marked selected for screen readers', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpWindow(tester, StreamModalWindow(tabs: tabs()));

      expect(
        find.semantics.byPredicate(
          (node) =>
              node.label == 'Device' &&
              node.hasFlag(SemanticsFlag.isButton) &&
              node.hasFlag(SemanticsFlag.isSelected),
        ),
        findsOne,
      );
      expect(
        find.semantics.byPredicate(
          (node) =>
              node.label == 'Effects' &&
              node.hasFlag(SemanticsFlag.isButton) &&
              !node.hasFlag(SemanticsFlag.isSelected),
        ),
        findsOne,
      );
      semantics.dispose();
    });

    testWidgets('the close button pops the window', (tester) async {
      var popped = false;

      await tester.pumpWidget(
        TestWrapper(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                await showStreamModalDialog<void>(
                  context: context,
                  builder: (context) => StreamModalWindow(tabs: tabs()),
                );
                popped = true;
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Device content'), findsOneWidget);

      await tester.tap(find.byIcon(const StreamIcons().xmark));
      await tester.pumpAndSettle();

      expect(find.text('Device content'), findsNothing);
      expect(popped, isTrue);
    });

    testWidgets('onClose replaces popping', (tester) async {
      var closed = false;
      await pumpWindow(
        tester,
        StreamModalWindow(tabs: tabs(), onClose: () => closed = true),
      );

      await tester.tap(find.byIcon(const StreamIcons().xmark));
      expect(closed, isTrue);
    });

    testWidgets('showCloseButton: false draws no close button', (tester) async {
      await pumpWindow(
        tester,
        StreamModalWindow(tabs: tabs(), showCloseButton: false),
      );

      expect(find.byIcon(const StreamIcons().xmark), findsNothing);
    });

    testWidgets('the sidebar is at the start edge', (tester) async {
      await pumpWindow(tester, StreamModalWindow(tabs: tabs()));

      expect(
        tester.getCenter(find.text('Effects')).dx,
        lessThan(tester.getCenter(find.text('Device content')).dx),
      );
    });

    testWidgets('right to left, the sidebar is at the right edge', (
      tester,
    ) async {
      await pumpWindow(
        tester,
        StreamModalWindow(tabs: tabs()),
        textDirection: TextDirection.rtl,
      );

      expect(
        tester.getCenter(find.text('Effects')).dx,
        greaterThan(tester.getCenter(find.text('Device content')).dx),
      );
    });

    group('in a narrow window', () {
      const narrow = Size(560, 600);

      testWidgets('the sidebar shows only icons', (tester) async {
        await pumpWindow(tester, StreamModalWindow(tabs: tabs()), size: narrow);

        // The labels are still in the tree for screen readers, but not drawn.
        final effects = find.text('Effects');
        expect(effects, findsOneWidget);
        expect(tester.getSize(effects), Size.zero);
        expect(find.byIcon(const StreamIcons().blurFill), findsOneWidget);
        expect(find.text('Device content'), findsOneWidget);
      });

      testWidgets('a row keeps its label for screen readers', (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpWindow(tester, StreamModalWindow(tabs: tabs()), size: narrow);

        expect(
          find.semantics.byPredicate(
            (node) =>
                node.label == 'Effects' && node.hasFlag(SemanticsFlag.isButton),
          ),
          findsOne,
        );
        semantics.dispose();
      });

      testWidgets('a row shows its label as a tooltip', (tester) async {
        await pumpWindow(tester, StreamModalWindow(tabs: tabs()), size: narrow);

        await tester.longPress(find.byIcon(const StreamIcons().blurFill));
        await tester.pumpAndSettle();

        final tooltipLabel = find.descendant(
          of: find.byType(Overlay),
          matching: find.text('Effects'),
        );
        // The hidden label in the row, and the one in the tooltip.
        expect(tooltipLabel, findsNWidgets(2));
        expect(tester.getSize(tooltipLabel.last), isNot(Size.zero));
      });

      testWidgets('tooltip replaces the label as the tooltip', (tester) async {
        await pumpWindow(
          tester,
          StreamModalWindow(
            tabs: [
              StreamModalWindowTab(
                icon: Icon(const StreamIcons().settingsFill),
                label: const Text('Device'),
                tooltip: 'Camera and microphone',
                builder: (context) => const Text('Device content'),
              ),
            ],
          ),
          size: narrow,
        );

        await tester.longPress(find.byIcon(const StreamIcons().settingsFill));
        await tester.pumpAndSettle();

        expect(find.text('Camera and microphone'), findsOneWidget);
      });

      testWidgets('tapping an icon selects its tab', (tester) async {
        await pumpWindow(tester, StreamModalWindow(tabs: tabs()), size: narrow);

        await tester.tap(find.byIcon(const StreamIcons().captionFill));
        await tester.pump();

        expect(find.text('Captions content'), findsOneWidget);
      });

      testWidgets('right to left, the icons are at the right edge', (
        tester,
      ) async {
        await pumpWindow(
          tester,
          StreamModalWindow(tabs: tabs()),
          size: narrow,
          textDirection: TextDirection.rtl,
        );

        expect(
          tester.getCenter(find.byIcon(const StreamIcons().blurFill)).dx,
          greaterThan(tester.getCenter(find.text('Device content')).dx),
        );
      });
    });

    group('theme', () {
      // The nearest focus traversal group around a row is the sidebar's.
      double sidebarWidth(WidgetTester tester) => tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Effects'),
                  matching: find.byType(FocusTraversalGroup),
                )
                .first,
          )
          .width;

      testWidgets('the sidebar is 200 wide by default', (tester) async {
        await pumpWindow(tester, StreamModalWindow(tabs: tabs()));
        expect(sidebarWidth(tester), 200);
      });

      testWidgets('a local theme overrides one value and inherits the rest', (
        tester,
      ) async {
        const red = Color(0xFFFF0000);

        await pumpWindow(
          tester,
          StreamModalWindowTheme(
            data: const StreamModalWindowThemeData(
              style: StreamModalWindowStyle(sidebarWidth: 240),
            ),
            child: StreamModalWindow(tabs: tabs()),
          ),
        );
        expect(sidebarWidth(tester), 240);

        await pumpWindow(
          tester,
          StreamModalWindowTheme(
            data: const StreamModalWindowThemeData(
              style: StreamModalWindowStyle(sidebarBorderColor: red),
            ),
            child: StreamModalWindow(tabs: tabs()),
          ),
        );
        expect(sidebarWidth(tester), 200);
      });

      testWidgets('navItemStyle merges with the default row style', (
        tester,
      ) async {
        await pumpWindow(
          tester,
          StreamModalWindowTheme(
            data: const StreamModalWindowThemeData(
              style: StreamModalWindowStyle(
                navItemStyle: StreamListTileThemeData(
                  shape: StadiumBorder(),
                ),
              ),
            ),
            child: StreamModalWindow(tabs: tabs()),
          ),
        );

        final row = tester.element(find.text('Effects'));
        final rowTheme = StreamListTileTheme.of(row);
        expect(rowTheme.shape, const StadiumBorder());
        // The default padding is kept.
        expect(
          rowTheme.contentPadding,
          EdgeInsets.symmetric(
            horizontal: row.streamSpacing.sm,
            vertical: row.streamSpacing.xs,
          ),
        );
      });

      testWidgets('reads the app-wide theme from StreamVideoTheme', (
        tester,
      ) async {
        await pumpWindow(
          tester,
          Builder(
            builder: (context) => Theme(
              data: Theme.of(context).copyWith(
                extensions: [
                  StreamVideoTheme.of(context).copyWith(
                    modalWindowTheme: const StreamModalWindowThemeData(
                      style: StreamModalWindowStyle(sidebarWidth: 260),
                    ),
                  ),
                  ...Theme.of(context).extensions.values.where(
                    (it) => it is! StreamVideoTheme,
                  ),
                ],
              ),
              child: StreamModalWindow(tabs: tabs()),
            ),
          ),
        );

        expect(sidebarWidth(tester), 260);
      });
    });
  });

  group('goldens', () {
    for (final brightness in Brightness.values) {
      streamGoldenTest(
        'StreamModalWindow renders the sidebar and the selected tab',
        fileName: 'stream_modal_window',
        brightness: brightness,
        // The window's 720 x 640, plus the space the dialog keeps around it.
        constraints: const BoxConstraints.tightFor(width: 784, height: 704),
        builder: () => StreamModalWindow(tabs: tabs()),
      );

      streamGoldenTest(
        'StreamModalWindow collapses the sidebar to icons when narrow',
        fileName: 'stream_modal_window_collapsed',
        brightness: brightness,
        constraints: const BoxConstraints.tightFor(width: 520, height: 400),
        builder: () => StreamModalWindow(tabs: tabs(), initialIndex: 1),
      );
    }
  });
}
