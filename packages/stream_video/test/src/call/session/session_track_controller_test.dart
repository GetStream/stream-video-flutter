import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/session/session_track_controller.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import '../fixtures/data.dart';
import 'fixtures/call_session_harness.dart';

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

MockRtcRemoteTrack _remote(SfuTrackType type, {String prefix = 'alice'}) {
  final track = MockRtcRemoteTrack();
  when(() => track.trackId).thenReturn('$prefix:$type');
  when(() => track.trackIdPrefix).thenReturn(prefix);
  when(() => track.trackType).thenReturn(type);
  when(() => track.isAudioTrack).thenReturn(type == SfuTrackType.audio);
  when(track.start).thenAnswer((_) async {});
  when(track.disable).thenReturn(null);
  when(track.enable).thenReturn(null);
  when(
    () =>
        track.stop(disposeWebAudioPlayer: any(named: 'disposeWebAudioPlayer')),
  ).thenAnswer((_) async {});
  return track;
}

MockRtcLocalTrack _local(SfuTrackType type) {
  final track = MockRtcLocalTrack();
  when(() => track.trackId).thenReturn('local:$type');
  when(() => track.trackType).thenReturn(type);
  when(() => track.isAudioTrack).thenReturn(type == SfuTrackType.audio);
  when(() => track.isVideoTrack).thenReturn(type == SfuTrackType.video);
  when(
    () => track.isScreenShareTrack,
  ).thenReturn(type == SfuTrackType.screenShare);
  when(track.start).thenAnswer((_) async {});
  when(track.disable).thenReturn(null);
  when(track.enable).thenReturn(null);
  return track;
}

final _alice = harnessSfuParticipant(trackLookupPrefix: 'alice');

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  late MockRtcManager rtcManager;
  RtcManager? manager;
  late bool audioSuspended;
  late CallParticipantState? localParticipant;
  late bool selectedByUser;
  late RtcMediaDevice? audioOutput;
  late RtcMediaDevice? videoInput;
  late List<String> suspended;
  late List<RtcMediaDevice> outputsSet;
  late List<RtcMediaDevice> inputsSet;
  late List<bool> screenShares;
  late List<(RtcLocalTrack, bool)> muteStates;
  late List<(String, SfuTrackType)> subscriberTracks;
  late List<String> events;
  late Result<None> outputResult;
  late SessionTrackController controller;

  setUp(() {
    rtcManager = MockRtcManager();
    manager = rtcManager;
    audioSuspended = false;
    localParticipant = harnessParticipant(
      userId: 'me',
      sessionId: 'me-session',
      trackIdPrefix: 'local',
      isLocal: true,
    ).copyWith(publishedTracks: {SfuTrackType.audio: TrackState.local()});
    selectedByUser = false;
    audioOutput = null;
    videoInput = null;
    suspended = [];
    outputsSet = [];
    inputsSet = [];
    screenShares = [];
    muteStates = [];
    subscriberTracks = [];
    events = [];
    outputResult = const Result.success(none);
    when(() => rtcManager.getTrack(any())).thenReturn(null);
    when(() => rtcManager.localTracks).thenReturn(const {});
    when(() => rtcManager.remoteTracks).thenReturn(const {});

    controller = SessionTrackController(
      rtcManager: () => manager,
      getTrack: (prefix, type) => manager?.getTrack('$prefix:$type'),
      isAudioSuspended: () => audioSuspended,
      localParticipant: () => localParticipant,
      participants: () => [
        harnessParticipant(trackIdPrefix: 'alice'),
      ],
      audioOutputSelectedByUser: () => selectedByUser,
      audioOutputDevice: () => audioOutput,
      videoInputDevice: () => videoInput,
      onSuspendedAudioTrackRecorded: suspended.add,
      setAudioOutputDevice: (device) async {
        outputsSet.add(device);
        events.add('output');
        return outputResult;
      },
      setVideoInputDevice: (device) async {
        inputsSet.add(device);
        events.add('input');
      },
      setScreenShareEnabled: (enabled) async => screenShares.add(enabled),
      sendMuteState: (track, muted) {
        muteStates.add((track, muted));
        events.add('mute');
      },
      updateSubscriberTrack:
          ({required String trackIdPrefix, required SfuTrackType trackType}) =>
              subscriberTracks.add((trackIdPrefix, trackType)),
      logTag: 'test',
    );
  });

  void give(RtcTrack track) {
    // Read outside the stub: a mock call inside `when` confuses mocktail.
    final trackId = track.trackId;
    when(() => rtcManager.getTrack(trackId)).thenReturn(track);
  }

  SfuTrackPublishedEvent published(SfuTrackType type, {String? userId}) =>
      SfuTrackPublishedEvent(
        userId: userId ?? 'alice',
        sessionId: 'alice-session',
        trackType: type,
        participant: _alice,
      );

  SfuTrackUnpublishedEvent unpublished(SfuTrackType type) =>
      SfuTrackUnpublishedEvent(
        userId: 'alice',
        sessionId: 'alice-session',
        trackType: type,
        participant: _alice,
      );

  group('track published', () {
    test('a remote video track starts', () async {
      final track = _remote(SfuTrackType.video);
      give(track);

      await controller.onTrackPublished(published(SfuTrackType.video));

      verify(track.start).called(1);
      expect(outputsSet, isEmpty);
    });

    test('a remote audio track starts and re-applies the selected '
        'output', () async {
      selectedByUser = true;
      audioOutput = SampleCallData.defaultMediaDevice;
      final track = _remote(SfuTrackType.audio);
      when(track.start).thenAnswer((_) async => events.add('start'));
      give(track);

      await controller.onTrackPublished(published(SfuTrackType.audio));

      expect(outputsSet, [SampleCallData.defaultMediaDevice]);
      expect(events, ['start', 'output']);
    });

    test('an output the user did not select is not re-applied', () async {
      audioOutput = SampleCallData.defaultMediaDevice;
      final track = _remote(SfuTrackType.audio);
      give(track);

      await controller.onTrackPublished(published(SfuTrackType.audio));

      expect(outputsSet, isEmpty);
    });

    test(
      'a remote audio track is suspended while audio is suspended',
      () async {
        audioSuspended = true;
        final track = _remote(SfuTrackType.audio);
        give(track);

        await controller.onTrackPublished(published(SfuTrackType.audio));

        verify(track.disable).called(1);
        verifyNever(track.start);
        expect(suspended, ['alice:${SfuTrackType.audio}']);
      },
    );

    test('a local track is left alone', () async {
      final track = _local(SfuTrackType.video);
      when(
        () => rtcManager.getTrack('alice:${SfuTrackType.video}'),
      ).thenReturn(track);

      await controller.onTrackPublished(published(SfuTrackType.video));

      verifyNever(track.start);
    });

    test('a participant without the track is ignored', () async {
      await controller.onTrackPublished(published(SfuTrackType.video));

      verify(
        () => rtcManager.getTrack('alice:${SfuTrackType.video}'),
      ).called(1);
    });

    test('a failing output re-apply is swallowed', () async {
      selectedByUser = true;
      audioOutput = SampleCallData.defaultMediaDevice;
      outputResult = const Result.failure(StreamVideoException(message: 'no'));
      final track = _remote(SfuTrackType.audio);
      give(track);

      await controller.onTrackPublished(published(SfuTrackType.audio));

      expect(outputsSet, hasLength(1));
    });

    test('an unknown participant is ignored', () async {
      await controller.onTrackPublished(
        published(SfuTrackType.video, userId: 'mallory'),
      );

      verifyNever(() => rtcManager.getTrack(any()));
    });
  });

  group('track unpublished', () {
    test('a remote track stops and keeps its web audio player', () async {
      final track = _remote(SfuTrackType.audio);
      give(track);

      await controller.onTrackUnpublished(unpublished(SfuTrackType.audio));

      verify(() => track.stop(disposeWebAudioPlayer: false)).called(1);
    });

    for (final (name, type, enabled, expected) in [
      ('a still-enabled screen share', SfuTrackType.screenShare, true, [false]),
      ('a disabled screen share', SfuTrackType.screenShare, false, <bool>[]),
      ('an enabled camera', SfuTrackType.video, true, <bool>[]),
    ]) {
      test(
        'a local track, $name, '
        '${expected.isEmpty ? 'leaves sharing alone' : 'turns sharing off'}',
        () async {
          final track = _local(type);
          final mediaTrack = _MockMediaStreamTrack();
          when(() => mediaTrack.enabled).thenReturn(enabled);
          when(() => track.mediaTrack).thenReturn(mediaTrack);
          // Found under the participant's prefix, then looked up again under
          // its own id.
          when(() => rtcManager.getTrack('alice:$type')).thenReturn(track);
          give(track);

          await controller.onTrackUnpublished(unpublished(type));

          expect(screenShares, expected);
        },
      );
    }
  });

  group('local track published', () {
    test('an audio track starts, re-applies the output and is '
        'unmuted', () async {
      selectedByUser = true;
      audioOutput = SampleCallData.defaultMediaDevice;
      final track = _local(SfuTrackType.audio);

      await controller.onLocalTrackPublished(track);

      verify(track.start).called(1);
      expect(outputsSet, hasLength(1));
      expect(inputsSet, isEmpty);
      expect(muteStates, [(track, false)]);
    });

    test('a video track starts and re-applies the selected input', () async {
      videoInput = SampleCallData.defaultMediaDevice;
      final track = _local(SfuTrackType.video);
      when(track.start).thenAnswer((_) async => events.add('start'));

      await controller.onLocalTrackPublished(track);

      expect(inputsSet, [SampleCallData.defaultMediaDevice]);
      expect(events, ['start', 'input', 'mute']);
      expect(muteStates, [(track, false)]);
    });

    test('an audio track is suspended while audio is suspended, and still '
        'unmuted', () async {
      audioSuspended = true;
      final track = _local(SfuTrackType.audio);

      await controller.onLocalTrackPublished(track);

      verify(track.disable).called(1);
      verifyNever(track.start);
      expect(suspended, ['local:${SfuTrackType.audio}']);
      expect(muteStates, [(track, false)]);
    });
  });

  group('remote track received', () {
    test('starts the track and records it', () async {
      final track = _remote(SfuTrackType.video);

      await controller.onRemoteTrackReceived(MockTracedPeerConnection(), track);

      verify(track.start).called(1);
      expect(subscriberTracks, [('alice', SfuTrackType.video)]);
    });

    test('suspends audio while audio is suspended, and still records '
        'it', () async {
      audioSuspended = true;
      final track = _remote(SfuTrackType.audio);

      await controller.onRemoteTrackReceived(MockTracedPeerConnection(), track);

      verifyNever(track.start);
      expect(suspended, ['alice:${SfuTrackType.audio}']);
      expect(subscriberTracks, [('alice', SfuTrackType.audio)]);
    });
  });

  test('replayRemoteTracks hands every remote track over again', () async {
    final subscriber = MockTracedPeerConnection();
    final video = _remote(SfuTrackType.video);
    final audio = _remote(SfuTrackType.audio, prefix: 'bob');
    when(() => rtcManager.subscriber).thenReturn(subscriber);
    when(() => rtcManager.remoteTracks).thenReturn({
      video.trackId: video,
      audio.trackId: audio,
    });

    await controller.replayRemoteTracks();

    verify(video.start).called(1);
    verify(audio.start).called(1);
    expect(subscriberTracks, [
      ('alice', SfuTrackType.video),
      ('bob', SfuTrackType.audio),
    ]);
  });

  group('resumeSuspendedAudioTracks', () {
    late MockRtcRemoteTrack remoteAudio;
    late MockRtcLocalTrack localMic;

    setUp(() {
      remoteAudio = _remote(SfuTrackType.audio);
      localMic = _local(SfuTrackType.audio);
      when(
        () => rtcManager.localTracks,
      ).thenReturn({localMic.trackId: localMic});
      when(
        () => rtcManager.remoteTracks,
      ).thenReturn({remoteAudio.trackId: remoteAudio});
      give(remoteAudio);
      give(localMic);
    });

    test('re-enables what was enabled and starts what never started', () async {
      selectedByUser = true;
      audioOutput = SampleCallData.defaultMediaDevice;

      await controller.resumeSuspendedAudioTracks({
        remoteAudio.trackId: SuspendedTrackState.neverStarted,
        localMic.trackId: SuspendedTrackState.wasEnabled,
      });

      verify(remoteAudio.start).called(1);
      verify(localMic.enable).called(1);
      expect(outputsSet, hasLength(1));
    });

    test('leaves what was disabled, and what has no prior state', () async {
      await controller.resumeSuspendedAudioTracks({
        remoteAudio.trackId: SuspendedTrackState.wasDisabled,
      });

      verifyNever(remoteAudio.start);
      verifyNever(remoteAudio.enable);
      verifyNever(localMic.enable);
    });

    test('keeps a microphone muted since the suspension off', () async {
      localParticipant = localParticipant!.copyWith(publishedTracks: {});

      await controller.resumeSuspendedAudioTracks({
        localMic.trackId: SuspendedTrackState.wasEnabled,
      });

      verifyNever(localMic.enable);
    });

    test(
      'treats the microphone as muted without a local participant',
      () async {
        localParticipant = null;

        await controller.resumeSuspendedAudioTracks({
          localMic.trackId: SuspendedTrackState.neverStarted,
        });

        verifyNever(localMic.start);
      },
    );

    test('skips a track removed before its turn', () async {
      final trackId = remoteAudio.trackId;
      when(() => rtcManager.getTrack(trackId)).thenReturn(null);

      await controller.resumeSuspendedAudioTracks({
        remoteAudio.trackId: SuspendedTrackState.neverStarted,
      });

      verifyNever(remoteAudio.start);
    });

    test('does nothing without a manager', () async {
      manager = null;

      await controller.resumeSuspendedAudioTracks({
        remoteAudio.trackId: SuspendedTrackState.neverStarted,
      });

      verifyNever(remoteAudio.start);
    });
  });
}
