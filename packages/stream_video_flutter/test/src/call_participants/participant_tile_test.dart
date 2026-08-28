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

  group('StreamCallParticipant (deprecated)', () {
    testWidgets('renders the default participant tile', (tester) async {
      final participant = MockCallParticipantState();
      when(() => participant.isSpeaking).thenReturn(false);

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
