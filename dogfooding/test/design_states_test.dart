import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/app_accent_color.dart';
import 'package:flutter_dogfooding/app/app_design.dart';
import 'package:flutter_dogfooding/app/app_theme.dart';
import 'package:flutter_dogfooding/app/design/app_design_spec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:shad/shad.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  setUpAll(() => designGoogleFontsEnabled = false);

  Future<void> pump(WidgetTester tester, AppDesign design, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(
          design: design,
          brightness: Brightness.dark,
          accent: AppAccentColor.designDefault,
        ),
        builder: (context, child) => design.spec.wrap(
          context,
          AppAccentColor.designDefault,
          StreamComponentFactory(
            builders: design.spec.builders(const []),
            child: child!,
          ),
        ),
        home: Scaffold(body: Center(child: child)),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
  }

  // A running recording is a selected destructive button.
  final recording = StreamButton.icon(
    style: StreamButtonStyle.destructive,
    type: StreamButtonType.outline,
    isSelected: true,
    icon: const Icon(Icons.circle),
    onPressed: () {},
  );

  testWidgets('shad draws a selected destructive button destructive', (
    tester,
  ) async {
    await pump(tester, AppDesign.shad, recording);

    final button = tester.widget<ShadIconButton>(find.byType(ShadIconButton));
    expect(button.variant, ShadButtonVariant.destructive);
  });

  testWidgets('Liquid Glass tints a selected destructive button red', (
    tester,
  ) async {
    await pump(tester, AppDesign.liquidGlass, recording);

    final context = tester.element(find.byType(GlassButton));
    final button = tester.widget<GlassButton>(find.byType(GlassButton));
    expect(
      button.settings?.glassColor,
      context.streamColorScheme.accentError.withValues(alpha: 0.6),
    );
  });

  testWidgets('Liquid Glass disables a labelled button without a callback', (
    tester,
  ) async {
    await pump(
      tester,
      AppDesign.liquidGlass,
      StreamButton(onPressed: null, child: const Text('Off')),
    );

    final button = tester.widget<GlassButton>(find.byType(GlassButton));
    expect(button.enabled, isFalse);
  });

  testWidgets('Liquid Glass ignores input on a disabled switch', (
    tester,
  ) async {
    await pump(
      tester,
      AppDesign.liquidGlass,
      StreamSwitch(value: false, onChanged: null),
    );

    expect(
      find.ancestor(
        of: find.byType(GlassSwitch),
        matching: find.byWidgetPredicate(
          (w) => w is IgnorePointer && w.ignoring,
        ),
      ),
      findsOneWidget,
    );
  });
}
