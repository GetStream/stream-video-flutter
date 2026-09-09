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
const _backCamera = RtcMediaDevice(
  id: 'cam-2',
  label: 'Studio Display Camera',
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
  late MockRtcMediaDeviceNotifier notifier;
  late MutableSharedEmitter<StreamCallEvent> events;
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late Map<String, CallParticipant> sessionParticipants;
  late CallSettings callSettings;

  setUp(() {
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();
    sessionParticipants = {};

    notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

    // Neither default is on, so constructing the controller opens no tracks
    // unless a test asks for it.
    callSettings = const CallSettings(
      audio: StreamAudioSettings(micDefaultOn: false),
      video: StreamVideoSettings(cameraDefaultOn: false),
    );

    callState = MockCallState();
    when(() => callState.settings).thenReturn(callSettings);

    call = MockCall();
    events = stubLobbyCall(
      call,
      callState,
      currentUser: const UserInfo(id: _localUserId),
      callCid: _callCid,
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

      events.emit(
        StreamCallSessionParticipantJoinedEvent(
          _callCid,
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

        events.emit(
          StreamCallSessionParticipantJoinedEvent(
            _callCid,
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
        events.emit(
          StreamCallSessionParticipantJoinedEvent(
            _callCid,
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

    // The coordinator's socket carries every call the user is in, so a call
    // ringing in the background used to move people in and out of this
    // lobby's list.
    test('ignores an event for another call', () async {
      sessionParticipants = {'a': _participant('a')};
      final controller = build();
      await pumpEventQueue();

      events
        ..emit(
          StreamCallSessionParticipantJoinedEvent(
            StreamCallCid(cid: 'default:other'),
            createdAt: DateTime(2026),
            sessionId: 'session',
            user: _user('b'),
            participant: _participant('b'),
          ),
        )
        ..emit(
          StreamCallSessionParticipantLeftEvent(
            StreamCallCid(cid: 'default:other'),
            createdAt: DateTime(2026),
            sessionId: 'session',
            duration: Duration.zero,
            user: _user('a'),
            participant: _participant('a'),
          ),
        );
      await pumpEventQueue();

      expect(controller.participants.map((it) => it.userId), ['a']);
    });

    test('ignores a join event for the local user', () async {
      final controller = build();
      await pumpEventQueue();

      events.emit(
        StreamCallSessionParticipantJoinedEvent(
          _callCid,
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

      events.emit(
        StreamCallSessionParticipantLeftEvent(
          _callCid,
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
      expect(controller.cameraError?.cause, isA<StateError>());
      // Nothing in "no camera" names a cause the SDK can act on, so it is
      // reported as unknown rather than guessed at.
      expect(controller.cameraError?.reason, StreamDeviceFailureReason.unknown);
      expect(controller.hasOpenedCamera, isFalse);
    });

    test('records why the microphone would not open', () async {
      when(call.ensureNativeFactory).thenThrow(StateError('no microphone'));

      final controller = build();
      await controller.toggleMicrophone();

      expect(controller.microphoneEnabled, isFalse);
      expect(controller.microphoneError?.cause, isA<StateError>());
      expect(
        controller.microphoneError?.reason,
        StreamDeviceFailureReason.unknown,
      );
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
          // "device in use" classifies as a device another app is holding,
          // which is exactly the retryable kind.
          expect(
            controller.microphoneError?.reason,
            StreamDeviceFailureReason.deviceBusy,
          );
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

      // The fetch is a network round-trip and the toggles are live from the
      // first frame, so the defaults arrive after the user can already have
      // acted. Applying them as a toggle undid the tap.
      test('leave a device the user already reached for alone', () async {
        callSettings = const CallSettings(
          // ignore: avoid_redundant_argument_values
          audio: StreamAudioSettings(micDefaultOn: true),
          video: StreamVideoSettings(cameraDefaultOn: false),
        );

        final fetched = Completer<Result<CallReceivedData>>();
        when(call.get).thenAnswer((_) => fetched.future);

        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async => tracks.microphone,
          openCameraTrack: (_) async => tracks.camera,
        );

        // The user unmutes before the call's own default lands.
        await controller.toggleMicrophone();
        expect(controller.microphoneEnabled, isTrue);

        final metadata = MockCallMetadata();
        when(() => metadata.users).thenReturn({});
        when(() => metadata.session).thenReturn(const CallSessionData());
        when(() => metadata.settings).thenReturn(callSettings);
        fetched.complete(
          Result.success(
            CallReceivedData(callCid: _callCid, metadata: metadata),
          ),
        );
        await pumpEventQueue();

        // Still on, and never stopped: the default agreed with the tap here,
        // but a toggle would have turned it off regardless.
        expect(controller.microphoneEnabled, isTrue);
        verifyNever(tracks.microphone.stop);
      });

      test('do not invert a tap that disagrees with them', () async {
        callSettings = const CallSettings(
          audio: StreamAudioSettings(micDefaultOn: false),
          // ignore: avoid_redundant_argument_values
          video: StreamVideoSettings(cameraDefaultOn: true),
        );

        final fetched = Completer<Result<CallReceivedData>>();
        when(call.get).thenAnswer((_) => fetched.future);

        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async => tracks.microphone,
          openCameraTrack: (_) async => tracks.camera,
        );

        // The user turns the camera on, then the call says it should be on
        // too. A toggle would read "already on" and switch it off.
        await controller.toggleCamera();
        expect(controller.cameraEnabled, isTrue);

        final metadata = MockCallMetadata();
        when(() => metadata.users).thenReturn({});
        when(() => metadata.session).thenReturn(const CallSessionData());
        when(() => metadata.settings).thenReturn(callSettings);
        fetched.complete(
          Result.success(
            CallReceivedData(callCid: _callCid, metadata: metadata),
          ),
        );
        await pumpEventQueue();

        expect(controller.cameraEnabled, isTrue);
        verifyNever(tracks.camera.stop);
      });
    });

    group('setting a device rather than toggling it', () {
      test('asking for the state it is already in does nothing', () async {
        var opens = 0;
        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async {
            opens++;
            return tracks.microphone;
          },
        );

        await controller.setMicrophoneEnabled(enabled: true);
        await controller.setMicrophoneEnabled(enabled: true);

        expect(opens, 1);
        expect(controller.microphoneEnabled, isTrue);

        await controller.setMicrophoneEnabled(enabled: false);
        await controller.setMicrophoneEnabled(enabled: false);

        expect(controller.microphoneEnabled, isFalse);
        verify(tracks.microphone.stop).called(1);
      });

      // Turning a device off while it is still opening has nothing to stop
      // yet. Dropping that tap left the user with the microphone on after
      // they had asked twice for it to be off.
      test('a tap during an open is not lost', () async {
        final opening = Completer<RtcLocalAudioTrack>();
        final tracks = fakeTracks();
        final controller = build(openMicrophoneTrack: () => opening.future);

        final turningOn = controller.setMicrophoneEnabled(enabled: true);
        expect(controller.isOpeningMicrophone, isTrue);

        // The user changes their mind before the platform has answered.
        await controller.setMicrophoneEnabled(enabled: false);

        opening.complete(tracks.microphone);
        await turningOn;
        await pumpEventQueue();

        // The track that landed is released rather than kept: nothing wants
        // it any more.
        expect(controller.microphoneEnabled, isFalse);
        verify(tracks.microphone.stop).called(1);
      });

      test('reports an open in flight', () async {
        final opening = Completer<RtcLocalAudioTrack>();
        final tracks = fakeTracks();
        final controller = build(openMicrophoneTrack: () => opening.future);

        expect(controller.isOpeningMicrophone, isFalse);

        final pending = controller.setMicrophoneEnabled(enabled: true);
        expect(controller.isOpeningMicrophone, isTrue);

        opening.complete(tracks.microphone);
        await pending;

        expect(controller.isOpeningMicrophone, isFalse);
        expect(controller.microphoneEnabled, isTrue);
      });
    });

    group('switching camera', () {
      test('opens the newly picked device', () async {
        final tracks = fakeTracks();
        final second = MockRtcLocalCameraTrack();
        when(second.stop).thenAnswer((_) async {});
        when(() => second.mediaConstraints).thenReturn(
          const CameraConstraints(),
        );

        final opened = <String?>[];
        final controller = build(
          openCameraTrack: (deviceId) async {
            opened.add(deviceId);
            return opened.length == 1 ? tracks.camera : second;
          },
        );

        deviceChanges.add(const [_frontCamera, _backCamera]);
        await pumpEventQueue();

        await controller.toggleCamera();
        expect(controller.cameraTrack, tracks.camera);

        await controller.devices.selectVideoInput(_backCamera);
        await pumpEventQueue();

        // The old track was released and the new one opened against the id
        // the user picked, not against the system default.
        verify(tracks.camera.stop).called(1);
        expect(opened, [null, _backCamera.id]);
        expect(controller.cameraTrack, second);
        expect(controller.devices.selectedVideoInput, _backCamera);
      });

      test('leaves a camera the user turned off alone', () async {
        var opens = 0;
        final controller = build(
          openCameraTrack: (_) async {
            opens++;
            return fakeTracks().camera;
          },
        );

        deviceChanges.add(const [_frontCamera, _backCamera]);
        await pumpEventQueue();

        await controller.devices.selectVideoInput(_backCamera);
        await pumpEventQueue();

        // Picking a device is not a request to start filming.
        expect(opens, 0);
        expect(controller.cameraEnabled, isFalse);
        expect(controller.devices.selectedVideoInput, _backCamera);
      });

      // The open is async, and the pick can change while it runs. Landing the
      // first track and stopping there left the preview on the old camera
      // with the picker naming the new one.
      test('ends up on the last device picked, however fast', () async {
        final opened = <String?>[];
        final firstOpening = Completer<RtcLocalCameraTrack>();

        RtcLocalCameraTrack trackFor() {
          final track = MockRtcLocalCameraTrack();
          when(track.stop).thenAnswer((_) async {});
          when(
            () => track.mediaConstraints,
          ).thenReturn(const CameraConstraints());
          return track;
        }

        final controller = build(
          openCameraTrack: (deviceId) {
            opened.add(deviceId);
            // Only the first open is held; the rest resolve on their own, so
            // completing the first cannot deadlock on a later one.
            if (opened.length == 1) return firstOpening.future;
            return Future.value(trackFor());
          },
        );

        deviceChanges.add(const [_frontCamera, _backCamera]);
        await pumpEventQueue();

        final firstOpen = controller.toggleCamera();
        // Pick a different camera while the first is still opening.
        final picking = controller.devices.selectVideoInput(_backCamera);

        firstOpening.complete(trackFor());
        await firstOpen;
        await picking;
        await pumpEventQueue();

        // The camera the user last picked is the one the preview reconciled
        // onto, and the picker agrees with it.
        expect(opened, [null, _backCamera.id]);
        expect(controller.devices.selectedVideoInput, _backCamera);
        expect(controller.cameraEnabled, isTrue);
      });

      test('puts the picker back when the new device will not open', () async {
        final tracks = fakeTracks();
        final controller = build(
          openCameraTrack: (deviceId) async {
            if (deviceId == _backCamera.id) throw StateError('device busy');
            return tracks.camera;
          },
        );

        deviceChanges.add(const [_frontCamera, _backCamera]);
        await pumpEventQueue();

        await controller.toggleCamera();
        await controller.devices.selectVideoInput(_backCamera);
        await pumpEventQueue();

        // The selection never claims a camera the hardware refused.
        expect(controller.devices.selectedVideoInput, isNot(_backCamera));
        expect(controller.cameraError, isNotNull);
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

      // A host can navigate away while its join is still in flight, so the
      // lobby is disposed with the tracks handed over and the join then fails.
      // Nothing but a late reclaim is left that can release the hardware.
      test('stops handed-over tracks when the reclaim arrives late', () async {
        final tracks = fakeTracks();
        final controller = build(
          openMicrophoneTrack: () async => tracks.microphone,
          openCameraTrack: (_) async => tracks.camera,
          autoDispose: false,
        );

        await controller.toggleMicrophone();
        await controller.toggleCamera();

        controller.handOverTracks();
        controller.dispose();

        // Still running: as far as dispose knew, a call was publishing them.
        verifyNever(tracks.microphone.stop);
        verifyNever(tracks.camera.stop);

        controller.reclaimTracks();

        // The join never happened, so the microphone and camera go off rather
        // than staying live with nothing left to own them.
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
        deviceNotifier: notifier,
      );
      final devices = controller.devices;
      controller.dispose();

      // A disposed ChangeNotifier throws when listened to.
      expect(() => devices.addListener(() {}), throwsFlutterError);
    });
  });
}
