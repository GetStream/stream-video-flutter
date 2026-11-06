import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/manager/native_call_controller.dart';
import 'package:stream_video_push_notification/src/manager/ringing_event_broadcaster.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

// Pins the platform rules the controller wraps around the native commands:
// what reaches the platform on which platform, how a call is found by its
// cid, and which native echo is suppressed. The end-by-cid decision itself is
// pinned in end_call_by_cid_test.dart.

/// Records every command and answers `activeCalls` with a scripted list.
class _RecordingPlatform extends StreamVideoPushNotificationPlatform {
  final calls = <String>[];
  List<CallData> active = const [];
  StreamVideoPushParams? lastParams;
  final _events = StreamController<RingingEvent?>.broadcast();

  @override
  Stream<RingingEvent?> get onEvent => _events.stream;

  void emit(RingingEvent event) => _events.add(event);

  @override
  Future<void> showIncomingCall(StreamVideoPushParams params) async {
    calls.add('showIncomingCall');
    lastParams = params;
  }

  @override
  Future<void> showMissCallNotification(StreamVideoPushParams params) async {
    calls.add('showMissCallNotification');
    lastParams = params;
  }

  @override
  Future<void> startCall(StreamVideoPushParams params) async {
    calls.add('startCall');
    lastParams = params;
  }

  @override
  Future<List<CallData>> activeCalls() async {
    calls.add('activeCalls');
    return active;
  }

  @override
  Future<void> endAllCalls() async => calls.add('endAllCalls');

  @override
  Future<void> endCall(String id) async => calls.add('endCall:$id');

  @override
  Future<void> dismissRingingCall(String cid) async =>
      calls.add('dismissRingingCall:$cid');

  @override
  Future<void> muteCall(String id, {bool isMuted = true}) async =>
      calls.add('muteCall:$id:$isMuted');

  @override
  Future<void> holdCall(String id, {bool isOnHold = true}) async =>
      calls.add('holdCall:$id:$isOnHold');

  @override
  Future<void> setCallConnected(String id) async =>
      calls.add('callConnected:$id');

  @override
  Future<void> reportCallEnded(String uuid, CallEndedReason reason) async =>
      calls.add('reportCallEnded:$uuid:${reason.name}');
}

const _configuration = StreamVideoPushConfiguration(
  android: AndroidPushConfiguration(ringtonePath: 'ring.mp3'),
  ios: IOSPushConfiguration(iconName: 'CallIcon'),
);

void main() {
  late _RecordingPlatform platform;
  late RingingEventBroadcaster broadcaster;
  late NativeCallController controller;
  late List<RingingEvent> received;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    platform = _RecordingPlatform();
    broadcaster = RingingEventBroadcaster(platform: platform);
    controller = NativeCallController(
      configuration: _configuration,
      broadcaster: broadcaster,
      platform: platform,
    );
    received = [];
    final subscription = broadcaster.onEvent.listen(received.add);
    addTearDown(subscription.cancel);
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  group('show and start', () {
    test('build the params for the call from the configuration', () async {
      await controller.showIncomingCall(
        uuid: 'u1',
        callCid: 'default:c1',
        avatar: 'ada.png',
        callerName: 'Ada',
        hasVideo: false,
      );

      expect(platform.calls, ['showIncomingCall']);
      final params = platform.lastParams!;
      expect(params.id, 'u1');
      expect(params.extra, {'callCid': 'default:c1'});
      expect(params.callerName, 'Ada');
      expect(params.type, 0);
      expect(params.android?.avatar, 'ada.png');
      expect(params.android?.ringtonePath, 'ring.mp3');
      expect(params.ios?.iconName, 'CallIcon');
    });

    test(
      'a missed call and an outgoing call reach their own commands',
      () async {
        await controller.showMissedCall(uuid: 'u1', callCid: 'default:c1');
        await controller.startOutgoingCall(uuid: 'u2', callCid: 'default:c2');

        expect(platform.calls, ['showMissCallNotification', 'startCall']);
        expect(platform.lastParams?.id, 'u2');
      },
    );
  });

  group('activeCalls', () {
    test('is empty off mobile without asking the platform', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      expect(await controller.activeCalls(), isEmpty);
      expect(platform.calls, isEmpty);
    });

    test('is what the platform reports on mobile', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      expect(await controller.activeCalls(), platform.active);
    });
  });

  group('endCallByCid', () {
    test('ends every call when all of them belong to the cid', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.endCallByCid('default:c1');

      expect(platform.calls, ['activeCalls', 'endAllCalls']);
    });

    test(
      'ends only the matching and the unidentified calls otherwise',
      () async {
        platform.active = const [
          CallData(uuid: 'u1', callCid: 'default:c1'),
          CallData(uuid: 'u2', callCid: 'default:other'),
          CallData(uuid: 'u3'),
        ];

        await controller.endCallByCid('default:c1');

        expect(platform.calls, ['activeCalls', 'endCall:u1', 'endCall:u3']);
      },
    );

    test('silent suppresses the native events the end produces', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.endCallByCid('default:c1', silent: true);
      platform.emit(
        const ActionCallEnded(
          data: CallData(uuid: 'u1', callCid: 'default:c1'),
        ),
      );
      await pumpEventQueue();

      expect(received, isEmpty);
    });

    test('without silent the native events come through', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.endCallByCid('default:c1');
      platform.emit(
        const ActionCallEnded(
          data: CallData(uuid: 'u1', callCid: 'default:c1'),
        ),
      );
      await pumpEventQueue();

      expect(received, hasLength(1));
    });
  });

  group('dismissRingingCallByCid', () {
    test('on iOS ends the call, since CallKit is the ring', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.dismissRingingCallByCid('default:c1');

      expect(platform.calls, ['activeCalls', 'endAllCalls']);
    });

    test('on Android dismisses the ring and keeps the Telecom call', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await controller.dismissRingingCallByCid('default:c1');

      expect(platform.calls, ['dismissRingingCall:default:c1']);
    });
  });

  group('setCallMutedByCid', () {
    test('mutes the calls of the cid on iOS and suppresses the echo', () async {
      platform.active = const [
        CallData(uuid: 'u1', callCid: 'default:c1'),
        CallData(uuid: 'u2', callCid: 'default:other'),
      ];

      await controller.setCallMutedByCid('default:c1', true);

      expect(platform.calls, ['activeCalls', 'muteCall:u1:true']);

      // The echo of this mute is dropped; the opposite value is not.
      platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
      platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: false));
      await pumpEventQueue();
      expect(received, [
        const ActionCallToggleMute(uuid: 'u1', isMuted: false),
      ]);
    });

    test('does nothing off iOS', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.setCallMutedByCid('default:c1', true);

      expect(platform.calls, isEmpty);
    });
  });

  test('the plain commands pass straight through', () async {
    await controller.endAllCalls();
    await controller.endCall('u1');
    await controller.holdCall('u1', isOnHold: false);
    await controller.muteCall('u1');
    await controller.setCallConnected('u1');
    await controller.reportCallEnded('u1', reason: CallEndedReason.unanswered);

    expect(platform.calls, [
      'endAllCalls',
      'endCall:u1',
      'holdCall:u1:false',
      'muteCall:u1:true',
      'callConnected:u1',
      'reportCallEnded:u1:unanswered',
    ]);
  });
}
