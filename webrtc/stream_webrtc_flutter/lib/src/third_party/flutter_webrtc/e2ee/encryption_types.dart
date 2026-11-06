/// Shared value types for the native `EncryptionManager` bridge.
///
/// These mirror `org.webrtc.EncryptionManager` (Android) and
/// `RTCEncryptionManager` (ObjC) one-for-one so the same wire format is used
/// across all the SDKs.
library;

/// AES-GCM key size. Default is AES-128.
enum EncryptionAlgorithm {
  /// 16-byte keys.
  aes128Gcm(0),

  /// 32-byte keys.
  aes256Gcm(1);

  const EncryptionAlgorithm(this.value);

  final int value;

  /// Key length, in bytes, that [EncryptionManager.setKey] expects.
  int get keyLengthBytes => this == EncryptionAlgorithm.aes256Gcm ? 32 : 16;
}

/// Enumerates the grouping used for an encrypted track's replay window.
///
/// Used in encrypt/decrypt operations:
/// - If omitted, the native implementation infers audio or video from the RTP sender/receiver.
/// - Screenshare must be specified explicitly to ensure its replay window remains separate from the camera stream.
enum E2eeTrackType {
  audio(0),
  video(1),
  screenShare(2),
  screenShareAudio(3);

  const E2eeTrackType(this.value);

  final int value;

  /// Resolves a native ordinal, or `null` when [value] is out of range.
  static E2eeTrackType? fromValue(int? value) {
    if (value == null) return null;
    for (final type in E2eeTrackType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}

/// Kinds of `e2ee.*` event emitted by the native manager.
enum E2eeEventType {
  decryptionFailed(0, 'e2ee.decryption_failed'),
  decryptionResumed(1, 'e2ee.decryption_resumed'),
  decryptionStalled(2, 'e2ee.decryption_stalled'),
  encryptionFailed(3, 'e2ee.encryption_failed'),
  missingKey(4, 'e2ee.missing_key'),
  unencryptedFrame(5, 'e2ee.unencrypted_frame'),
  unsupportedVersion(6, 'e2ee.unsupported_version'),
  keyState(7, 'e2ee.key_state'),
  perfReport(8, 'e2ee.perf_report');

  const E2eeEventType(this.value, this.eventName);

  final int value;
  final String eventName;

  /// Resolves a native ordinal, or `null` when [value] is out of range.
  static E2eeEventType? fromValue(int? value) {
    if (value == null) return null;
    for (final type in E2eeEventType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}

/// A key registered for a specific remote user.
class E2eeUserKey {
  const E2eeUserKey({
    required this.userId,
    required this.keyIndex,
    required this.fingerprint,
  });

  factory E2eeUserKey.fromMap(Map<dynamic, dynamic> map) {
    return E2eeUserKey(
      userId: map['userId'] as String? ?? '',
      keyIndex: map['keyIndex'] as int? ?? 0,
      fingerprint: map['fingerprint'] as String? ?? '',
    );
  }

  final String userId;
  final int keyIndex;
  final String fingerprint;

  @override
  String toString() =>
      'E2eeUserKey(userId: $userId, keyIndex: $keyIndex, '
      'fingerprint: $fingerprint)';
}

/// A key registered for every participant at a given index.
class E2eeSharedKey {
  const E2eeSharedKey({
    required this.keyIndex,
    required this.fingerprint,
    required this.isActive,
  });

  factory E2eeSharedKey.fromMap(Map<dynamic, dynamic> map) {
    return E2eeSharedKey(
      keyIndex: map['keyIndex'] as int? ?? 0,
      fingerprint: map['fingerprint'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? false,
    );
  }

  final int keyIndex;
  final String fingerprint;

  /// Whether this index is the one used to encrypt outgoing frames.
  final bool isActive;

  @override
  String toString() =>
      'E2eeSharedKey(keyIndex: $keyIndex, fingerprint: $fingerprint, '
      'isActive: $isActive)';
}

/// Payload of an `e2ee.key_state` event.
class E2eeKeyState {
  const E2eeKeyState({required this.perUserKeys, required this.sharedKeys});

  factory E2eeKeyState.fromMap(Map<dynamic, dynamic> map) {
    return E2eeKeyState(
      perUserKeys: (map['perUserKeys'] as List<dynamic>? ?? const [])
          .map((e) => E2eeUserKey.fromMap(e as Map<dynamic, dynamic>))
          .toList(growable: false),
      sharedKeys: (map['sharedKeys'] as List<dynamic>? ?? const [])
          .map((e) => E2eeSharedKey.fromMap(e as Map<dynamic, dynamic>))
          .toList(growable: false),
    );
  }

  final List<E2eeUserKey> perUserKeys;
  final List<E2eeSharedKey> sharedKeys;

  @override
  String toString() =>
      'E2eeKeyState(perUserKeys: $perUserKeys, sharedKeys: $sharedKeys)';
}

/// One row of an `e2ee.perf_report` event.
class E2eeTrackPerf {
  const E2eeTrackPerf({
    required this.userId,
    required this.trackType,
    required this.codec,
    required this.fps,
    required this.maxCryptoMs,
  });

  factory E2eeTrackPerf.fromMap(Map<dynamic, dynamic> map) {
    return E2eeTrackPerf(
      userId: map['userId'] as String? ?? '',
      trackType: E2eeTrackType.fromValue(map['trackType'] as int?),
      codec: map['codec'] as String?,
      fps: (map['fps'] as num?)?.toDouble() ?? 0,
      maxCryptoMs: (map['maxCryptoMs'] as num?)?.toDouble() ?? 0,
    );
  }

  final String userId;
  final E2eeTrackType? trackType;

  /// Set on encode samples only.
  final String? codec;
  final double fps;
  final double maxCryptoMs;

  @override
  String toString() =>
      'E2eeTrackPerf(userId: $userId, trackType: $trackType, codec: $codec, '
      'fps: $fps, maxCryptoMs: $maxCryptoMs)';
}

/// A single `e2ee.*` event emitted by the native manager.
///
/// Optional fields are `null` when the native event omits them.
class E2eeEvent {
  const E2eeEvent({
    required this.type,
    required this.name,
    required this.userId,
    this.trackType,
    this.keyIndex,
    this.version,
    this.reason,
    this.keyState,
    this.encode,
    this.decode,
  });

  factory E2eeEvent.fromMap(Map<dynamic, dynamic> map) {
    final type = E2eeEventType.fromValue(map['type'] as int?);
    final keyState = map['keyState'] as Map<dynamic, dynamic>?;
    final encode = map['encode'] as List<dynamic>?;
    final decode = map['decode'] as List<dynamic>?;

    return E2eeEvent(
      type: type,
      name: map['name'] as String? ?? type?.eventName ?? 'e2ee.unknown',
      userId: map['userId'] as String? ?? '',
      trackType: E2eeTrackType.fromValue(map['trackType'] as int?),
      keyIndex: map['keyIndex'] as int?,
      version: map['version'] as int?,
      reason: map['reason'] as String?,
      keyState: keyState == null ? null : E2eeKeyState.fromMap(keyState),
      encode: encode
          ?.map((e) => E2eeTrackPerf.fromMap(e as Map<dynamic, dynamic>))
          .toList(growable: false),
      decode: decode
          ?.map((e) => E2eeTrackPerf.fromMap(e as Map<dynamic, dynamic>))
          .toList(growable: false),
    );
  }

  /// `null` when native reports a type this version does not know about.
  final E2eeEventType? type;

  /// Wire name, e.g. `e2ee.missing_key`.
  final String name;

  /// The key owner the event is about. Empty for manager-wide events.
  final String userId;
  final E2eeTrackType? trackType;
  final int? keyIndex;
  final int? version;
  final String? reason;

  /// Set on `e2ee.key_state` only.
  final E2eeKeyState? keyState;

  /// Set on `e2ee.perf_report` only.
  final List<E2eeTrackPerf>? encode;

  /// Set on `e2ee.perf_report` only.
  final List<E2eeTrackPerf>? decode;

  @override
  String toString() {
    final buffer = StringBuffer('E2eeEvent($name');
    if (userId.isNotEmpty) buffer.write(', userId: $userId');
    if (trackType != null) buffer.write(', trackType: $trackType');
    if (keyIndex != null) buffer.write(', keyIndex: $keyIndex');
    if (version != null) buffer.write(', version: $version');
    if (reason != null) buffer.write(', reason: $reason');
    if (keyState != null) buffer.write(', keyState: $keyState');
    if (encode != null) buffer.write(', encode: $encode');
    if (decode != null) buffer.write(', decode: $decode');
    return (buffer..write(')')).toString();
  }
}
