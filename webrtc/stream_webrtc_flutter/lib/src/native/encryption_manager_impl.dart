import 'dart:async';

import 'package:flutter/services.dart';

import 'package:webrtc_interface/webrtc_interface.dart';

import '../e2ee/encryption_manager.dart';
import '../e2ee/encryption_types.dart';
import 'rtc_rtp_receiver_impl.dart';
import 'rtc_rtp_sender_impl.dart';
import 'utils.dart';

/// Whether this platform ships the native `EncryptionManager`.
///
/// Android, iOS and macOS bundle it. Windows and Linux run the C++ plugin,
/// which has no encoded-transform bridge, so they report `false` here even
/// though they otherwise take the native code path.
bool get encryptionManagerIsSupported =>
    WebRTC.platformIsAndroid || WebRTC.platformIsIOS || WebRTC.platformIsMacOS;

/// Builds the native-backed [EncryptionManager].
EncryptionManager createEncryptionManager({
  required String userId,
  required EncryptionAlgorithm algorithm,
}) {
  if (!encryptionManagerIsSupported) {
    throw UnsupportedError(
      'EncryptionManager is only available on Android, iOS and macOS. '
      'Check EncryptionManager.isSupported before creating one.',
    );
  }
  return EncryptionManagerNative._(userId, algorithm);
}

/// Method-channel backed [EncryptionManager] for Android, iOS and macOS.
///
/// Every operation runs on a single serialized queue so ordering matches the
/// order the calls were made in, even when the caller does not await each
/// one. That is what lets `setSharedKey` followed by `encrypt` be correct
/// without explicit awaits.
class EncryptionManagerNative implements EncryptionManager {
  EncryptionManagerNative._(this.userId, this.algorithm) {
    // `ignore()` marks a failed create as handled so it is not reported as an
    // unhandled zone error when no operation is ever queued behind it. The
    // error still reaches the `onError` handlers in [_enqueue] and [dispose].
    _queue = _create()..ignore();
  }

  @override
  final String userId;

  @override
  final EncryptionAlgorithm algorithm;

  final StreamController<E2eeEvent> _events =
      StreamController<E2eeEvent>.broadcast();

  /// Serializes every native call, including the initial create.
  late Future<void> _queue;

  /// Native handle, `null` until the create call lands.
  String? _managerId;

  StreamSubscription<dynamic>? _eventSubscription;
  bool _disposed = false;

  @override
  bool get isDisposed => _disposed;

  @override
  Stream<E2eeEvent> get events => _events.stream;

  Future<void> _create() async {
    final response = await WebRTC.invokeMethod<Map<dynamic, dynamic>, dynamic>(
      'encryptionManagerCreate',
      <String, dynamic>{'userId': userId, 'algorithm': algorithm.value},
    );

    final managerId = response?['managerId'] as String?;
    if (managerId == null) {
      throw StateError('Failed to create EncryptionManager for $userId');
    }

    // Subscribing only once the id is known keeps the channel name stable and
    // avoids a second manager ever sharing this stream.
    _eventSubscription = EventChannel(
      'FlutterWebRTC/e2ee/$managerId',
    ).receiveBroadcastStream().listen(_onNativeEvent, onError: _onNativeError);

    _managerId = managerId;
  }

  void _onNativeEvent(dynamic event) {
    if (event is! Map || _events.isClosed) return;
    _events.add(E2eeEvent.fromMap(event));
  }

  void _onNativeError(Object error, StackTrace stackTrace) {
    if (_events.isClosed) return;
    _events.addError(error, stackTrace);
  }

  /// Runs [action] after every previously queued operation has settled.
  ///
  /// A failure inside one operation is reported to that caller only; the
  /// queue stays usable for the operations behind it.
  Future<T> _enqueue<T>(Future<T> Function(String managerId) action) {
    final completer = Completer<T>();

    void fail(Object error, StackTrace stackTrace) {
      if (!completer.isCompleted) completer.completeError(error, stackTrace);
    }

    _queue = _queue.then<void>(
      (_) async {
        try {
          // Check handle, not [_disposed]: queued ops must run until teardown completes.
          final managerId = _managerId;
          if (managerId == null) {
            throw StateError(
              'EncryptionManager for $userId is disposed or was never created',
            );
          }
          completer.complete(await action(managerId));
        } catch (error, stackTrace) {
          fail(error, stackTrace);
        }
      },
      // The create call (or an earlier operation) failed. Report it here and
      // return normally so the queue does not stay poisoned.
      onError: fail,
    );

    return completer.future;
  }

  void _validateKeyIndex(int keyIndex) {
    if (keyIndex < 0 || keyIndex > 255) {
      throw ArgumentError.value(
        keyIndex,
        'keyIndex',
        'must be between 0 and 255',
      );
    }
  }

  void _validateKey(Uint8List rawKey) {
    final expected = algorithm.keyLengthBytes;
    if (rawKey.length != expected) {
      throw ArgumentError.value(
        rawKey.length,
        'rawKey.length',
        'must be exactly $expected bytes for ${algorithm.name}',
      );
    }
  }

  @override
  Future<void> setKey(String userId, int keyIndex, Uint8List rawKey) {
    if (userId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }
    _validateKeyIndex(keyIndex);
    _validateKey(rawKey);

    return _enqueue((managerId) async {
      await WebRTC.invokeMethod('encryptionManagerSetKey', <String, dynamic>{
        'managerId': managerId,
        'userId': userId,
        'keyIndex': keyIndex,
        'rawKey': rawKey,
      });
    });
  }

  @override
  Future<void> setSharedKey(int keyIndex, Uint8List rawKey) {
    _validateKeyIndex(keyIndex);
    _validateKey(rawKey);

    return _enqueue((managerId) async {
      await WebRTC.invokeMethod(
        'encryptionManagerSetSharedKey',
        <String, dynamic>{
          'managerId': managerId,
          'keyIndex': keyIndex,
          'rawKey': rawKey,
        },
      );
    });
  }

  @override
  Future<void> removeKey(String userId, int keyIndex) {
    _validateKeyIndex(keyIndex);

    return _enqueue((managerId) async {
      await WebRTC.invokeMethod('encryptionManagerRemoveKey', <String, dynamic>{
        'managerId': managerId,
        'userId': userId,
        'keyIndex': keyIndex,
      });
    });
  }

  @override
  Future<void> removeAllKeys(String userId) {
    return _enqueue((managerId) async {
      await WebRTC.invokeMethod(
        'encryptionManagerRemoveAllKeys',
        <String, dynamic>{'managerId': managerId, 'userId': userId},
      );
    });
  }

  @override
  Future<void> removeSharedKey(int keyIndex) {
    _validateKeyIndex(keyIndex);

    return _enqueue((managerId) async {
      await WebRTC.invokeMethod(
        'encryptionManagerRemoveSharedKey',
        <String, dynamic>{'managerId': managerId, 'keyIndex': keyIndex},
      );
    });
  }

  @override
  Future<void> encrypt(
    RTCRtpSender sender, {
    String? codec,
    E2eeTrackType? trackType,
  }) {
    if (sender is! RTCRtpSenderNative) {
      throw ArgumentError.value(
        sender,
        'sender',
        'expected a native RTCRtpSender',
      );
    }
    final peerConnectionId = sender.peerConnectionId;
    final senderId = sender.senderId;

    return _enqueue((managerId) async {
      await WebRTC.invokeMethod('encryptionManagerEncrypt', <String, dynamic>{
        'managerId': managerId,
        'peerConnectionId': peerConnectionId,
        'rtpSenderId': senderId,
        'codec': codec,
        // -1 tells native to pick audio vs video from the sender's media type.
        'trackType': trackType?.value ?? -1,
      });
    });
  }

  @override
  Future<void> decrypt(
    RTCRtpReceiver receiver, {
    required String userId,
    E2eeTrackType? trackType,
  }) {
    if (receiver is! RTCRtpReceiverNative) {
      throw ArgumentError.value(
        receiver,
        'receiver',
        'expected a native RTCRtpReceiver',
      );
    }
    if (userId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }
    final peerConnectionId = receiver.peerConnectionId;
    final receiverId = receiver.receiverId;

    return _enqueue((managerId) async {
      await WebRTC.invokeMethod('encryptionManagerDecrypt', <String, dynamic>{
        'managerId': managerId,
        'peerConnectionId': peerConnectionId,
        'rtpReceiverId': receiverId,
        'userId': userId,
        'trackType': trackType?.value ?? -1,
      });
    });
  }

  @override
  Future<void> enablePerformanceReporting(bool enabled) {
    return _enqueue((managerId) async {
      await WebRTC.invokeMethod(
        'encryptionManagerEnablePerformanceReporting',
        <String, dynamic>{'managerId': managerId, 'enabled': enabled},
      );
    });
  }

  @override
  Future<void> requestKeyState() {
    return _enqueue((managerId) async {
      await WebRTC.invokeMethod(
        'encryptionManagerRequestKeyState',
        <String, dynamic>{'managerId': managerId},
      );
    });
  }

  @override
  Future<void> dispose() {
    if (_disposed) return Future<void>.value();
    // Flipped before the queue drains so operations queued after this call
    // fail fast instead of racing the native teardown.
    _disposed = true;

    final completer = Completer<void>();

    void finish([Object? error, StackTrace? stackTrace]) {
      if (completer.isCompleted) return;
      if (error != null) {
        completer.completeError(error, stackTrace ?? StackTrace.current);
      } else {
        completer.complete();
      }
    }

    _queue = _queue.then<void>(
      (_) async {
        try {
          await _eventSubscription?.cancel();
          _eventSubscription = null;

          final managerId = _managerId;
          _managerId = null;
          if (managerId != null) {
            await WebRTC.invokeMethod(
              'encryptionManagerDispose',
              <String, dynamic>{'managerId': managerId},
            );
          }
          finish();
        } catch (error, stackTrace) {
          finish(error, stackTrace);
        } finally {
          await _events.close();
        }
      },
      // Nothing native to release if the manager never came up.
      onError: (Object _, StackTrace __) async {
        await _events.close();
        finish();
      },
    );

    return completer.future;
  }
}
