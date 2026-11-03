import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  final participant = CallParticipantState(
    name: 'alice',
    userId: 'alice',
    sessionId: 'alice-session',
    custom: const {},
    roles: const [],
    trackIdPrefix: 'alice',
    isLocal: true,
  );

  testWidgets(
    'the default local participant fills the view instead of letterboxing',
    (tester) async {
      StreamParticipantVideoProps? videoProps;

      await tester.pumpWidget(
        StreamComponentFactory(
          // Replaces the renderer, not the tile: the fit the tile hands it is
          // what this is about.
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantVideo: (context, props) {
                videoProps = props;
                return const SizedBox.expand();
              },
            ),
          ),
          child: TestWrapper(
            child: StreamLocalVideo(
              call: MockCall(),
              participant: participant,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );

      expect(videoProps?.videoFit, VideoFit.cover);
    },
  );
}
