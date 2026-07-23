import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/video_environment.dart';

void main() {
  group('VideoEnvironment.xStreamClientHeader', () {
    test('builds header from all fields', () {
      const environment = VideoEnvironment(
        sdkVersion: '1.4.1',
        osName: 'android',
        osVersion: '16',
        appName: 'MyApp',
        appVersion: '2.5.1',
        deviceModel: 'Nothing A142',
      );

      expect(
        environment.xStreamClientHeader,
        'stream-video-flutter-v1.4.1|app=MyApp|app_version=2.5.1|'
        'os=android 16|device_model=Nothing A142',
      );
    });

    test('strips non-ASCII characters from the app name', () {
      const environment = VideoEnvironment(
        sdkVersion: '1.4.1',
        osName: 'android',
        osVersion: '16',
        appName: 'aąbęcódńfśłżźć',
        appVersion: '2.5.1',
        deviceModel: 'Nothing A142',
      );

      final header = environment.xStreamClientHeader;

      expect(header.contains('app=abcdf'), isTrue);
      expect(header.contains('ó'), isFalse);
      // The resulting header value must be valid US-ASCII.
      expect(header.codeUnits.every((c) => c >= 0x20 && c <= 0x7E), isTrue);
    });

    test('drops the "|" separator from field values', () {
      const environment = VideoEnvironment(
        sdkVersion: '1.4.1',
        osName: 'android',
        appName: 'My|App',
      );

      expect(
        environment.xStreamClientHeader,
        'stream-video-flutter-v1.4.1|app=MyApp|os=android',
      );
    });
  });
}
