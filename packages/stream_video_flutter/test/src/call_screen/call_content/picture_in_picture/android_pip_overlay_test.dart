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

    // The registered tile builder adds an overflow menu to every tile, the way
    // the dogfooding app does.
    Future<void> pumpOverlay(
      WidgetTester tester, {
      StreamPictureInPictureThemeData? pictureInPictureTheme,
      StreamConnectionQualityIndicatorThemeData?
      connectionQualityIndicatorTheme,
    }) async {
      final overlay = switch (pictureInPictureTheme) {
        final theme? => StreamPictureInPictureTheme(
          data: theme,
          child: AndroidPipOverlay(call: call),
        ),
        null => AndroidPipOverlay(call: call),
      };

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
              child: switch (connectionQualityIndicatorTheme) {
                final theme? => StreamConnectionQualityIndicatorTheme(
                  data: theme,
                  child: overlay,
                ),
                null => overlay,
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('draws the name and the connection quality', (tester) async {
      await pumpOverlay(tester);

      expect(find.text('renderer'), findsOneWidget);
      expect(find.text('Rene Floor'), findsOneWidget);
      expect(find.byType(StreamConnectionQualityIndicator), findsOneWidget);
    });

    testWidgets('draws no overflow button, camera icon or sound indicator', (
      tester,
    ) async {
      when(() => participant.isVideoEnabled).thenReturn(false);

      await pumpOverlay(tester);

      expect(find.byIcon(const StreamIcons().moreHorizontal), findsNothing);
      expect(find.byIcon(const StreamIcons().videoOffFill), findsNothing);
      expect(find.byType(StreamAudioIndicator), findsNothing);
    });

    // The system rounds the window, and a tile rounding itself as well leaves
    // the Material behind it showing through the corners.
    testWidgets('draws square corners', (tester) async {
      await pumpOverlay(tester);

      final clip = tester.widget<ClipRRect>(
        find
            .descendant(
              of: find.byType(DefaultStreamParticipantTile),
              matching: find.byType(ClipRRect),
            )
            .first,
      );

      expect(clip.borderRadius, BorderRadius.zero);
    });

    // An outline runs into the same clip as the corners: drawn square, with the
    // window cutting its corners off. Covers the speaking outline too, which
    // is the one state that draws over video.
    testWidgets('draws no outline, speaking or not', (tester) async {
      when(() => participant.isVideoEnabled).thenReturn(false);
      when(() => participant.isSpeaking).thenReturn(true);

      await pumpOverlay(tester);

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DefaultStreamParticipantTile),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.foregroundDecoration as BoxDecoration?;

      expect(decoration?.border, const Border());
    });

    // Both pieces of chrome sit in a corner of the window, so the corner each
    // one occupies is square.
    testWidgets('anchors the chrome in the corners', (tester) async {
      await pumpOverlay(tester);

      final toolbarPadding = tester
          .widgetList<Padding>(
            find.descendant(
              of: find.byType(DefaultStreamParticipantTile),
              matching: find.byType(Padding),
            ),
          )
          .map((it) => it.padding)
          .toList();

      expect(toolbarPadding, contains(EdgeInsets.zero));

      final pill = tester.widget<ClipRRect>(
        find
            .descendant(
              of: find.byType(DefaultStreamParticipantLabel),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      expect(
        pill.borderRadius,
        BorderRadius.only(topRight: const StreamRadius().lg),
      );
    });

    // Only the shape is the window's business, so the fill an app themed the
    // indicator with has to survive.
    testWidgets('squares the indicator without dropping its fill', (
      tester,
    ) async {
      const themed = Color(0xFF00FF00);

      await pumpOverlay(
        tester,
        connectionQualityIndicatorTheme:
            const StreamConnectionQualityIndicatorThemeData(
              style: StreamConnectionQualityIndicatorStyle(
                decoration: BoxDecoration(color: themed),
              ),
            ),
      );

      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(StreamConnectionQualityIndicator),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final decoration = box.decoration as BoxDecoration;

      expect(decoration.color, themed);
      expect(decoration.shape, BoxShape.rectangle);
      expect(
        decoration.borderRadius,
        BorderRadius.only(topLeft: const StreamRadius().lg),
      );
    });

    testWidgets('draws the chrome the picture-in-picture theme asks back', (
      tester,
    ) async {
      when(() => participant.isVideoEnabled).thenReturn(false);

      await pumpOverlay(
        tester,
        pictureInPictureTheme: const StreamPictureInPictureThemeData(
          style: StreamPictureInPictureStyle(
            tileStyle: StreamParticipantTileStyle(
              showMoreButton: true,
              labelStyle: StreamParticipantLabelStyle(
                showAudioIndicator: true,
                showVideoOffIcon: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(const StreamIcons().moreHorizontal), findsOneWidget);
      expect(find.byIcon(const StreamIcons().videoOffFill), findsOneWidget);
      expect(find.byType(StreamAudioIndicator), findsOneWidget);
    });
  });
}
