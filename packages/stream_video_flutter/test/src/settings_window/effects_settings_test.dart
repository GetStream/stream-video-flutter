import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// One-pixel PNGs in a solid color, standing in for background photos.
final _blue = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGPw7zoJAALOAaMBwSK0AAAAAElFTkSuQmCC',
  ),
);
final _orange = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGN4MN8OAAQgAb6q/ZP0AAAAAElFTkSuQmCC',
  ),
);
final _green = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGOIXpEFAALPAW6GnwaVAAAAAElFTkSuQmCC',
  ),
);

void main() {
  late MockCall call;
  late MockCallState callState;
  late List<String?> applied;

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    applied = [];

    when(() => callState.localParticipant).thenReturn(null);
    final emitter = MutableStateEmitter<CallState>(callState, sync: true);
    when(() => call.state).thenAnswer((_) => emitter);
    when(
      () => call.partialState<CallParticipantState?>(any()),
    ).thenAnswer((invocation) {
      final CallStateSelector<CallParticipantState?> selector =
          invocation.positionalArguments.first;
      return Stream.value(selector(callState));
    });
  });

  List<StreamVideoFilter> filters() => [
    for (final (id, icon) in [
      ('light', const StreamIcons().blurFill),
      ('medium', const StreamIcons().gridPixelFill),
      ('heavy', const StreamIcons().fullBlurFill),
    ])
      StreamVideoFilter(
        id: id,
        label: '$id blur',
        icon: Icon(icon),
        onSelected: () async => applied.add(id),
      ),
  ];

  List<StreamVideoBackground> backgrounds() => [
    for (final (index, image) in [_blue, _orange, _green].indexed)
      StreamVideoBackground(
        id: 'background-$index',
        label: 'Background $index',
        image: image,
        onSelected: () async => applied.add('background-$index'),
      ),
  ];

  Future<void> clear() async => applied.add(null);

  Future<void> pump(
    WidgetTester tester, {
    List<StreamVideoFilter>? filters,
    List<StreamVideoBackground>? backgrounds,
    String? initialSelected,
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    tester.view.physicalSize = const Size(600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        child: Directionality(
          textDirection: textDirection,
          child: SingleChildScrollView(
            child: StreamEffectsSettings(
              call: call,
              filters: filters,
              backgrounds: backgrounds,
              onClear: clear,
              initialSelected: initialSelected,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Whether the button or tile named [label] is marked selected.
  bool isSelected(WidgetTester tester, String label) {
    final node = tester.getSemantics(find.bySemanticsLabel(label));
    return node.hasFlag(SemanticsFlag.isSelected);
  }

  group('StreamEffectsSettings', () {
    testWidgets('offers nothing but the preview by default', (tester) async {
      await pump(tester);

      expect(find.text('Effects'), findsNothing);
      expect(find.text('Backgrounds'), findsNothing);
      expect(find.byIcon(const StreamIcons().xmark), findsNothing);
    });

    testWidgets('draws the filters after a button to turn effects off', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, filters: filters());

      expect(find.text('Effects'), findsOneWidget);
      expect(find.text('Backgrounds'), findsNothing);
      expect(isSelected(tester, 'No effect'), isTrue);
      expect(isSelected(tester, 'light blur'), isFalse);

      final none = tester.getCenter(find.byIcon(const StreamIcons().xmark));
      final light = tester.getCenter(find.byIcon(const StreamIcons().blurFill));
      expect(none.dx, lessThan(light.dx));
      semantics.dispose();
    });

    testWidgets('draws the backgrounds four to a row', (tester) async {
      await pump(
        tester,
        backgrounds: [...backgrounds(), ...backgrounds(), ...backgrounds()],
      );

      expect(find.text('Backgrounds'), findsOneWidget);
      final tiles = find.byType(Image);
      expect(tiles, findsNWidgets(9));
      // The fifth tile starts the second row.
      expect(
        tester.getTopLeft(tiles.at(4)).dy,
        greaterThan(tester.getTopLeft(tiles.at(3)).dy),
      );
      expect(
        tester.getTopLeft(tiles.at(3)).dy,
        tester.getTopLeft(tiles.at(0)).dy,
      );
    });

    testWidgets('selecting a filter applies it and marks it', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, filters: filters(), backgrounds: backgrounds());

      await tester.tap(find.byIcon(const StreamIcons().gridPixelFill));
      await tester.pumpAndSettle();

      expect(applied, ['medium']);
      expect(isSelected(tester, 'medium blur'), isTrue);
      expect(isSelected(tester, 'No effect'), isFalse);
      semantics.dispose();
    });

    testWidgets('selecting a background moves the selection off a filter', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pump(
        tester,
        filters: filters(),
        backgrounds: backgrounds(),
        initialSelected: 'light',
      );
      expect(isSelected(tester, 'light blur'), isTrue);

      await tester.tap(find.bySemanticsLabel('Background 1'));
      await tester.pumpAndSettle();

      expect(applied, ['background-1']);
      expect(isSelected(tester, 'Background 1'), isTrue);
      expect(isSelected(tester, 'light blur'), isFalse);
      semantics.dispose();
    });

    testWidgets('the button to turn effects off clears them', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, filters: filters(), initialSelected: 'heavy');

      await tester.tap(find.byIcon(const StreamIcons().xmark));
      await tester.pumpAndSettle();

      expect(applied, [null]);
      expect(isSelected(tester, 'No effect'), isTrue);
      semantics.dispose();
    });

    testWidgets('without filters, the selected background turns itself off', (
      tester,
    ) async {
      await pump(
        tester,
        backgrounds: backgrounds(),
        initialSelected: 'background-0',
      );

      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();
      expect(applied, [null]);

      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();
      expect(applied, [null, 'background-0']);
    });

    testWidgets('keeps the selection when an effect fails', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(
        tester,
        filters: [
          StreamVideoFilter(
            id: 'broken',
            label: 'Broken',
            icon: const Icon(Icons.error),
            onSelected: () async => throw StateError('no effect'),
          ),
        ],
      );

      await tester.tap(find.bySemanticsLabel('Broken'));
      await tester.pumpAndSettle();

      expect(isSelected(tester, 'No effect'), isTrue);
      expect(isSelected(tester, 'Broken'), isFalse);
      semantics.dispose();
    });

    testWidgets('only the last of overlapping selections sticks', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final slow = Completer<void>();
      await pump(
        tester,
        filters: [
          StreamVideoFilter(
            id: 'slow',
            label: 'Slow',
            icon: const Icon(Icons.hourglass_empty),
            onSelected: () => slow.future,
          ),
          StreamVideoFilter(
            id: 'fast',
            label: 'Fast',
            icon: const Icon(Icons.bolt),
            onSelected: () async {},
          ),
        ],
      );

      await tester.tap(find.bySemanticsLabel('Slow'));
      await tester.tap(find.bySemanticsLabel('Fast'));
      await tester.pumpAndSettle();
      slow.complete();
      await tester.pumpAndSettle();

      expect(isSelected(tester, 'Fast'), isTrue);
      expect(isSelected(tester, 'Slow'), isFalse);
      semantics.dispose();
    });

    testWidgets('right to left, the row starts at the right edge', (
      tester,
    ) async {
      await pump(
        tester,
        filters: filters(),
        textDirection: TextDirection.rtl,
      );

      final none = tester.getCenter(find.byIcon(const StreamIcons().xmark));
      final light = tester.getCenter(find.byIcon(const StreamIcons().blurFill));
      expect(none.dx, greaterThan(light.dx));
    });
  });

  group('StreamEffectsSettingsTab', () {
    testWidgets('is labelled "Effects"', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamModalWindow(
            tabs: [StreamEffectsSettingsTab(call: call, onClear: clear)],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Once in the sidebar, once as the header's title.
      expect(find.text('Effects'), findsNWidgets(2));
      expect(find.byType(StreamEffectsSettings), findsOneWidget);
    });
  });

  group('goldens', () {
    setUp(() {
      final local = MockCallParticipantState();
      when(() => local.name).thenReturn('Katie Miler');
      when(() => local.image).thenReturn(null);
      when(() => local.isSpeaking).thenReturn(false);
      when(() => local.isAudioEnabled).thenReturn(true);
      when(() => local.isVideoEnabled).thenReturn(true);
      when(
        () => local.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => local.reaction).thenReturn(null);
      when(() => callState.localParticipant).thenReturn(local);
    });

    for (final brightness in Brightness.values) {
      streamGoldenTest(
        'StreamEffectsSettings renders the filters and backgrounds',
        fileName: 'stream_effects_settings',
        brightness: brightness,
        constraints: const BoxConstraints.tightFor(width: 520, height: 560),
        pumpBeforeTest: (tester) async {
          // Decodes the images, which happens outside the fake clock.
          await tester.runAsync(
            () => Future.wait([
              for (final image in [_blue, _orange, _green])
                precacheImage(
                  image,
                  tester.element(find.byType(Material).first),
                ),
            ]),
          );
          await tester.pumpAndSettle();
        },
        builder: () => StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              // A real renderer needs a live call. A flat fill stands in for
              // the camera.
              participantTile: (context, props) => DefaultStreamParticipantTile(
                props: props.copyWith(
                  videoRendererBuilder: (_, _, _) =>
                      const ColoredBox(color: Color(0xFF6E7A8A)),
                ),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StreamEffectsSettings(
              call: call,
              filters: filters(),
              backgrounds: [...backgrounds(), backgrounds().first],
              onClear: clear,
              initialSelected: 'background-1',
            ),
          ),
        ),
      );
    }
  });
}
