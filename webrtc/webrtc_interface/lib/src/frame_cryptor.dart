import 'dart:typed_data';

import 'rtc_rtp_receiver.dart';
import 'rtc_rtp_sender.dart';

/// Built-in Algorithm.
enum Algorithm {
  kAesGcm,
  kAesCbc,
}

enum KeyDerivationAlgorithm {
  kPBKDF2,
  kHKDF,
}

class KeyProviderOptions {
  KeyProviderOptions({
    required this.sharedKey,
    required this.ratchetSalt,
    required this.ratchetWindowSize,
    this.uncryptedMagicBytes,
    this.failureTolerance = -1,
    this.keyRingSize = 16,
    this.discardFrameWhenCryptorNotReady = false,
    this.keyDerivationAlgorithm = KeyDerivationAlgorithm.kPBKDF2,
  });
  bool sharedKey;
  Uint8List ratchetSalt;
  Uint8List? uncryptedMagicBytes;
  int ratchetWindowSize;
  int failureTolerance;

  /// key ring size should be between 1 and 255
  /// default is 16
  int keyRingSize;
  bool discardFrameWhenCryptorNotReady;
  KeyDerivationAlgorithm keyDerivationAlgorithm;

  Map<String, dynamic> toJson() {
    return {
      'sharedKey': sharedKey,
      'ratchetSalt': ratchetSalt,
      if (uncryptedMagicBytes != null)
        'uncryptedMagicBytes': uncryptedMagicBytes,
      'ratchetWindowSize': ratchetWindowSize,
      'failureTolerance': failureTolerance,
      'keyRingSize': keyRingSize,
      'discardFrameWhenCryptorNotReady': discardFrameWhenCryptorNotReady,
      'keyDerivationAlgorithm': keyDerivationAlgorithm.index,
    };
  }
}

/// Shared secret key for frame encryption.
abstract class KeyProvider {
  /// The unique identifier of the key provider.
  String get id;

  Future<void> setSharedKey({required Uint8List key, int index = 0}) =>
      throw UnimplementedError();

  Future<Uint8List> ratchetSharedKey({int index = 0}) =>
      throw UnimplementedError();

  Future<Uint8List> exportSharedKey({int index = 0}) =>
      throw UnimplementedError();

  /// Set the raw key at the given index.
  Future<bool> setKey({
    required String participantId,
    required int index,
    required Uint8List key,
  });

  /// ratchet the key at the given index.
  Future<Uint8List> ratchetKey({
    required String participantId,
    required int index,
  });

  /// Export the key at the given index.
  Future<Uint8List> exportKey({
    required String participantId,
    required int index,
  });

  Future<void> setSifTrailer({required Uint8List trailer}) =>
      throw UnimplementedError();

  /// Dispose the key manager.
  Future<void> dispose();
}

enum FrameCryptorState {
  FrameCryptorStateNew,
  FrameCryptorStateOk,
  FrameCryptorStateEncryptionFailed,
  FrameCryptorStateDecryptionFailed,
  FrameCryptorStateMissingKey,
  FrameCryptorStateKeyRatcheted,
  FrameCryptorStateInternalError,
}

/// Frame encryption/decryption.
///
abstract class FrameCryptor {
  FrameCryptor();

  Function(String participantId, FrameCryptorState state)?
      onFrameCryptorStateChanged;

  /// The unique identifier of the frame cryptor.
  String get participantId;

  /// Enable/Disable frame crypto for the sender or receiver.
  Future<bool> setEnabled(bool enabled);

  /// Get the enabled state for the sender or receiver.
  Future<bool> get enabled;

  /// Set the key index for the sender or receiver.
  /// If the key index is not set, the key index will be set to 0.
  Future<bool> setKeyIndex(int index);

  /// Get the key index for the sender or receiver.
  Future<int> get keyIndex;

  Future<void> updateCodec(String codec);

  /// Dispose the frame cryptor.
  Future<void> dispose();
}

/// Factory for creating frame Cryptors.
/// For End 2 End Encryption, you need to create a [KeyProvider] for each peer.
/// And set your key in keyProvider.
abstract class FrameCryptorFactory {
  /// Shared key manager.
  Future<KeyProvider> createDefaultKeyProvider(KeyProviderOptions options);

  /// Create a frame Cryptor from a [RTCRtpSender].
  Future<FrameCryptor> createFrameCryptorForRtpSender({
    required String participantId,
    required RTCRtpSender sender,
    required Algorithm algorithm,
    required KeyProvider keyProvider,
  });

  /// Create a frame Cryptor from a [RTCRtpReceiver].
  Future<FrameCryptor> createFrameCryptorForRtpReceiver({
    required String participantId,
    required RTCRtpReceiver receiver,
    required Algorithm algorithm,
    required KeyProvider keyProvider,
  });
}
