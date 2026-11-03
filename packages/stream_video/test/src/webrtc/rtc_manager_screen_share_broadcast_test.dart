import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/rtc_manager_fakes.dart';

final _screenShareOption = publishOption(1, SfuTrackType.screenShare);

const _broadcast = ScreenShareConstraints(useiOSBroadcastExtension: true);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  late FakeWebRtcPlatform platform;
  late RtcManagerFixture fixture;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    platform = FakeWebRtcPlatform()..install();
    fixture = RtcManagerFixture(publishOptions: [_screenShareOption]);
  });

  tearDown(() async {
    // Cancels the broadcast listener, which outlives the test otherwise.
    await fixture.manager.dispose();
    CurrentPlatform.debugCurrentPlatformOverride = null;
    platform.uninstall();
  });

  /// Test 1 is the control for the tests that expect no publish after this:
  /// it shows a single event-loop turn is enough for the listener to publish.
  Future<void> broadcastStarted() async {
    await platform.emitEvent('screenSharingStarted');
    // Let the listener run its publish.
    await Future<void>.delayed(Duration.zero);
  }

  group('setScreenShareEnabled with the iOS broadcast extension', () {
    test(
      'creates the track at once but publishes it only when the broadcast '
      'starts',
      () async {
        final result = await fixture.manager.setScreenShareEnabled(
          constraints: _broadcast,
        );

        expect(result.isSuccess, isTrue);
        expect(platform.callsOf('getDisplayMedia'), hasLength(1));
        expect(fixture.transceivers, isEmpty);
        expect(fixture.manager.tracks, isEmpty);

        await broadcastStarted();

        expect(fixture.transceivers, hasLength(1));
        expect(
          fixture.manager.tracks.keys,
          [result.getDataOrNull()!.trackId],
        );
      },
    );

    test(
      'a second start event publishes the same track again (bug 3 of '
      'FLU-1046, pinned as it behaves today; fixed in T13)',
      () async {
        await fixture.manager.setScreenShareEnabled(constraints: _broadcast);
        await broadcastStarted();
        final sender = fixture.transceivers.single.sender;
        expect(sender.replacedTracks, isEmpty);

        await broadcastStarted();

        // Republished onto the cached transceiver.
        expect(fixture.transceivers, hasLength(1));
        expect(sender.replacedTracks, hasLength(1));
      },
    );

    test(
      'disabling before the broadcast starts cancels the publish but leaves '
      'the created track running (bug 3, pinned as it behaves today)',
      () async {
        final created = (await fixture.manager.setScreenShareEnabled(
          constraints: _broadcast,
        )).getDataOrNull()!;

        await fixture.manager.setScreenShareEnabled(enabled: false);
        await broadcastStarted();

        expect(fixture.transceivers, isEmpty);
        expect(fixture.manager.tracks, isEmpty);
        expect(
          platform.disposedTrackIds,
          isNot(contains(created.mediaTrack.id)),
        );
      },
    );

    test('stopping the created track disposes it on the platform', () async {
      // The control for the test above: a stop is visible to the fake.
      final created = (await fixture.manager.setScreenShareEnabled(
        constraints: _broadcast,
      )).getDataOrNull()!;

      await created.stop();

      expect(platform.disposedTrackIds, contains(created.mediaTrack.id));
    });
  });
}
