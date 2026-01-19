import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

class _FakePushNotificationPlatform
    extends StreamVideoPushNotificationPlatform {
  final StreamController<RingingEvent?> _controller =
      StreamController<RingingEvent?>.broadcast();

  @override
  Stream<RingingEvent?> get onEvent => _controller.stream;

  void emit(RingingEvent event) => _controller.add(event);

  Future<void> dispose() => _controller.close();
}

CallData _callData() => const CallData(uuid: 'uuid-1', callCid: 'default:1');

void main() {
  late _FakePushNotificationPlatform platform;
  late StreamSubscription<RingingEvent> subscription;
  late List<RingingEvent> events;

  setUpAll(() {
    platform = _FakePushNotificationPlatform();
    StreamVideoPushNotificationPlatform.instance = platform;
  });

  setUp(() {
    events = <RingingEvent>[];
    subscription = RingingEventBroadcaster().onEvent.listen(events.add);
  });

  tearDown(() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    platform.emit(ActionCallIncoming(data: _callData()));
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await subscription.cancel();
  });

  test('suppresses all events within window', () async {
    RingingEventBroadcaster().suppressEvent(
      window: const Duration(
        milliseconds: 50,
      ),
    );

    platform.emit(ActionCallIncoming(data: _callData()));
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(events, isEmpty);
  });

  test('suppresses a specific event type and value', () async {
    RingingEventBroadcaster().suppressEvent(
      eventType: ActionCallToggleMute,
      valueKey: 'true',
      window: const Duration(milliseconds: 50),
    );

    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: false));
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(events.length, 1);
    expect(
      events.first,
      const ActionCallToggleMute(uuid: 'uuid-1', isMuted: false),
    );
  });

  test('suppression expires after window', () async {
    RingingEventBroadcaster().suppressEvent(
      eventType: ActionCallToggleMute,
      valueKey: 'true',
      window: const Duration(milliseconds: 20),
    );

    await Future<void>.delayed(const Duration(milliseconds: 30));
    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(events.length, 1);
    expect(
      events.first,
      const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true),
    );
  });

  test('suppression applies to multiple matching events in window', () async {
    RingingEventBroadcaster().suppressEvent(
      eventType: ActionCallToggleMute,
      valueKey: 'true',
      window: const Duration(milliseconds: 50),
    );

    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(events, isEmpty);
  });
}
