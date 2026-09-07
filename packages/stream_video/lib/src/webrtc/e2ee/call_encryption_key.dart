import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../models/call_cid.dart';

/// A key the SDK sets end-to-end encryption up with on the app's behalf.
///
/// Returned from a [CallEncryptionKeyResolver] when a call needs a key and the
/// app has not attached an `EncryptionManager` to it by hand.
///
/// Per-user keys are deliberately absent. `setKey(userId, ...)` needs a key for
/// each remote participant, and participants keep arriving after the join, so a
/// resolver called once beforehand cannot cover them. Set those through
/// `call.e2eeManager` as the participant list changes.
sealed class CallEncryptionKey extends Equatable {
  const CallEncryptionKey._({required this.keyIndex, required this.algorithm});

  /// One key that every participant on the call holds.
  ///
  /// This is the passphrase-style setup: everyone derives the same bytes and
  /// imports them at the same index.
  ///
  /// [keyIndex] has to match what every other participant uses. Frames carry
  /// the index they were encrypted with, and a receiver looking at another slot
  /// fails every decrypt.
  factory CallEncryptionKey.shared({
    required Uint8List bytes,
    int keyIndex,
    rtc.EncryptionAlgorithm algorithm,
  }) = SharedCallEncryptionKey;

  /// The key slot this key occupies, written into every frame.
  final int keyIndex;

  /// The AES-GCM variant, which fixes the required key length.
  final rtc.EncryptionAlgorithm algorithm;
}

/// One key shared by every participant on the call.
final class SharedCallEncryptionKey extends CallEncryptionKey {
  SharedCallEncryptionKey({
    required this.bytes,
    int keyIndex = 0,
    rtc.EncryptionAlgorithm algorithm = rtc.EncryptionAlgorithm.aes128Gcm,
  }) : super._(keyIndex: keyIndex, algorithm: algorithm) {
    if (bytes.length != algorithm.keyLengthBytes) {
      throw ArgumentError.value(
        bytes.length,
        'bytes',
        'must be ${algorithm.keyLengthBytes} bytes for ${algorithm.name}',
      );
    }
    if (keyIndex < 0 || keyIndex > 255) {
      throw ArgumentError.value(keyIndex, 'keyIndex', 'must be 0..255');
    }
  }

  /// The raw key. Never logged and never sent anywhere by the SDK.
  final Uint8List bytes;

  /// Deliberately excludes [bytes], so a key cannot reach a log through
  /// `toString` or an equality mismatch report.
  @override
  List<Object?> get props => [keyIndex, algorithm];

  @override
  String toString() =>
      'SharedCallEncryptionKey(keyIndex: $keyIndex, '
      'algorithm: ${algorithm.name})';
}

/// The call a key is being asked for.
///
/// A request object rather than a bare cid so more context can be added later
/// without breaking every resolver.
class CallEncryptionKeyRequest extends Equatable {
  const CallEncryptionKeyRequest({required this.callCid});

  /// The call a key is being asked for.
  final StreamCallCid callCid;

  @override
  List<Object?> get props => [callCid];

  @override
  String toString() => 'CallEncryptionKeyRequest(callCid: $callCid)';
}

/// Provides the shared key for a call the app has not set up by hand.
///
/// The SDK calls this once per call, before the first join attempt, and only
/// when no `EncryptionManager` is attached. An attached manager always wins:
/// the app has already said which keys the call uses.
///
/// Answer only for the calls you mean to encrypt, from whatever your app knows
/// about them. The request carries the call's id and nothing else on purpose:
/// the SDK does not tell you the call's encryption mode, because it does not
/// reliably know it before the join and the other Stream SDKs do not offer one
/// either. Returning a key for a call whose peers are not encrypting gets the
/// join rejected by the server.
///
/// Return `null` for a call that needs no key from you. That is fine for a call
/// whose encryption is `available`, which then joins unencrypted, and an error
/// for one that is `auto-on`, which cannot be joined without a key at all.
///
/// Keep it quick. It runs inside the join, and on platforms where answering a
/// call holds a system watchdog open — CallKit's answer action, on SDKs that
/// defer fulfilment until the join completes — a slow key fetch can get the
/// join timed out.
typedef CallEncryptionKeyResolver =
    Future<CallEncryptionKey?> Function(CallEncryptionKeyRequest request);
