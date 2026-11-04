import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_pin.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_session_harness.dart';

final _reconnectDetails = sfu_events.ReconnectDetails(
  strategy: WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_FAST,
);

CallSessionHarness _connectedHarness() {
  final harness = CallSessionHarness();
  harness.session.rtcManager = harness.rtcManager;
  return harness;
}

void _expectReconnectingClearedOnBoth(CallSessionHarness harness) {
  for (final pc in [harness.subscriber, harness.publisher]) {
    expect(
      verify(() => pc.setReconnecting(captureAny())).captured,
      [true, false],
    );
  }
}

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  group('fastReconnect exits', () {
    test('a socket that cannot be recreated fails before the join', () async {
      final harness = _connectedHarness();
      when(harness.sfuWS.recreate).thenAnswer(
        (_) async =>
            const Result.failure(StreamVideoException(message: 'no socket')),
      );

      final result = await harness.session.fastReconnect(
        reconnectDetails: _reconnectDetails,
      );

      expect(result.getErrorOrNull()?.message, contains('no socket'));
      expect(harness.joinRequests, isEmpty);
      expect(harness.takeTraceTags(), [
        TraceTag.fastReconnect,
        TraceTag.fastReconnectFailure,
      ]);
      _expectReconnectingClearedOnBoth(harness);
    });

    test('a join request that cannot be sent fails', () async {
      final harness = _connectedHarness();
      when(() => harness.sfuWS.send(any())).thenReturn(
        const Result.failure(StreamVideoException(message: 'not open')),
      );

      final result = await harness.session.fastReconnect(
        reconnectDetails: _reconnectDetails,
      );

      expect(result.getErrorOrNull()?.message, contains('not open'));
      verifyNever(
        () => harness.sfuWS.waitForJoinResponse(
          timeLimit: any(named: 'timeLimit'),
        ),
      );
      expect(harness.takeTraceTags(), [
        TraceTag.fastReconnect,
        TraceTag.fastReconnectFailure,
      ]);
      _expectReconnectingClearedOnBoth(harness);
    });

    test('an unanswered join fails with the wait error', () async {
      final harness = _connectedHarness();
      when(
        () => harness.sfuWS.waitForJoinResponse(
          timeLimit: any(named: 'timeLimit'),
        ),
      ).thenAnswer(
        (_) async =>
            const Result.failure(StreamVideoException(message: 'no answer')),
      );

      final result = await harness.session.fastReconnect(
        reconnectDetails: _reconnectDetails,
      );

      expect(result.getErrorOrNull()?.message, 'no answer');
      verify(
        () => harness.sfuWS.waitForJoinResponse(
          timeLimit: const Duration(seconds: 15),
        ),
      ).called(1);
      expect(harness.takeTraceTags(), [
        TraceTag.fastReconnect,
        TraceTag.fastReconnectFailure,
      ]);
      _expectReconnectingClearedOnBoth(harness);
    });

    test('a join the SFU did not resume fails as not resumed', () async {
      final harness = _connectedHarness();
      when(
        () => harness.sfuWS.waitForJoinResponse(
          timeLimit: any(named: 'timeLimit'),
        ),
      ).thenAnswer(
        (_) async => Result.success(
          SfuJoinResponseEvent(callState: harnessSfuCallState()),
        ),
      );

      final result = await harness.session.fastReconnect(
        reconnectDetails: _reconnectDetails,
      );

      expect(
        (result as Failure).error,
        isA<SfuSessionNotResumedException>(),
      );
      verifyNever(() => harness.stateManager.sfuPinsUpdated(any()));
      verifyNever(harness.publisherPc.restartIce);
      expect(harness.takeTraceTags(), [
        TraceTag.fastReconnect,
        TraceTag.fastReconnectFailure,
      ]);
      _expectReconnectingClearedOnBoth(harness);
    });

    test('a failed renegotiation turns a resumed join into a failure and '
        'still replays the remote tracks', () async {
      final harness = _connectedHarness();
      final track = MockRtcRemoteTrack();
      when(() => track.trackIdPrefix).thenReturn('alice-prefix');
      when(() => track.trackType).thenReturn(SfuTrackType.video);
      when(() => track.isAudioTrack).thenReturn(false);
      when(track.start).thenAnswer((_) async {});
      when(
        () => harness.rtcManager.remoteTracks,
      ).thenReturn({'alice-prefix:video': track});
      // The renegotiation refuses to run on a socket it sees as closed.
      when(() => harness.sfuWS.isConnected).thenReturn(false);

      final result = await harness.session.fastReconnect(
        reconnectDetails: _reconnectDetails,
      );

      expect(
        result.getErrorOrNull()?.message,
        contains('SFU WS is not connected'),
      );
      verify(() => harness.stateManager.sfuPinsUpdated(any())).called(1);
      verify(harness.publisherPc.restartIce).called(1);
      verify(track.start).called(1);
      expect(harness.takeTraceTags(), [
        TraceTag.fastReconnect,
        TraceTag.fastReconnectFailure,
      ]);
      _expectReconnectingClearedOnBoth(harness);
    });

    test('a resumed join succeeds with the call state', () async {
      final harness = _connectedHarness();
      const pin = SfuPin(userId: 'alice', sessionId: 'alice-session');
      final callState = harnessSfuCallState(
        pins: const [pin],
        e2eeEnabled: true,
      );
      when(
        () => harness.sfuWS.waitForJoinResponse(
          timeLimit: any(named: 'timeLimit'),
        ),
      ).thenAnswer(
        (_) async => Result.success(
          SfuJoinResponseEvent(
            callState: callState,
            isReconnected: true,
            fastReconnectDeadline: const Duration(seconds: 4),
          ),
        ),
      );

      final result = await harness.session.fastReconnect(
        reconnectDetails: _reconnectDetails,
      );

      final data = result.getDataOrNull()!;
      expect(data.callState, callState);
      expect(data.fastReconnectDeadline, const Duration(seconds: 4));
      verify(() => harness.stateManager.sfuPinsUpdated([pin])).called(1);
      verify(() => harness.stateManager.sfuE2eeEnabledUpdated(true)).called(1);
      verify(harness.publisherPc.restartIce).called(1);
      verify(harness.rtcManager.isPublisherEmpty).called(1);
      expect(harness.takeTraceTags(), [
        TraceTag.fastReconnect,
        TraceTag.fastReconnectSuccess,
      ]);
      _expectReconnectingClearedOnBoth(harness);
    });

    test(
      'a throw while preparing the join fails and clears reconnecting',
      () async {
        final harness = _connectedHarness();
        when(
          () => harness.pcFactory.getGenericSdp(any()),
        ).thenThrow(StateError('no offer'));

        final result = await harness.session.fastReconnect(
          reconnectDetails: _reconnectDetails,
        );

        expect(result.isFailure, isTrue);
        expect(harness.takeTraceTags(), [
          TraceTag.fastReconnect,
          TraceTag.fastReconnectFailure,
        ]);
        _expectReconnectingClearedOnBoth(harness);
      },
    );
  });

  group('fastReconnect join request', () {
    test('carries the details, the current publish options and no '
        'subscribe options', () async {
      final harness = _connectedHarness();
      when(
        () => harness.rtcManager.publishOptions,
      ).thenReturn(harnessPublishOptions);

      await harness.session.fastReconnect(
        reconnectDetails: _reconnectDetails,
        unifiedSessionId: 'unified',
      );

      final request = harness.joinRequests.single;
      expect(request.sessionId, harnessSessionId);
      expect(request.token, 'test-token');
      expect(request.subscriberSdp, 'subscriber-sdp');
      expect(request.publisherSdp, 'publisher-sdp');
      expect(request.reconnectDetails, _reconnectDetails);
      expect(request.unifiedSessionId, 'unified');
      expect(request.preferredPublishOptions.single.codec.name, 'vp8');
      expect(request.preferredSubscribeOptions, isEmpty);
    });
  });

  group('fastReconnect replays remote tracks', () {
    test('every remote track starts and reaches the call state', () async {
      final harness = _connectedHarness();
      final tracks = {
        for (final (prefix, type) in [
          ('alice-prefix', SfuTrackType.video),
          ('bob-prefix', SfuTrackType.audio),
        ])
          '$prefix:$type': () {
            final track = MockRtcRemoteTrack();
            when(() => track.trackIdPrefix).thenReturn(prefix);
            when(() => track.trackType).thenReturn(type);
            when(() => track.trackId).thenReturn('$prefix:$type');
            when(
              () => track.isAudioTrack,
            ).thenReturn(type == SfuTrackType.audio);
            when(track.start).thenAnswer((_) async {});
            when(track.disable).thenReturn(null);
            return track;
          }(),
      };
      when(() => harness.rtcManager.remoteTracks).thenReturn(tracks);

      await harness.session.fastReconnect(reconnectDetails: _reconnectDetails);

      for (final track in tracks.values) {
        verify(track.start).called(1);
      }
      // The audio track re-applies the audio output after it starts.
      verify(() => harness.stateManager.audioOutputSelectedByUser).called(1);
      verifyInOrder([
        () => harness.stateManager.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'alice-prefix',
          trackType: SfuTrackType.video,
        ),
        () => harness.stateManager.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'bob-prefix',
          trackType: SfuTrackType.audio,
        ),
      ]);
    });

    test('a remote audio track is suspended while audio is suspended and '
        'still reaches the call state', () async {
      final harness = _connectedHarness();
      harness.state = harness.state.copyWith(isAudioSuspended: true);
      final track = MockRtcRemoteTrack();
      when(() => track.trackId).thenReturn('bob-prefix:audio');
      when(() => track.trackIdPrefix).thenReturn('bob-prefix');
      when(() => track.trackType).thenReturn(SfuTrackType.audio);
      when(() => track.isAudioTrack).thenReturn(true);
      when(track.disable).thenReturn(null);
      when(
        () => harness.rtcManager.remoteTracks,
      ).thenReturn({'bob-prefix:audio': track});

      await harness.session.fastReconnect(reconnectDetails: _reconnectDetails);

      verify(track.disable).called(1);
      verifyNever(track.start);
      expect(harness.suspendedTrackIds, ['bob-prefix:audio']);
      verify(
        () => harness.stateManager.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'bob-prefix',
          trackType: SfuTrackType.audio,
        ),
      ).called(1);
    });
  });
}
