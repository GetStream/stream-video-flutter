import 'dart:typed_data';

import 'frame_cryptor.dart' show Algorithm, KeyProvider;

class EncryptedPacket {
  EncryptedPacket({
    required this.data,
    required this.keyIndex,
    required this.iv,
  });

  Uint8List data;
  int keyIndex;
  Uint8List iv;
}

abstract class DataPacketCryptor {
  Future<EncryptedPacket> encrypt({
    required String participantId,
    required int keyIndex,
    required Uint8List data,
  });

  Future<Uint8List> decrypt({
    required String participantId,
    required EncryptedPacket encryptedPacket,
  });

  Future<void> dispose();
}

abstract class DataPacketCryptorFactory {
  Future<DataPacketCryptor> createDataPacketCryptor({
    required Algorithm algorithm,
    required KeyProvider keyProvider,
  });
}
