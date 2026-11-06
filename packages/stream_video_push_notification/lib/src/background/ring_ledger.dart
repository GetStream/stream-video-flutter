import 'package:stream_video/stream_video.dart';

/// The rings a background session is waiting on, and the ones the backend
/// says may have ended.
///
/// Pure bookkeeping: the only outside world it touches is the reader of the
/// native calls it is given to check a ring against.
class RingLedger {
  RingLedger({required String logTag}) : _tag = logTag;

  final String _tag;

  /// The ringing flows still waiting on the user, by call cid.
  final pendingRings = <String>{};

  /// The pending rings the backend says may have ended, by call cid, with how
  /// many times their native call has been checked since.
  ///
  /// Only a hint: a rejection by one member of a group call leaves the ring
  /// up for the others. Whether it really ended is read off the native call,
  /// and the push manager removes that asynchronously: `endCall` only sends a
  /// broadcast, which a backgrounded app may handle well after a release falls
  /// due. So a ring still shown is checked again, up to
  /// [maxEndedRingChecks] times.
  final endedRings = <String, int>{};

  /// How many times a ring with an end hint is checked before the hint is
  /// dropped and the ring left to its user.
  ///
  /// Enough to outlast a slow decline broadcast; a group-call ring that really
  /// stays up costs this many extra checks rather than a leak.
  static const maxEndedRingChecks = 5;

  /// Whether nothing is left to wait for.
  bool get isIdle => pendingRings.isEmpty;

  /// Notes that [callCid] rings and the user has to answer it. Rung again, so
  /// an end heard for an earlier ring no longer applies.
  void addRing(String callCid) {
    pendingRings.add(callCid);
    endedRings.remove(callCid);
  }

  /// Marks the flow for [callCid] resolved, and reports whether nothing is
  /// left to wait for.
  bool resolveRing(String? callCid) {
    if (callCid == null) {
      streamLog.w(
        _tag,
        () => '[resolveRing] no call cid; releasing every pending ring',
      );

      pendingRings.clear();
    } else {
      pendingRings.remove(callCid);
    }

    return pendingRings.isEmpty;
  }

  /// Notes that the ring for [callCid] may have ended, and reports whether it
  /// is one being waited on.
  bool markEnded(String? callCid) {
    if (callCid == null || !pendingRings.contains(callCid)) return false;

    // A fresh signal earns the ring a fresh round of checks.
    endedRings[callCid] = 0;
    return true;
  }

  /// Lets go of the rings that ended without the user, so they no longer hold
  /// the client, and reports whether any is still worth checking again.
  ///
  /// A ring counts as ended once the backend said so and its native call is
  /// gone, as read through [nativeCalls]. The native call alone is not enough:
  /// a ring that just arrived may not be posted yet.
  Future<bool> dropEndedRings(
    Future<List<CallData>> Function() nativeCalls,
  ) async {
    final candidates = pendingRings.intersection(endedRings.keys.toSet());
    if (candidates.isEmpty) return false;

    Set<String?>? shown;
    try {
      shown = (await nativeCalls()).map((call) => call.callCid).toSet();
    } catch (e) {
      // Not knowing is not a reason to end a call the user may still answer,
      // nor to keep the client for good: check again, like a ring still shown.
      streamLog.w(
        _tag,
        () => '[dropEndedRings] could not read the native calls: $e',
      );
    }

    var recheck = false;
    for (final cid in candidates) {
      if (shown != null && !shown.contains(cid)) {
        streamLog.d(
          _tag,
          () => '[dropEndedRings] ring ended without the user: $cid',
        );
        endedRings.remove(cid);
        pendingRings.remove(cid);
        continue;
      }

      final checks = (endedRings[cid] ?? 0) + 1;
      if (checks >= maxEndedRingChecks) {
        streamLog.d(
          _tag,
          () => '[dropEndedRings] ring still up after $checks checks: $cid',
        );
        endedRings.remove(cid);
        continue;
      }

      endedRings[cid] = checks;
      recheck = true;
    }

    return recheck;
  }
}
