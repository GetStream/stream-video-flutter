import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import 'fixtures/call_session_harness.dart';

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

final _alice = harnessSfuParticipant();

SfuTrackPublishedEvent _published(SfuTrackType type, {String? userId}) =>
    SfuTrackPublishedEvent(
      userId: userId ?? 'alice',
      sessionId: 'alice-session',
      trackType: type,
      participant: _alice,
    );

SfuTrackUnpublishedEvent _unpublished(SfuTrackType type) =>
    SfuTrackUnpublishedEvent(
      userId: 'alice',
      sessionId: 'alice-session',
      trackType: type,
      participant: _alice,
    );

MockRtcRemoteTrack _remoteTrack(SfuTrackType type) {
  final track = MockRtcRemoteTrack();
  when(() => track.trackId).thenReturn('alice-prefix:$type');
  when(() => track.trackIdPrefix).thenReturn('alice-prefix');
  when(() => track.trackType).thenReturn(type);
  when(() => track.isAudioTrack).thenReturn(type == SfuTrackType.audio);
  when(track.start).thenAnswer((_) async {});
  when(
    () =>
        track.stop(disposeWebAudioPlayer: any(named: 'disposeWebAudioPlayer')),
  ).thenAnswer((_) async {});
  when(track.disable).thenReturn(null);
  return track;
}

MockRtcLocalTrack _localTrack(SfuTrackType type) {
  final track = MockRtcLocalTrack();
  when(() => track.trackId).thenReturn('local-prefix:$type');
  when(() => track.trackType).thenReturn(type);
  when(() => track.isAudioTrack).thenReturn(type == SfuTrackType.audio);
  when(() => track.isVideoTrack).thenReturn(type == SfuTrackType.video);
  when(
    () => track.isScreenShareTrack,
  ).thenReturn(type == SfuTrackType.screenShare);
  when(track.start).thenAnswer((_) async {});
  when(track.disable).thenReturn(null);
  return track;
}

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  late CallSessionHarness harness;

  setUp(() {
    harness = CallSessionHarness();
    harness.session.rtcManager = harness.rtcManager;
    harness.state = harness.state.copyWith(
      callParticipants: [harnessParticipant()],
    );
  });

  void giveAliceTrack(RtcTrack track, SfuTrackType type) {
    when(
      () => harness.rtcManager.getTrack('alice-prefix:$type'),
    ).thenReturn(track);
  }

  group('track published', () {
    test('a remote video track starts', () async {
      final track = _remoteTrack(SfuTrackType.video);
      giveAliceTrack(track, SfuTrackType.video);

      await harness.session.debugHandleSfuEvent(
        _published(SfuTrackType.video),
      );

      verify(track.start).called(1);
      verifyNever(() => harness.stateManager.audioOutputSelectedByUser);
    });

    test(
      'a remote audio track starts and re-applies the audio output',
      () async {
        final track = _remoteTrack(SfuTrackType.audio);
        giveAliceTrack(track, SfuTrackType.audio);

        await harness.session.debugHandleSfuEvent(
          _published(SfuTrackType.audio),
        );

        verifyInOrder([
          track.start,
          () => harness.stateManager.audioOutputSelectedByUser,
        ]);
      },
    );

    test(
      'a remote audio track is suspended while audio is suspended',
      () async {
        harness.state = harness.state.copyWith(isAudioSuspended: true);
        final track = _remoteTrack(SfuTrackType.audio);
        giveAliceTrack(track, SfuTrackType.audio);

        await harness.session.debugHandleSfuEvent(
          _published(SfuTrackType.audio),
        );

        verify(track.disable).called(1);
        verifyNever(track.start);
        expect(harness.suspendedTrackIds, [
          'alice-prefix:${SfuTrackType.audio}',
        ]);
      },
    );

    test('a local track is left to the user', () async {
      final track = _localTrack(SfuTrackType.video);
      giveAliceTrack(track, SfuTrackType.video);

      await harness.session.debugHandleSfuEvent(
        _published(SfuTrackType.video),
      );

      verifyNever(track.start);
    });

    test('an unknown participant is ignored', () async {
      await harness.session.debugHandleSfuEvent(
        _published(SfuTrackType.video, userId: 'mallory'),
      );

      verifyNever(() => harness.rtcManager.getTrack(any()));
    });

    test('an unknown track is ignored', () async {
      await harness.session.debugHandleSfuEvent(
        _published(SfuTrackType.video),
      );

      verify(
        () => harness.rtcManager.getTrack('alice-prefix:${SfuTrackType.video}'),
      ).called(1);
      verify(() => harness.stateManager.sfuTrackPublished(any())).called(1);
    });
  });

  group('track unpublished', () {
    test('a remote track stops and keeps its web audio player', () async {
      final track = _remoteTrack(SfuTrackType.audio);
      giveAliceTrack(track, SfuTrackType.audio);

      await harness.session.debugHandleSfuEvent(
        _unpublished(SfuTrackType.audio),
      );

      verify(() => track.stop(disposeWebAudioPlayer: false)).called(1);
    });

    test('a local camera track is left to the user', () async {
      final track = _localTrack(SfuTrackType.video);
      final mediaTrack = _MockMediaStreamTrack();
      when(() => mediaTrack.enabled).thenReturn(true);
      when(() => track.mediaTrack).thenReturn(mediaTrack);
      giveAliceTrack(track, SfuTrackType.video);
      // Looked up again under its own id; only its kind keeps sharing on.
      when(
        () => harness.rtcManager.getTrack('local-prefix:${SfuTrackType.video}'),
      ).thenReturn(track);

      await harness.session.debugHandleSfuEvent(
        _unpublished(SfuTrackType.video),
      );

      verify(() => harness.stateManager.sfuTrackUnpublished(any())).called(1);
    });

    test('a disabled local screen share is left alone', () async {
      final track = _localTrack(SfuTrackType.screenShare);
      final mediaTrack = _MockMediaStreamTrack();
      when(() => mediaTrack.enabled).thenReturn(false);
      when(() => track.mediaTrack).thenReturn(mediaTrack);
      giveAliceTrack(track, SfuTrackType.screenShare);
      // Looked up again under its own id.
      when(
        () => harness.rtcManager.getTrack(
          'local-prefix:${SfuTrackType.screenShare}',
        ),
      ).thenReturn(track);

      await harness.session.debugHandleSfuEvent(
        _unpublished(SfuTrackType.screenShare),
      );

      verify(() => mediaTrack.enabled).called(1);
      verify(() => harness.stateManager.sfuTrackUnpublished(any())).called(1);
    });

    // The server muted the share. `setScreenShareEnabled` reaches
    // RtcManager's private members, which the mock lacks, so getting there
    // throws.
    test(
      'a still-enabled local screen share turns screen sharing off',
      () async {
        final track = _localTrack(SfuTrackType.screenShare);
        final mediaTrack = _MockMediaStreamTrack();
        when(() => mediaTrack.enabled).thenReturn(true);
        when(() => track.mediaTrack).thenReturn(mediaTrack);
        giveAliceTrack(track, SfuTrackType.screenShare);
        // Looked up again under its own id.
        when(
          () => harness.rtcManager.getTrack(
            'local-prefix:${SfuTrackType.screenShare}',
          ),
        ).thenReturn(track);

        await expectLater(
          harness.session.debugHandleSfuEvent(
            _unpublished(SfuTrackType.screenShare),
          ),
          throwsA(
            isA<NoSuchMethodError>().having(
              (e) => '$e',
              'message',
              contains('_cancelPendingBroadcast'),
            ),
          ),
        );
      },
    );
  });

  group('ICE restart', () {
    test('the publisher restarts ICE and renegotiates outside the events '
        'lock', () async {
      final calls = <String>[];
      when(harness.publisher.restartIce).thenAnswer((_) async {
        calls.add('restartIce');
        return const Result.success(null);
      });
      final negotiation = Completer<bool>();
      when(harness.rtcManager.isPublisherEmpty).thenAnswer((_) {
        calls.add('isPublisherEmpty');
        return negotiation.future;
      });

      await harness.session
          .debugHandleSfuEvent(
            const SfuIceRestartEvent(peerType: StreamPeerType.publisher),
          )
          .timeout(const Duration(seconds: 1));
      // The renegotiation still runs, yet the next event is not held up.
      await harness.session
          .debugHandleSfuEvent(
            SfuParticipantJoinedEvent(callCid: 'cid', participant: _alice),
          )
          .timeout(const Duration(seconds: 1));

      expect(calls, ['restartIce', 'isPublisherEmpty']);
      verify(() => harness.stateManager.sfuParticipantJoined(any())).called(1);
      verifyNever(harness.subscriber.restartIce);
      negotiation.complete(true);
      await pumpEventQueue();
    });

    test('the subscriber only restarts ICE', () async {
      await harness.session.debugHandleSfuEvent(
        const SfuIceRestartEvent(peerType: StreamPeerType.subscriber),
      );
      await pumpEventQueue();

      verify(harness.subscriber.restartIce).called(1);
      verifyNever(harness.publisher.restartIce);
      verifyNever(harness.rtcManager.isPublisherEmpty);
    });

    test('a session without a publisher skips the publisher restart', () async {
      when(() => harness.rtcManager.publisher).thenReturn(null);

      await harness.session.debugHandleSfuEvent(
        const SfuIceRestartEvent(peerType: StreamPeerType.publisher),
      );
      await pumpEventQueue();

      verifyNever(harness.rtcManager.isPublisherEmpty);
      verifyNever(harness.subscriber.restartIce);
    });
  });

  group('local track published', () {
    // Typed as the session's handler, which the typedef hides behind void.
    late Future<void> Function(RtcLocalTrack) onLocalTrackPublished;
    late OnLocalTrackMuted onLocalTrackMuted;

    setUp(() async {
      final fresh = CallSessionHarness();
      harness = fresh;
      await fresh.session.start();
      onLocalTrackPublished =
          verify(
                () => fresh.rtcManager.onLocalTrackPublished = captureAny(),
              ).captured.single
              as Future<void> Function(RtcLocalTrack);
      onLocalTrackMuted =
          verify(
                () => fresh.rtcManager.onLocalTrackMuted = captureAny(),
              ).captured.single
              as OnLocalTrackMuted;
    });

    sfu.UpdateMuteStatesRequest sentMuteState() =>
        verify(
              () => harness.sfuClient.updateMuteState(captureAny()),
            ).captured.single
            as sfu.UpdateMuteStatesRequest;

    test('an audio track starts, re-applies the audio output and is '
        'unmuted', () async {
      final track = _localTrack(SfuTrackType.audio);

      await onLocalTrackPublished(track);

      verifyInOrder([
        track.start,
        () => harness.stateManager.audioOutputSelectedByUser,
      ]);
      final request = sentMuteState();
      expect(request.sessionId, harnessSessionId);
      expect(request.muteStates.single.muted, isFalse);
      expect(
        request.muteStates.single.trackType,
        sfu_models.TrackType.TRACK_TYPE_AUDIO,
      );
    });

    test('an audio track is suspended while audio is suspended, and still '
        'unmuted', () async {
      harness.state = harness.state.copyWith(isAudioSuspended: true);
      final track = _localTrack(SfuTrackType.audio);

      await onLocalTrackPublished(track);

      verify(track.disable).called(1);
      verifyNever(track.start);
      expect(harness.suspendedTrackIds, ['local-prefix:${SfuTrackType.audio}']);
      expect(sentMuteState().muteStates.single.muted, isFalse);
    });

    test('a video track starts and re-applies the video input', () async {
      final track = _localTrack(SfuTrackType.video);
      clearInteractions(harness.stateManager);

      await onLocalTrackPublished(track);

      verify(track.start).called(1);
      verifyNever(() => harness.stateManager.audioOutputSelectedByUser);
      // Read for the selected video input; none is selected here.
      verify(() => harness.stateManager.callStateStream).called(1);
      expect(sentMuteState().muteStates.single.muted, isFalse);
    });

    // Bug 5 of FLU-1060, pinned as it behaves today: the mute state RPC is
    // not awaited, so the next one is sent before it completes.
    test('the mute state is sent without waiting for the SFU', () async {
      final rpc = Completer<Result<sfu.UpdateMuteStatesResponse>>();
      when(
        () => harness.sfuClient.updateMuteState(any()),
      ).thenAnswer((_) => rpc.future);

      onLocalTrackMuted(_localTrack(SfuTrackType.audio), true);
      await onLocalTrackPublished(
        _localTrack(SfuTrackType.video),
      ).timeout(const Duration(seconds: 1));

      final requests = verify(
        () => harness.sfuClient.updateMuteState(captureAny()),
      ).captured.cast<sfu.UpdateMuteStatesRequest>();
      expect(
        [for (final r in requests) r.muteStates.single.muted],
        [
          true,
          false,
        ],
      );
      expect(rpc.isCompleted, isFalse);
    });
  });
}
