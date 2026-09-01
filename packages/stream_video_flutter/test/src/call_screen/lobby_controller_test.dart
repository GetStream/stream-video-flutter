import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

const _localUserId = 'local-user';
final _callCid = StreamCallCid(cid: 'default:lobby');

const _headset = RtcMediaDevice(
  id: 'mic-2',
  label: 'Jabra Evolve2 65',
  kind: RtcMediaDeviceKind.audioInput,
);
const _speakers = RtcMediaDevice(
  id: 'out-1',
  label: 'MacBook Pro Speakers',
  kind: RtcMediaDeviceKind.audioOutput,
);
const _frontCamera = RtcMediaDevice(
  id: 'cam-1',
  label: 'FaceTime HD Camera',
  kind: RtcMediaDeviceKind.videoInput,
);

CallParticipant _participant(String id, {int joinedSecondsAgo = 0}) =>
    CallParticipant(
      userSessionId: 'session-$id',
      userId: id,
      role: 'user',
      joinedAt: DateTime(2026).add(Duration(seconds: -joinedSecondsAgo)),
    );

CallUser _user(String id) =>
    CallUser(id: id, name: id, roles: const [], image: '');

void main() {
  late MockCall call;
  late MockCallState callState;
  late MockStreamVideo video;
  late MockRtcMediaDeviceNotifier notifier;
  late StreamController<CoordinatorEvent> events;
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late Map<String, CallParticipant> sessionParticipants;

  setUp(() {
    events = StreamController<CoordinatorEvent>.broadcast();
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();
    sessionParticipants = {};

    notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

    video = MockStreamVideo();
    when(() => video.currentUser).thenReturn(const UserInfo(id: _localUserId));
    when(() => video.events).thenAnswer((_) => events.stream);

    callState = MockCallState();
    // Neither default is on, so constructing the controller opens no tracks:
    // RtcLocalTrack's factories are static and cannot be faked.
    when(() => callState.settings).thenReturn(
      const CallSettings(
        audio: StreamAudioSettings(micDefaultOn: false),
        video: StreamVideoSettings(cameraDefaultOn: false),
      ),
    );

    call = MockCall();
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(call.getOrCreate).thenAnswer((_) async {
      final metadata = MockCallMetadata();
      when(() => metadata.users).thenReturn({});
      when(() => metadata.session).thenReturn(
        CallSessionData(participants: sessionParticipants),
      );

      final data = MockCallCreatedData();
      when(() => data.metadata).thenReturn(metadata);
      return Result.success(
        CallReceivedOrCreatedData(wasCreated: true, data: data),
      );
    });
  });

  tearDown(() async {
    await events.close();
    await deviceChanges.close();
  });

  StreamLobbyController build() {
    final controller = StreamLobbyController(
      call: call,
      streamVideo: video,
      deviceNotifier: notifier,
    );
    addTearDown(controller.dispose);
    return controller;
  }

  group('StreamLobbyController', () {
    test('exposes one device controller for every action to share', () {
      expect(build().devices, isA<StreamMediaDevicesController>());
    });

    test('starts with the microphone and camera off', () {
      final controller = build();

      expect(controller.microphoneEnabled, isFalse);
      expect(controller.cameraEnabled, isFalse);
      expect(controller.microphoneError, isNull);
      expect(controller.cameraError, isNull);
    });

    test('lists the people already in the call, oldest first', () async {
      sessionParticipants = {
        'b': _participant('b', joinedSecondsAgo: 10),
        'a': _participant('a', joinedSecondsAgo: 30),
      };

      final controller = build();
      await pumpEventQueue();

      expect(controller.participants.map((it) => it.userId), ['a', 'b']);
    });

    test('leaves the local user out of the participant list', () async {
      sessionParticipants = {
        _localUserId: _participant(_localUserId),
        'a': _participant('a'),
      };

      final controller = build();
      await pumpEventQueue();

      expect(controller.participants.map((it) => it.userId), ['a']);
    });

    test('adds a participant that joins while the lobby is open', () async {
      final controller = build();
      await pumpEventQueue();

      events.add(
        CoordinatorCallSessionParticipantJoinedEvent(
          callCid: _callCid,
          createdAt: DateTime(2026),
          sessionId: 'session',
          user: _user('a'),
          participant: _participant('a'),
        ),
      );
      await pumpEventQueue();

      expect(controller.participants.map((it) => it.userId), ['a']);
      expect(controller.users.keys, ['a']);
    });

    test('drops a participant that leaves, and their user with them', () async {
      sessionParticipants = {'a': _participant('a')};
      final controller = build();
      await pumpEventQueue();

      events.add(
        CoordinatorCallSessionParticipantLeftEvent(
          callCid: _callCid,
          createdAt: DateTime(2026),
          sessionId: 'session',
          duration: Duration.zero,
          user: _user('a'),
          participant: _participant('a'),
        ),
      );
      await pumpEventQueue();

      expect(controller.participants, isEmpty);
      expect(controller.users, isEmpty);
    });

    // The SDK lobby used to drop these on the floor, so the call rejoined on
    // whatever the system considered default.
    test('carries the picked devices into the connect options', () async {
      final controller = build();

      await controller.devices.selectAudioInput(_headset);
      await controller.devices.selectAudioOutput(_speakers);
      await controller.devices.selectVideoInput(_frontCamera);

      final options = controller.connectOptions;
      expect(options.audioInputDevice, _headset);
      expect(options.audioOutputDevice, _speakers);
      expect(options.videoInputDevice, _frontCamera);
    });

    test('leaves a track disabled when it was never turned on', () {
      final options = build().connectOptions;

      expect(options.camera, isA<TrackDisabled>());
      expect(options.microphone, isA<TrackDisabled>());
    });

    test('records why the camera would not open', () async {
      when(call.ensureNativeFactory).thenThrow(StateError('no camera'));

      final controller = build();
      await controller.toggleCamera();

      expect(controller.cameraEnabled, isFalse);
      expect(controller.cameraError, isA<StateError>());
      expect(controller.hasCameraPermission, isFalse);
    });

    test('records why the microphone would not open', () async {
      when(call.ensureNativeFactory).thenThrow(StateError('no microphone'));

      final controller = build();
      await controller.toggleMicrophone();

      expect(controller.microphoneEnabled, isFalse);
      expect(controller.microphoneError, isA<StateError>());
      expect(controller.hasMicrophonePermission, isFalse);
    });

    test('hands the tracks over and takes them back', () {
      final controller = build();
      expect(controller.tracksHandedOver, isFalse);

      controller.handOverTracks();
      expect(controller.tracksHandedOver, isTrue);

      controller.reclaimTracks();
      expect(controller.tracksHandedOver, isFalse);
    });

    test('disposes the device controller with itself', () {
      final controller = StreamLobbyController(
        call: call,
        streamVideo: video,
        deviceNotifier: notifier,
      );
      final devices = controller.devices;
      controller.dispose();

      // A disposed ChangeNotifier throws when listened to.
      expect(() => devices.addListener(() {}), throwsFlutterError);
    });
  });
}
