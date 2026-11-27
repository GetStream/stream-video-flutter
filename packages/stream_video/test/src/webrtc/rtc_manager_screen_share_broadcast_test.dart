import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import '../../fixtures/webrtc_capabilities.dart';
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
    await fixture.manager.dispose();
    CurrentPlatform.debugCurrentPlatformOverride = null;
    platform.uninstall();
  });

  test('without a broadcast extension, the screen is captured and published '
      'at once', () async {
    overrideWebRtcCapabilities(platform: PlatformType.android);

    final result = await fixture.manager.setScreenShareEnabled(
      constraints: _broadcast,
    );

    expect(result.isSuccess, isTrue);
    expect(fixture.transceivers, hasLength(1));
  });

  test('a broadcast share is captured without the picker and published at '
      'once', () async {
    final result = await fixture.manager.setScreenShareEnabled(
      constraints: _broadcast,
    );

    expect(result.isSuccess, isTrue);
    final constraints =
        platform.callsOf('getDisplayMedia').single.arguments['constraints']
            as Map;
    expect((constraints['video'] as Map)['deviceId'], 'broadcast-manual');
    expect(fixture.transceivers, hasLength(1));
    expect(fixture.manager.tracks.keys, [result.getDataOrNull()!.trackId]);
  });

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
    expect(fixture.transceivers, hasLength(1));
  });
}
