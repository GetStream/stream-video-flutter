import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import '../../fixtures/webrtc_capabilities.dart';
import '../call/fixtures/call_test_helpers.dart';
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
    overrideWebRtcCapabilities(platform: PlatformType.ios);
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

  test('without a broadcast extension, the screen is captured and published '
      'at once', () async {
    overrideWebRtcCapabilities(platform: PlatformType.android);

    final result = await fixture.manager.setScreenShareEnabled(
      constraints: _broadcast,
    );

    expect(result.isSuccess, isTrue);
    expect(fixture.transceivers, hasLength(1));
  });

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

    test('a second start event does not publish the track again', () async {
      await fixture.manager.setScreenShareEnabled(constraints: _broadcast);
      await broadcastStarted();
      final sender = fixture.transceivers.single.sender;

      await broadcastStarted();

      expect(fixture.transceivers, hasLength(1));
      expect(sender.replacedTracks, isEmpty);
    });

    test(
      'disabling before the broadcast starts stops the created track',
      () async {
        final created = (await fixture.manager.setScreenShareEnabled(
          constraints: _broadcast,
        )).getDataOrNull()!;

        await fixture.manager.setScreenShareEnabled(enabled: false);
        await broadcastStarted();

        expect(fixture.transceivers, isEmpty);
        expect(fixture.manager.tracks, isEmpty);
        expect(platform.disposedTrackIds, contains(created.mediaTrack.id));
      },
    );

    test(
      'a broadcast that stops before it starts stops the created track',
      () async {
        final created = (await fixture.manager.setScreenShareEnabled(
          constraints: _broadcast,
        )).getDataOrNull()!;

        await platform.emitEvent('screenSharingStopped');
        await Future<void>.delayed(Duration.zero);
        await broadcastStarted();

        expect(fixture.transceivers, isEmpty);
        expect(platform.disposedTrackIds, contains(created.mediaTrack.id));
      },
    );

    test(
      'enabling again before the broadcast starts replaces the created track',
      () async {
        final first = (await fixture.manager.setScreenShareEnabled(
          constraints: _broadcast,
        )).getDataOrNull()!;
        final second = (await fixture.manager.setScreenShareEnabled(
          constraints: _broadcast,
        )).getDataOrNull()!;

        await broadcastStarted();

        expect(platform.disposedTrackIds, contains(first.mediaTrack.id));
        expect(fixture.manager.tracks.keys, [second.trackId]);
        expect(fixture.transceivers, hasLength(1));
      },
    );

    test(
      'disposing before the broadcast starts stops the created track',
      () async {
        final created = (await fixture.manager.setScreenShareEnabled(
          constraints: _broadcast,
        )).getDataOrNull()!;

        await fixture.manager.dispose();

        expect(platform.disposedTrackIds, contains(created.mediaTrack.id));
      },
    );

    for (final (name, cancel) in [
      (
        'disabling',
        (RtcManager m) => m.setScreenShareEnabled(enabled: false),
      ),
      ('disposing', (RtcManager m) => m.dispose()),
    ]) {
      test(
        '$name while the track is still being created stops it and never '
        'publishes it',
        () async {
          platform.getDisplayMediaGate = Completer<void>();

          final starting = fixture.manager.setScreenShareEnabled(
            constraints: _broadcast,
          );
          await pumpEventQueue();
          final cancelling = cancel(fixture.manager);
          platform.getDisplayMediaGate!.complete();
          await cancelling;

          expect((await starting).isFailure, isTrue);
          await broadcastStarted();

          expect(fixture.transceivers, isEmpty);
          expect(fixture.manager.tracks, isEmpty);
          expect(platform.disposedTrackIds, isNotEmpty);
        },
      );
    }

    test(
      'a publish that fails stops the track and marks the share off',
      () async {
        final state = createTestCallStateManager();
        final failing = RtcManagerFixture(stateManager: state);
        final created = (await failing.manager.setScreenShareEnabled(
          constraints: _broadcast,
        )).getDataOrNull()!;

        await broadcastStarted();

        expect(failing.transceivers, isEmpty);
        expect(platform.disposedTrackIds, contains(created.mediaTrack.id));
        verify(
          () => state.participantSetScreenShareEnabled(enabled: false),
        ).called(1);
        await failing.manager.dispose();
      },
    );

    test('two enables at once create one track', () async {
      final first = fixture.manager.setScreenShareEnabled(
        constraints: _broadcast,
      );
      final second = fixture.manager.setScreenShareEnabled(
        constraints: _broadcast,
      );

      final (a, b) = (await first, await second);

      expect(platform.callsOf('getDisplayMedia'), hasLength(1));
      expect(a.getDataOrNull(), same(b.getDataOrNull()));
    });

    test('stopping the created track disposes it on the platform', () async {
      // The control for the tests above: a stop is visible to the fake.
      final created = (await fixture.manager.setScreenShareEnabled(
        constraints: _broadcast,
      )).getDataOrNull()!;

      await created.stop();

      expect(platform.disposedTrackIds, contains(created.mediaTrack.id));
    });
  });
}
