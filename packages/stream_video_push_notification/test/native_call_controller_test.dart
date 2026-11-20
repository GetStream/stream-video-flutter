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
  Future<void> dismissRingingCall(
    String cid, {
    CallDismissReason reason = CallDismissReason.accepted,
  }) async => calls.add('dismissRingingCall:$cid:${reason.name}');

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

  bool routed = true;

  @override
  Future<bool> requestAudioEndpoint(
    String cid,
    TelecomAudioEndpoint endpoint, {
    String? name,
  }) async {
    calls.add('requestAudioEndpoint:$cid:${endpoint.name}:$name');
    return routed;
  }
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
        ringTimeout: const Duration(seconds: 45),
      );

      expect(platform.calls, ['showIncomingCall']);
      final params = platform.lastParams!;
      expect(params.duration, 45000);
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

    test(
      'silent lets the events of another call and an incoming ring through',
      () async {
        platform.active = const [
          CallData(uuid: 'u1', callCid: 'default:c1'),
          CallData(uuid: 'u2', callCid: 'default:c2'),
        ];

        await controller.endCallByCid('default:c1', silent: true);
        platform.emit(
          const ActionCallDecline(
            data: CallData(uuid: 'u2', callCid: 'default:c2'),
          ),
        );
        platform.emit(
          const ActionCallIncoming(
            data: CallData(uuid: 'u3', callCid: 'default:c1'),
          ),
        );
        await pumpEventQueue();

        expect(received, hasLength(2));
      },
    );

    for (final active in <List<CallData>>[
      const [],
      const [CallData(uuid: 'u2', callCid: 'default:other')],
    ]) {
      test(
        'silent ends nothing when no native call has the cid '
        '(${active.length} other)',
        () async {
          CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
          platform.active = active;

          await controller.endCallByCid('default:c1', silent: true);

          expect(platform.calls, ['activeCalls']);
        },
      );
    }

    test('without silent an empty native list is swept', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      platform.active = const [];

      await controller.endCallByCid('default:c1');

      expect(platform.calls, ['activeCalls', 'endAllCalls']);
    });

    test('does nothing off mobile', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.endCallByCid('default:c1');

      expect(platform.calls, isEmpty);
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

  group('ringEnded', () {
    test('ends the ring without reporting a decline', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.ringEnded('default:c1');
      platform.emit(
        const ActionCallDecline(
          data: CallData(uuid: 'u1', callCid: 'default:c1'),
        ),
      );
      await pumpEventQueue();

      expect(platform.calls, ['activeCalls', 'endAllCalls']);
      expect(received, isEmpty);
    });

    test('ends only the ring of the cid', () async {
      platform.active = const [
        CallData(uuid: 'u1', callCid: 'default:c1'),
        CallData(uuid: 'u2', callCid: 'default:other'),
      ];

      await controller.ringEnded('default:c1');

      expect(platform.calls, ['activeCalls', 'endCall:u1']);
    });

    test(
      'keeps a ring the user answered on the native call screen, for the '
      'client that takes it over',
      () async {
        platform.active = const [
          CallData(uuid: 'u1', callCid: 'default:c1', isAccepted: true),
        ];

        await controller.ringEnded('default:c1');

        expect(platform.calls, ['activeCalls']);
      },
    );

    test(
      'ends nothing when the native side shows no ring of the cid, so a '
      'call only Telecom holds is not swept',
      () async {
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
        platform.active = const [];

        await controller.ringEnded('default:c1');

        expect(platform.calls, ['activeCalls']);
      },
    );

    test('does nothing off mobile', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.ringEnded('default:c1');

      expect(platform.calls, isEmpty);
    });
  });

  group('callLeft', () {
    test('ends the call, accepted or not', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      platform.active = const [
        CallData(uuid: 'u1', callCid: 'default:c1', isAccepted: true),
        CallData(uuid: 'u2', callCid: 'default:other'),
      ];

      await controller.callLeft('default:c1');

      expect(platform.calls, ['activeCalls', 'endCall:u1']);
    });

    for (final active in <List<CallData>>[
      const [],
      const [CallData(uuid: 'u2', callCid: 'default:other')],
    ]) {
      test(
        'ends nothing when no native call has the cid '
        '(${active.length} other)',
        () async {
          CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
          platform.active = active;

          await controller.callLeft('default:c1');

          expect(platform.calls, ['activeCalls']);
        },
      );
    }

    test('lets the report of the end through', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.callLeft('default:c1');
      platform.emit(
        const ActionCallEnded(
          data: CallData(uuid: 'u1', callCid: 'default:c1'),
        ),
      );
      await pumpEventQueue();

      expect(received, hasLength(1));
    });
  });

  group('callAccepted', () {
    setUp(() {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    });

    test('dismisses a ring the native side still shows unanswered', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.callAccepted('default:c1');

      expect(platform.calls, [
        'activeCalls',
        'dismissRingingCall:default:c1:accepted',
      ]);
    });

    test('leaves a ring answered on the native call screen alone', () async {
      platform.active = const [
        CallData(uuid: 'u1', callCid: 'default:c1'),
        CallData(uuid: 'u2', callCid: 'default:c1', isAccepted: true),
      ];

      await controller.callAccepted('default:c1');

      expect(platform.calls, ['activeCalls']);
    });

    test('does nothing when the native side shows no ring of it', () async {
      platform.active = const [
        CallData(uuid: 'u2', callCid: 'default:other'),
      ];

      await controller.callAccepted('default:c1');

      expect(platform.calls, ['activeCalls']);
    });

    test('on iOS ends the ring without reporting a decline', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.callAccepted('default:c1');
      platform.emit(
        const ActionCallDecline(
          data: CallData(uuid: 'u1', callCid: 'default:c1'),
        ),
      );
      await pumpEventQueue();

      expect(platform.calls, ['activeCalls', 'endAllCalls']);
      expect(received, isEmpty);
    });
  });

  group('dismissRingingCallByCid', () {
    test('on iOS ends the call, since CallKit is the ring', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.dismissRingingCallByCid('default:c1');

      expect(platform.calls, ['activeCalls', 'endAllCalls']);
    });

    test('on iOS the end is not reported as a decline', () async {
      platform.active = const [CallData(uuid: 'u1', callCid: 'default:c1')];

      await controller.dismissRingingCallByCid('default:c1');
      platform.emit(
        const ActionCallDecline(
          data: CallData(uuid: 'u1', callCid: 'default:c1'),
        ),
      );
      await pumpEventQueue();

      expect(received, isEmpty);
    });

    test('on Android dismisses the ring and keeps the Telecom call', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await controller.dismissRingingCallByCid('default:c1');

      expect(platform.calls, ['dismissRingingCall:default:c1:accepted']);
    });

    test('on Android passes the reason', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await controller.dismissRingingCallByCid(
        'default:c1',
        reason: CallDismissReason.answeredElsewhere,
      );

      expect(platform.calls, [
        'dismissRingingCall:default:c1:answeredElsewhere',
      ]);
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

  group('setCallAudioOutputDeviceByCid', () {
    const speaker = RtcMediaDevice(
      id: 'speaker',
      label: 'Speaker',
      kind: RtcMediaDeviceKind.audioOutput,
    );

    test('asks Telecom for the endpoint of the device on Android', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await controller.setCallAudioOutputDeviceByCid('default:c1', speaker);

      expect(platform.calls, [
        'requestAudioEndpoint:default:c1:speaker:Speaker',
      ]);
    });

    test('completes when Telecom does not route the call', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      platform.routed = false;

      await expectLater(
        controller.setCallAudioOutputDeviceByCid('default:c1', speaker),
        completes,
      );
    });

    test('names the Bluetooth headset by its label', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await controller.setCallAudioOutputDeviceByCid(
        'default:c1',
        const RtcMediaDevice(
          id: 'bluetooth',
          label: 'Car',
          groupId: 'bluetooth',
          kind: RtcMediaDeviceKind.audioOutput,
        ),
      );

      expect(platform.calls, [
        'requestAudioEndpoint:default:c1:bluetooth:Car',
      ]);
    });

    test(
      'asks again once an outgoing call started later is registered',
      () async {
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
        platform.routed = false;
        await controller.setCallAudioOutputDeviceByCid('default:c1', speaker);
        platform.calls.clear();

        await controller.startOutgoingCall(uuid: 'u1', callCid: 'default:c1');
        await pumpEventQueue();

        expect(platform.calls, [
          'startCall',
          'requestAudioEndpoint:default:c1:speaker:Speaker',
        ]);
      },
    );

    test('asks nothing again for a call that ended', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      await controller.setCallAudioOutputDeviceByCid('default:c1', speaker);
      await controller.endCallByCid('default:c1');
      platform.calls.clear();

      await controller.startOutgoingCall(uuid: 'u1', callCid: 'default:c1');
      await pumpEventQueue();

      expect(platform.calls, ['startCall']);
    });

    test('asks nothing for a device Telecom has no endpoint for', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await controller.setCallAudioOutputDeviceByCid(
        'default:c1',
        const RtcMediaDevice(
          id: '7',
          label: 'USB',
          groupId: '22',
          kind: RtcMediaDeviceKind.audioOutput,
        ),
      );

      expect(platform.calls, isEmpty);
    });

    test('does nothing off Android', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;

      await controller.setCallAudioOutputDeviceByCid('default:c1', speaker);

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
