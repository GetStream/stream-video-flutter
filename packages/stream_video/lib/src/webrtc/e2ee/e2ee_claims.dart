import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../../models/call_cid.dart';

/// Tracks which [EncryptionManager] is attached to which call via `callCid`.
/// Each manager must be mapped to just one call, and vice versa; both mappings
/// are weak to allow cleanup.
class E2eeClaims {
  /// The registry every call claims through.
  static final instance = E2eeClaims();

  final Map<String, _E2eeClaim> _claims = <String, _E2eeClaim>{};

  /// Records that [owner] holds [manager] for [callCid].
  ///
  /// Throws a [StateError] when another owner already holds a manager for
  /// [callCid], or when [manager] is already held for another call.
  void claim(
    StreamCallCid callCid,
    Object owner,
    EncryptionManager manager,
  ) {
    final claimant = _claims[callCid.value]?.owner.target;
    if (claimant != null && !identical(claimant, owner)) {
      throw StateError(
        'Another Call instance for $callCid already has an EncryptionManager. '
        'A manager belongs to one call, because its key store has to have one '
        'owner. Reuse that Call, or release its manager with '
        'clearE2EEManager() (or leave()) and give this one its own.',
      );
    }

    _claims.removeWhere((_, claim) => claim.owner.target == null);
    for (final entry in _claims.entries) {
      if (entry.key == callCid.value) continue;
      if (identical(entry.value.manager.target, manager)) {
        throw StateError(
          'This EncryptionManager is already attached to call ${entry.key}. '
          'Keys live on the manager, so sharing one between calls makes them '
          'overwrite each other. Create a separate manager for $callCid.',
        );
      }
    }

    _claims[callCid.value] = _E2eeClaim(owner, manager);
  }

  /// Drops the claim on [callCid] if [owner] holds it.
  void release(StreamCallCid callCid, Object owner) {
    if (identical(_claims[callCid.value]?.owner.target, owner)) {
      _claims.remove(callCid.value);
    }
  }

  /// Drops every recorded claim.
  void reset() => _claims.clear();
}

/// One call cid's claim on an [EncryptionManager], held weakly.
///
/// Both sides weak, so a claim never keeps either alive. [owner] going null is
/// what makes a claim stale.
class _E2eeClaim {
  _E2eeClaim(Object owner, EncryptionManager manager)
    : owner = WeakReference(owner),
      manager = WeakReference(manager);

  final WeakReference<Object> owner;
  final WeakReference<EncryptionManager> manager;
}
