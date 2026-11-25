// ignore_for_file: avoid_implementing_value_types

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// ignore: implementation_imports
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/manager/native_call_controller.dart';
import 'package:stream_video_push_notification/src/manager/ringing_event_broadcaster.dart';
import 'package:stream_video_push_notification/src/manager/ringing_sync_observer.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

// Pins how the observer keeps the native call UI in step with the backend
// and the app: which backend events end or dismiss the native call and which
// are ignored, when the backend subscriptions start and stop, what a CallKit
// mute does to the app's call, and that the app leaving a call ends the
// native one.

const _me = 'me';
final _cid = StreamCallCid(cid: 'default:c1');

class _MockClient extends Mock implements CoordinatorClient {}

// ignore: subtype_of_sealed_class
class _MockStreamVideo extends Mock implements StreamVideo {
  // StreamVideo marks dispose as @mustBeOverridden.
  @override
  Future<void> dispose() =>
      noSuchMethod(Invocation.method(#dispose, const [])) as Future<void>;
}

class _MockClientState extends Mock implements ClientState {}

// ignore: subtype_of_sealed_class
class _MockRingingFlowCoordinator extends Mock
    implements RingingFlowCoordinator {}

class _MockController extends Mock implements NativeCallController {}

class _MockCall extends Mock implements Call {}

class _MockCallState extends Mock implements CallState {}

class _MockAcceptedEvent extends Mock implements StreamCallAcceptedEvent {}

class _FakePlatform extends StreamVideoPushNotificationPlatform {
  final _events = StreamController<RingingEvent?>.broadcast();

  @override
  Stream<RingingEvent?> get onEvent => _events.stream;

  void emit(RingingEvent event) => _events.add(event);
}

void main() {
  late _MockClient client;
  late MutableSharedEmitter<StreamVideoEvent> backendEvents;
  late _MockStreamVideo streamVideo;
  late _MockRingingFlowCoordinator ringing;
  late MutableStateEmitter<List<Call>> activeCalls;
  late _MockController controller;
  late _FakePlatform platform;
  late RingingEventBroadcaster broadcaster;
  late List<RingingEvent> received;
  late RingingSyncObserver observer;

  /// The cids whose ring the observer dismissed, in order.
  late List<String> dismissed;

  setUpAll(() {
    registerFallbackValue(StreamCallCid(cid: 'default:fallback'));
  });

  setUp(() {
    client = _MockClient();
    backendEvents = MutableSharedEmitter<StreamVideoEvent>();
    when(() => client.events).thenAnswer((_) => backendEvents);
    when(() => client.isConnected).thenReturn(true);
    when(
      () => client.openConnection(),
    ).thenAnswer((_) async => const Result.success(none));

    final state = _MockClientState();
    activeCalls = MutableStateEmitter<List<Call>>(const <Call>[]);
    when(() => state.activeCalls).thenAnswer((_) => activeCalls);
    ringing = _MockRingingFlowCoordinator();
    when(() => ringing.isCallAcceptedOnThisDevice(any())).thenReturn(false);
    streamVideo = _MockStreamVideo();
    when(() => streamVideo.state).thenReturn(state);
    when(() => streamVideo.ringing).thenReturn(ringing);
    when(() => streamVideo.currentUser).thenReturn(const UserInfo(id: _me));
    when(() => streamVideo.activeCalls).thenReturn(const []);

    controller = _MockController();
    when(() => controller.activeCalls()).thenAnswer((_) async => const []);
    when(
      () => controller.endCallByCid(any(), silent: any(named: 'silent')),
    ).thenAnswer((_) async {});
    dismissed = [];
    when(() => controller.dismissRingingCallByCid(any())).thenAnswer((
      invocation,
    ) async {
      dismissed.add(invocation.positionalArguments.first as String);
    });

    platform = _FakePlatform();
    broadcaster = RingingEventBroadcaster(platform: platform);
    received = [];
    final subscription = broadcaster.onEvent.listen(received.add);
    addTearDown(subscription.cancel);

    observer = RingingSyncObserver(
      streamVideo: streamVideo,
      client: client,
      controller: controller,
      ringingEvents: broadcaster.onEvent,
    );
    addTearDown(observer.dispose);
  });

  /// Starts the observer and lets its start-up probe of the native calls run.
  Future<void> start() async {
    observer.start();
    await pumpEventQueue();
  }

  /// Rings: the native incoming event, which starts the backend subscriptions.
  Future<void> ring() async {
    platform.emit(ActionCallIncoming(data: CallData(callCid: _cid.value)));
    await pumpEventQueue();
  }

  _MockAcceptedEvent acceptedBy(String userId, {String? cid}) {
    final event = _MockAcceptedEvent();
    when(
      () => event.callCid,
    ).thenReturn(cid == null ? _cid : StreamCallCid(cid: cid));
    when(() => event.acceptedByUserId).thenReturn(userId);
    return event;
  }

  _MockCall call({
    required String cid,
    bool isRingingFlow = false,
    CallStatus? status,
  }) {
    final callState = _MockCallState();
    when(() => callState.isRingingFlow).thenReturn(isRingingFlow);
    when(() => callState.status).thenReturn(status ?? CallStatusIdle());
    final call = _MockCall();
    when(() => call.callCid).thenReturn(StreamCallCid(cid: cid));
    when(() => call.state).thenAnswer((_) => MutableStateEmitter(callState));
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => call.leave(reason: any(named: 'reason')),
    ).thenAnswer((_) async => const Result.success(none));
    return call;
  }

  group('a ring', () {
    test('opens the backend connection when closed', () async {
      when(() => client.isConnected).thenReturn(false);
      await start();
      await ring();

      verify(() => client.openConnection()).called(1);
    });

    test('leaves an open connection alone', () async {
      await start();
      await ring();

      verifyNever(() => client.openConnection());
    });

    test(
      "is not followed on the backend: ending and dismissing it are core's",
      () async {
        when(() => ringing.isCallAcceptedOnThisDevice(any())).thenReturn(true);
        await start();
        await ring();

        backendEvents.emit(acceptedBy(_me));
        await pumpEventQueue();

        expect(dismissed, isEmpty);
        verifyNever(
          () => controller.endCallByCid(any(), silent: any(named: 'silent')),
        );
      },
    );
  });

  group('a CallKit mute', () {
    test('reaches the call the native uuid belongs to', () async {
      await start();
      final target = call(cid: _cid.value);
      final other = call(cid: 'default:other', isRingingFlow: true);
      activeCalls.value = [other, target];
      await pumpEventQueue();
      when(() => controller.activeCalls()).thenAnswer(
        (_) async => [CallData(uuid: 'U1', callCid: _cid.value)],
      );

      platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
      await pumpEventQueue();

      verify(() => target.setMicrophoneEnabled(enabled: false)).called(1);
      verifyNever(
        () => other.setMicrophoneEnabled(enabled: any(named: 'enabled')),
      );
    });

    test(
      'reaches a call just joined while an earlier call is still ending',
      () async {
        await start();
        final left = call(cid: 'default:left');
        activeCalls.value = [left];
        await pumpEventQueue();
        final ending = Completer<void>();
        when(
          () => controller.endCallByCid(any(), silent: any(named: 'silent')),
        ).thenAnswer((_) => ending.future);
        final joined = call(cid: _cid.value);
        activeCalls.value = [joined];
        await pumpEventQueue();
        when(() => controller.activeCalls()).thenAnswer(
          (_) async => [CallData(uuid: 'u1', callCid: _cid.value)],
        );

        platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
        await pumpEventQueue();
        ending.complete();

        verify(() => joined.setMicrophoneEnabled(enabled: false)).called(1);
      },
    );

    test(
      'falls back to the call in the ringing flow for an unknown uuid',
      () async {
        await start();
        final ringingCall = call(cid: _cid.value, isRingingFlow: true);
        final other = call(cid: 'default:other');
        activeCalls.value = [other, ringingCall];
        await pumpEventQueue();

        platform.emit(const ActionCallToggleMute(uuid: 'gone', isMuted: false));
        await pumpEventQueue();

        verify(() => ringingCall.setMicrophoneEnabled(enabled: true)).called(1);
        verifyNever(
          () => other.setMicrophoneEnabled(enabled: any(named: 'enabled')),
        );
      },
    );

    test(
      'is dropped when its uuid names a call the app is not in',
      () async {
        await start();
        final ringingCall = call(cid: _cid.value, isRingingFlow: true);
        final other = call(cid: 'default:other');
        activeCalls.value = [other, ringingCall];
        await pumpEventQueue();
        when(() => controller.activeCalls()).thenAnswer(
          (_) async => const [CallData(uuid: 'u1', callCid: 'default:gone')],
        );

        platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
        await pumpEventQueue();

        verifyNever(
          () =>
              ringingCall.setMicrophoneEnabled(enabled: any(named: 'enabled')),
        );
        verifyNever(
          () => other.setMicrophoneEnabled(enabled: any(named: 'enabled')),
        );
      },
    );

    test('falls back when the native calls cannot be read', () async {
      await start();
      final ringingCall = call(cid: _cid.value, isRingingFlow: true);
      activeCalls.value = [ringingCall];
      await pumpEventQueue();
      when(
        () => controller.activeCalls(),
      ).thenAnswer((_) => Future.error(PlatformException(code: 'channel')));

      platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
      await pumpEventQueue();

      verify(() => ringingCall.setMicrophoneEnabled(enabled: false)).called(1);
    });

    test('does nothing without a call to apply it to', () async {
      await start();
      final other = call(cid: 'default:other');
      activeCalls.value = [other];
      await pumpEventQueue();

      platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
      await pumpEventQueue();

      verifyNever(
        () => other.setMicrophoneEnabled(enabled: any(named: 'enabled')),
      );
    });

    test(
      'falls back to the call in the ringing flow for a uuid without a cid',
      () async {
        when(() => controller.activeCalls()).thenAnswer(
          (_) async => const [CallData(uuid: 'u1')],
        );
        await start();
        final ringingCall = call(cid: _cid.value, isRingingFlow: true);
        activeCalls.value = [ringingCall];
        await pumpEventQueue();

        platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
        await pumpEventQueue();

        verify(
          () => ringingCall.setMicrophoneEnabled(enabled: false),
        ).called(1);
      },
    );

    test('is dropped when the observer is disposed meanwhile', () async {
      await start();
      final ringingCall = call(cid: _cid.value, isRingingFlow: true);
      activeCalls.value = [ringingCall];
      await pumpEventQueue();
      final lookup = Completer<List<CallData>>();
      when(() => controller.activeCalls()).thenAnswer((_) => lookup.future);

      platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
      await pumpEventQueue();
      observer.dispose();
      lookup.complete(const []);
      await pumpEventQueue();

      verifyNever(
        () => ringingCall.setMicrophoneEnabled(enabled: any(named: 'enabled')),
      );
    });
  });

  test('dispose stops everything', () async {
    when(() => client.isConnected).thenReturn(false);
    await start();

    observer.dispose();
    await ring();

    verifyNever(() => client.openConnection());
  });

  group('a Telecom hold on Android', () {
    setUp(() async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      when(() => streamVideo.options).thenReturn(StreamVideoOptions());
      await start();
    });
    tearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

    /// A call the app is in, joined unless [status] says otherwise.
    Future<_MockCall> joined({
      String cid = 'default:c1',
      CallStatus? status,
    }) async {
      final target = call(cid: cid, status: status ?? CallStatusJoined());
      activeCalls.value = [...activeCalls.value, target];
      await pumpEventQueue();
      return target;
    }

    /// Sends a hold. Two equal events in a row reach the observer once, so a
    /// test sending the same hold twice passes another [uuid].
    Future<void> hold({
      required bool isOnHold,
      String? cid = 'default:c1',
      String uuid = 'u1',
    }) async {
      platform.emit(
        ActionCallToggleHold(uuid: uuid, isOnHold: isOnHold, callCid: cid),
      );
      await pumpEventQueue();
    }

    void verifyLeft(_MockCall target) {
      final reason = verify(
        () => target.leave(reason: captureAny(named: 'reason')),
      ).captured.single;
      expect(
        reason,
        const DisconnectReason.left(
          initiator: LeaveInitiator.callkit,
          message: 'Call put on hold',
        ),
      );
    }

    void verifyNotLeft(_MockCall target) =>
        verifyNever(() => target.leave(reason: any(named: 'reason')));

    test('leaves the call with the hold reason', () async {
      final target = await joined();

      await hold(isOnHold: true);

      verifyLeft(target);
    });

    test('leaves only the call whose cid the hold carries', () async {
      final first = await joined();
      final second = await joined(cid: 'default:other');

      await hold(isOnHold: true, cid: 'default:other');

      verifyLeft(second);
      verifyNotLeft(first);
    });

    test('a resume changes nothing', () async {
      final target = await joined();

      await hold(isOnHold: false);

      verifyNotLeft(target);
    });

    test(
      'a hold without a cid, or naming a call the app is not in, leaves nothing',
      () async {
        final target = await joined();

        await hold(isOnHold: true, cid: null);
        await hold(isOnHold: true, cid: 'default:unknown');

        verifyNotLeft(target);
      },
    );

    test('an incoming call not accepted yet is left alone', () async {
      final incoming = await joined(status: CallStatus.incoming());

      await hold(isOnHold: true);

      verifyNotLeft(incoming);
    });

    test(
      'a call in any other state is left, a ringing outgoing call included',
      () async {
        final calls = [
          await joined(
            cid: 'default:accepted',
            status: CallStatus.incoming(acceptedByMe: true),
          ),
          await joined(cid: 'default:outgoing', status: CallStatus.outgoing()),
          await joined(
            cid: 'default:connecting',
            status: CallStatusConnecting(),
          ),
          await joined(cid: 'default:connected', status: CallStatusConnected()),
        ];

        for (final target in calls) {
          await hold(isOnHold: true, cid: target.callCid.value);
          verifyLeft(target);
        }
      },
    );

    test('nothing is left while several calls may be active', () async {
      when(
        () => streamVideo.options,
      ).thenReturn(StreamVideoOptions(allowMultipleActiveCalls: true));
      final target = await joined();

      await hold(isOnHold: true);

      verifyNotLeft(target);
    });

    test(
      'a leave that fails or throws is logged and the observer goes on',
      () async {
        final target = await joined();
        when(
          () => target.leave(reason: any(named: 'reason')),
        ).thenAnswer(
          (_) async =>
              const Result.failure(StreamVideoException(message: 'boom')),
        );
        await hold(isOnHold: true);

        when(
          () => target.leave(reason: any(named: 'reason')),
        ).thenThrow(StateError('boom'));
        await hold(isOnHold: true, uuid: 'u2');
        verify(() => target.leave(reason: any(named: 'reason'))).called(2);

        when(() => controller.activeCalls()).thenAnswer(
          (_) async => [const CallData(uuid: 'u1', callCid: 'default:c1')],
        );
        platform.emit(const ActionCallToggleMute(uuid: 'u1', isMuted: true));
        await pumpEventQueue();
        verify(() => target.setMicrophoneEnabled(enabled: false)).called(1);
      },
    );

    test('is ignored on iOS', () async {
      final target = await joined();
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;

      await hold(isOnHold: true);

      verifyNotLeft(target);
    });
  });

  group('the calls Telecom holds', () {
    late List<Set<String>> reported;

    setUp(() {
      reported = [];
      observer.dispose();
      observer = RingingSyncObserver(
        streamVideo: streamVideo,
        client: client,
        controller: controller,
        ringingEvents: broadcaster.onEvent,
        onTelecomCallsChanged: reported.add,
      );
      addTearDown(observer.dispose);
    });

    Future<void> custom(Map<String, Object?> body) async {
      platform.emit(ActionCallCustom(body));
      await pumpEventQueue();
    }

    test('are passed on as the plugin reports them', () async {
      await start();

      await custom({
        'type': 'telecomCallsChanged',
        'callCids': ['default:c1', 'default:c2'],
      });
      await custom({'type': 'telecomCallsChanged', 'callCids': <String>[]});

      expect(reported, [
        {'default:c1', 'default:c2'},
        <String>{},
      ]);
    });

    test('are not passed on from a report without cids', () async {
      await start();

      await custom({'type': 'telecomCallsChanged'});

      expect(reported, isEmpty);
    });

    test('ignore other custom events', () async {
      await start();

      await custom({'type': 'telecomAudioEndpointsChanged', 'callCids': []});

      expect(reported, isEmpty);
    });
  });
}
