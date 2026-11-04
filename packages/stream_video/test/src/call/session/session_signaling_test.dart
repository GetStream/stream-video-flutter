import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/session/publisher_negotiator.dart';
import 'package:stream_video/src/call/session/session_signaling.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import 'fixtures/call_session_harness.dart';

class _MockPublisherNegotiator extends Mock implements PublisherNegotiator {}

const _offer = SfuSubscriberOfferEvent(
  sdp: 'offer-sdp',
  iceRestart: false,
  negotiationId: 9,
);

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  late MockSfuClient sfuClient;
  late MockRtcManager rtcManager;
  late MockTracedPeerConnection publisher;
  late MockTracedPeerConnection subscriber;
  late _MockPublisherNegotiator negotiator;
  late bool leavingOrClosed;
  late bool callDisconnected;
  RtcManager? manager;
  late SessionSignaling signaling;

  setUp(() {
    sfuClient = MockSfuClient();
    rtcManager = MockRtcManager();
    publisher = MockTracedPeerConnection();
    subscriber = MockTracedPeerConnection();
    negotiator = _MockPublisherNegotiator();
    leavingOrClosed = false;
    callDisconnected = false;
    manager = rtcManager;

    when(() => publisher.type).thenReturn(StreamPeerType.publisher);
    when(() => subscriber.type).thenReturn(StreamPeerType.subscriber);
    for (final pc in [publisher, subscriber]) {
      when(pc.restartIce).thenAnswer((_) async => const Result.success(null));
    }
    when(() => rtcManager.publisher).thenReturn(publisher);
    when(() => rtcManager.subscriber).thenReturn(subscriber);
    when(
      () => rtcManager.onSubscriberOffer(any()),
    ).thenAnswer((_) async => 'answer-sdp');
    when(
      () => rtcManager.onRemoteIceCandidate(
        peerType: any(named: 'peerType'),
        iceCandidate: any(named: 'iceCandidate'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    when(() => sfuClient.sendAnswer(any())).thenAnswer(
      (_) async => Result.success(sfu.SendAnswerResponse()),
    );
    when(() => sfuClient.iceTrickle(any())).thenAnswer(
      (_) async => Result.success(sfu.ICETrickleResponse()),
    );
    when(() => sfuClient.updateMuteState(any())).thenAnswer(
      (_) async => Result.success(sfu.UpdateMuteStatesResponse()),
    );
    when(() => negotiator.negotiateOrRecover(any())).thenAnswer((_) async {});

    signaling = SessionSignaling(
      sfuClient: sfuClient,
      sessionId: 'session',
      rtcManager: () => manager,
      negotiator: negotiator,
      isLeavingOrClosed: () => leavingOrClosed,
      isCallDisconnected: () => callDisconnected,
      logTag: 'test',
    );
  });

  group('subscriber offer', () {
    test('is answered with the manager answer and the offer negotiation '
        'id', () async {
      await signaling.onSubscriberOffer(_offer);

      verify(() => rtcManager.onSubscriberOffer('offer-sdp')).called(1);
      final request =
          verify(() => sfuClient.sendAnswer(captureAny())).captured.single
              as sfu.SendAnswerRequest;
      expect(request.sdp, 'answer-sdp');
      expect(request.sessionId, 'session');
      expect(request.peerType, sfu_models.PeerType.PEER_TYPE_SUBSCRIBER);
      expect(request.negotiationId, 9);
    });

    for (final (name, setUpGuard) in [
      ('the session is leaving', () => leavingOrClosed = true),
      ('the call is disconnected', () => callDisconnected = true),
    ]) {
      test('is ignored while $name', () async {
        setUpGuard();

        await signaling.onSubscriberOffer(_offer);

        verifyNever(() => rtcManager.onSubscriberOffer(any()));
        verifyNever(() => sfuClient.sendAnswer(any()));
      });
    }

    test('is not answered without an answer', () async {
      when(
        () => rtcManager.onSubscriberOffer(any()),
      ).thenAnswer((_) async => null);

      await signaling.onSubscriberOffer(_offer);

      verifyNever(() => sfuClient.sendAnswer(any()));
    });

    test('is not answered once the session left mid-offer', () async {
      final answer = Completer<String?>();
      when(
        () => rtcManager.onSubscriberOffer(any()),
      ).thenAnswer((_) => answer.future);

      final handled = signaling.onSubscriberOffer(_offer);
      leavingOrClosed = true;
      answer.complete('answer-sdp');
      await handled;

      verifyNever(() => sfuClient.sendAnswer(any()));
    });
  });

  group('ICE candidates', () {
    test('a remote candidate goes to the peer connection it names', () async {
      await signaling.onRemoteIceCandidate(
        const SfuIceTrickleEvent(
          sessionId: 'session',
          peerType: StreamPeerType.subscriber,
          iceCandidate: 'candidate',
        ),
      );

      verify(
        () => rtcManager.onRemoteIceCandidate(
          peerType: StreamPeerType.subscriber,
          iceCandidate: 'candidate',
        ),
      ).called(1);
    });

    test('a local candidate is trickled with its peer type', () {
      final candidate = rtc.RTCIceCandidate('candidate', '0', 0);

      signaling
        ..onLocalIceCandidate(publisher, candidate)
        ..onLocalIceCandidate(subscriber, candidate);

      final trickles = verify(
        () => sfuClient.iceTrickle(captureAny()),
      ).captured.cast<sfu_models.ICETrickle>();
      expect(
        [for (final t in trickles) t.peerType],
        [
          sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED,
          sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
        ],
      );
      for (final trickle in trickles) {
        expect(trickle.sessionId, 'session');
        expect(trickle.iceCandidate, json.encode(candidate.toMap()));
      }
    });
  });

  group('ICE restart', () {
    test('the publisher restarts ICE, then renegotiates without being '
        'awaited', () async {
      final negotiation = Completer<void>();
      when(
        () => negotiator.negotiateOrRecover(any()),
      ).thenAnswer((_) => negotiation.future);

      await signaling
          .onIceRestart(
            const SfuIceRestartEvent(peerType: StreamPeerType.publisher),
          )
          .timeout(const Duration(seconds: 1));

      verifyInOrder([
        publisher.restartIce,
        () => negotiator.negotiateOrRecover(publisher),
      ]);
      verifyNever(subscriber.restartIce);
      negotiation.complete();
    });

    test('a failing publisher renegotiation is caught', () async {
      when(
        () => negotiator.negotiateOrRecover(any()),
      ).thenAnswer((_) => Future.error(StateError('boom')));

      await signaling.onIceRestart(
        const SfuIceRestartEvent(peerType: StreamPeerType.publisher),
      );
      await pumpEventQueue();

      verify(() => negotiator.negotiateOrRecover(publisher)).called(1);
    });

    test('the subscriber only restarts ICE', () async {
      await signaling.onIceRestart(
        const SfuIceRestartEvent(peerType: StreamPeerType.subscriber),
      );

      verify(subscriber.restartIce).called(1);
      verifyNever(publisher.restartIce);
      verifyNever(() => negotiator.negotiateOrRecover(any()));
    });

    test('a missing publisher is skipped', () async {
      when(() => rtcManager.publisher).thenReturn(null);

      await signaling.onIceRestart(
        const SfuIceRestartEvent(peerType: StreamPeerType.publisher),
      );

      verifyNever(() => negotiator.negotiateOrRecover(any()));
    });

    test('without a manager nothing restarts', () async {
      manager = null;

      await signaling.onIceRestart(
        const SfuIceRestartEvent(peerType: StreamPeerType.subscriber),
      );

      verifyNever(subscriber.restartIce);
    });
  });

  group('mute state', () {
    test('is sent for the track type', () {
      final track = MockRtcLocalTrack();
      when(() => track.trackType).thenReturn(SfuTrackType.audio);

      signaling.sendMuteState(track, true);

      final request =
          verify(() => sfuClient.updateMuteState(captureAny())).captured.single
              as sfu.UpdateMuteStatesRequest;
      expect(request.sessionId, 'session');
      expect(request.muteStates.single.muted, isTrue);
      expect(
        request.muteStates.single.trackType,
        sfu_models.TrackType.TRACK_TYPE_AUDIO,
      );
    });
  });
}
