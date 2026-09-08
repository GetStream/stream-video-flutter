// ignore_for_file: avoid_implementing_value_types

import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class MockCall extends Mock implements Call {}

class MockCallState extends Mock implements CallState {}

class MockCallParticipantState extends Mock implements CallParticipantState {
  MockCallParticipantState() {
    // Whether the SFU has paused a track is asked of every participant the
    // tile draws, but it is an inbound-bandwidth state almost no test is
    // about. Default it to "not paused" so only the tests that exercise
    // pausing have to say anything; `when` in a test still overrides this.
    // The tile reads this to notice a recycled element pointing at somebody
    // new. Tests about that override it; the rest just need it non-null.
    when(() => sessionId).thenReturn('session');

    for (final trackType in [
      SfuTrackType.video,
      SfuTrackType.audio,
      SfuTrackType.screenShare,
      SfuTrackType.screenShareAudio,
      SfuTrackType.unspecified,
    ]) {
      when(() => isTrackPaused(trackType)).thenReturn(false);
    }
  }
}

class MockRtcMediaDeviceNotifier extends Mock
    implements RtcMediaDeviceNotifier {}
