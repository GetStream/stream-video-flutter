import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

/// What the captions settings select from the call state.
typedef _Captions = ({
  bool available,
  bool on,
  bool canStart,
  bool canStop,
  bool canChangeLanguage,
  TranscriptionSettingsLanguage? language,
  ClosedCaptionSettingsMode closedCaptionMode,
  TranscriptionSettingsMode transcriptionMode,
});

const _allowed = [
  CallPermission.startClosedCaptionsCall,
  CallPermission.stopClosedCaptionsCall,
  CallPermission.updateCallSettings,
];

void main() {
  setUpAll(() {
    registerFallbackValue(const StreamTranscriptionSettings());
  });

  late MockCall call;
  late MockCallState callState;

  /// Stubs the call's captions: whether they are [on], the call's [language]
  /// and [mode], and what the user may do.
  void stubCaptions({
    bool on = false,
    TranscriptionSettingsLanguage? language = TranscriptionSettingsLanguage.en,
    ClosedCaptionSettingsMode mode = ClosedCaptionSettingsMode.available,
    List<CallPermission> capabilities = _allowed,
  }) {
    when(() => callState.isCaptioning).thenReturn(on);
    when(() => callState.ownCapabilities).thenReturn(capabilities);
    when(() => callState.settings).thenReturn(
      CallSettings(
        transcription: StreamTranscriptionSettings(
          closedCaptionMode: mode,
          transcriptionMode: TranscriptionSettingsMode.autoOn,
          language: language,
        ),
      ),
    );
  }

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    stubCaptions();

    final emitter = MutableStateEmitter<CallState>(callState, sync: true);
    when(() => call.state).thenAnswer((_) => emitter);
    // Runs the real selector against the stubbed state.
    when(() => call.partialState<_Captions>(any())).thenAnswer((invocation) {
      final CallStateSelector<_Captions> selector =
          invocation.positionalArguments.first;
      return Stream.value(selector(callState));
    });
    when(
      () => call.update(transcription: any(named: 'transcription')),
    ).thenAnswer((_) async => Result.success(MockCallMetadata()));
  });

  Future<void> pump(
    WidgetTester tester, {
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        platform: TargetPlatform.macOS,
        child: Directionality(
          textDirection: textDirection,
          child: SingleChildScrollView(
            child: StreamCaptionsSettings(call: call),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  StreamSwitch captionsSwitch(WidgetTester tester) =>
      tester.widget<StreamSwitch>(find.byType(StreamSwitch));

  group('StreamCaptionsSettings', () {
    testWidgets('while captions are off, offers only the switch', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('Turn On Captions'), findsOneWidget);
      expect(captionsSwitch(tester).props.value, isFalse);
      expect(find.text('Language'), findsNothing);
    });

    testWidgets('while captions are on, shows the language', (tester) async {
      stubCaptions(on: true, language: TranscriptionSettingsLanguage.nl);
      await pump(tester);

      expect(captionsSwitch(tester).props.value, isTrue);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Dutch'), findsOneWidget);
    });

    testWidgets('the switch is disabled where the call has captions off', (
      tester,
    ) async {
      stubCaptions(mode: ClosedCaptionSettingsMode.disabled);
      await pump(tester);

      expect(captionsSwitch(tester).props.onChanged, isNull);
    });

    testWidgets('the switch is disabled for a user who may not start them', (
      tester,
    ) async {
      stubCaptions(capabilities: const []);
      await pump(tester);

      expect(captionsSwitch(tester).props.onChanged, isNull);
    });

    testWidgets('the switch is disabled for a user who may not stop them', (
      tester,
    ) async {
      stubCaptions(
        on: true,
        capabilities: const [CallPermission.startClosedCaptionsCall],
      );
      await pump(tester);

      expect(captionsSwitch(tester).props.onChanged, isNull);
    });

    testWidgets('picking a language keeps the modes in use', (tester) async {
      stubCaptions(on: true);
      await pump(tester);

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Automatic'));
      await tester.pumpAndSettle();

      final transcription =
          verify(
                () => call.update(
                  transcription: captureAny(named: 'transcription'),
                ),
              ).captured.single
              as StreamTranscriptionSettings;
      expect(transcription.language, TranscriptionSettingsLanguage.auto);
      expect(
        transcription.closedCaptionMode,
        ClosedCaptionSettingsMode.available,
      );
      expect(transcription.transcriptionMode, TranscriptionSettingsMode.autoOn);
    });

    testWidgets('a call without a language shows the default', (tester) async {
      stubCaptions(on: true, language: null);
      await pump(tester);

      expect(find.text('Default'), findsOneWidget);
    });

    testWidgets('picking the default sets the call back to no language', (
      tester,
    ) async {
      stubCaptions(on: true);
      await pump(tester);

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Default'));
      await tester.pumpAndSettle();

      final transcription =
          verify(
                () => call.update(
                  transcription: captureAny(named: 'transcription'),
                ),
              ).captured.single
              as StreamTranscriptionSettings;
      expect(transcription.language, isNull);
      expect(transcription.transcriptionMode, TranscriptionSettingsMode.autoOn);
    });

    testWidgets("a failed change leaves the call's language shown", (
      tester,
    ) async {
      stubCaptions(on: true);
      when(
        () => call.update(transcription: any(named: 'transcription')),
      ).thenAnswer((_) async => failureWithError('not allowed'));
      await pump(tester);

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('French'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.text('French'), findsNothing);
    });

    testWidgets('the language is fixed for a user who may not change it', (
      tester,
    ) async {
      stubCaptions(
        on: true,
        capabilities: const [CallPermission.stopClosedCaptionsCall],
      );
      await pump(tester);

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.text('Automatic'), findsNothing);
    });

    testWidgets('right to left, the switch is at the left edge', (
      tester,
    ) async {
      await pump(tester, textDirection: TextDirection.rtl);

      expect(
        tester.getCenter(find.byType(StreamSwitch)).dx,
        lessThan(tester.getCenter(find.text('Turn On Captions')).dx),
      );
    });
  });

  group('StreamCaptionsSettingsTab', () {
    testWidgets('is labelled "Captions"', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamModalWindow(
            tabs: [StreamCaptionsSettingsTab(call: call)],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Captions'), findsNWidgets(2));
      expect(find.byIcon(const StreamIcons().captionFill), findsOneWidget);
    });
  });

  group('goldens', () {
    for (final brightness in Brightness.values) {
      for (final on in [false, true]) {
        streamGoldenTest(
          'StreamCaptionsSettings renders captions ${on ? 'on' : 'off'}',
          fileName: 'stream_captions_settings_${on ? 'on' : 'off'}',
          brightness: brightness,
          constraints: const BoxConstraints.tightFor(width: 520, height: 280),
          builder: () {
            stubCaptions(on: on);
            return Padding(
              padding: const EdgeInsets.all(24),
              child: StreamCaptionsSettings(call: call),
            );
          },
        );
      }
    }
  });
}
