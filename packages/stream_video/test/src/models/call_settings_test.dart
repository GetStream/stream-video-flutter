import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  test('call settings that differ in any section are not equal', () {
    const base = CallSettings();

    final changed = [
      base.copyWith(
        ring: const StreamRingSettings(
          autoCancelTimeout: Duration(seconds: 5),
        ),
      ),
      base.copyWith(
        recording: const StreamRecordingSettings(audioOnly: true),
      ),
      base.copyWith(
        geofencing: const StreamGeofencingSettings(names: ['eu']),
      ),
      base.copyWith(
        backstage: const StreamBackstageSettings(enabled: true),
      ),
    ];

    for (final settings in changed) {
      expect(settings, isNot(base));
    }
  });
}
