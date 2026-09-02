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



    test('round-trips through JSON', () {
      const config = TelecomPushConfiguration(enabled: true, schema: 'myapp');

      expect(
        TelecomPushConfiguration.fromJson(config.toJson()),
        isA<TelecomPushConfiguration>()
            .having((c) => c.enabled, 'enabled', isTrue)
            .having((c) => c.schema, 'schema', 'myapp'),
      );
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
