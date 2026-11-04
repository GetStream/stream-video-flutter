// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/app_accent_color.dart';
import 'package:flutter_dogfooding/app/app_design.dart';
import 'package:flutter_dogfooding/app/app_theme.dart';
import 'package:flutter_dogfooding/app/design/app_design_spec.dart';
import 'package:flutter_dogfooding/app/design/m3e/m3e_design.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core_flutter/video.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  setUpAll(() => designGoogleFontsEnabled = false);

  Future<void> pump(
    WidgetTester tester,
    AppDesign design,
    Brightness brightness,
    AppAccentColor accent,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(
          design: design,
          brightness: brightness,
          accent: accent,
        ),
        builder: (context, child) => design.spec.wrap(
          context,
          accent,
          StreamComponentFactory(
            builders: design.spec.builders(const []),
            child: child!,
          ),
        ),
        home: const Scaffold(body: _Components()),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('material3Expressive defaults to the device accent color', (
    tester,
  ) async {
    const device = Color(0xFF2E7D32);
    M3EDesign.deviceAccent = device;
    addTearDown(() => M3EDesign.deviceAccent = null);

    await pump(
      tester,
      AppDesign.material3Expressive,
      Brightness.light,
      AppAccentColor.designDefault,
    );

    final context = tester.element(find.byType(_Components));
    final shown = HSLColor.fromColor(context.streamColorScheme.accentPrimary);
    expect(
      (shown.hue - HSLColor.fromColor(device).hue).abs(),
      lessThan(30),
    );
  });

  for (final design in AppDesign.values) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '${design.name} draws the core components in ${brightness.name}',
        (tester) async {
          await pump(tester, design, brightness, AppAccentColor.designDefault);

          expect(tester.takeException(), isNull);
          expect(
            find.text('Solid'),
            findsNWidgets(StreamButtonStyle.values.length),
          );
          // A design that draws its own buttons draws its own split button
          // too, or its buttons would sit in the Stream split button's pill.
          expect(
            find.byType(DefaultStreamSplitButton),
            design == AppDesign.stream ? findsNWidgets(2) : findsNothing,
          );
        },
      );
    }

    for (final type in StreamButtonType.values) {
      testWidgets('${design.name} ${type.name} buttons take taps', (
        tester,
      ) async {
        var labelled = 0;
        var icon = 0;
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
            home: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamButton(
                    type: type,
                    onPressed: () => labelled++,
                    child: const Text('Labelled'),
                  ),
                  Center(
                    child: StreamButton.icon(
                      key: const Key('icon'),
                      type: type,
                      icon: const Icon(Icons.add),
                      onPressed: () => icon++,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump(const Duration(seconds: 1));

        await tester.tap(find.text('Labelled'));
        await tester.tap(find.byKey(const Key('icon')));
        await tester.pump(const Duration(seconds: 1));

        expect(labelled, 1, reason: 'labelled');
        expect(icon, 1, reason: 'icon');
      });
    }

    testWidgets('${design.name} takes a picked accent color', (tester) async {
      await pump(tester, design, Brightness.light, AppAccentColor.red);

      expect(tester.takeException(), isNull);
      final context = tester.element(find.byType(_Components));
      expect(
        context.streamColorScheme.accentPrimary,
        isNot(design.defaultAccent(Brightness.light)),
      );
    });

    testWidgets('${design.name} keeps the hue of a picked accent color', (
      tester,
    ) async {
      for (final accent in [AppAccentColor.blue, AppAccentColor.green]) {
        await pump(tester, design, Brightness.dark, accent);

        final context = tester.element(find.byType(_Components));
        final picked = HSLColor.fromColor(
          accent.paletteColor(Brightness.dark)!,
        ).hue;
        final shown = HSLColor.fromColor(
          context.streamColorScheme.accentPrimary,
        ).hue;
        final distance = (picked - shown).abs() % 360;
        expect(
          distance > 180 ? 360 - distance : distance,
          lessThan(30),
          reason: '${accent.name}: picked hue $picked, shown hue $shown',
        );
      }
    });
  }
}

/// The core components the app's screens use, in their variants.
class _Components extends StatelessWidget {
  const _Components();

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return SingleChildScrollView(
      child: Column(
        spacing: 8,
        children: [
          for (final type in StreamButtonType.values)
            Wrap(
              spacing: 8,
              children: [
                for (final style in StreamButtonStyle.values) ...[
                  StreamButton(
                    type: type,
                    style: style,
                    onPressed: () {},
                    child: Text(type == StreamButtonType.solid ? 'Solid' : ''),
                  ),
                  StreamButton.icon(
                    type: type,
                    style: style,
                    icon: Icon(icons.voiceFill),
                    tooltip: 'Icon',
                    onPressed: () {},
                  ),
                ],
                StreamButton.icon(
                  type: type,
                  icon: Icon(icons.videoFill),
                  isSelected: true,
                  onPressed: () {},
                ),
                StreamButton(
                  type: type,
                  onPressed: null,
                  child: const Text(''),
                ),
              ],
            ),
          for (final variant in StreamSplitButtonVariant.values)
            StreamSplitButton.icon(
              variant: variant,
              leadingIcon: Icon(icons.voiceFill),
              trailingIcon: Icon(icons.caretDown),
              leadingTooltip: 'Mute',
              trailingTooltip: 'Devices',
              onLeadingPressed: () {},
              onTrailingPressed: () {},
            ),
          StreamTextInput(
            labelText: 'Label',
            hintText: 'Hint',
            helperText: 'Helper',
          ),
          StreamTextInput(
            hintText: 'Error',
            helperText: 'Something went wrong',
            helperState: StreamHelperState.error,
          ),
          StreamSwitch(value: true, onChanged: (_) {}),
          StreamSwitch(value: false, onChanged: null),
          StreamCheckbox(value: true, onChanged: (_) {}),
          StreamProgressBar(value: 0.4),
          StreamProgressBar(),
          StreamLoadingSpinner(),
          StreamLoadingSpinner(value: 0.4),
        ],
      ),
    );
  }
}
