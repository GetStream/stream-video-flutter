import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// The single key index this app uses for its shared E2EE key.
///
/// Every participant derives the key from the same passphrase, so they have to
/// agree on the index too: a frame carries the index it was encrypted with,
/// and a receiver looking elsewhere fails every decrypt.
const int kE2EESharedKeyIndex = 0;

/// Salt this app derives its shared key with.
///
/// The salt and the iteration count are a contract between *participants*, not
/// between SDKs: change either and peers on the old build derive a different
/// key from the same passphrase, and nothing decrypts.
const streamE2eePassphraseSalt = 'stream-e2ee';

/// PBKDF2 iteration count this app derives its shared key with.
///
/// See [streamE2eePassphraseSalt] on why this cannot change unilaterally.
const streamE2eePassphraseIterations = 100000;

/// Derives an AES key from a human-typed [passphrase].
///
/// PBKDF2-HMAC-SHA256 with [streamE2eePassphraseSalt] and
/// [streamE2eePassphraseIterations].
///
/// [bits] must match the manager's algorithm: 128 for AES-128 (the default)
/// and 256 for AES-256.
///
/// ```dart
/// final keyBytes = await deriveKeyFromPassphrase('noun-rover-waitress');
/// await e2ee.setSharedKey(kE2EESharedKeyIndex, keyBytes);
/// ```
Future<Uint8List> deriveKeyFromPassphrase(
  String passphrase, {
  int bits = 128,
  String salt = streamE2eePassphraseSalt,
  int iterations = streamE2eePassphraseIterations,
}) async {
  if (passphrase.isEmpty) {
    throw ArgumentError.value(passphrase, 'passphrase', 'must not be empty');
  }
  if (bits != 128 && bits != 256) {
    throw ArgumentError.value(bits, 'bits', 'must be either 128 or 256');
  }

  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: bits,
  );

  final derived = await pbkdf2.deriveKey(
    secretKey: SecretKey(utf8.encode(passphrase)),
    nonce: utf8.encode(salt),
  );

  return Uint8List.fromList(await derived.extractBytes());
}
