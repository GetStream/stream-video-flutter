import 'package:flutter_dogfooding/utils/e2ee.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('deriveKeyFromPassphrase', () {
    // Reference vectors computed independently with Python's
    // hashlib.pbkdf2_hmac('sha256', passphrase, b'stream-e2ee', 100000, n).
    // Every Stream SDK derives the same bytes from the same passphrase, so a
    // change here breaks interop with web, iOS and Android.
    const passphrase = 'noun-rover-waitress';
    const expectedAes128 = 'd30b96af272a8791e237e83571639cf2';
    const expectedAes256 =
        'd30b96af272a8791e237e83571639cf2'
        'a10ffde6029c37dfd3ce00e57fd5b37b';

    String hex(List<int> bytes) =>
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    test('derives the shared 16-byte AES-128 key', () async {
      final key = await deriveKeyFromPassphrase(passphrase);

      expect(key, hasLength(16));
      expect(hex(key), expectedAes128);
    });

    test('derives the shared 32-byte AES-256 key', () async {
      final key = await deriveKeyFromPassphrase(passphrase, bits: 256);

      expect(key, hasLength(32));
      expect(hex(key), expectedAes256);
    });

    test('AES-128 is the AES-256 key truncated, as PBKDF2 defines', () async {
      final short = await deriveKeyFromPassphrase(passphrase);
      final long = await deriveKeyFromPassphrase(passphrase, bits: 256);

      expect(hex(long).startsWith(hex(short)), isTrue);
    });

    test('different passphrases derive different keys', () async {
      final a = await deriveKeyFromPassphrase(passphrase);
      final b = await deriveKeyFromPassphrase('noun-rover-waitres');

      expect(hex(a), isNot(hex(b)));
    });

    test('a different salt derives a different key', () async {
      final a = await deriveKeyFromPassphrase(passphrase);
      final b = await deriveKeyFromPassphrase(passphrase, salt: 'other-salt');

      expect(hex(a), isNot(hex(b)));
    });

    test('rejects an empty passphrase', () {
      expect(
        () => deriveKeyFromPassphrase(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects a key size no AES-GCM variant supports', () {
      expect(
        () => deriveKeyFromPassphrase(passphrase, bits: 192),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
