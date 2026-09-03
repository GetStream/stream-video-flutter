import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  // The icons the widget resolves off `context.streamIcons`; the defaults are
  // what TestWrapper's theme installs.
  const icons = StreamIcons();

  testWidgets('StreamMicrophoneButton', (tester) async {
    var isAudioEnabled = true;

    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.publishedTracks).thenReturn({
      SfuTrackType.audio: TrackState.local(muted: !isAudioEnabled),
    });
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer(
      (invocation) async {
        isAudioEnabled =
            invocation.namedArguments[const Symbol('enabled')] as bool;
        return const Result.success(none);
      },
    );

    // Microphone is enabled
    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );

    expect(find.byIcon(icons.voiceFill), findsOneWidget);
    expect(find.byIcon(icons.voiceOffFill), findsNothing);

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    verify(() => call.setMicrophoneEnabled(enabled: false)).called(1);

    // Microphone is disabled
    when(() => localParticipant.publishedTracks).thenReturn({
      SfuTrackType.audio: TrackState.local(muted: !isAudioEnabled),
    });
    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );
    expect(find.byIcon(icons.voiceFill), findsNothing);
    expect(find.byIcon(icons.voiceOffFill), findsOneWidget);
  });

  // The refusal used to be dropped on the floor: `setMicrophoneEnabled`
  // returns a Result, and the button's state comes from the call's own
  // participant state, which does not change on failure. A viewer without
  // `sendAudio` pressed the button and got no movement, no message, no log.
  testWidgets('StreamMicrophoneButton reports a refusal', (tester) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();
    Object? reported;

    when(
      () => localParticipant.publishedTracks,
    ).thenReturn({SfuTrackType.audio: TrackState.local()});
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
          onError: (error) => reported = error,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    expect(reported, _refused);
  });

  testWidgets('StreamCameraButton reports a refusal', (tester) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();
    Object? reported;

    when(
      () => localParticipant.publishedTracks,
    ).thenReturn({SfuTrackType.video: TrackState.local()});
    when(
      () => call.setCameraEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: StreamCameraButton(
          localParticipant: localParticipant,
          call: call,
          onError: (error) => reported = error,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.videoFill));
    await tester.pumpAndSettle();

    expect(reported, _refused);
  });

  // A control with no listener still has to survive the refusal rather than
  // throw out of the button's callback.
  testWidgets('StreamMicrophoneButton survives a refusal unwatched', (
    tester,
  ) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(
      () => localParticipant.publishedTracks,
    ).thenReturn({SfuTrackType.audio: TrackState.local()});
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  // The plain toggles had no way to say a device was missing, so a phone bar
  // using them lost the badge the split buttons show. `devices` is opt-in:
  // enumerating devices to draw a mic button is a cost a screen chooses.
  group('with devices', () {
    late StreamController<List<RtcMediaDevice>> deviceChanges;
    late StreamMediaDevicesController devices;

    setUp(() {
      deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();

      final notifier = MockRtcMediaDeviceNotifier();
      when(
        () => notifier.onDeviceChange,
      ).thenAnswer((_) => deviceChanges.stream);
      when(
        notifier.enumerateDevices,
      ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

      devices = StreamMediaDevicesController(deviceNotifier: notifier);
      addTearDown(devices.dispose);
    });

    tearDown(() => deviceChanges.close());

    Future<void> pump(WidgetTester tester) async {
      final localParticipant = MockCallParticipantState();
      when(
        () => localParticipant.publishedTracks,
      ).thenReturn({SfuTrackType.audio: TrackState.local()});

      await tester.pumpWidget(
        TestWrapper(
          child: StreamMicrophoneButton(
            localParticipant: localParticipant,
            call: MockCall(),
            devices: devices,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    CallControlButton button(WidgetTester tester) =>
        tester.widget<CallControlButton>(find.byType(CallControlButton));

    testWidgets('badges and disables a microphone the platform lacks', (
      tester,
    ) async {
      await pump(tester);
      deviceChanges.add(const []);
      await tester.pumpAndSettle();

      expect(button(tester).showErrorBadge, isTrue);
      expect(button(tester).onPressed, isNull);
      // Badged, not muted: an absent device is not a choice the user made.
      expect(button(tester).tone, CallControlTone.neutral);
    });

    testWidgets('says nothing until the platform has answered', (tester) async {
      await pump(tester);

      expect(button(tester).showErrorBadge, isFalse);
      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('clears the badge once a microphone appears', (tester) async {
      await pump(tester);
      deviceChanges.add(const []);
      await tester.pumpAndSettle();
      deviceChanges.add(const [
        RtcMediaDevice(
          id: 'mic-1',
          label: 'MacBook Pro Microphone',
          kind: RtcMediaDeviceKind.audioInput,
        ),
      ]);
      await tester.pumpAndSettle();

      expect(button(tester).showErrorBadge, isFalse);
      expect(button(tester).onPressed, isNotNull);
    });
  });

  // A typedef to a class carries its constructors, so an unmigrated call site
  // keeps compiling rather than only the type annotation surviving.
  testWidgets('the deprecated name still builds one', (tester) async {
    final localParticipant = MockCallParticipantState();
    when(
      () => localParticipant.publishedTracks,
    ).thenReturn({SfuTrackType.audio: TrackState.local()});

    await tester.pumpWidget(
      TestWrapper(
        // ignore: deprecated_member_use_from_same_package
        child: ToggleMicrophoneOption(
          localParticipant: localParticipant,
          call: MockCall(),
        ),
      ),
    );

    expect(find.byType(StreamMicrophoneButton), findsOneWidget);
  });

  // The join flash: `isAudioEnabled` is `!(track?.muted ?? true)`, so a track
  // the SFU has not named yet read as muted and the control went red for the
  // second between joining and the first track arriving.
  group('while the track has not been reported', () {
    late MockCall call;
    late MockCallState callState;

    void givenLocalParticipant(Map<SfuTrackType, TrackState> tracks) {
      final participant = MockCallParticipantState();
      when(() => participant.publishedTracks).thenReturn(tracks);
      when(() => callState.localParticipant).thenReturn(participant);
    }

    setUp(() {
      call = MockCall();
      callState = MockCallState();

      final emitter = MutableStateEmitter<CallState>(callState, sync: true);
      when(() => call.state).thenAnswer((_) => emitter);
      when(() => call.partialState<bool?>(any())).thenAnswer((invocation) {
        final CallStateSelector<bool?> selector =
            invocation.positionalArguments[0];
        return Stream.value(selector(callState));
      });
    });

    Future<CallControlButton> pumpButton(
      WidgetTester tester, {
      required TrackOption microphone,
    }) async {
      when(
        () => call.connectOptions,
      ).thenReturn(CallConnectOptions(microphone: microphone));

      await tester.pumpWidget(
        TestWrapper(child: StreamMicrophoneButton(call: call)),
      );
      await tester.pumpAndSettle();

      return tester.widget<CallControlButton>(find.byType(CallControlButton));
    }

    testWidgets('draws a call joined with the microphone on as on', (
      tester,
    ) async {
      when(() => callState.localParticipant).thenReturn(null);

      final button = await pumpButton(
        tester,
        microphone: TrackOption.enabled(),
      );

      expect(button.tone, CallControlTone.neutral);
      expect(find.byIcon(icons.voiceFill), findsOneWidget);
    });

    // A track handed over from the lobby, which only provides one for a device
    // it actually opened.
    testWidgets('counts a provided track as on', (tester) async {
      when(() => callState.localParticipant).thenReturn(null);

      final button = await pumpButton(
        tester,
        microphone: TrackOption.provided(MockRtcLocalAudioTrack()),
      );

      expect(button.tone, CallControlTone.neutral);
    });

    testWidgets('draws a call joined muted as muted', (tester) async {
      when(() => callState.localParticipant).thenReturn(null);

      final button = await pumpButton(
        tester,
        microphone: TrackOption.disabled(),
      );

      expect(button.tone, CallControlTone.negative);
      expect(find.byIcon(icons.voiceOffFill), findsOneWidget);
    });

    // The local participant can exist before its tracks do, which is the
    // window the flash actually happened in.
    testWidgets('falls back for a participant with no tracks yet', (
      tester,
    ) async {
      givenLocalParticipant(const {});

      final button = await pumpButton(
        tester,
        microphone: TrackOption.enabled(),
      );

      expect(button.tone, CallControlTone.neutral);
    });

    // The half that must not regress: once the track exists, it decides. A
    // user who muted a call they joined unmuted stays muted.
    testWidgets('a reported mute wins over the intent', (tester) async {
      givenLocalParticipant({
        SfuTrackType.audio: TrackState.local(muted: true),
      });

      final button = await pumpButton(
        tester,
        microphone: TrackOption.enabled(),
      );

      expect(button.tone, CallControlTone.negative);
      expect(find.byIcon(icons.voiceOffFill), findsOneWidget);
    });

    testWidgets('a reported unmute wins over a disabled intent', (
      tester,
    ) async {
      givenLocalParticipant({
        SfuTrackType.audio: TrackState.local(),
      });

      final button = await pumpButton(
        tester,
        microphone: TrackOption.disabled(),
      );

      expect(button.tone, CallControlTone.neutral);
    });
  });
}

const _refused = 'the call refused';
