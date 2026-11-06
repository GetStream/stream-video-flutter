import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/app_accent_color.dart';
import 'package:flutter_dogfooding/app/app_design.dart';
import 'package:flutter_dogfooding/app/app_theme.dart';
import 'package:flutter_dogfooding/app/design/app_design_spec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => designGoogleFontsEnabled = false);

  Widget app(AppDesign design) => MaterialApp(
    theme: buildAppTheme(
      design: design,
      brightness: Brightness.dark,
      accent: AppAccentColor.designDefault,
    ),
    home: const Scaffold(
      body: ExpansionTile(title: Text('Share'), children: [Text('Link')]),
    ),
  );

  for (final from in AppDesign.values) {
    for (final to in AppDesign.values) {
      if (from == to) continue;
      testWidgets('switches from ${from.name} to ${to.name}', (tester) async {
        await tester.pumpWidget(app(from));
        await tester.pumpWidget(app(to));
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          expect(tester.takeException(), isNull);
        }
      });
    }
  }

  testWidgets(
    'keeps the state above the navigator through every design wrapper',
    (
      tester,
    ) async {
      final contentKey = GlobalKey();
      var mounts = 0;

      Widget wrapped(AppDesign design) => MaterialApp(
        theme: buildAppTheme(
          design: design,
          brightness: Brightness.dark,
          accent: AppAccentColor.designDefault,
        ),
        builder: (context, child) => design.spec.wrap(
          context,
          AppAccentColor.designDefault,
          KeyedSubtree(
            key: contentKey,
            // Above the navigator, as the app's snackbar scope is.
            child: _MountCounter(onMount: () => mounts++, child: child!),
          ),
        ),
        home: const SizedBox.shrink(),
      );

      for (final design in [...AppDesign.values, AppDesign.stream]) {
        await tester.pumpWidget(wrapped(design));
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(mounts, 1);
    },
  );
}

class _MountCounter extends StatefulWidget {
  const _MountCounter({required this.onMount, required this.child});

  final VoidCallback onMount;
  final Widget child;

  @override
  State<_MountCounter> createState() => _MountCounterState();
}

class _MountCounterState extends State<_MountCounter> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
