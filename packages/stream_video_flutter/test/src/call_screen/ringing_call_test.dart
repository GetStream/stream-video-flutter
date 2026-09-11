import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  setUpAll(() {
    // The selector `partialState` is called with, which mocktail's `any()`
    // needs a stand-in for.
    registerFallbackValue(
      (CallState state) =>
          state.ringingMembers.map((it) => it.toUserInfo()).toList(),
    );
  });

  ({MockCall call, MockCallState state}) ringing(
    List<String> names, {
    CallConnectOptions connectOptions = const CallConnectOptions(),
  }) {
    final call = MockCall();
    final state = MockCallState();
    stubRingingCall(
      call,
      state,
      ringingMembers: [for (final name in names) ringingMember(name)],
      connectOptions: connectOptions,
    );
    return (call: call, state: state);
  }

  group('StreamIncomingCallContent', () {
    testWidgets('names one caller, and says the call is incoming', (
      tester,
    ) async {
      final mocks = ringing(['Tammy']);

      await tester.pumpWidget(
        TestWrapper(child: StreamIncomingCallContent(call: mocks.call)),
      );

      expect(find.text('Tammy'), findsOneWidget);
      expect(find.text('Incoming call'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    });

    testWidgets('one caller gets one avatar at the largest size', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamIncomingCallContent(call: ringing(['Tammy']).call),
        ),
      );

      expect(find.byType(StreamAvatarGroup), findsNothing);
      expect(
        tester.getSize(find.byType(StreamAvatar)),
        Size.square(StreamAvatarSize.xxxl.value),
      );
    });

    testWidgets('more than one caller gets a group in the same box', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamIncomingCallContent(
            call: ringing(['Tammy', 'Ann']).call,
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(StreamAvatarGroup)),
        Size.square(StreamAvatarGroupSize.xxxl.value),
      );
    });

    testWidgets('three callers are named two and a count', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamIncomingCallContent(
            call: ringing(['Tammy', 'Ann', 'Bo']).call,
          ),
        ),
      );

      expect(find.text('Tammy, Ann, and 1 other'), findsOneWidget);
    });

    testWidgets('four callers count the rest in the plural', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamIncomingCallContent(
            call: ringing(['Tammy', 'Ann', 'Bo', 'Cass']).call,
          ),
        ),
      );

      expect(find.text('Tammy, Ann, and 2 others'), findsOneWidget);
    });

    testWidgets(
      'the microphone and camera the call is answered with are kept',
      (
        tester,
      ) async {
        // The design drops these; the SDK keeps them, so this is the test that
        // notices if they are lost in a later pass at the screen.
        final mocks = ringing(
          ['Tammy'],
          connectOptions: CallConnectOptions(
            microphone: TrackOption.enabled(),
            camera: TrackOption.disabled(),
          ),
        );
        const icons = StreamIcons();

        await tester.pumpWidget(
          TestWrapper(child: StreamIncomingCallContent(call: mocks.call)),
        );

        expect(find.byIcon(icons.voiceFill), findsOneWidget);
        expect(find.byIcon(icons.videoOffFill), findsOneWidget);
      },
    );

    testWidgets('a supplied avatar and name replace the default ones', (
      tester,
    ) async {
      final mocks = ringing(['Tammy']);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamIncomingCallContent(
            call: mocks.call,
            participantsAvatarWidgetBuilder: (_, _, _) =>
                const Text('custom avatar'),
            participantsDisplayNameWidgetBuilder: (_, _, _) =>
                const Text('custom name'),
          ),
        ),
      );

      expect(find.text('custom avatar'), findsOneWidget);
      expect(find.text('custom name'), findsOneWidget);
      expect(find.text('Tammy'), findsNothing);
      expect(find.byType(StreamAvatar), findsNothing);
    });
  });

  group('StreamOutgoingCallContent', () {
    testWidgets('names the callee, and says the call is calling', (
      tester,
    ) async {
      final mocks = ringing(['Tammy']);

      await tester.pumpWidget(
        TestWrapper(child: StreamOutgoingCallContent(call: mocks.call)),
      );

      expect(find.text('Tammy'), findsOneWidget);
      expect(find.text('Calling…'), findsOneWidget);
      // One large button, and no labels: the outgoing screen only cancels.
      expect(find.byType(CallRingingButton), findsOneWidget);
      expect(find.text('Decline'), findsNothing);
    });

    testWidgets('the camera reads as off until a track opens', (tester) async {
      const icons = StreamIcons();
      final mocks = ringing(['Tammy']);
      final controller = StreamRingingCameraController(
        call: mocks.call,
        openCameraTrack: () async => mockCameraTrack(),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamOutgoingCallContent(
            call: mocks.call,
            controller: controller,
          ),
        ),
      );

      expect(find.byIcon(icons.videoOffFill), findsOneWidget);

      // TrackOption.provided reads as neither enabled nor disabled, so the
      // screen asks the controller rather than the connect options.
      await controller.setCameraEnabled(enabled: true);
      await tester.pump();

      expect(find.byIcon(icons.videoFill), findsOneWidget);
    });

    testWidgets('a background builder replaces the camera behind the blur', (
      tester,
    ) async {
      final mocks = ringing(['Tammy']);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamOutgoingCallContent(
            call: mocks.call,
            callBackgroundWidgetBuilder: (_, _, child) =>
                ColoredBox(color: const Color(0xFF112233), child: child),
          ),
        ),
      );

      expect(find.byType(RingingCallBackground), findsNothing);
      expect(find.text('Tammy'), findsOneWidget);
    });
  });

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'the ringing screens',
      fileName: 'ringing_call',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 3,
        // Both screens fill whatever they are given, so each scenario is
        // pinned to a phone-sized box rather than left to expand.
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 402,
          height: 740,
        ),
        children: [
          GoldenTestScenario(
            name: 'incoming',
            child: StreamIncomingCallContent(call: ringing(['Tammy']).call),
          ),
          GoldenTestScenario(
            name: 'incoming group',
            child: StreamIncomingCallContent(
              call: ringing(['Tammy', 'Ann', 'Bo']).call,
            ),
          ),
          GoldenTestScenario(
            name: 'outgoing',
            child: StreamOutgoingCallContent(call: ringing(['Tammy']).call),
          ),
        ],
      ),
    );
  }
}
