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
  late CallSettings callSettings;

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

    // Neither default is on, so constructing the controller opens no tracks
    // unless a test asks for it.
    callSettings = const CallSettings(
      audio: StreamAudioSettings(micDefaultOn: false),
      video: StreamVideoSettings(cameraDefaultOn: false),
    );

    callState = MockCallState();
    when(() => callState.settings).thenReturn(callSettings);

    call = MockCall();
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(call.get).thenAnswer((_) async {
      final metadata = MockCallMetadata();
      when(() => metadata.users).thenReturn({});
      when(() => metadata.session).thenReturn(
        CallSessionData(participants: sessionParticipants),
      );
      // The defaults are applied from the fetched metadata, not from the
      // state the call starts with, so this is what decides them.
      when(() => metadata.settings).thenReturn(callSettings);

      return Result.success(
        CallReceivedData(callCid: _callCid, metadata: metadata),
      );
    });
  });

  tearDown(() async {
    await events.close();
    await deviceChanges.close();
  });

  StreamLobbyController build({
    LobbyAudioTrackOpener? openMicrophoneTrack,
    LobbyCameraTrackOpener? openCameraTrack,
    // Off for the tests that dispose the controller themselves: dispose is
    // not idempotent, matching every other ChangeNotifier.
    bool autoDispose = true,
  }) {
    final controller = StreamLobbyController(
      call: call,
      streamVideo: video,
      deviceNotifier: notifier,
      openMicrophoneTrack: openMicrophoneTrack,
      openCameraTrack: openCameraTrack,
    );
    if (autoDispose) addTearDown(controller.dispose);
    return controller;
  }

  /// A microphone and a camera that record whether they were stopped.
  ///
  /// [RtcLocalTrack]'s factories are static, so the only way to observe what
  /// the controller does with a track it has opened is to hand it one.
  ({MockRtcLocalAudioTrack microphone, MockRtcLocalCameraTrack camera})
  fakeTracks() {
    final microphone = MockRtcLocalAudioTrack();
    when(microphone.stop).thenAnswer((_) async {});

    final camera = MockRtcLocalCameraTrack();
    when(camera.stop).thenAnswer((_) async {});
    when(() => camera.mediaConstraints).thenReturn(const CameraConstraints());

    return (microphone: microphone, camera: camera);
  }

  group('StreamLobbyController', () {
    // Showing a waiting room is not a decision to create the call. What a
    // call is created with — its encryption mode above all, which cannot be
    // changed afterwards — belongs to whoever creates it.
    test('reads the call and never creates it', () async {
      build();
      await pumpEventQueue();

      verify(call.get).called(1);
      verifyNever(call.getOrCreate);
    });

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

    // The fetch returns a snapshot of the session while the event
    // subscription is already live, so a join already reflected in that
    // snapshot still arrives as an event. Appending it blindly listed the same
    // person twice.
    test(
      'does not list someone twice when the snapshot already had them',
      () async {
        sessionParticipants = {'a': _participant('a')};
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

        expect(controller.participants, hasLength(1));
      },
    );

    // Identity is the session, not the user: someone on a phone and a laptop
    // is two participants and belongs in the list twice.
    test('lists a second session of the same user separately', () async {
      final controller = build();
      await pumpEventQueue();

      for (final sessionId in ['phone', 'laptop']) {
        events.add(
          CoordinatorCallSessionParticipantJoinedEvent(
            callCid: _callCid,
            createdAt: DateTime(2026),
            sessionId: 'session',
            user: _user('a'),
            participant: CallParticipant(
              userSessionId: sessionId,
              userId: 'a',
              role: 'user',
            ),
          ),
        );
      }
      await pumpEventQueue();

      expect(controller.participants, hasLength(2));
    });

    test('ignores a join event for the local user', () async {
      final controller = build();
      await pumpEventQueue();

      events.add(
        CoordinatorCallSessionParticipantJoinedEvent(
          callCid: _callCid,
          createdAt: DateTime(2026),
          sessionId: 'session',
          user: _user(_localUserId),
          participant: _participant(_localUserId),
        ),
      );
      await pumpEventQueue();

      expect(controller.participants, isEmpty);
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
      expect(controller.hasOpenedCamera, isFalse);
    });

    test('records why the microphone would not open', () async {
      when(call.ensureNativeFactory).thenThrow(StateError('no microphone'));

      final controller = build();
      await controller.toggleMicrophone();

      expect(controller.microphoneEnabled, isFalse);
      expect(controller.microphoneError, isA<StateError>());
      expect(controller.hasOpenedMicrophone, isFalse);
    });

    group('an unusable device', () {
      test(
        'stays retryable after a failed open, and a retry clears it',
        () async {
          final tracks = fakeTracks();
          var attempts = 0;
          final controller = build(
            openMicrophoneTrack: () async {
              attempts++;
              // Busy the first time — another app holding the device — then
              // free, as it is once that app lets go.
              if (attempts == 1) throw StateError('device in use');
              return tracks.microphone;
            },
          );

          await controller.toggleMicrophone();
          expect(controller.microphoneError, isA<StateError>());
          // Badged, so the user can see something is wrong...
          expect(controller.microphoneUnavailable, isTrue);
          // ...but not written off: there is a device, it just would not open.
          expect(controller.microphoneMissing, isFalse);

          await controller.toggleMicrophone();

          expect(attempts, 2);
          expect(controller.microphoneEnabled, isTrue);
          expect(controller.microphoneError, isNull);
          expect(controller.microphoneUnavailable, isFalse);
        },
      );

      test('is written off once the platform reports no device', () async {
        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async => tracks.microphone,
        );

        await controller.toggleMicrophone();
        // A live track is proof the device exists, so it is not missing yet
        // however empty the enumeration is.
        deviceChanges.add(const []);
        await pumpEventQueue();
        expect(controller.microphoneMissing, isFalse);

        // Turned off, and now the platform names nothing: the device is gone
        // rather than merely unasked, and there is nothing to retry.
        await controller.toggleMicrophone();

        expect(controller.microphoneMissing, isTrue);
        expect(controller.microphoneUnavailable, isTrue);
      });
    });

    group('the call defaults', () {
      test(
        'come from the fetched call, not from the state it starts in',
        () async {
          // A CallState is constructed with `const CallSettings()`, whose two
          // defaults are both on, and the real settings only arrive with the
          // metadata. Reading the state too early opened a microphone on a call
          // configured to start muted.
          // Both spelled out: which one wins is the whole point here.
          // ignore: avoid_redundant_argument_values
          callSettings = const CallSettings(
            audio: StreamAudioSettings(micDefaultOn: false),
            // ignore: avoid_redundant_argument_values
            video: StreamVideoSettings(cameraDefaultOn: true),
          );
          when(() => callState.settings).thenReturn(const CallSettings());

          final tracks = fakeTracks();
          final controller = build(
            openMicrophoneTrack: () async => tracks.microphone,
            openCameraTrack: (_) async => tracks.camera,
          );
          await pumpEventQueue();

          expect(controller.microphoneEnabled, isFalse);
          expect(controller.cameraEnabled, isTrue);
        },
      );

      test('fall back to the call state when the fetch fails', () async {
        when(call.get).thenAnswer(
          (_) async => Result.failure(StateError('offline'), StackTrace.empty),
        );
        when(() => callState.settings).thenReturn(
          const CallSettings(
            // ignore: avoid_redundant_argument_values
            audio: StreamAudioSettings(micDefaultOn: true),
            video: StreamVideoSettings(cameraDefaultOn: false),
          ),
        );

        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async => tracks.microphone,
          openCameraTrack: (_) async => tracks.camera,
        );
        await pumpEventQueue();

        // A lobby that cannot reach the coordinator is still a lobby.
        expect(controller.microphoneEnabled, isTrue);
        expect(controller.cameraEnabled, isFalse);
        expect(controller.fetchError, isA<StateError>());
        expect(controller.participants, isEmpty);
      });
    });

    group('lifecycle', () {
      test(
        'hands the tracks to the call, so disposing the lobby leaves them '
        'running',
        () async {
          final tracks = fakeTracks();
          final controller = build(
            openMicrophoneTrack: () async => tracks.microphone,
            openCameraTrack: (_) async => tracks.camera,
            autoDispose: false,
          );

          await controller.toggleMicrophone();
          await controller.toggleCamera();
          expect(controller.microphoneEnabled, isTrue);
          expect(controller.cameraEnabled, isTrue);

          // What StreamLobbyView does when the join button is pressed: read
          // the options, then mark the tracks as the call's.
          final options = controller.connectOptions;
          controller.handOverTracks();
          controller.dispose();

          // The whole point: the call is publishing these, so the lobby must
          // not have stopped them on its way out.
          verifyNever(tracks.microphone.stop);
          verifyNever(tracks.camera.stop);
          expect(controller.tracksHandedOver, isTrue);

          // And the live tracks are the very ones the call is told to join
          // with, so the feed carries across without reopening the hardware.
          expect(
            (options.microphone as TrackProvided).track,
            same(tracks.microphone),
          );
          expect(
            (options.camera as TrackProvided).track,
            same(tracks.camera),
          );
        },
      );

      // What StreamLobbyView does when onJoinCallPressed returns false: the
      // join did not happen, so the preview is the lobby's again and leaving
      // it stops the tracks after all.
      test('stops the tracks when a handed-over join did not happen', () async {
        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async => tracks.microphone,
          openCameraTrack: (_) async => tracks.camera,
          autoDispose: false,
        );

        await controller.toggleMicrophone();
        await controller.toggleCamera();

        controller.handOverTracks();
        controller.reclaimTracks();
        expect(controller.tracksHandedOver, isFalse);

        controller.dispose();

        verify(tracks.microphone.stop).called(1);
        verify(tracks.camera.stop).called(1);
      });

      test('stops the tracks when the lobby is left without joining', () async {
        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async => tracks.microphone,
          openCameraTrack: (_) async => tracks.camera,
          autoDispose: false,
        );

        await controller.toggleMicrophone();
        await controller.toggleCamera();
        controller.dispose();

        verify(tracks.microphone.stop).called(1);
        verify(tracks.camera.stop).called(1);
      });

      test('stops a track that finishes opening after dispose', () async {
        final tracks = fakeTracks();
        final opening = Completer<RtcLocalCameraTrack>();
        final controller = build(
          openCameraTrack: (_) => opening.future,
          autoDispose: false,
        );

        final pending = controller.toggleCamera();
        // The user backs out while the permission prompt is still up.
        controller.dispose();
        opening.complete(tracks.camera);
        await pending;

        // Nobody is left to hand this to a call, so the lobby owns it.
        verify(tracks.camera.stop).called(1);
        expect(controller.cameraEnabled, isFalse);
      });

      test('does not notify after being disposed', () async {
        final tracks = fakeTracks();
        final opening = Completer<RtcLocalAudioTrack>();
        final controller = build(
          openMicrophoneTrack: () => opening.future,
          autoDispose: false,
        );

        final pending = controller.toggleMicrophone();
        controller.dispose();
        opening.complete(tracks.microphone);

        // A post-dispose notifyListeners throws, so completing without one is
        // the assertion.
        await expectLater(pending, completes);
      });

      test('opens one track however fast the button is tapped', () async {
        final tracks = fakeTracks();
        var opens = 0;
        final opening = Completer<RtcLocalAudioTrack>();
        final controller = build(
          openMicrophoneTrack: () {
            opens++;
            return opening.future;
          },
        );

        final first = controller.toggleMicrophone();
        final second = controller.toggleMicrophone();
        opening.complete(tracks.microphone);
        await Future.wait([first, second]);

        expect(opens, 1);
        expect(controller.microphoneEnabled, isTrue);
      });

      test(
        'applies the call defaults unless the lobby is left first',
        () async {
          callSettings = const CallSettings();

          final tracks = fakeTracks();
          var opens = 0;
          final controller = build(
            openMicrophoneTrack: () async {
              opens++;
              return tracks.microphone;
            },
            openCameraTrack: (_) async {
              opens++;
              return tracks.camera;
            },
            autoDispose: false,
          );

          // Disposed inside the same frame, before the deferred defaults run.
          controller.dispose();
          await pumpEventQueue();

          expect(opens, 0);
        },
      );
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
