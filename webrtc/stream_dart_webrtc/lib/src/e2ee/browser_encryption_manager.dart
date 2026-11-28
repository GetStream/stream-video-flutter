import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

import '../third_party/dart_webrtc/rtc_rtp_receiver_impl.dart';
import '../third_party/dart_webrtc/rtc_rtp_sender_impl.dart';
import 'e2ee_worker_messages.dart';
import 'e2ee_worker_source.g.dart';
import 'encoded_transform_api.dart';

export 'encoded_transform_api.dart';

/// The encoded-transform API of the browser the app runs in.
@internal
final EncodedTransformApi? browserEncodedTransformApi = () {
  try {
    final sender = web.window.getProperty<JSObject?>('RTCRtpSender'.toJS);
    final prototype = sender?.getProperty<JSObject?>('prototype'.toJS);
    return encodedTransformApiFor(
      userAgent: web.window.navigator.userAgent,
      hasScriptTransform: web.window
          .hasProperty('RTCRtpScriptTransform'.toJS)
          .toDart,
      hasInsertableStreams:
          prototype?.hasProperty('createEncodedStreams'.toJS).toDart ?? false,
    );
  } catch (_) {
    return null;
  }
}();

/// [EncryptionManager] for the browser.
///
/// Frames are encrypted in a web worker running the E2EE worker of the
/// JavaScript SDK, so they match every other SDK byte for byte. The worker
/// starts from a blob URL: a Content-Security-Policy has to allow
/// `worker-src blob:`.
@internal
class BrowserEncryptionManager implements EncryptionManager {
  BrowserEncryptionManager({
    required this.userId,
    required this.algorithm,
    required this._transformApi,
  }) {
    final blob = web.Blob(
      [e2eeWorkerSource.toJS].toJS,
      web.BlobPropertyBag(type: 'application/javascript'),
    );
    _workerUrl = web.URL.createObjectURL(blob);
    try {
      _worker = web.Worker(
        _workerUrl.toJS,
        web.WorkerOptions(name: 'stream-video-e2ee'),
      );
    } catch (_) {
      web.URL.revokeObjectURL(_workerUrl);
      rethrow;
    }
    _worker.onmessage = _onMessage.toJS;
    _worker.onerror = _onError.toJS;
  }

  @override
  final String userId;

  @override
  final EncryptionAlgorithm algorithm;

  final EncodedTransformApi _transformApi;
  late final String _workerUrl;
  late final web.Worker _worker;

  final _events = StreamController<E2eeEvent>.broadcast();
  bool _disposed = false;

  @override
  bool get isDisposed => _disposed;

  @override
  Stream<E2eeEvent> get events => _events.stream;

  @override
  Future<void> setKey(String userId, int keyIndex, Uint8List rawKey) async {
    if (userId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }
    _validateKeyIndex(keyIndex);
    _validateKey(rawKey);
    _post('cmd.set_key', {
      'userId': userId.toJS,
      'keyIndex': keyIndex.toJS,
      'rawKey': _toArrayBuffer(rawKey),
    });
  }

  @override
  Future<void> setSharedKey(int keyIndex, Uint8List rawKey) async {
    _validateKeyIndex(keyIndex);
    _validateKey(rawKey);
    _post('cmd.set_shared_key', {
      'keyIndex': keyIndex.toJS,
      'rawKey': _toArrayBuffer(rawKey),
    });
  }

  @override
  Future<void> removeKey(String userId, int keyIndex) async {
    _validateKeyIndex(keyIndex);
    _post('cmd.remove_key', {
      'userId': userId.toJS,
      'keyIndex': keyIndex.toJS,
    });
  }

  @override
  Future<void> removeAllKeys(String userId) async {
    _post('cmd.remove_all_keys', {'userId': userId.toJS});
  }

  @override
  Future<void> removeSharedKey(int keyIndex) async {
    _validateKeyIndex(keyIndex);
    _post('cmd.remove_shared_key', {'keyIndex': keyIndex.toJS});
  }

  @override
  Future<void> encrypt(
    RTCRtpSender sender, {
    String? codec,
    E2eeTrackType? trackType,
  }) async {
    if (sender is! RTCRtpSenderWeb) {
      throw ArgumentError.value(sender, 'sender', 'expected a browser sender');
    }
    final jsSender = sender.jsRtpSender;
    _pipe(jsSender, {
      'operation': 'encode'.toJS,
      'userId': userId.toJS,
      if (codec != null) 'codec': codec.toJS,
      'trackType': e2eeWorkerTrackType(trackType, jsSender.track?.kind).toJS,
    });
  }

  @override
  Future<void> decrypt(
    RTCRtpReceiver receiver, {
    required String userId,
    E2eeTrackType? trackType,
  }) async {
    if (receiver is! RTCRtpReceiverWeb) {
      throw ArgumentError.value(
        receiver,
        'receiver',
        'expected a browser receiver',
      );
    }
    if (userId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }
    final jsReceiver = receiver.jsRtpReceiver;
    _pipe(jsReceiver, {
      'operation': 'decode'.toJS,
      'userId': userId.toJS,
      'trackType': e2eeWorkerTrackType(trackType, jsReceiver.track.kind).toJS,
    });
  }

  @override
  Future<void> enablePerformanceReporting(bool enabled) async {
    _post('cmd.enable_performance_reporting', {'enabled': enabled.toJS});
  }

  @override
  Future<void> requestKeyState() async {
    _post('cmd.request_key_state', const {});
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _worker
      ..onmessage = null
      ..onerror = null
      ..terminate();
    web.URL.revokeObjectURL(_workerUrl);
    await _events.close();
  }

  /// Runs [target]'s frames through the worker with [options].
  void _pipe(JSObject target, Map<String, JSAny> options) {
    _assertUsable();
    switch (_transformApi) {
      case EncodedTransformApi.script:
        target.setProperty(
          'transform'.toJS,
          web.RTCRtpScriptTransform(_worker, _object(options)),
        );
      case EncodedTransformApi.insertableStreams:
        // A sender or receiver gives out its insertable streams once only.
        if (target.hasProperty(_pipedProperty).toDart) return;
        final streams = target.callMethod<JSObject>(
          'createEncodedStreams'.toJS,
        );
        target.setProperty(_pipedProperty, true.toJS);
        final readable = streams.getProperty<JSObject>('readable'.toJS);
        final writable = streams.getProperty<JSObject>('writable'.toJS);
        _worker.postMessage(
          _object({
            'type': 'cmd.setup_transform'.toJS,
            ...options,
            'readable': readable,
            'writable': writable,
          }),
          [readable, writable].toJS,
        );
    }
  }

  void _post(String type, Map<String, JSAny> payload) {
    _assertUsable();
    _worker.postMessage(_object({'type': type.toJS, ...payload}));
  }

  void _onMessage(web.MessageEvent event) {
    final data = event.data.dartify();
    if (data is! Map || _events.isClosed) return;
    final e2eeEvent = e2eeEventFromWorkerMessage(data);
    if (e2eeEvent != null) _events.add(e2eeEvent);
  }

  void _onError(web.ErrorEvent event) {
    if (_events.isClosed) return;
    _events.addError(StateError('E2EE worker error: ${event.message}'));
  }

  void _assertUsable() {
    if (_disposed) {
      throw StateError('EncryptionManager for $userId is disposed');
    }
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
}

/// Marks a sender or receiver whose insertable streams went to the worker.
final _pipedProperty = '__streamE2eePiped'.toJS;

/// A copy of [bytes] as an `ArrayBuffer`.
JSArrayBuffer _toArrayBuffer(Uint8List bytes) =>
    Uint8List.fromList(bytes).buffer.toJS;

JSObject _object(Map<String, JSAny> properties) {
  final object = JSObject();
  for (final MapEntry(:key, :value) in properties.entries) {
    object.setProperty(key.toJS, value);
  }
  return object;
}
