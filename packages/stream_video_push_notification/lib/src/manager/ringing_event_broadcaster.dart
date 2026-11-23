import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_video/stream_video.dart';

import '../../stream_video_push_notification_platform_interface.dart';

/// Fans the platform's ringing events out to any number of listeners and
/// applies the suppressions the SDK asks for around its own native calls.
///
/// One instance holds the single subscription to
/// [StreamVideoPushNotificationPlatform.onEvent]. Everything that reads ringing
/// events in a process goes through [shared].
@internal
final class RingingEventBroadcaster {
  /// A broadcaster over `platform`, for tests.
  @visibleForTesting
  RingingEventBroadcaster({required this._platform});

  RingingEventBroadcaster._shared() : _platform = null;

  /// The process-wide broadcaster the manager and the token provider use.
  /// Built on first use; it reads [StreamVideoPushNotificationPlatform.instance]
  /// each time it starts listening.
  static final shared = RingingEventBroadcaster._shared();

  static const _ringingEventSuppressionWindow = Duration(milliseconds: 500);

  final StreamVideoPushNotificationPlatform? _platform;

  StreamVideoPushNotificationPlatform get _resolvedPlatform =>
      _platform ?? StreamVideoPushNotificationPlatform.instance;

  StreamController<RingingEvent>? _controller;
  final List<_RingingEventSuppression> _suppressions = [];

  /// Returns a Stream of [RingingEvent].
  Stream<RingingEvent> get onEvent {
    _controller ??= StreamController<RingingEvent>.broadcast(
      onListen: _startListenEvent,
      onCancel: _stopListenEvent,
    );
    return _controller!.stream;
  }

  /// Suppresses the upcoming events of [eventType] whose value matches
  /// [valueKey]: the mute or hold state they carry, or none for other events.
  void suppressEvent({
    required Type eventType,
    String? valueKey,
    Duration window = _ringingEventSuppressionWindow,
  }) {
    _suppressions.add(
      _RingingEventSuppression(
        eventTypes: {eventType},
        valueKey: valueKey,
        timestamp: DateTime.now(),
        window: window,
      ),
    );
  }

  /// Suppresses the upcoming reports that a native call of [callCid] ended:
  /// [ActionCallDecline], [ActionCallEnded], [ActionCallTimeout] and
  /// [ActionCallDismissed] carrying that cid. Events of other calls, and
  /// events that are not about an end, still go through.
  void suppressCallEnd(
    String callCid, {
    Duration window = _ringingEventSuppressionWindow,
  }) {
    _suppressions.add(
      _RingingEventSuppression(
        eventTypes: _callEndTypes,
        callCid: callCid,
        timestamp: DateTime.now(),
        window: window,
      ),
    );
  }

  static const _callEndTypes = {
    ActionCallDecline,
    ActionCallEnded,
    ActionCallTimeout,
    ActionCallDismissed,
  };

  StreamSubscription<RingingEvent?>? _eventSubscription;

  Future<void> _startListenEvent() async {
    _eventSubscription ??= _resolvedPlatform.onEvent.distinct().listen((
      event,
    ) {
      if (event == null) return;
      if (_shouldSuppressEvent(event)) return;
      _controller?.add(event);
    });
  }

  Future<void> _stopListenEvent() async {
    // Clears the subscription before its cancel completes.
    final cancelled = _eventSubscription?.cancel();
    _eventSubscription = null;
    await cancelled;
  }

  bool _shouldSuppressEvent(RingingEvent event) {
    _suppressions.removeWhere((suppression) => !suppression.isValid());
    if (_suppressions.isEmpty) {
      return false;
    }

    final valueKey = _eventValueKey(event);
    final callCid = _eventCallCid(event);
    return _suppressions.any(
      (suppression) =>
          suppression.eventTypes.contains(event.runtimeType) &&
          suppression.valueKey == valueKey &&
          suppression.callCid == callCid,
    );
  }

  String? _eventCallCid(RingingEvent event) {
    return switch (event) {
      ActionCallDecline(:final data) ||
      ActionCallEnded(:final data) ||
      ActionCallTimeout(:final data) ||
      ActionCallDismissed(:final data) => data.callCid,
      _ => null,
    };
  }

  String? _eventValueKey(RingingEvent event) {
    return switch (event) {
      ActionCallToggleMute(:final isMuted) => isMuted.toString(),
      ActionCallToggleHold(:final isOnHold) => isOnHold.toString(),
      _ => null,
    };
  }
}

class _RingingEventSuppression {
  const _RingingEventSuppression({
    required this.eventTypes,
    this.valueKey,
    this.callCid,
    required this.timestamp,
    required this.window,
  });

  final Set<Type> eventTypes;
  final String? valueKey;

  // The cid the event has to carry; null for an event that carries none.
  final String? callCid;
  final DateTime timestamp;
  final Duration window;

  bool isValid() {
    return DateTime.now().difference(timestamp) <= window;
  }
}
