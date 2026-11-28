import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

const _trackTypeNames = {
  E2eeTrackType.audio: 'AUDIO',
  E2eeTrackType.video: 'VIDEO',
  E2eeTrackType.screenShare: 'SCREEN_SHARE',
  E2eeTrackType.screenShareAudio: 'SCREEN_SHARE_AUDIO',
};

/// The worker's name for [trackType], which keeps a track's replay window
/// apart from the user's other tracks. Without one, the track's [kind]
/// decides between audio and video.
@internal
String e2eeWorkerTrackType(E2eeTrackType? trackType, String? kind) =>
    _trackTypeNames[trackType ?? _trackTypeForKind(kind)]!;

E2eeTrackType _trackTypeForKind(String? kind) =>
    kind == 'audio' ? E2eeTrackType.audio : E2eeTrackType.video;

E2eeTrackType? _trackTypeFromName(Object? name) {
  for (final MapEntry(:key, :value) in _trackTypeNames.entries) {
    if (value == name) return key;
  }
  return null;
}

/// The [E2eeEvent] a message from the worker reports, or `null` for a
/// message that is not an event.
@internal
E2eeEvent? e2eeEventFromWorkerMessage(Map<dynamic, dynamic> data) {
  final name = data['type'];
  if (name is! String || !name.startsWith('e2ee.') || name == 'e2ee.error') {
    return null;
  }
  E2eeEventType? type;
  for (final value in E2eeEventType.values) {
    if (value.eventName == name) type = value;
  }

  final keyState = name == 'e2ee.key_state' ? _keyState(data) : null;

  return E2eeEvent(
    type: type,
    name: name,
    userId: data['userId'] as String? ?? '',
    trackType: _trackTypeFromName(data['trackType']),
    keyIndex: (data['keyIndex'] as num?)?.toInt(),
    version: (data['version'] as num?)?.toInt(),
    reason: data['reason'] as String?,
    keyState: keyState,
    encode: _trackPerfs(data['encode']),
    decode: _trackPerfs(data['decode']),
  );
}

// Numbers arrive as doubles from the worker under dart2wasm, so every int is
// read through num.
int _int(Object? value) => (value as num?)?.toInt() ?? 0;

E2eeKeyState _keyState(Map<dynamic, dynamic> data) {
  List<Map<dynamic, dynamic>> rows(Object? value) =>
      value is List ? value.whereType<Map<dynamic, dynamic>>().toList() : [];

  return E2eeKeyState(
    perUserKeys: [
      for (final row in rows(data['perUserKeys']))
        E2eeUserKey(
          userId: row['userId'] as String? ?? '',
          keyIndex: _int(row['keyIndex']),
          fingerprint: row['fingerprint'] as String? ?? '',
        ),
    ],
    sharedKeys: [
      for (final row in rows(data['sharedKeys']))
        E2eeSharedKey(
          keyIndex: _int(row['keyIndex']),
          fingerprint: row['fingerprint'] as String? ?? '',
          isActive: row['isActive'] as bool? ?? false,
        ),
    ],
  );
}

List<E2eeTrackPerf>? _trackPerfs(Object? rows) {
  if (rows is! List) return null;
  return [
    for (final row in rows.whereType<Map<dynamic, dynamic>>())
      E2eeTrackPerf(
        userId: row['userId'] as String? ?? '',
        trackType: _trackTypeFromName(row['trackType']),
        codec: row['codec'] as String?,
        fps: (row['fps'] as num?)?.toDouble() ?? 0,
        maxCryptoMs: (row['maxCryptoMs'] as num?)?.toDouble() ?? 0,
      ),
  ];
}
