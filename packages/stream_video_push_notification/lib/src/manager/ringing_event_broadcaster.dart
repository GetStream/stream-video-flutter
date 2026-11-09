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

  /// Suppresses upcoming Ringing events.
  ///
  /// - If [eventType] is null, all events are suppressed.
  /// - If [valueKey] is provided, it must match the event value to suppress.
  void suppressEvent({
    Type? eventType,
    String? valueKey,
    Duration window = _ringingEventSuppressionWindow,
  }) {
    _suppressions.add(
      _RingingEventSuppression(
        eventType: eventType,
        valueKey: valueKey,
        timestamp: DateTime.now(),
        window: window,
      ),
    );
  }

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
    // Clears the subscription before cancelling it.
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
    return _suppressions.any(
      (suppression) =>
          suppression.eventType == null ||
          (event.runtimeType == suppression.eventType &&
              suppression.valueKey == valueKey),
    );
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
    required this.eventType,
    required this.valueKey,
    required this.timestamp,
    required this.window,
  });

  final Type? eventType;
  final String? valueKey;
  final DateTime timestamp;
  final Duration window;

  bool isValid() {
    return DateTime.now().difference(timestamp) <= window;
  }
}
