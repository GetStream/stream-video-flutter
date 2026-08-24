// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'e2ee.dart';

/// Supplies a key for a call answered from a ringing notification.
Future<CallEncryptionKey?> resolveRingingEncryptionKey(
  CallEncryptionKeyRequest request,
) async {
  if (request.encryptionMode != StreamEncryptionMode.autoOn) return null;

  // Dogfooding does not currently support the proper flow of encrypted ringing calls,
  // so we use a random key here. See [randomEncryptionKey] for details: using a wrong
  // key allows the user to enter the call, and the correct key can later be provided
  // through the in-call banner.
  return CallEncryptionKey.shared(
    bytes: randomEncryptionKey(),
    // Spelled out even though it matches the default: the index is a contract
    // between participants, not a default worth inheriting quietly.
    // ignore: avoid_redundant_argument_values
    keyIndex: kE2EESharedKeyIndex,
  );
}
