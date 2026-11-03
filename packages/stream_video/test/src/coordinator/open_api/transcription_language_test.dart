import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/coordinator/open_api/open_api_extensions.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  TranscriptionSettingsLanguage? read(String json) =>
      TranscriptionLanguage(json).toSettingsDomain();

  group('TranscriptionLanguage.toSettingsDomain', () {
    test('a language nobody set is null', () {
      expect(read(''), isNull);
    });

    test('a language that was set is read as is', () {
      expect(read('nl'), TranscriptionSettingsLanguage.nl);
      expect(read('auto'), TranscriptionSettingsLanguage.auto);
    });

    test('a language the SDK does not know yet is auto', () {
      expect(read('xx'), TranscriptionSettingsLanguage.auto);
    });
  });

  group('StreamTranscriptionSettings.toOpenDto', () {
    test('sends no language where none is set', () {
      expect(const StreamTranscriptionSettings().toOpenDto().language, isNull);
    });

    test('sends the language that is set', () {
      expect(
        const StreamTranscriptionSettings(
          language: TranscriptionSettingsLanguage.nl,
        ).toOpenDto().language,
        TranscriptionLanguage.nl,
      );
    });
  });
}
