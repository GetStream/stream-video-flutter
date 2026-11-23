import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/manager/ringing_event_broadcaster.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

class _FakePushNotificationPlatform
    extends StreamVideoPushNotificationPlatform {
  final StreamController<RingingEvent?> _controller =
      StreamController<RingingEvent?>.broadcast();

  /// How many times the platform stream was listened to.
  int listens = 0;

  @override
  Stream<RingingEvent?> get onEvent {
    listens++;
    return _controller.stream;
  }

  void emit(RingingEvent? event) => _controller.add(event);

  Future<void> dispose() => _controller.close();
}

CallData _callData() => const CallData(uuid: 'uuid-1', callCid: 'default:1');

void main() {
  late _FakePushNotificationPlatform platform;
  late RingingEventBroadcaster broadcaster;
  late StreamSubscription<RingingEvent> subscription;
  late List<RingingEvent> events;

  setUp(() {
    platform = _FakePushNotificationPlatform();
    broadcaster = RingingEventBroadcaster(platform: platform);
    events = <RingingEvent>[];
    subscription = broadcaster.onEvent.listen(events.add);
  });

  tearDown(() async {
    await subscription.cancel();
    await platform.dispose();
  });

  test('forwards events and drops null ones', () async {
    platform.emit(ActionCallIncoming(data: _callData()));
    platform.emit(null);
    platform.emit(ActionCallAccept(data: _callData()));
    await pumpEventQueue();

    expect(events, [
      ActionCallIncoming(data: _callData()),
      ActionCallAccept(data: _callData()),
    ]);
  });

  test(
    'a listener that subscribes while the last one is cancelling gets events',
    () async {
      unawaited(subscription.cancel());
      final again = <RingingEvent>[];
      final next = broadcaster.onEvent.listen(again.add);
      addTearDown(next.cancel);
      await pumpEventQueue();

      platform.emit(ActionCallIncoming(data: _callData()));
      await pumpEventQueue();

      expect(again, [ActionCallIncoming(data: _callData())]);
      expect(platform.listens, 2);
    },
  );

  test('holds one platform subscription for any number of listeners', () async {
    final other = <RingingEvent>[];
    final second = broadcaster.onEvent.listen(other.add);
    addTearDown(second.cancel);

    platform.emit(ActionCallIncoming(data: _callData()));
    await pumpEventQueue();

    expect(platform.listens, 1);
    expect(events, hasLength(1));
    expect(other, hasLength(1));
  });

  group('suppressing a call end', () {
    CallData call(String cid) => CallData(uuid: 'uuid-$cid', callCid: cid);

    test('drops every report that the call ended', () async {
      broadcaster.suppressCallEnd('default:1');

      platform.emit(ActionCallDecline(data: call('default:1')));
      platform.emit(ActionCallEnded(data: call('default:1')));
      platform.emit(ActionCallTimeout(data: call('default:1')));
      platform.emit(
        ActionCallDismissed(
          data: call('default:1'),
          reason: CallDismissReason.accepted,
        ),
      );
      await pumpEventQueue();

      expect(events, isEmpty);
    });

    test('lets the end of another call through', () async {
      broadcaster.suppressCallEnd('default:1');

      platform.emit(ActionCallEnded(data: call('default:2')));
      platform.emit(const ActionCallEnded(data: CallData(uuid: 'no-cid')));
      await pumpEventQueue();

      expect(events, [
        ActionCallEnded(data: call('default:2')),
        const ActionCallEnded(data: CallData(uuid: 'no-cid')),
      ]);
    });

    test('lets events that are not an end through', () async {
      broadcaster.suppressCallEnd('default:1');

      platform.emit(ActionCallIncoming(data: call('default:1')));
      platform.emit(ActionCallAccept(data: call('default:1')));
      platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
      await pumpEventQueue();

      expect(events, hasLength(3));
    });

    test('expires after its window', () async {
      broadcaster.suppressCallEnd(
        'default:1',
        window: const Duration(milliseconds: 20),
      );

      await Future<void>.delayed(const Duration(milliseconds: 30));
      platform.emit(ActionCallEnded(data: call('default:1')));
      await pumpEventQueue();

      expect(events, [ActionCallEnded(data: call('default:1'))]);
    });
  });

  test('suppresses a specific event type and value', () async {
    broadcaster.suppressEvent(
      eventType: ActionCallToggleMute,
      valueKey: 'true',
      window: const Duration(milliseconds: 50),
    );

    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: false));
    await pumpEventQueue();

    expect(events, [
      const ActionCallToggleMute(uuid: 'uuid-1', isMuted: false),
    ]);
  });

  test('suppression expires after window', () async {
    broadcaster.suppressEvent(
      eventType: ActionCallToggleMute,
      valueKey: 'true',
      window: const Duration(milliseconds: 20),
    );

    await Future<void>.delayed(const Duration(milliseconds: 30));
    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
    await pumpEventQueue();

    expect(events, [
      const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true),
    ]);
  });

  test('suppression applies to multiple matching events in window', () async {
    broadcaster.suppressEvent(
      eventType: ActionCallToggleMute,
      valueKey: 'true',
      window: const Duration(milliseconds: 50),
    );

    platform.emit(const ActionCallToggleMute(uuid: 'uuid-1', isMuted: true));
    platform.emit(const ActionCallToggleMute(uuid: 'uuid-2', isMuted: true));
    await pumpEventQueue();

    expect(events, isEmpty);
  });
}
