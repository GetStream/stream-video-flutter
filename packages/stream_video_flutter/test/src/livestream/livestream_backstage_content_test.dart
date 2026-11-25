import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'fake_livestream_call.dart';

void main() {
  testWidgets(
    'LivestreamBackstageContent shows the server count of early joiners',
    (tester) async {
      // A large call: the client holds details for a few participants only.
      final backstage = CallState(
        currentUserId: 'viewer',
        callCid: StreamCallCid(cid: 'livestream:test'),
        preferences: DefaultCallPreferences(),
      ).copyWith(isBackstage: true, participantCount: 3000);

      await tester.pumpWidget(
        MaterialApp(
          home: LivestreamBackstageContent(call: FakeLivestreamCall(backstage)),
        ),
      );
      await tester.pump();

      expect(find.textContaining('3000 participants'), findsOneWidget);
    },
  );
}
