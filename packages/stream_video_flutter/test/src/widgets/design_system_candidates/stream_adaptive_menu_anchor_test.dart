import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

// Both presentations live above the page — the anchored menu in an Overlay, the
// sheet in a route — and the capture Alchemist uses for the committed CI
// goldens drops overlay content, so an open menu snapshots blank rather than
// failing. Everything here is asserted instead of snapshotted.
void main() {
  group('StreamAdaptiveMenuAnchor', () {
    testWidgets('opens a sheet on Android', (tester) async {
      await tester.pumpWidget(
        // Android happens to be TestWrapper's default, but naming it is what
        // makes this test's pair with the macOS one legible.
        // ignore: avoid_redundant_argument_values
        const TestWrapper(platform: .android, child: _Menu()),
      );

      expect(find.byType(StreamListTile), findsNothing);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamSheetHeader), findsOneWidget);
      expect(find.byType(StreamListTile), findsNWidgets(3));
      expect(find.byType(StreamContextMenuAction<void>), findsNothing);
    });

    testWidgets('opens a sheet on iOS', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .iOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamListTile), findsNWidgets(3));
    });

    testWidgets('opens an anchored menu on macOS', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamContextMenuAction<void>), findsNWidgets(3));
      expect(find.byType(StreamSheetHeader), findsNothing);
      expect(find.byType(StreamListTile), findsNothing);
    });

    // A menu is not always a choice: a list that only shows something — the
    // people already in a call — has no radio indicators and nothing to press.
    for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
      final name = platform.name;

      testWidgets('draws a plain row where there is no choice on $name', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestWrapper(
            platform: platform,
            child: const _Menu(
              sections: [
                StreamMenuSection(
                  options: [
                    StreamMenuOption(
                      label: 'Rene',
                      leading: Icon(Icons.person),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('Rene'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
        // No choice, so no radio and no heading.
        expect(find.byType(StreamRadioIndicator), findsNothing);
        expect(find.byType(StreamContextMenuHeading), findsNothing);
      });
    }

    // A device menu carries 16px icons, so it keeps the design's row and is
    // not dragged along by the roomier one an avatar list asks for.
    testWidgets('keeps the design row when no override is given', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final row = tester.getSize(
        find.byType(StreamContextMenuAction<void>).first,
      );
      expect(row.height, 32);
    });

    // MenuAnchor clips its panel to the panel's own bounds by default, which
    // cuts off the shadow the menu's Material draws outside them — the shadow
    // stops dead along the bottom edge rather than fading out, and raising the
    // elevation changes nothing because the extra shadow is clipped too.
    testWidgets('does not let the panel clip the menu shadow', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(
        tester.widget<MenuAnchor>(find.byType(MenuAnchor)).clipBehavior,
        Clip.none,
      );
    });

    testWidgets('menuElevation reaches the menu', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(
          platform: .macOS,
          child: _Menu(menuElevation: 0),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<StreamContextMenu>(find.byType(StreamContextMenu))
            .elevation,
        0,
      );
    });

    // A selected row's fill is rounded, and running it flush into the sheet's
    // edges looks like a rendering mistake.
    testWidgets('insets sheet rows so a selected fill clears the edges', (
      tester,
    ) async {
      await tester.pumpWidget(
        // Android is TestWrapper's default, but naming it says which
        // presentation this is about.
        // ignore: avoid_redundant_argument_values
        const TestWrapper(platform: .android, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final sheet = tester.getRect(find.byType(StreamSheetHeader).first);
      final row = tester.getRect(find.byType(StreamListTile).first);

      expect(row.left - sheet.left, 4);
      expect(sheet.right - row.right, 4);
    });

    testWidgets('useSheet overrides the platform', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu(useSheet: true)),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamListTile), findsNWidgets(3));
    });

    // The anchor has to be given loose constraints for a SizedBox inside it to
    // mean anything: TestWrapper's Material is sized to the viewport and hands
    // its child tight constraints.
    Future<double> openMenuUnder(
      WidgetTester tester, {
      required double anchorWidth,
      required bool matchAnchorWidth,
    }) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: TargetPlatform.macOS,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: anchorWidth,
              child: _Menu(matchAnchorWidth: matchAnchorWidth),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      return tester.getSize(find.byType(StreamContextMenu).first).width;
    }

    testWidgets('sizes the menu to its content by default', (tester) async {
      final width = await openMenuUnder(
        tester,
        anchorWidth: 600,
        matchAnchorWidth: false,
      );

      // Content-sized, and capped by the anchor's own maximum.
      expect(width, lessThan(600));
      expect(
        width,
        lessThanOrEqualTo(StreamContextMenuAnchor.defaultConstraints.maxWidth),
      );
    });

    testWidgets('matchAnchorWidth stretches the menu to the anchor', (
      tester,
    ) async {
      final width = await openMenuUnder(
        tester,
        anchorWidth: 600,
        matchAnchorWidth: true,
      );

      expect(width, 600);
    });

    // A field narrower than the row's own 200px minimum: the tight width has
    // to win, or the panel overflows its field.
    testWidgets('matchAnchorWidth holds below the row minimum width', (
      tester,
    ) async {
      final width = await openMenuUnder(
        tester,
        anchorWidth: 160,
        matchAnchorWidth: true,
      );

      expect(width, 160);
    });

    // The presentation is the anchor's business; what the builder sees must not
    // depend on it, or an anchor's caret would rotate on one platform only.
    for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
      final name = platform.name;

      testWidgets('reports isOpen to the builder on $name', (tester) async {
        await tester.pumpWidget(
          TestWrapper(platform: platform, child: const _Menu()),
        );

        expect(find.text('closed'), findsOneWidget);

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('showing'), findsOneWidget);
      });

      testWidgets('closes itself before reporting the choice on $name', (
        tester,
      ) async {
        String? picked;

        await tester.pumpWidget(
          TestWrapper(
            platform: platform,
            child: _Menu(onPicked: (label) => picked = label),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Jabra Evolve2 65'));
        await tester.pumpAndSettle();

        expect(picked, 'Jabra Evolve2 65');
        expect(find.text('closed'), findsOneWidget);
      });

      testWidgets('shows every section heading on $name', (tester) async {
        await tester.pumpWidget(
          TestWrapper(platform: platform, child: const _Menu()),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('Speaker'), findsOneWidget);
        // 'Microphone' is both the sheet title and a section heading, so it is
        // matched loosely.
        expect(find.text('Microphone'), findsWidgets);
      });
    }
  });

  testWidgets('draws no heading over a section with no rows', (tester) async {
    // The type permits an empty section, so every caller had to remember to
    // filter one out; the anchor drops its heading itself now.
    await tester.pumpWidget(
      const TestWrapper(
        child: _Menu(
          useSheet: false,
          sections: [
            StreamMenuSection(heading: 'Speaker'),
            StreamMenuSection(
              heading: 'Microphone',
              options: [StreamMenuOption(label: 'Jabra Evolve2 65')],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Speaker'), findsNothing);
    expect(find.text('Microphone'), findsOneWidget);
  });

  test('says when a set of sections has nothing to offer', () {
    expect(const [StreamMenuSection()].hasNoOptions, isTrue);
    expect(
      const [
        StreamMenuSection(),
        StreamMenuSection(options: [StreamMenuOption(label: 'Headset')]),
      ].hasNoOptions,
      isFalse,
    );
  });

  test('a section of content alone still has something to offer', () {
    // Otherwise a menu built only of strips — reactions, video filters —
    // reports itself empty and every anchor over it disables its own button.
    final sections = [
      StreamMenuSection(content: (context, handle) => const Text('reactions')),
    ];

    expect(sections.hasNoOptions, isFalse);
  });

  // The value a row reports, which both presentations draw at the far end of
  // the row: the On beside a toggle, the resolution beside a quality picker.
  for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
    testWidgets("draws an option's trailing on ${platform.name}", (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: platform,
          child: const _Menu(
            sections: [
              StreamMenuSection(
                options: [
                  StreamMenuOption(
                    label: 'Noise cancellation',
                    trailing: Text('On'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Noise cancellation'), findsOneWidget);
      expect(find.text('On'), findsOneWidget);
    });

    testWidgets("draws a section's content on ${platform.name}", (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: platform,
          child: _Menu(
            sections: [
              StreamMenuSection(
                heading: 'Reactions',
                content: (context, handle) => const Text('strip'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('strip'), findsOneWidget);
      // A heading labels content as readily as it labels rows.
      expect(find.text('Reactions'), findsOneWidget);
      // Content is not a row, so it carries none of the row's chrome.
      expect(find.byType(StreamListTile), findsNothing);
      expect(find.byType(StreamContextMenuAction<void>), findsNothing);
    });

    testWidgets('content closes the menu through the handle on '
        '${platform.name}', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: platform,
          child: _Menu(
            sections: [
              StreamMenuSection(
                content: (context, handle) => TextButton(
                  onPressed: handle.close,
                  child: const Text('send'),
                ),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('showing'), findsOneWidget);

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(find.text('closed'), findsOneWidget);
      expect(find.text('send'), findsNothing);
    });
  }

  // A row reporting state the menu is showing keeps the menu up, so the value
  // it just changed is visible rather than hidden behind the dismissal.
  for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
    testWidgets('closesMenu false leaves the menu up on ${platform.name}', (
      tester,
    ) async {
      var picked = 0;

      await tester.pumpWidget(
        TestWrapper(
          platform: platform,
          child: _Menu(
            sections: [
              StreamMenuSection(
                options: [
                  StreamMenuOption(
                    label: 'Closed captions',
                    closesMenu: false,
                    onSelected: () => picked++,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Closed captions'));
      await tester.pumpAndSettle();

      expect(picked, 1);
      expect(find.text('showing'), findsOneWidget);
      expect(find.text('Closed captions'), findsOneWidget);
    });

    testWidgets('a collapsible section starts folded on ${platform.name}', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: platform,
          child: const _Menu(
            sections: [
              StreamMenuSection(
                heading: 'Input device',
                collapsible: true,
                options: [StreamMenuOption(label: 'Jabra Evolve2 65')],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // The heading is what is left to press; its rows are away.
      expect(find.text('Input device'), findsOneWidget);
      expect(find.text('Jabra Evolve2 65'), findsNothing);

      await tester.tap(find.text('Input device'));
      await tester.pumpAndSettle();

      expect(find.text('Jabra Evolve2 65'), findsOneWidget);

      await tester.tap(find.text('Input device'));
      await tester.pumpAndSettle();

      expect(find.text('Jabra Evolve2 65'), findsNothing);
    });

    testWidgets('an expanded section stays open across a rebuild on '
        '${platform.name}', (tester) async {
      // The sections are rebuilt whenever the anchor's parent rebuilds, which
      // a menu over live call state does constantly. The fold is keyed by
      // heading precisely so it survives that.
      Widget menu(String label) => TestWrapper(
        platform: platform,
        child: _Menu(
          sections: [
            StreamMenuSection(
              heading: 'Input device',
              collapsible: true,
              options: [StreamMenuOption(label: label)],
            ),
          ],
        ),
      );

      await tester.pumpWidget(menu('Jabra Evolve2 65'));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Input device'));
      await tester.pumpAndSettle();
      expect(find.text('Jabra Evolve2 65'), findsOneWidget);

      await tester.pumpWidget(menu('MacBook Pro Microphone'));
      await tester.pumpAndSettle();

      expect(find.text('MacBook Pro Microphone'), findsOneWidget);
    });
  }

  // The fold is a pure read of what the user chose, so a section they have not
  // touched shows its own default however many times the menu is built. An
  // earlier version registered each default on first sight, from inside the
  // build, which made the answer depend on the build order.
  for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
    testWidgets('an untouched section keeps its default on ${platform.name}', (
      tester,
    ) async {
      Widget build(int tick) => TestWrapper(
        platform: platform,
        child: _Menu(
          sections: [
            // Two defaults at once: whichever order they are built in, each
            // has to come out the way it asked for.
            StreamMenuSection(
              heading: 'Input device',
              collapsible: true,
              options: [StreamMenuOption(label: 'Jabra $tick')],
            ),
            StreamMenuSection(
              heading: 'Quality',
              collapsible: true,
              initiallyCollapsed: false,
              options: [StreamMenuOption(label: 'Auto $tick')],
            ),
          ],
        ),
      );

      await tester.pumpWidget(build(0));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // The menu rebuilds constantly off call state while it is open.
      for (var tick = 1; tick <= 3; tick++) {
        await tester.pumpWidget(build(tick));
        await tester.pumpAndSettle();

        expect(find.text('Jabra $tick'), findsNothing);
        expect(find.text('Auto $tick'), findsOneWidget);
      }
    });

    testWidgets('an untouched section follows a changed default on '
        '${platform.name}', (tester) async {
      Widget build({required bool initiallyCollapsed}) => TestWrapper(
        platform: platform,
        child: _Menu(
          sections: [
            StreamMenuSection(
              heading: 'Quality',
              collapsible: true,
              initiallyCollapsed: initiallyCollapsed,
              options: const [StreamMenuOption(label: 'Auto')],
            ),
          ],
        ),
      );

      await tester.pumpWidget(build(initiallyCollapsed: true));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Auto'), findsNothing);

      // Nobody has touched this section, so the default still speaks for it.
      await tester.pumpWidget(build(initiallyCollapsed: false));
      await tester.pumpAndSettle();

      expect(find.text('Auto'), findsOneWidget);
    });

    testWidgets('a fold outlives the section it was made on '
        '${platform.name}', (tester) async {
      Widget build(int tick) => TestWrapper(
        platform: platform,
        child: _Menu(
          sections: [
            StreamMenuSection(
              heading: 'Quality',
              collapsible: true,
              initiallyCollapsed: false,
              options: [StreamMenuOption(label: 'Auto $tick')],
            ),
          ],
        ),
      );

      await tester.pumpWidget(build(0));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Auto 0'), findsOneWidget);

      await tester.tap(find.text('Quality'));
      await tester.pumpAndSettle();

      // Folded by hand, so it stays folded even though every rebuild hands
      // over a brand new section that says it opens expanded.
      for (var tick = 1; tick <= 3; tick++) {
        await tester.pumpWidget(build(tick));
        await tester.pumpAndSettle();
        expect(find.text('Auto $tick'), findsNothing);
      }
    });
  }

  // The sheet branch opens by pushing a route and closes by popping one, so
  // both directions are guarded: a second push stacks a sheet the handle can
  // no longer reach, and a pop with nothing open takes the host screen.
  for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
    final name = platform.name;

    testWidgets('opening twice presents one menu on $name', (tester) async {
      late StreamMenuHandle handle;

      await tester.pumpWidget(
        TestWrapper(
          platform: platform,
          child: _Menu(onHandle: (it) => handle = it),
        ),
      );

      handle.open();
      await tester.pumpAndSettle();
      handle.open();
      await tester.pumpAndSettle();

      expect(handle.isOpen, isTrue);

      handle.close();
      await tester.pumpAndSettle();

      // One close is enough: a second sheet would still be up, and the
      // anchor would have no way left to dismiss it.
      expect(handle.isOpen, isFalse);
      expect(find.byType(StreamListTile), findsNothing);
      expect(find.byType(StreamContextMenuAction<void>), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('closing while closed does nothing on $name', (tester) async {
      late StreamMenuHandle handle;

      await tester.pumpWidget(
        TestWrapper(
          platform: platform,
          child: _Menu(onHandle: (it) => handle = it),
        ),
      );

      handle.close();
      await tester.pumpAndSettle();

      // Unguarded, the sheet branch would have popped the screen the anchor
      // sits on.
      expect(handle.isOpen, isFalse);
      expect(find.text('open'), findsOneWidget);
    });
  }
}

/// An anchor over two sections, whose button reports the handle's open state.
class _Menu extends StatelessWidget {
  const _Menu({
    this.useSheet,
    this.onPicked,
    this.matchAnchorWidth = false,
    this.menuElevation,
    this.sections,
    this.onHandle,
  });

  final bool? useSheet;
  final ValueChanged<String>? onPicked;
  final bool matchAnchorWidth;
  final double? menuElevation;
  final List<StreamMenuSection>? sections;
  final ValueChanged<StreamMenuHandle>? onHandle;

  @override
  Widget build(BuildContext context) {
    StreamMenuOption option(String label, {bool selected = false}) =>
        StreamMenuOption(
          label: label,
          selected: selected,
          onSelected: () => onPicked?.call(label),
        );

    return StreamAdaptiveMenuAnchor(
      title: 'Microphone',
      useSheet: useSheet,
      matchAnchorWidth: matchAnchorWidth,
      menuElevation: menuElevation,
      sections:
          sections ??
          [
            StreamMenuSection(
              heading: 'Microphone',
              options: [
                option('MacBook Pro Microphone', selected: true),
                option('Jabra Evolve2 65'),
              ],
            ),
            StreamMenuSection(
              heading: 'Speaker',
              options: [option('MacBook Pro Speakers', selected: true)],
            ),
          ],
      builder: (context, handle) {
        onHandle?.call(handle);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(handle.isOpen ? 'showing' : 'closed'),
            TextButton(onPressed: handle.toggle, child: const Text('open')),
          ],
        );
      },
    );
  }
}
