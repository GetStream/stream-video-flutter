import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_pin.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'fixtures/call_session_harness.dart';

const _sfuError = SfuError(
  message: 'join refused',
  code: SfuErrorCode.unspecified,
  shouldRetry: false,
  reconnectStrategy: SfuReconnectionStrategy.rejoin,
);

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  group('start wires the manager', () {
    test('an anonymous user gets a manager without a publisher and four '
        'callbacks', () async {
      final harness = CallSessionHarness();
      final rtcManager = harness.rtcManager;

      final result = await harness.session.start(isAnonymousUser: true);

      expect(result.isSuccess, isTrue);
      expect(harness.capturedPublisherId(), isNull);
      verify(() => rtcManager.onSubscriberIceCandidate = any()).called(1);
      verify(() => rtcManager.onRenegotiationNeeded = any()).called(1);
      verify(() => rtcManager.onReconnectionNeeded = any()).called(1);
      verify(() => rtcManager.onRemoteTrackReceived = any()).called(1);
      verifyNever(() => rtcManager.onPublisherIceCandidate = any());
      verifyNever(() => rtcManager.onLocalTrackMuted = any());
      verifyNever(() => rtcManager.onLocalTrackPublished = any());
    });

    test('a regular user publishes under the local participant prefix with '
        'seven callbacks', () async {
      final harness = CallSessionHarness();
      final rtcManager = harness.rtcManager;

      final result = await harness.session.start();

      expect(result.isSuccess, isTrue);
      expect(harness.capturedPublisherId(), 'local-prefix');
      verify(() => rtcManager.onPublisherIceCandidate = any()).called(1);
      verify(() => rtcManager.onSubscriberIceCandidate = any()).called(1);
      verify(() => rtcManager.onLocalTrackMuted = any()).called(1);
      verify(() => rtcManager.onLocalTrackPublished = any()).called(1);
      verify(() => rtcManager.onReconnectionNeeded = any()).called(1);
      verify(() => rtcManager.onRenegotiationNeeded = any()).called(1);
      verify(() => rtcManager.onRemoteTrackReceived = any()).called(1);
    });

    test('the wired callbacks reach the SFU and the call state', () async {
      final harness = CallSessionHarness();
      final rtcManager = harness.rtcManager;
      await harness.session.start();

      T captured<T>(void Function() setter) =>
          verify(setter).captured.single as T;
      final onPublisherIce = captured<OnIceCandidate>(
        () => rtcManager.onPublisherIceCandidate = captureAny(),
      );
      final onSubscriberIce = captured<OnIceCandidate>(
        () => rtcManager.onSubscriberIceCandidate = captureAny(),
      );
      final onRemoteTrack = captured<Function>(
        () => rtcManager.onRemoteTrackReceived = captureAny(),
      );

      final candidate = rtc.RTCIceCandidate('candidate', '0', 0);
      onPublisherIce(harness.publisher, candidate);
      onSubscriberIce(harness.subscriber, candidate);
      final trickles = verify(
        () => harness.sfuClient.iceTrickle(captureAny()),
      ).captured.cast<sfu_models.ICETrickle>();
      expect(
        [for (final t in trickles) t.peerType],
        [
          sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED,
          sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
        ],
      );
      expect(
        [for (final t in trickles) t.sessionId],
        [
          harnessSessionId,
          harnessSessionId,
        ],
      );

      final track = MockRtcRemoteTrack();
      when(() => track.trackIdPrefix).thenReturn('alice-prefix');
      when(() => track.trackType).thenReturn(SfuTrackType.video);
      when(() => track.isAudioTrack).thenReturn(false);
      when(track.start).thenAnswer((_) async {});
      // ignore: avoid_dynamic_calls
      await onRemoteTrack(harness.subscriber, track);
      verify(track.start).called(1);
      verify(
        () => harness.stateManager.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'alice-prefix',
          trackType: SfuTrackType.video,
        ),
      ).called(1);
    });

    test('events that arrive before the manager exists are handled once it '
        'is set, each once', () async {
      final harness = CallSessionHarness();
      // The join response is answered before the manager is created.
      await harness.session.start();
      await pumpEventQueue();

      verify(
        () => harness.stateManager.sfuJoinResponse(
          any(),
          subscriberReused: any(named: 'subscriberReused'),
        ),
      ).called(1);

      harness.events.emit(
        SfuParticipantJoinedEvent(
          callCid: 'cid',
          participant: harnessSfuParticipant(),
        ),
      );
      await pumpEventQueue();

      verify(() => harness.stateManager.sfuParticipantJoined(any())).called(1);
    });

    test('a success hands back the call state, applies pins and E2EE, and '
        'builds the stats reporter', () async {
      final harness = CallSessionHarness();
      const pin = SfuPin(userId: 'alice', sessionId: 'alice-session');
      final callState = harnessSfuCallState(
        pins: const [pin],
        e2eeEnabled: true,
      );
      harness.joinAnswer = () => SfuJoinResponseEvent(
        callState: callState,
        fastReconnectDeadline: const Duration(seconds: 3),
      );

      final result = await harness.session.start();

      final data = result.getDataOrNull()!;
      expect(data.callState, callState);
      expect(data.fastReconnectDeadline, const Duration(seconds: 3));
      verify(() => harness.stateManager.sfuPinsUpdated([pin])).called(1);
      verify(() => harness.stateManager.sfuE2eeEnabledUpdated(true)).called(1);
      expect(harness.session.rtcManager, same(harness.rtcManager));
      expect(harness.session.statsReporter, isNotNull);
      expect(harness.reporter.completedStages, [ClientEventOutcome.success]);
    });
  });

  group('start sends one join request', () {
    test('a first join asks for the client publish options', () async {
      final harness = CallSessionHarness(
        clientPublishOptions: ClientPublishOptions(
          preferredCodec: PreferredCodec.vp9,
          subscriberCodec: PreferredCodec.h264,
        ),
      );

      await harness.session.start(unifiedSessionId: 'unified');

      final request = harness.joinRequests.single;
      expect(request.sessionId, harnessSessionId);
      expect(request.token, 'test-token');
      expect(request.subscriberSdp, 'subscriber-sdp');
      expect(request.publisherSdp, 'publisher-sdp');
      expect(request.unifiedSessionId, 'unified');
      expect(request.hasReconnectDetails(), isFalse);
      expect(request.preferredPublishOptions.single.codec.name, 'vp9');
      expect(
        request.preferredSubscribeOptions.single.codecs.single.name,
        'h264',
      );
    });

    test('a rejoin asks for the publish options of the current manager and '
        'none for subscribing', () async {
      final harness = CallSessionHarness(
        clientPublishOptions: ClientPublishOptions(
          preferredCodec: PreferredCodec.vp9,
          subscriberCodec: PreferredCodec.h264,
        ),
      );
      harness.session.rtcManager = harness.rtcManager;
      when(
        () => harness.rtcManager.publishOptions,
      ).thenReturn(harnessPublishOptions);

      await harness.session.start(
        reconnectDetails: sfu_events.ReconnectDetails(
          strategy:
              WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_REJOIN,
        ),
      );

      final request = harness.joinRequests.single;
      expect(request.hasReconnectDetails(), isTrue);
      expect(request.preferredPublishOptions.single.codec.name, 'vp8');
      expect(request.preferredSubscribeOptions, isEmpty);
    });
  });

  group('start fails the wsJoin stage', () {
    test('when the socket does not connect', () async {
      final harness = CallSessionHarness();
      when(harness.sfuWS.connect).thenAnswer(
        (_) async =>
            const Result.failure(StreamVideoException(message: 'no socket')),
      );

      final result = await harness.session.start();

      expect(result.isFailure, isTrue);
      expect(harness.reporter.stageErrors, hasLength(1));
      expect(harness.joinRequests, isEmpty);
      expect(harness.session.rtcManager, isNull);
    });

    test('when the SFU answers the join with an error', () async {
      final harness = CallSessionHarness();
      harness.joinAnswer = () => const SfuErrorEvent(error: _sfuError);

      final result = await harness.session.start();

      expect(result.getErrorOrNull()?.message, 'join refused');
      expect(harness.reporter.stageErrors, [_sfuError]);
      expect(harness.session.rtcManager, isNull);
    });

    test('with a request timeout when the join is not answered in time', () {
      fakeAsync((async) {
        final harness = CallSessionHarness(
          joinResponseTimeout: const Duration(seconds: 2),
        );
        harness.joinAnswer = null;

        Result<Object?>? result;
        unawaited(harness.session.start().then((r) => result = r));
        async.elapse(const Duration(seconds: 2));

        expect(result?.isFailure, isTrue);
        expect(harness.reporter.stageFailures, [
          ClientEventStandardCode.requestTimeout,
        ]);
        expect(harness.takeTraceTags(), contains(TraceTag.joinRequestTimeout));
      });
    });

    // Bug 1 of FLU-1060, pinned as it behaves today: `start` waits only for
    // a join response or an SFU error, so a socket that closes during the
    // join fails it only at the timeout. CS4 makes it fail at once.
    test('only at the timeout when the socket closes during the join', () {
      fakeAsync((async) {
        final harness = CallSessionHarness(
          joinResponseTimeout: const Duration(seconds: 2),
        );
        harness.joinAnswer = () => const SfuSocketDisconnected(
          sessionId: harnessSessionId,
          url: 'wss://test.example.com/ws',
          reason: DisconnectionReason(
            closeReason: 'closed',
            isReconnectable: true,
          ),
        );

        Result<Object?>? result;
        unawaited(harness.session.start().then((r) => result = r));
        async.elapse(const Duration(milliseconds: 1900));
        expect(result, isNull);

        async.elapse(const Duration(milliseconds: 100));
        expect(result?.isFailure, isTrue);
        expect(harness.reporter.stageFailures, [
          ClientEventStandardCode.requestTimeout,
        ]);
      });
    });
  });
}
