import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/manager/push_token_source.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

// Pins where the VoIP token source reads from: the token the platform stored,
// then every token the iOS plugin sends on the event channel, leaving out the
// empty one it sends when PushKit invalidates the token.

class _FakePushPlatform extends StreamVideoPushNotificationPlatform {
  _FakePushPlatform(this.storedToken);

  final String storedToken;

  /// When set, reading the stored token waits for it.
  Completer<void>? readGate;

  // Closed in the test's tearDown.
  // ignore: close_sinks
  final events = StreamController<RingingEvent?>.broadcast();

  @override
  Stream<RingingEvent?> get onEvent => events.stream;

  @override
  Future<String> getDevicePushTokenVoIP() async {
    await readGate?.future;
    return storedToken;
  }
}

void main() {
  late _FakePushPlatform platform;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
  });

  tearDown(() async {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    await platform.events.close();
  });

  Future<List<String>> collect(Iterable<String> sent) async {
    final tokens = <String>[];
    final subscription = const VoIPTokenSource().tokens.listen(tokens.add);
    await pumpEventQueue();
    for (final token in sent) {
      platform.events.add(ActionDidUpdateDevicePushTokenVoip(token: token));
      await pumpEventQueue();
    }
    await subscription.cancel();
    return tokens;
  }

  test('emits the stored token, then each refresh but the empty one', () async {
    platform = _FakePushPlatform('stored');
    StreamVideoPushNotificationPlatform.instance = platform;

    expect(await collect(['first', '', 'second']), [
      'stored',
      'first',
      'second',
    ]);
  });

  test('a token sent before one was stored is the first emitted', () async {
    platform = _FakePushPlatform('');
    StreamVideoPushNotificationPlatform.instance = platform;

    expect(await collect(['first']), ['first']);
  });

  test(
    'a refresh sent while the stored token is read follows it',
    () async {
      platform = _FakePushPlatform('stored')..readGate = Completer<void>();
      StreamVideoPushNotificationPlatform.instance = platform;

      final tokens = <String>[];
      final subscription = const VoIPTokenSource().tokens.listen(tokens.add);
      await pumpEventQueue();

      platform.events.add(
        const ActionDidUpdateDevicePushTokenVoip(token: 'rotated'),
      );
      await pumpEventQueue();
      expect(tokens, isEmpty);

      platform.readGate!.complete();
      await pumpEventQueue();
      await subscription.cancel();

      expect(tokens, ['stored', 'rotated']);
    },
  );

  test('emits nothing off iOS', () async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    platform = _FakePushPlatform('stored');
    StreamVideoPushNotificationPlatform.instance = platform;

    expect(await collect(['first']), isEmpty);
  });
}
