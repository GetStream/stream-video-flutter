import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

/// Captures the configuration map handed to the platform, which is the thing the native side
/// actually reads. Asserting on a hand-built `toJson()` skips the merge and the dispatch.
class _CapturingPlatform extends StreamVideoPushNotificationPlatform {
  final List<Map<String, dynamic>> initCalls = <Map<String, dynamic>>[];

  @override
  Future<void> init(Map<String, dynamic> pushConfiguration) async {
    initCalls.add(pushConfiguration);
  }
}

class _MockCoordinatorClient extends Mock implements CoordinatorClient {}

class _MockStreamVideo extends Mock implements StreamVideo {}

/// Runs the real `create` path and returns the map the platform was given.
Map<String, dynamic> _dispatch(
  _CapturingPlatform platform,
  StreamVideoPushConfiguration? configuration,
) {
  final provider = StreamVideoPushNotificationManager.create(
    iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn'),
    androidPushProvider: const StreamVideoPushProvider.firebase(name: 'fcm'),
    pushConfiguration: configuration,
  );

  provider(_MockCoordinatorClient(), _MockStreamVideo());
  return platform.initCalls.last;
}

Map<String, dynamic>? _telecomOf(Map<String, dynamic> configuration) {
  final android = configuration['android'] as Map<String, dynamic>?;
  return android?['telecom'] as Map<String, dynamic>?;
}

void main() {
  late _CapturingPlatform platform;

  setUp(() {
    platform = _CapturingPlatform();
    StreamVideoPushNotificationPlatform.instance = platform;
  });

  group('telecom configuration reaching the platform', () {
    test('survives the merge with the default configuration', () {
      // The default configuration carries an `android` section without a telecom one, so this is
      // the case where a wholesale merge could drop it before it ever reaches native.
      final dispatched = _dispatch(
        platform,
        const StreamVideoPushConfiguration(
          android: AndroidPushConfiguration(
            telecom: TelecomPushConfiguration(enabled: true, schema: 'myapp'),
          ),
        ),
      );

      expect(_telecomOf(dispatched), isNotNull);
      expect(_telecomOf(dispatched)!['enabled'], isTrue);
      expect(_telecomOf(dispatched)!['schema'], 'myapp');
    });

    test('an explicit opt-out reaches the platform as false, not as absent', () {
      // The whole tri-state hinges on this: native cannot tell "said no" from "said nothing" if
      // false collapses to null on the way out.
      final dispatched = _dispatch(
        platform,
        const StreamVideoPushConfiguration(
          android: AndroidPushConfiguration(
            telecom: TelecomPushConfiguration(enabled: false),
          ),
        ),
      );

      expect(_telecomOf(dispatched)!['enabled'], isFalse);
    });

    test('no telecom section is dispatched when none was configured', () {
      // Native reads this as "no preference" and applies the platform default, so an empty map
      // here would be wrong in a way no Dart-side assertion would notice.
      final dispatched = _dispatch(platform, null);

      expect(dispatched['android'], isNotNull);
      expect(_telecomOf(dispatched), isNull);
    });

    test('an override without a telecom section keeps the one it overrides', () {
      // `AndroidPushConfiguration.merge` passes `other.telecom` to `copyWith`, which resolves it
      // as `telecom ?? this.telecom` — so a null override cannot clear the section. Pinned because
      // it rests on that `??`: making `copyWith` honour explicit nulls, a common "fix", would
      // start silently dropping a caller's telecom configuration here.
      const base = StreamVideoPushConfiguration(
        android: AndroidPushConfiguration(
          telecom: TelecomPushConfiguration(enabled: true, schema: 'base'),
        ),
      );

      final merged = base.merge(
        const StreamVideoPushConfiguration(
          android: AndroidPushConfiguration(defaultAvatar: 'avatar'),
        ),
      );

      expect(merged.android?.telecom?.enabled, isTrue);
      expect(merged.android?.telecom?.schema, 'base');
    });
  });
}
