import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  group('StreamParticipantTile', () {
    late MockCall call;
    late MockCallParticipantState participant;

    setUp(() {
      call = MockCall();
      participant = MockCallParticipantState();
    });

    testWidgets('renders the builder registered on the component factory', (
      tester,
    ) async {
      StreamParticipantTileProps? receivedProps;

      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantTile: (context, props) {
                receivedProps = props;
                return const Text('custom tile');
              },
            ),
          ),
          child: TestWrapper(
            child: StreamParticipantTile(
              call: call,
              participant: participant,
              showParticipantLabel: false,
            ),
          ),
        ),
      );

      expect(find.text('custom tile'), findsOneWidget);
      expect(find.byType(DefaultStreamParticipantTile), findsNothing);

      // The props are forwarded as passed to the widget.
      expect(receivedProps?.call, same(call));
      expect(receivedProps?.participant, same(participant));
      expect(receivedProps?.showParticipantLabel, isFalse);
    });

    testWidgets('falls back to the default tile without a factory', (
      tester,
    ) async {
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isVideoEnabled).thenReturn(true);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamParticipantTile(
            call: call,
            participant: participant,
            showParticipantLabel: false,
            showConnectionQualityIndicator: false,
            // Stub out the renderer, it needs a real call to publish tracks.
            videoRendererBuilder: (_, _, _) => const Text('renderer'),
          ),
        ),
      );

      expect(find.byType(DefaultStreamParticipantTile), findsOneWidget);
      expect(find.text('renderer'), findsOneWidget);
    });
  });

  group('StreamFloatingParticipantTile', () {
    // Both floating goldens hand in their own participantBuilder, so the
    // default composition — a StreamParticipantTile inside the surface — is
    // only covered here.
    testWidgets('clips the tile to the surface radius it was given', (
      tester,
    ) async {
      final participant = MockCallParticipantState();
      when(() => participant.name).thenReturn('Rene Floor');
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isAudioEnabled).thenReturn(true);
      when(() => participant.isVideoEnabled).thenReturn(true);
      when(
        () => participant.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => participant.reaction).thenReturn(null);

      const radius = BorderRadius.all(Radius.circular(24));

      await tester.pumpWidget(
        StreamComponentFactory(
          // Replaces the renderer, not the tile: the tile's own clip is what
          // this is about.
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantVideo: (context, props) =>
                  const ColoredBox(color: Color(0xFF102030)),
            ),
          ),
          child: TestWrapper(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant,
              style: const StreamFloatingParticipantTileStyle(
                borderRadius: radius,
              ),
            ),
          ),
        ),
      );

      // A surface rounded further than the tile inside it leaves transparent
      // notches where the tighter clip stops short of the corner.
      final clip = tester.widget<ClipRRect>(
        find
            .descendant(
              of: find.byType(DefaultStreamParticipantTile),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      expect(clip.borderRadius, radius);
    });
  });

  group('StreamCallParticipant (deprecated)', () {
    testWidgets('renders the default participant tile', (tester) async {
      final participant = MockCallParticipantState();
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isVideoEnabled).thenReturn(true);

      await tester.pumpWidget(
        TestWrapper(
          // ignore: deprecated_member_use_from_same_package
          child: StreamCallParticipant(
            call: MockCall(),
            participant: participant,
            showParticipantLabel: false,
            showConnectionQualityIndicator: false,
            // Stub out the renderer, it needs a real call to publish tracks.
            videoRendererBuilder: (_, _, _) => const Text('renderer'),
          ),
        ),
      );

      expect(find.byType(DefaultStreamParticipantTile), findsOneWidget);
      expect(find.text('renderer'), findsOneWidget);
    });
  });
}
