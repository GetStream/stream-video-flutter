import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

class _MockDynascaleManager extends Mock implements DynascaleManager {}

IncomingVideoSettings _settings({bool? enabled, int? height}) =>
    IncomingVideoSettings(
      enabled: enabled,
      preferredResolution: height == null
          ? null
          : RtcVideoDimension(width: height * 16 ~/ 9, height: height),
      participants: const {},
    );

void main() {
  setUpAll(() {
    registerFallbackValue(const RtcVideoDimension(width: 0, height: 0));
  });

  late MockCall call;
  late _MockDynascaleManager dynascale;
  late StreamController<IncomingVideoSettings?> incomingVideo;

  MockCall callAt(IncomingVideoSettings? settings) {
    final call = MockCall();
    final dynascale = _MockDynascaleManager();
    when(() => call.dynascaleManager).thenReturn(dynascale);
    when(() => dynascale.incomingVideoSettings).thenReturn(settings);
    // Like the real stream, it emits the current settings to a new listener.
    when(
      () => dynascale.incomingVideoSettingsStream,
    ).thenAnswer((_) => Stream.value(settings));
    return call;
  }

  setUp(() {
    call = MockCall();
    dynascale = _MockDynascaleManager();
    incomingVideo = StreamController<IncomingVideoSettings?>.broadcast();

    when(() => call.dynascaleManager).thenReturn(dynascale);
    when(() => dynascale.incomingVideoSettings).thenReturn(null);
    when(
      () => dynascale.incomingVideoSettingsStream,
    ).thenAnswer((_) => incomingVideo.stream);
    when(
      () => call.setPreferredIncomingVideoResolution(any()),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => call.setIncomingVideoEnabled(any()),
    ).thenAnswer((_) async => const Result.success(none));
  });

  tearDown(() => incomingVideo.close());

  Future<void> pump(
    WidgetTester tester, {
    StreamMenuDirection direction = StreamMenuDirection.down,
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        platform: TargetPlatform.macOS,
        child: Directionality(
          textDirection: textDirection,
          child: Center(
            child: StreamIncomingVideoQualityButton(
              call: call,
              menuDirection: direction,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the quality the call is set to', (tester) async {
    when(
      () => dynascale.incomingVideoSettings,
    ).thenReturn(_settings(height: 720));
    await pump(tester);

    expect(find.text('720p'), findsOneWidget);
  });

  testWidgets('follows a change made elsewhere', (tester) async {
    await pump(tester);
    expect(find.text('Auto'), findsOneWidget);

    incomingVideo.add(_settings(enabled: false));
    await tester.pumpAndSettle();

    expect(find.text('Off'), findsOneWidget);
  });

  testWidgets('follows a new call', (tester) async {
    Widget button(Call call) => TestWrapper(
      platform: TargetPlatform.macOS,
      child: Center(child: StreamIncomingVideoQualityButton(call: call)),
    );
    await tester.pumpWidget(button(call));
    expect(find.text('Auto'), findsOneWidget);

    await tester.pumpWidget(button(callAt(_settings(height: 720))));
    await tester.pumpAndSettle();
    expect(find.text('720p'), findsOneWidget);

    await tester.pumpWidget(button(call));
    incomingVideo.add(_settings(enabled: false));
    await tester.pumpAndSettle();
    expect(find.text('Off'), findsOneWidget);
  });

  testWidgets('a quality the call refuses leaves the button as it was', (
    tester,
  ) async {
    when(
      () => call.setPreferredIncomingVideoResolution(any()),
    ).thenAnswer((_) async => failureWithError('not joined'));
    await pump(tester);

    await tester.tap(find.text('Auto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HD 720p'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Auto'), findsOneWidget);
  });

  testWidgets('the menu marks the current choice', (tester) async {
    when(
      () => dynascale.incomingVideoSettings,
    ).thenReturn(_settings(height: 1080));
    await pump(tester);

    await tester.tap(find.text('1080p'));
    await tester.pumpAndSettle();

    expect(find.text('Full HD 1080p'), findsOneWidget);
    expect(find.text('Disable video'), findsOneWidget);
    final selected = tester.widget<StreamRadioIndicator>(
      find.descendant(
        of: find.ancestor(
          of: find.text('Full HD 1080p'),
          matching: find.byType(StreamContextMenuAction<void>),
        ),
        matching: find.byType(StreamRadioIndicator),
      ),
    );
    expect(selected.selected, isTrue);
  });

  testWidgets('picking a resolution asks the call for it', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Auto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SD 480p'));
    await tester.pumpAndSettle();

    verify(
      () => call.setPreferredIncomingVideoResolution(
        const RtcVideoDimension(width: 640, height: 480),
      ),
    ).called(1);
  });

  testWidgets('disabling video turns incoming video off', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Auto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Disable video'));
    await tester.pumpAndSettle();

    verify(() => call.setIncomingVideoEnabled(false)).called(1);
  });

  group('caret', () {
    const icons = StreamIcons();

    testWidgets('points down, then up, for a menu that opens below', (
      tester,
    ) async {
      await pump(tester);
      expect(find.byIcon(icons.caretDown), findsOneWidget);

      await tester.tap(find.text('Auto'));
      await tester.pumpAndSettle();

      expect(find.byIcon(icons.caretUp), findsOneWidget);
    });

    testWidgets('points up, then down, for a menu that opens above', (
      tester,
    ) async {
      await pump(tester, direction: StreamMenuDirection.up);
      expect(find.byIcon(icons.caretUp), findsOneWidget);

      await tester.tap(find.text('Auto'));
      await tester.pumpAndSettle();

      expect(find.byIcon(icons.caretDown), findsOneWidget);
    });
  });

  testWidgets('right to left, the sliders sit at the right edge', (
    tester,
  ) async {
    await pump(tester, textDirection: TextDirection.rtl);

    expect(
      tester.getCenter(find.byIcon(const StreamIcons().slidersFill)).dx,
      greaterThan(tester.getCenter(find.text('Auto')).dx),
    );
  });

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamIncomingVideoQualityButton shows the quality in use',
      fileName: 'stream_incoming_video_quality_button',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final (name, settings) in [
            ('auto', null),
            ('720p', _settings(height: 720)),
            ('off', _settings(enabled: false)),
          ])
            GoldenTestScenario(
              name: name,
              child: StreamIncomingVideoQualityButton(call: callAt(settings)),
            ),
        ],
      ),
    );
  }
}
