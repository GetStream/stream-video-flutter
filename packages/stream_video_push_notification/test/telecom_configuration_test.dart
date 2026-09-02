import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

void main() {
  group('TelecomPushConfiguration', () {
    test('leaves the decision to the platform when unset', () {
      const config = TelecomPushConfiguration();

      // Not false: the native side needs to tell "said nothing" apart from "said no", because the
      // default depends on the Android version (on from 17, off below).
      expect(config.enabled, isNull);
      expect(config.schema, isNull);
    });

    test('an explicit opt-out survives JSON as false, not as unset', () {
      const config = TelecomPushConfiguration(enabled: false);

      final json = config.toJson();
      expect(json['enabled'], isFalse);
      expect(TelecomPushConfiguration.fromJson(json).enabled, isFalse);
    });

    test('an unset value survives JSON as unset', () {
      const config = TelecomPushConfiguration();

      final json = config.toJson();
      expect(json['enabled'], isNull);
      expect(TelecomPushConfiguration.fromJson(json).enabled, isNull);
    });

    test('round-trips through JSON', () {
      const config = TelecomPushConfiguration(enabled: true, schema: 'myapp');

      expect(
        TelecomPushConfiguration.fromJson(config.toJson()),
        isA<TelecomPushConfiguration>()
            .having((c) => c.enabled, 'enabled', isTrue)
            .having((c) => c.schema, 'schema', 'myapp'),
      );
    });

    test('is carried by the android section of the push configuration', () {
      const configuration = StreamVideoPushConfiguration(
        android: AndroidPushConfiguration(
          telecom: TelecomPushConfiguration(enabled: true, schema: 'myapp'),
        ),
      );

      final android = configuration.toJson()['android'] as Map<String, dynamic>;
      final telecom = android['telecom'] as Map<String, dynamic>;

      expect(telecom['enabled'], isTrue);
      expect(telecom['schema'], 'myapp');
    });

    test('absent telecom section stays absent after merging', () {
      const base = StreamVideoPushConfiguration(
        android: AndroidPushConfiguration(ringtonePath: 'ringtone'),
      );

      final merged = base.merge(
        const StreamVideoPushConfiguration(
          android: AndroidPushConfiguration(defaultAvatar: 'avatar'),
        ),
      );

      expect(merged.android?.telecom, isNull);
    });

    test('merge takes the telecom section from the override', () {
      const base = StreamVideoPushConfiguration(
        android: AndroidPushConfiguration(
          telecom: TelecomPushConfiguration(schema: 'base'),
        ),
      );

      final merged = base.merge(
        const StreamVideoPushConfiguration(
          android: AndroidPushConfiguration(
            telecom: TelecomPushConfiguration(enabled: true, schema: 'myapp'),
          ),
        ),
      );

      expect(merged.android?.telecom?.enabled, isTrue);
      expect(merged.android?.telecom?.schema, 'myapp');
    });
  });

  group('CallEndedReason', () {
    test('raw values match CXCallEndedReason', () {
      expect(CallEndedReason.failed.rawValue, 1);
      expect(CallEndedReason.remoteEnded.rawValue, 2);
      expect(CallEndedReason.unanswered.rawValue, 3);
      expect(CallEndedReason.answeredElsewhere.rawValue, 4);
      expect(CallEndedReason.declinedElsewhere.rawValue, 5);
    });
  });
}
