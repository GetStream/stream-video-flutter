import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import 'fake_livestream_call.dart';

void main() {
  final base = CallState(
    currentUserId: 'viewer',
    callCid: StreamCallCid(cid: 'livestream:test'),
    preferences: DefaultCallPreferences(),
  );

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'Livestream ended and backstage cards',
      fileName: 'livestream_status_cards',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 280,
          height: 482,
        ),
        children: [
          GoldenTestScenario(
            name: 'ended',
            child: LivestreamEndedContent(
              call: FakeLivestreamCall(base),
            ),
          ),
          GoldenTestScenario(
            name: 'backstage',
            child: LivestreamBackstageContent(
              call: FakeLivestreamCall(
                base.copyWith(isBackstage: true, participantCount: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
