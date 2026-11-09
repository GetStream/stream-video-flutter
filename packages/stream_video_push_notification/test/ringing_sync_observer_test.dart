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
const _caller = 'ada';
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

class _MockEndedEvent extends Mock implements StreamCallEndedEvent {}

class _MockCountEvent extends Mock
    implements StreamCallSessionParticipantCountUpdatedEvent {}

class _MockRejectedEvent extends Mock implements StreamCallRejectedEvent {}

class _MockAcceptedEvent extends Mock implements StreamCallAcceptedEvent {}

class _MockMetadata extends Mock implements CallMetadata {}

class _MockDetails extends Mock implements CallDetails {}

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
    when(
      () => controller.dismissRingingCallByCid(any()),
    ).thenAnswer((_) async {});

    platform = _FakePlatform();
    broadcaster = RingingEventBroadcaster(platform: platform);
    received = [];
    final subscription = broadcaster.onEvent.listen(received.add);
    addTearDown(subscription.cancel);

    observer = RingingSyncObserver(
      streamVideo: streamVideo,
      client: client,
      controller: controller,
      broadcaster: broadcaster,
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

  _MockEndedEvent ended() {
    final event = _MockEndedEvent();
    when(() => event.callCid).thenReturn(_cid);
    return event;
  }

  _MockCountEvent participants(Map<String, int> byRole) {
    final event = _MockCountEvent();
    when(() => event.callCid).thenReturn(_cid);
    when(() => event.participantsCountByRole).thenReturn(byRole);
    return event;
  }

  _MockRejectedEvent rejectedBy(String userId) {
    final details = _MockDetails();
    when(() => details.createdBy).thenReturn(
      const CallUser(id: _caller, name: _caller, roles: [], image: ''),
    );
    final metadata = _MockMetadata();
    when(() => metadata.details).thenReturn(details);
    final event = _MockRejectedEvent();
    when(() => event.callCid).thenReturn(_cid);
    when(() => event.rejectedByUserId).thenReturn(userId);
    when(() => event.metadata).thenReturn(metadata);
    return event;
  }

  _MockAcceptedEvent acceptedBy(String userId) {
    final event = _MockAcceptedEvent();
    when(() => event.callCid).thenReturn(_cid);
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
    return call;
  }

  group('backend subscriptions', () {
    test('are off until a call rings', () async {
      await start();

      backendEvents.emit(ended());
      await pumpEventQueue();

      verifyNever(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      );
    });

    test('start with the native incoming event', () async {
      await start();
      await ring();

      backendEvents.emit(ended());
      await pumpEventQueue();

      verify(() => controller.endCallByCid(_cid.value)).called(1);
    });

    test('start at start-up when the native side still shows a call', () async {
      when(() => controller.activeCalls()).thenAnswer(
        (_) async => [CallData(uuid: 'u1', callCid: _cid.value)],
      );
      await start();

      backendEvents.emit(ended());
      await pumpEventQueue();

      verify(() => controller.endCallByCid(_cid.value)).called(1);
    });

    test(
      'do not start when disposed before the start-up probe returns',
      () async {
        final probe = Completer<List<CallData>>();
        when(() => controller.activeCalls()).thenAnswer((_) => probe.future);
        observer.start();
        observer.dispose();
        probe.complete([CallData(uuid: 'u1', callCid: _cid.value)]);
        await pumpEventQueue();

        backendEvents.emit(ended());
        await pumpEventQueue();

        verifyNever(
          () => controller.endCallByCid(any(), silent: any(named: 'silent')),
        );
      },
    );

    test('a failing start-up probe is logged, not thrown', () async {
      when(
        () => controller.activeCalls(),
      ).thenAnswer((_) => Future.error(PlatformException(code: 'channel')));

      await start();

      backendEvents.emit(ended());
      await pumpEventQueue();
      verifyNever(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      );
    });

    test("stop with the user's answer", () async {
      await start();
      await ring();
      platform.emit(ActionCallAccept(data: CallData(callCid: _cid.value)));
      await pumpEventQueue();

      backendEvents.emit(ended());
      await pumpEventQueue();

      verifyNever(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      );
    });

    test(
      'the incoming event opens the backend connection when closed',
      () async {
        when(() => client.isConnected).thenReturn(false);
        await start();
        await ring();

        verify(() => client.openConnection()).called(1);
      },
    );

    test('the incoming event leaves an open connection alone', () async {
      await start();
      await ring();

      verifyNever(() => client.openConnection());
    });
  });

  group('while a call rings', () {
    setUp(() async {
      await start();
      await ring();
    });

    test(
      'a call ended event ends the native call and mutes the echo',
      () async {
        backendEvents.emit(ended());
        await pumpEventQueue();

        verify(() => controller.endCallByCid(_cid.value)).called(1);
        platform.emit(ActionCallEnded(data: CallData(callCid: _cid.value)));
        await pumpEventQueue();
        // Only the incoming event made it through; the end echo was suppressed.
        expect(received.whereType<ActionCallEnded>(), isEmpty);
      },
    );

    test('no participants left ends the native call', () async {
      backendEvents.emit(participants({'user': 0}));
      await pumpEventQueue();

      verify(() => controller.endCallByCid(_cid.value)).called(1);
    });

    test('participants still in the call change nothing', () async {
      backendEvents.emit(participants({'user': 2}));
      await pumpEventQueue();

      verifyNever(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      );
    });

    test('a rejection by the caller ends the native call', () async {
      backendEvents.emit(rejectedBy(_caller));
      await pumpEventQueue();

      verify(() => controller.endCallByCid(_cid.value)).called(1);
    });

    test('a rejection by the current user ends the native call', () async {
      backendEvents.emit(rejectedBy(_me));
      await pumpEventQueue();

      verify(() => controller.endCallByCid(_cid.value)).called(1);
    });

    test('a rejection by another member changes nothing', () async {
      backendEvents.emit(rejectedBy('someone-else'));
      await pumpEventQueue();

      verifyNever(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      );
    });

    test('an acceptance by another user changes nothing', () async {
      backendEvents.emit(acceptedBy('someone-else'));
      await pumpEventQueue();

      verifyNever(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      );
      verifyNever(() => controller.dismissRingingCallByCid(any()));
    });

    test('an acceptance on another device ends the native call', () async {
      backendEvents.emit(acceptedBy(_me));
      await pumpEventQueue();

      verify(() => controller.endCallByCid(_cid.value)).called(1);
      verifyNever(() => controller.dismissRingingCallByCid(any()));
    });

    test('an acceptance on this device dismisses the ring silently', () async {
      when(
        () => ringing.isCallAcceptedOnThisDevice(_cid.value),
      ).thenReturn(true);

      backendEvents.emit(acceptedBy(_me));
      await pumpEventQueue();

      verify(() => controller.dismissRingingCallByCid(_cid.value)).called(1);
      verifyNever(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      );
      platform.emit(ActionCallEnded(data: CallData(callCid: _cid.value)));
      await pumpEventQueue();
      expect(received.whereType<ActionCallEnded>(), isEmpty);
    });

    test('an active call on this device counts as accepted here', () async {
      // Built before the stub: the helper stubs too, and mocktail refuses a
      // `when` while another one is being set up.
      final active = call(
        cid: _cid.value,
        status: const CallStatusIncoming(acceptedByMe: true),
      );
      when(() => streamVideo.activeCalls).thenReturn([active]);

      backendEvents.emit(acceptedBy(_me));
      await pumpEventQueue();

      verify(() => controller.dismissRingingCallByCid(_cid.value)).called(1);
    });
  });

  group('the app leaving a call', () {
    test('ends the native call it left', () async {
      await start();
      final left = call(cid: _cid.value);
      final kept = call(cid: 'default:other');
      activeCalls.value = [left, kept];
      await pumpEventQueue();

      activeCalls.value = [kept];
      await pumpEventQueue();

      verify(() => controller.endCallByCid(_cid.value)).called(1);
      verifyNever(() => controller.endCallByCid('default:other'));
    });

    test('ends no more calls once disposed', () async {
      await start();
      final first = call(cid: _cid.value);
      final second = call(cid: 'default:other');
      activeCalls.value = [first, second];
      await pumpEventQueue();
      final ending = Completer<void>();
      when(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      ).thenAnswer((_) => ending.future);

      activeCalls.value = [];
      await pumpEventQueue();
      observer.dispose();
      ending.complete();
      await pumpEventQueue();

      verify(
        () => controller.endCallByCid(any(), silent: any(named: 'silent')),
      ).called(1);
    });
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
    await start();
    await ring();

    observer.dispose();
    backendEvents.emit(ended());
    activeCalls.value = [call(cid: _cid.value)];
    activeCalls.value = const [];
    await pumpEventQueue();

    verifyNever(
      () => controller.endCallByCid(any(), silent: any(named: 'silent')),
    );
  });
}
