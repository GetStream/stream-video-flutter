import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';
import 'package:synchronized/synchronized.dart';

import 'ring_ledger.dart';

/// One isolate's client, its observers, and how to let go of them.
@internal
class BackgroundSession {
  BackgroundSession({
    required this.streamVideo,
    required this.observers,
    required this.onDispose,
    required this._lock,
    required this._resolutionGrace,
    required this._onDetach,
    required this._releaseSingleton,
    required String logTag,
  }) : _tag = logTag,
       ledger = RingLedger(logTag: logTag);

  /// The client built for this isolate.
  final StreamVideo streamVideo;

  /// The core ringing observers the client was started with.
  final CompositeSubscription observers;

  /// The app's own teardown, run once the client is gone.
  final FutureOr<void> Function()? onDispose;

  /// The rings this session waits on.
  final RingLedger ledger;

  /// Serialises the release with everything else that touches the session.
  final Lock _lock;
  final Duration Function() _resolutionGrace;

  /// Lets the owner forget this session before it is torn down.
  final void Function(BackgroundSession session) _onDetach;
  final Future<void> Function(StreamVideo client) _releaseSingleton;
  final String _tag;

  /// The ringing events that resolve a ring: the user's answer.
  StreamSubscription<RingingEvent>? resolution;

  /// The coordinator events that can end a ring without the user.
  StreamSubscription<StreamVideoEvent>? ringEnds;

  bool _released = false;

  /// The release this session has scheduled, if it has one.
  Timer? _pendingRelease;

  /// Releases after [delay], so a flow that is still running finishes first.
  void releaseAfter(Duration delay) {
    _pendingRelease?.cancel();
    _pendingRelease = Timer(delay, () => unawaited(_release()));
  }

  /// The scheduled release, once it falls due.
  ///
  /// It releases also after an accept: the client sets up no media, so the
  /// app cannot join a call on it, and takes an accepted call over on its own
  /// client instead.
  ///
  /// Nothing awaits this, and `onDispose` is the app's own code: an error
  /// escaping here would land in a background isolate that has no zone
  /// handler to catch it.
  Future<void> _release() async {
    try {
      await _lock.synchronized(() async {
        final recheck = await ledger.dropEndedRings(
          () async =>
              await streamVideo.pushNotificationManager?.activeCalls() ??
              const [],
        );

        // A ringing flow is live. Whatever resolves it arms the next release,
        // and a ring that may have ended is looked at again shortly.
        if (!ledger.isIdle) {
          streamLog.d(
            _tag,
            () =>
                '[release] still ringing (${ledger.pendingRings.length}); '
                '${recheck ? 'checking again' : 'standing down'}',
          );

          if (recheck) {
            releaseAfter(_resolutionGrace());
          }
          return;
        }

        await release();
      });
    } catch (e, stk) {
      streamLog.e(_tag, () => '[releaseAfter] release failed: $e; $stk');
    }
  }

  /// Tears the session down, once.
  ///
  /// Only ever called holding the owner's lock. Still idempotent, because a
  /// release that falls due and one forced by a test can both decide the
  /// isolate is done.
  Future<void> release() async {
    if (_released) return;
    _released = true;

    _pendingRelease?.cancel();
    _pendingRelease = null;

    _onDetach(this);

    try {
      await resolution?.cancel();
      await ringEnds?.cancel();
      await observers.cancel();
      await streamVideo.dispose();
    } catch (e, stk) {
      streamLog.e(_tag, () => '[release] teardown failed: $e; $stk');
    } finally {
      try {
        await _releaseSingleton(streamVideo);
      } catch (e, stk) {
        streamLog.e(
          _tag,
          () => '[release] clearing the singleton failed: $e; $stk',
        );
      }

      await onDispose?.call();
    }
  }
}
