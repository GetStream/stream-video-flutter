import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import '../fixtures/data.dart';
import 'fixtures/call_session_harness.dart';

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  group('a session without a manager', () {
    late CallSessionHarness harness;

    setUp(() => harness = CallSessionHarness());

    Future<String?> messageOf(Future<Result<Object?>> call) async {
      final result = await call;
      return (result as Failure).videoError.message;
    }

    test('fails the media calls as not connected', () async {
      final session = harness.session;
      final device = SampleCallData.defaultMediaDevice;

      expect(
        await messageOf(session.setCameraEnabled(true)),
        'Unable to set camera, Call not connected',
      );
      expect(
        await messageOf(session.setMicrophoneEnabled(true)),
        'Unable to set microphone, Call not connected',
      );
      expect(
        await messageOf(session.setAudioOutputDevice(device)),
        'Unable to set speaker device, Call not connected',
      );
      expect(
        await messageOf(session.setScreenShareEnabled(true)),
        'Unable to set ScreenShare, Call not connected',
      );
      expect(
        await messageOf(session.flipCamera()),
        'Unable to flip camera, Call not connected',
      );
      expect(
        await messageOf(session.setLocalTrack(MockRtcLocalTrack())),
        'Unable to set local track, Call not connected',
      );
      expect(
        await messageOf(session.setAudioInputDevice(device)),
        'Unable to set audioInput, Call not connected',
      );
      expect(
        await messageOf(session.setVideoInputDevice(device)),
        'Unable to set video input, Call not connected',
      );
      expect(
        await messageOf(session.setCameraPosition(CameraPosition.front)),
        'Unable to set camera position, Call not connected',
      );
    });

    test('has no tracks', () {
      final session = harness.session;

      expect(session.getTrack('alice-prefix', SfuTrackType.video), isNull);
      expect(session.getTracks('alice-prefix'), isEmpty);
      expect(session.handOverLocalTracks(), isEmpty);
    });
  });
}
