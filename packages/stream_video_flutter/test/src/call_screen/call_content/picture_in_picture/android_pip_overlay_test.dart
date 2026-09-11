import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../../test_utils/test_wrapper.dart';
import '../../../mocks.dart';

void main() {
  group('AndroidPipOverlay', () {
    late MockCall call;
    late MockCallState callState;
    late MockCallParticipantState participant;

    setUp(() {
      call = MockCall();
      callState = MockCallState();
      participant = MockCallParticipantState();

      when(() => participant.userId).thenReturn('rene');
      when(() => participant.uniqueParticipantKey).thenReturn('rene-session');
      when(() => participant.name).thenReturn('Rene Floor');
      when(() => participant.isLocal).thenReturn(true);
      when(() => participant.isPinned).thenReturn(false);
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isAudioEnabled).thenReturn(true);
      when(() => participant.isVideoEnabled).thenReturn(true);
      when(() => participant.isScreenShareEnabled).thenReturn(false);
      when(() => participant.screenShareTrack).thenReturn(null);
      when(() => participant.reaction).thenReturn(null);
      when(
        () => participant.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => participant.viewportVisibility).thenReturn(
        ViewportVisibility.visible,
      );
      when(() => callState.callParticipants).thenReturn([participant]);

      final emitter = MutableStateEmitter<CallState>(callState, sync: true);
      when(() => call.state).thenAnswer((_) => emitter);
      when(
        () => call.partialState<List<CallParticipantState>>(any()),
      ).thenAnswer((invocation) {
        final CallStateSelector<List<CallParticipantState>> selector =
            invocation.positionalArguments[0];
        return Stream.value(selector(callState));
      });
    });

    // The PiP window shows the video and nothing else. An app that registers a
    // `participantTile` builder adding an overflow menu to every tile — which
    // the dogfooding app does — must not get one here either.
    testWidgets('draws the participant without any tile chrome', (
      tester,
    ) async {
      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantTile: (context, props) => DefaultStreamParticipantTile(
                props: props.copyWith(
                  actionsBuilder: (context, participant) => [
                    StreamParticipantTileAction(
                      icon: context.streamIcons.pin,
                      label: 'Pin',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // The real renderer needs a call publishing tracks.
              participantVideo: (context, props) => const Text('renderer'),
            ),
          ),
          child: TestWrapper(
            child: SizedBox(
              width: 200,
              height: 300,
              child: AndroidPipOverlay(call: call),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('renderer'), findsOneWidget);
      expect(find.byType(StreamParticipantLabel), findsNothing);
      expect(find.byType(StreamConnectionQualityIndicator), findsNothing);
      expect(find.byIcon(const StreamIcons().moreHorizontal), findsNothing);
    });
  });
}
