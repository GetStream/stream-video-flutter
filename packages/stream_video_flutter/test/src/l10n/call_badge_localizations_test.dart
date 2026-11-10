import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/l10n/localizations/stream_video_flutter_localizations.dart';

void main() {
  group('call badge labels', () {
    test('English', () {
      final l10n = lookupStreamVideoFlutterLocalizations(const Locale('en'));

      expect(l10n.callParticipantsSpoken(1), '1 participant');
      expect(l10n.callParticipantsSpoken(3), '3 participants');
      expect(l10n.callLatencySpoken(42), 'Latency 42 milliseconds');
      expect(l10n.callLatencyUnknownSpoken, 'Latency not measured yet');
    });

    test('Dutch', () {
      final l10n = lookupStreamVideoFlutterLocalizations(const Locale('nl'));

      expect(l10n.callParticipantsSpoken(1), '1 deelnemer');
      expect(l10n.callParticipantsSpoken(3), '3 deelnemers');
      expect(l10n.callLatencySpoken(42), 'Vertraging 42 milliseconden');
      expect(l10n.callLatencyUnknownSpoken, 'Vertraging nog niet gemeten');
    });
  });
}
