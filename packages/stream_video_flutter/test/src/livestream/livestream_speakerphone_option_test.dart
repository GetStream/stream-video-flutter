import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

const _speakerDevice = RtcMediaDevice(
  id: deviceIdSpeaker,
  label: 'Speaker',
  kind: RtcMediaDeviceKind.audioOutput,
);

const _earpieceDevice = RtcMediaDevice(
  id: deviceIdEarpiece,
  label: 'Earpiece',
  kind: RtcMediaDeviceKind.audioOutput,
);

void main() {
  late MockCall mockCall;
  late MockCallState mockCallState;
  late MutableStateEmitter<CallState> callStateEmitter;
  late MockRtcMediaDeviceNotifier mockDeviceNotifier;

  setUpAll(() {
    registerFallbackValue(_earpieceDevice);
  });

  setUp(() {
    mockCall = MockCall();
    mockCallState = MockCallState();
    callStateEmitter = MutableStateEmitter<CallState>(
      mockCallState,
      sync: true,
    );

    when(() => mockCall.state).thenAnswer((_) => callStateEmitter);
    when(() => mockCall.partialState<bool>(any())).thenAnswer((invocation) {
      final CallStateSelector<bool> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(mockCallState));
    });
    when(
      () => mockCall.setAudioOutputDevice(any()),
    ).thenAnswer((_) async => const Result.success(none));

    mockDeviceNotifier = MockRtcMediaDeviceNotifier();
    // No enumerated audio outputs by default; individual tests override this.
    when(
      () => mockDeviceNotifier.onDeviceChange,
    ).thenAnswer((_) => const Stream.empty());
    RtcMediaDeviceNotifier.instance = mockDeviceNotifier;
  });

  tearDown(() {
    RtcMediaDeviceNotifier.instance = null;
  });

  testWidgets('shows the volume_up icon when the speaker is the audio output', (
    tester,
  ) async {
    when(() => mockCallState.audioOutputDevice).thenReturn(_speakerDevice);

    await tester.pumpWidget(
      TestWrapper(child: LivestreamSpeakerphoneOption(call: mockCall)),
    );

    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    expect(find.byIcon(Icons.volume_off_rounded), findsNothing);
  });

  testWidgets(
    'shows the volume_off icon when the earpiece is the audio output',
    (
      tester,
    ) async {
      when(() => mockCallState.audioOutputDevice).thenReturn(_earpieceDevice);

      await tester.pumpWidget(
        TestWrapper(child: LivestreamSpeakerphoneOption(call: mockCall)),
      );

      expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.volume_up_rounded), findsNothing);
    },
  );

  testWidgets(
    'shows the volume_off icon when there is no audio output device',
    (
      tester,
    ) async {
      when(() => mockCallState.audioOutputDevice).thenReturn(null);

      await tester.pumpWidget(
        TestWrapper(child: LivestreamSpeakerphoneOption(call: mockCall)),
      );

      expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.volume_up_rounded), findsNothing);
    },
  );

  testWidgets(
    'tapping without any available audio outputs does not change the device',
    (tester) async {
      when(() => mockCallState.audioOutputDevice).thenReturn(_earpieceDevice);

      await tester.pumpWidget(
        TestWrapper(child: LivestreamSpeakerphoneOption(call: mockCall)),
      );

      await tester.tap(find.byIcon(Icons.volume_off_rounded));
      await tester.pumpAndSettle();

      // With no enumerated audio outputs the option guards against changing
      // the device, so no output switch should be attempted.
      verifyNever(() => mockCall.setAudioOutputDevice(any()));
    },
  );

  testWidgets('tapping while disabled switches the output to the speaker', (
    tester,
  ) async {
    when(() => mockCallState.audioOutputDevice).thenReturn(_earpieceDevice);
    when(() => mockDeviceNotifier.onDeviceChange).thenAnswer(
      (_) => Stream.value(const [_speakerDevice, _earpieceDevice]),
    );

    await tester.pumpWidget(
      TestWrapper(child: LivestreamSpeakerphoneOption(call: mockCall)),
    );
    // Let the device-change subscription deliver the available outputs.
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.volume_off_rounded));
    await tester.pumpAndSettle();

    verify(() => mockCall.setAudioOutputDevice(_speakerDevice)).called(1);
  });

  testWidgets('tapping while enabled switches the output to the earpiece', (
    tester,
  ) async {
    when(() => mockCallState.audioOutputDevice).thenReturn(_speakerDevice);
    when(() => mockDeviceNotifier.onDeviceChange).thenAnswer(
      (_) => Stream.value(const [_speakerDevice, _earpieceDevice]),
    );

    await tester.pumpWidget(
      TestWrapper(child: LivestreamSpeakerphoneOption(call: mockCall)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    await tester.pumpAndSettle();

    verify(() => mockCall.setAudioOutputDevice(_earpieceDevice)).called(1);
  });
}
