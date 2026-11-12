import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_video/stream_video.dart';
import 'package:uuid/uuid.dart';

/// Reports each ringing call the current user starts to CallKit as an outgoing call, and keeps
/// the CallKit call in step with the Stream call until either ends.
///
/// - The CallKit call starts once the call rings, that is once its status is
///   [CallStatusOutgoing]. A call that never rings is never reported.
/// - It is marked connected the first time the call reaches [CallStatusConnected], which a caller
///   only does after a callee accepted.
/// - It ends when the call disconnects, when its state stream closes, or when the call stops
///   being the outgoing one without having been joined.
/// - Ending it from the CallKit UI while the call is not joined leaves the call, which cancels
///   the ring. A joined call is left by the ringing flow coordinator, as any call CallKit ends,
///   so the app has to observe the core ringing events, as the ringing setup already requires.
///   Leaving it here too would race that leave and cancel the ring twice.
@internal
class OutgoingCallReporter {
  OutgoingCallReporter({
    required PushNotificationManager manager,
    required Stream<Call?> outgoingCalls,
    required this._isActive,
    String Function()? newUuid,
  }) : _manager = manager,
       _newUuid = newUuid ?? const Uuid().v4 {
    _subscriptions
      ..add(outgoingCalls.listen(_onOutgoingCall))
      ..add(manager.onCallEvent.listen(_onRingingEvent));
  }

  final PushNotificationManager _manager;
  final bool Function(Call call) _isActive;
  final String Function() _newUuid;

  final _logger = taggedLogger(tag: 'SV:OutgoingCallReporter');
  final _subscriptions = <StreamSubscription<Object?>>[];
  final _calls = <_ReportedCall>[];

  static CallStatus _status(CallState state) => state.status;

  void _onOutgoingCall(Call? call) {
    // A call that is no longer the outgoing one and was never joined loses its CallKit call;
    // leaving it, and so cancelling its ring, is the app's. A joined one is still followed
    // through its status.
    for (final reported in _calls.toList()) {
      if (!identical(reported.call, call) && !_isActive(reported.call)) {
        _end(reported);
      }
    }

    if (call == null || _calls.any((it) => identical(it.call, call))) return;

    final reported = _ReportedCall(call);
    _calls.add(reported);
    reported.statusSubscription = call
        .partialState(_status)
        .listen(
          (status) => _onStatus(reported, status),
          onDone: () => _end(reported),
        );
  }

  void _onStatus(_ReportedCall reported, CallStatus status) {
    if (reported.ended) return;

    switch (status) {
      case CallStatusOutgoing() when reported.uuid == null:
        _start(reported);
      case CallStatusConnected() when !reported.connected:
        final uuid = reported.uuid;
        if (uuid == null) return;
        reported.connected = true;
        _run('setCallConnected', () => _manager.setCallConnected(uuid));
      case CallStatusDisconnected():
        _end(reported);
      default:
        break;
    }
  }

  void _start(_ReportedCall reported) {
    final uuid = _newUuid();
    reported.uuid = uuid;

    final state = reported.call.state.value;
    final callees = state.callMembers
        .where((member) => member.userId != state.currentUserId)
        .toList();

    _logger.d(() => '[start] ${state.callCid} as $uuid');
    _run(
      'startOutgoingCall',
      () => _manager.startOutgoingCall(
        uuid: uuid,
        callCid: state.callCid.value,
        handle: callees.length == 1 ? callees.single.userId : state.callCid.id,
        callerName: callees.isEmpty
            ? null
            : callees.map(_displayName).join(', '),
        hasVideo: state.settings.video.enabled,
      ),
    );
  }

  static String _displayName(CallMemberState member) =>
      member.name.isNotEmpty ? member.name : member.userId;

  void _end(_ReportedCall reported) {
    if (reported.ended) return;
    reported.ended = true;
    _calls.remove(reported);
    unawaited(reported.statusSubscription?.cancel());

    final uuid = reported.uuid;
    if (uuid == null || reported.endedByCallKit) return;

    _logger.d(() => '[end] ${reported.call.callCid} as $uuid');
    _run('endCall', () => _manager.endCall(uuid));
  }

  void _onRingingEvent(RingingEvent event) {
    final data = switch (event) {
      ActionCallEnded(:final data) ||
      ActionCallDecline(:final data) ||
      ActionCallTimeout(:final data) => data,
      _ => null,
    };
    final uuid = data?.uuid;
    if (uuid == null) return;

    final reported = _calls.firstWhereOrNull((it) => it.uuid == uuid);
    if (reported == null) return;
    reported.endedByCallKit = true;

    // CallKit reports an outgoing call it ends as ended. A decline or a timeout is handled by the
    // ringing flow coordinator, which rejects the call. A joined call is left by the coordinator
    // too, like any call CallKit ends.
    if (event is! ActionCallEnded || _isActive(reported.call)) return;

    _logger.d(() => '[onCallKitEnded] leaving ${reported.call.callCid}');
    _run(
      'leave',
      () => reported.call.leave(reason: DisconnectReason.nativeCallEnded()),
    );
  }

  void _run(String action, Future<Object?> Function() body) {
    unawaited(
      Future.sync(body).catchError((Object error, StackTrace stackTrace) {
        _logger.e(() => '[$action] failed: $error\n$stackTrace');
        return null;
      }),
    );
  }

  /// Stops following calls. The CallKit calls already reported are left as they are.
  Future<void> dispose() async {
    // Taken out first: a status that arrives while a cancel is awaited must not change the
    // lists being iterated, nor end a call.
    final subscriptions = [..._subscriptions];
    final calls = [..._calls];
    _subscriptions.clear();
    _calls.clear();
    for (final reported in calls) {
      reported.ended = true;
    }

    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
    for (final reported in calls) {
      await reported.statusSubscription?.cancel();
    }
  }
}

class _ReportedCall {
  _ReportedCall(this.call);

  final Call call;

  /// The CallKit uuid, set once CallKit was asked to start the call.
  String? uuid;

  // Cancelled when the call ends, or by [OutgoingCallReporter.dispose].
  // ignore: cancel_subscriptions
  StreamSubscription<CallStatus>? statusSubscription;
  bool connected = false;
  bool ended = false;

  /// CallKit ended the call itself, so there is nothing to end there.
  bool endedByCallKit = false;
}
