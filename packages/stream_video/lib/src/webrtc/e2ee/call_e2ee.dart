import 'dart:async';

import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../../call/session/call_session.dart';
import '../../call_state.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import 'call_encryption_key.dart';
import 'e2ee_claims.dart';

/// The end-to-end encryption manager of one call: attaching it, building it
/// from the app's key resolver, and releasing it.
class CallE2ee {
  CallE2ee({
    required this._callCid,
    required this._state,
    required this._session,
    required this._logger,
  });

  final StreamCallCid _callCid;
  final CallState Function() _state;
  final CallSession? Function() _session;
  final TaggedLogger _logger;

  /// End-to-end encryption for this call, set via [attach].
  EncryptionManager? _manager;

  /// Logs `e2ee.*` diagnostics for [_manager].
  StreamSubscription<E2eeEvent>? _eventsSubscription;

  /// The attached manager, or `null` when the call is unencrypted.
  EncryptionManager? get manager => _manager;

  /// Attaches [manager] to the call. Throws a [StateError] once the join has
  /// begun, or when the manager is disposed or claimed elsewhere.
  Future<void> attach(EncryptionManager manager) async {
    final status = _state().status;
    final joinUnderWay =
        status is CallStatusConnecting || // and Reconnecting, Migrating
        status is CallStatusJoining ||
        status is CallStatusConnected ||
        status is CallStatusJoined;

    if (joinUnderWay || _session()?.rtcManager != null) {
      throw StateError(
        'setE2EEManager must be called before join(): this call is already '
        'connecting, so its session and its join request were built without '
        'the manager and its tracks would publish unencrypted.',
      );
    }

    if (manager.isDisposed) {
      throw StateError(
        'setE2EEManager was given a disposed EncryptionManager; it can no '
        'longer hold keys or attach transforms. Create a new one.',
      );
    }

    final current = _manager;
    if (current != null && !identical(current, manager)) {
      throw StateError(
        'This call already has a different EncryptionManager. Overwriting it '
        'would drop the current one while it still holds a native key store, '
        'so release it first with clearE2EEManager().',
      );
    }

    E2eeClaims.instance.claim(_callCid, this, manager);

    _logger.i(() => '[setE2EEManager] userId: ${manager.userId}');
    _manager = manager;

    await _eventsSubscription?.cancel();
    _eventsSubscription = manager.events.listen(
      _onEvent,
      onError: (Object e) => _logger.w(() => '[e2ee] event stream error: $e'),
    );
  }

  /// Builds and attaches an [EncryptionManager] from the app's key resolver,
  /// for a call that does not have one yet.
  Future<Result<None>> resolve() async {
    // An explicitly attached manager wins.
    if (_manager != null) return const Result.success(none);

    final resolve = _state().preferences.encryptionKeyResolver;

    if (resolve == null) return const Result.success(none);

    final CallEncryptionKey? key;
    try {
      key = await resolve(CallEncryptionKeyRequest(callCid: _callCid));
    } catch (e, stk) {
      _logger.e(() => '[resolveE2EE] resolver threw: $e; $stk');
      return failureWithError('The encryption key resolver failed: $e');
    }

    if (key == null) {
      _logger.d(() => '[resolveE2EE] no key, joining unencrypted');
      return const Result.success(none);
    }

    if (!EncryptionManager.isSupported) {
      return failureWithError(
        'A key was provided for $_callCid, but end-to-end encryption is not '
        'available on this platform.',
      );
    }

    final userId = _state().currentUserId;

    try {
      final manager = EncryptionManager.create(
        userId: userId,
        algorithm: key.algorithm,
      );

      try {
        switch (key) {
          case SharedCallEncryptionKey(:final keyIndex, :final bytes):
            await manager.setSharedKey(keyIndex, bytes);
        }

        // A concurrent join, or a setE2EEManager the app made while the
        // resolver was still running, may have attached one already. That one
        // holds the keys the session will use, so this is the surplus manager
        // and it is the one that has to give its handle back.
        if (_manager != null) {
          _logger.d(() => '[resolveE2EE] a manager was attached meanwhile');
          await manager.dispose().catchError((Object e) {
            _logger.w(() => '[resolveE2EE] surplus dispose failed: $e');
          });
          return const Result.success(none);
        }

        await attach(manager);
      } catch (_) {
        await manager.dispose().catchError((Object e) {
          _logger.w(() => '[resolveE2EE] rollback dispose failed: $e');
        });
        rethrow;
      }

      _logger.i(
        () =>
            '[resolveE2EE] attached, keyIndex: ${key!.keyIndex}, '
            'algorithm: ${key.algorithm.name}',
      );
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[resolveE2EE] failed: $e; $stk');
      return failureWithError('Could not set up end-to-end encryption: $e');
    }
  }

  /// Detaches the manager, releases its claim and disposes it. Does nothing
  /// when no manager is attached.
  Future<void> clear() async {
    final manager = _manager;
    if (manager == null) return;

    // `isDisposed` matters: leave() tears the session down and then calls this,
    // and a disposed CallSession still holds its RtcManager, so without it
    // every encrypted call would warn on the way out.
    final session = _session();
    if (session != null && !session.isDisposed && session.rtcManager != null) {
      _logger.w(
        () =>
            '[clearE2EEManager] disposing while peer connections are still '
            'up; this call will stop decrypting. Leave first.',
      );
    }

    _logger.i(() => '[clearE2EEManager] releasing');

    _manager = null;

    E2eeClaims.instance.release(_callCid, this);

    await _eventsSubscription?.cancel();
    _eventsSubscription = null;

    await manager.dispose().catchError((Object e) {
      _logger.w(() => '[clearE2EEManager] dispose failed: $e');
    });
  }

  void _onEvent(E2eeEvent event) {
    switch (event.type) {
      case E2eeEventType.missingKey:
      case E2eeEventType.decryptionFailed:
      case E2eeEventType.encryptionFailed:
      case E2eeEventType.unsupportedVersion:
      case E2eeEventType.decryptionStalled:
        _logger.e(() => '[e2ee] $event');
      case E2eeEventType.unencryptedFrame:
        _logger.w(() => '[e2ee] $event');
      case E2eeEventType.decryptionResumed:
      case E2eeEventType.keyState:
      case E2eeEventType.perfReport:
      case null:
        _logger.d(() => '[e2ee] $event');
    }
  }
}
