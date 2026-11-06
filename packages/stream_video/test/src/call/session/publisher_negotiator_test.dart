import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/session/publisher_negotiator.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import 'fixtures/call_session_harness.dart';

const _track = RtcTrackInfo(
  trackId: 'track',
  trackType: null,
  mid: '0',
  layers: null,
  codec: null,
  muted: false,
  publishOptionId: 1,
  dtx: false,
  stereo: false,
  red: false,
);

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  late MockSfuClient sfuClient;
  late MockRtcManager rtcManager;
  late MockTracedPeerConnection pc;
  late List<
    (StreamPeerConnection, SfuReconnectionStrategy, ReconnectionNeededReason)
  >
  reconnects;
  late bool leavingOrClosed;
  late bool callDisconnected;
  late bool sfuConnected;
  RtcManager? manager;
  late PublisherNegotiator negotiator;

  setUp(() {
    sfuClient = MockSfuClient();
    rtcManager = MockRtcManager();
    pc = MockTracedPeerConnection();
    reconnects = [];
    leavingOrClosed = false;
    callDisconnected = false;
    sfuConnected = true;
    manager = rtcManager;

    when(() => pc.type).thenReturn(StreamPeerType.publisher);
    when(pc.createOffer).thenAnswer(
      (_) async => Result.success(rtc.RTCSessionDescription('offer', 'offer')),
    );
    when(
      pc.rollbackLocalDescription,
    ).thenAnswer((_) async => const Result.success(null));
    when(
      () => pc.setRemoteAnswer(any()),
    ).thenAnswer((_) async => const Result.success(null));
    when(rtcManager.isPublisherEmpty).thenAnswer((_) async => false);
    when(
      () => rtcManager.getAnnouncedTracks(sdp: any(named: 'sdp')),
    ).thenAnswer((_) async => const [_track]);
    when(() => rtcManager.markNegotiated(any())).thenReturn(null);
    when(() => sfuClient.setPublisher(any())).thenAnswer(
      (_) async => Result.success(sfu.SetPublisherResponse(sdp: 'answer')),
    );

    negotiator = PublisherNegotiator(
      sfuClient: sfuClient,
      sessionId: 'session',
      rtcManager: () => manager,
      isLeavingOrClosed: () => leavingOrClosed,
      isCallDisconnected: () => callDisconnected,
      isSfuConnected: () => sfuConnected,
      onReconnectionNeeded: (pc, strategy, reason) =>
          reconnects.add((pc, strategy, reason)),
      logTag: 'test',
    );
  });

  group('negotiate', () {
    test('announces the tracks, applies the answer and marks them '
        'negotiated', () async {
      final result = await negotiator.negotiate(pc);

      expect(result.isSuccess, isTrue);
      final request =
          verify(
                () => sfuClient.setPublisher(captureAny()),
              ).captured.single
              as sfu.SetPublisherRequest;
      expect(request.sdp, 'offer');
      expect(request.sessionId, 'session');
      expect(request.tracks.single.trackId, 'track');
      verifyInOrder([
        () => pc.setRemoteAnswer('answer'),
        () => rtcManager.markNegotiated(const [_track]),
      ]);
      verifyNever(pc.rollbackLocalDescription);
    });

    for (final (name, setUpGuard, message) in [
      ('the session is leaving', () => leavingOrClosed = true, 'disconnected'),
      (
        'the call is disconnected',
        () => callDisconnected = true,
        'disconnected',
      ),
      ('the SFU socket is down', () => sfuConnected = false, 'not connected'),
    ]) {
      test('fails without an offer while $name', () async {
        setUpGuard();

        final result = await negotiator.negotiate(pc);

        expect(result.getErrorOrNull()?.message, contains(message));
        verifyNever(pc.createOffer);
      });
    }

    test('skips a publisher without transceivers', () async {
      when(rtcManager.isPublisherEmpty).thenAnswer((_) async => true);

      final result = await negotiator.negotiate(pc);

      expect(result.isSuccess, isTrue);
      verifyNever(pc.createOffer);
    });

    test('negotiates a subscriber even when the publisher is empty', () async {
      when(() => pc.type).thenReturn(StreamPeerType.subscriber);
      when(rtcManager.isPublisherEmpty).thenAnswer((_) async => true);

      await negotiator.negotiate(pc);

      verify(pc.createOffer).called(1);
    });

    test('reports a disconnected call before a down socket', () async {
      leavingOrClosed = true;
      sfuConnected = false;

      final result = await negotiator.negotiate(pc);

      expect(result.getErrorOrNull()?.message, 'Call is disconnected');
    });

    test('a failed offer fails without a rollback', () async {
      when(pc.createOffer).thenAnswer(
        (_) async =>
            const Result.failure(StreamVideoException(message: 'no offer')),
      );

      final result = await negotiator.negotiate(pc);

      expect(result.getErrorOrNull()?.message, contains('no offer'));
      verifyNever(pc.rollbackLocalDescription);
    });

    test('an unresolved track mid rolls back and fails', () async {
      when(
        () => rtcManager.getAnnouncedTracks(sdp: any(named: 'sdp')),
      ).thenAnswer((_) async => null);

      final result = await negotiator.negotiate(pc);

      expect(
        result.getErrorOrNull()?.message,
        contains('Could not resolve the mid'),
      );
      verify(pc.rollbackLocalDescription).called(1);
      verifyNever(() => sfuClient.setPublisher(any()));
    });

    test('an empty announce rolls back and succeeds', () async {
      when(
        () => rtcManager.getAnnouncedTracks(sdp: any(named: 'sdp')),
      ).thenAnswer((_) async => const []);

      final result = await negotiator.negotiate(pc);

      expect(result.isSuccess, isTrue);
      verify(pc.rollbackLocalDescription).called(1);
      verifyNever(() => sfuClient.setPublisher(any()));
    });

    test('an empty announce whose rollback fails fails', () async {
      when(
        () => rtcManager.getAnnouncedTracks(sdp: any(named: 'sdp')),
      ).thenAnswer((_) async => const []);
      when(pc.rollbackLocalDescription).thenAnswer(
        (_) async =>
            const Result.failure(StreamVideoException(message: 'wedged')),
      );

      final result = await negotiator.negotiate(pc);

      expect(result.getErrorOrNull()?.message, 'wedged');
    });

    test('a failed SetPublisher rolls back and fails', () async {
      when(() => sfuClient.setPublisher(any())).thenAnswer(
        (_) async => const Result.failure(StreamVideoException(message: 'no')),
      );

      final result = await negotiator.negotiate(pc);

      expect(result.getErrorOrNull()?.message, contains('SetPublisher failed'));
      verify(pc.rollbackLocalDescription).called(1);
      verifyNever(() => rtcManager.markNegotiated(any()));
    });

    test('a throwing SetPublisher rolls back and fails', () async {
      when(() => sfuClient.setPublisher(any())).thenThrow(StateError('boom'));

      final result = await negotiator.negotiate(pc);

      expect(result.isFailure, isTrue);
      verify(pc.rollbackLocalDescription).called(1);
      verifyNever(() => rtcManager.markNegotiated(any()));
    });

    test('a failed remote answer fails without marking the tracks', () async {
      when(() => pc.setRemoteAnswer(any())).thenAnswer(
        (_) async => const Result.failure(StreamVideoException(message: 'no')),
      );

      final result = await negotiator.negotiate(pc);

      expect(
        result.getErrorOrNull()?.message,
        contains('Failed to set remote answer'),
      );
      verifyNever(() => rtcManager.markNegotiated(any()));
      verifyNever(pc.rollbackLocalDescription);
    });

    test('an answer without SDP still marks the tracks', () async {
      when(() => sfuClient.setPublisher(any())).thenAnswer(
        (_) async => Result.success(sfu.SetPublisherResponse()),
      );

      final result = await negotiator.negotiate(pc);

      expect(result.isSuccess, isTrue);
      verifyNever(() => pc.setRemoteAnswer(any()));
      verify(() => rtcManager.markNegotiated(const [_track])).called(1);
    });

    test('without a manager there is nothing to announce', () async {
      manager = null;

      final result = await negotiator.negotiate(pc);

      expect(result.isSuccess, isTrue);
      verify(pc.rollbackLocalDescription).called(1);
      verifyNever(() => sfuClient.setPublisher(any()));
    });

    test('runs one negotiation at a time', () async {
      final firstAnswer = Completer<Result<sfu.SetPublisherResponse>>();
      var calls = 0;
      when(() => sfuClient.setPublisher(any())).thenAnswer((_) {
        calls++;
        return calls == 1
            ? firstAnswer.future
            : Future.value(Result.success(sfu.SetPublisherResponse()));
      });

      final first = negotiator.negotiate(pc);
      final second = negotiator.negotiate(pc);
      await pumpEventQueue();

      verify(pc.createOffer).called(1);

      firstAnswer.complete(Result.success(sfu.SetPublisherResponse()));
      await Future.wait([first, second]);

      verify(pc.createOffer).called(1);
      expect(calls, 2);
    });
  });

  group('negotiateOrRecover', () {
    test('an unresolved track mid asks for a fast reconnect', () async {
      when(
        () => rtcManager.getAnnouncedTracks(sdp: any(named: 'sdp')),
      ).thenAnswer((_) async => null);

      await negotiator.negotiateOrRecover(pc);

      expect(reconnects, [
        (pc, SfuReconnectionStrategy.fast, ReconnectionNeededReason.stuck),
      ]);
    });

    test('an unresolved track mid while leaving asks for nothing', () async {
      when(
        () => rtcManager.getAnnouncedTracks(sdp: any(named: 'sdp')),
      ).thenAnswer((_) async {
        leavingOrClosed = true;
        return null;
      });

      await negotiator.negotiateOrRecover(pc);

      expect(reconnects, isEmpty);
    });

    test('any other failure asks for nothing', () async {
      when(() => sfuClient.setPublisher(any())).thenAnswer(
        (_) async => const Result.failure(StreamVideoException(message: 'no')),
      );

      await negotiator.negotiateOrRecover(pc);

      expect(reconnects, isEmpty);
    });
  });
}
