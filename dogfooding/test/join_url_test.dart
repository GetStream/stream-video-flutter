import 'package:flutter_dogfooding/core/model/environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getJoinUrl encryption_key', () {
    test('is left off when there is no key', () {
      final url = Environment.pronto.getJoinUrl(callId: 'abc');
      expect(url, isNot(contains('encryption_key')));
    });

    test('is left off for an empty key, rather than sent empty', () {
      // An empty parameter reads as "this call is encrypted with nothing",
      // which the web demo would take as an encrypted call.
      final url = Environment.pronto.getJoinUrl(
        callId: 'abc',
        encryptionKey: '',
      );
      expect(url, isNot(contains('encryption_key')));
    });

    test('is appended to the query the environment already has', () {
      expect(
        Environment.pronto.getJoinUrl(
          callId: 'abc',
          encryptionKey: 'noun-rover-waitress',
        ),
        'https://pronto.getstream.io/join/abc'
        '?type=default&encryption_key=noun-rover-waitress',
      );
    });

    test(
      'survives a round trip through Uri for every environment with a URL',
      () {
        const passphrase = 'a b&c=d#e';

        for (final environment in Environment.values) {
          final url = environment.getJoinUrl(
            callId: 'abc',
            encryptionKey: passphrase,
          );
          if (url == null) continue;

          // The passphrase is typed by hand: an unencoded `&` or `#` would
          // silently truncate the key rather than fail.
          expect(
            Uri.parse(url).queryParameters['encryption_key'],
            passphrase,
            reason: 'round trip failed for ${environment.name}',
          );
        }
      },
    );

    test('custom has no join page, with or without a key', () {
      expect(
        Environment.custom.getJoinUrl(callId: 'abc', encryptionKey: 'key'),
        isNull,
      );
    });
  });
}
