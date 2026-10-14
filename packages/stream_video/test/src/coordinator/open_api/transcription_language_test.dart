import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/coordinator/open_api/open_api_extensions.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  TranscriptionSettingsLanguage read(String json) =>
      TranscriptionSettingsResponseLanguage.fromJson(json).toSettingsDomain();

  group('TranscriptionSettingsResponseLanguage.toSettingsDomain', () {
    test('a language nobody set is English, as the backend uses', () {
      expect(read(''), TranscriptionSettingsLanguage.en);
    });

    test('a language that was set is read as is', () {
      expect(read('nl'), TranscriptionSettingsLanguage.nl);
      expect(read('auto'), TranscriptionSettingsLanguage.auto);
    });

    test('a language the SDK does not know yet is auto', () {
      expect(read('xx'), TranscriptionSettingsLanguage.auto);
    });
  });
}
