import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart'
    as sfu_enums;
import 'package:stream_video/src/call/session/sfu_join_request_builder.dart';
import 'package:stream_video/src/sfu/data/models/sfu_subscription_details.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'fixtures/call_session_harness.dart';

SfuJoinRequestBuilder _builder({ClientPublishOptions? clientPublishOptions}) {
  final pcFactory = MockStreamPeerConnectionFactory();
  when(
    () => pcFactory.getGenericSdp(rtc.TransceiverDirection.RecvOnly),
  ).thenAnswer((_) async => 'subscriber-sdp');
  when(
    () => pcFactory.getGenericSdp(rtc.TransceiverDirection.SendOnly),
  ).thenAnswer((_) async => 'publisher-sdp');

  return SfuJoinRequestBuilder(
    sessionId: 'session',
    sfuToken: 'token',
    pcFactory: pcFactory,
    clientPublishOptions: clientPublishOptions,
  );
}

final _clientOptions = ClientPublishOptions(
  preferredCodec: PreferredCodec.vp9,
  fmtpLine: 'profile-id=2',
  preferredBitrate: 1000,
  maxSimulcastLayers: 2,
  subscriberCodec: PreferredCodec.h264,
  subscriberFmtpLine: 'level=1',
);

sfu_events.ReconnectDetails _details(
  sfu_enums.WebsocketReconnectStrategy strategy,
) => sfu_events.ReconnectDetails(strategy: strategy);

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  group('build', () {
    test('a first join carries the session, the SDPs and the client '
        'options', () async {
      final request = await _builder(clientPublishOptions: _clientOptions)
          .build(
            capabilities: {SfuClientCapability.subscriberVideoPause},
            unifiedSessionId: 'unified',
            currentPublishOptions: harnessPublishOptions,
          );

      expect(request.sessionId, 'session');
      expect(request.token, 'token');
      expect(request.subscriberSdp, 'subscriber-sdp');
      expect(request.publisherSdp, 'publisher-sdp');
      expect(request.unifiedSessionId, 'unified');
      expect(request.hasReconnectDetails(), isFalse);
      expect(request.hasClientDetails(), isTrue);
      expect(
        request.source,
        sfu_enums.ParticipantSource.PARTICIPANT_SOURCE_WEBRTC_UNSPECIFIED,
      );
      expect(request.capabilities, [
        sfu_enums.ClientCapability.CLIENT_CAPABILITY_SUBSCRIBER_VIDEO_PAUSE,
      ]);

      final publish = request.preferredPublishOptions.single;
      expect(publish.codec.name, 'vp9');
      expect(publish.codec.fmtp, 'profile-id=2');
      expect(publish.bitrate, 1000);
      expect(publish.maxSpatialLayers, 2);
      expect(publish.trackType, sfu_enums.TrackType.TRACK_TYPE_VIDEO);

      final subscribe = request.preferredSubscribeOptions.single;
      expect(subscribe.codecs.single.name, 'h264');
      expect(subscribe.codecs.single.fmtp, 'level=1');
    });

    test('a first join without client options asks for none', () async {
      final request = await _builder().build(capabilities: const {});

      expect(request.preferredPublishOptions, isEmpty);
      expect(request.preferredSubscribeOptions, isEmpty);
    });

    test('details without a strategy count as a first join', () async {
      final request = await _builder(clientPublishOptions: _clientOptions)
          .build(
            capabilities: const {},
            reconnectDetails: _details(
              sfu_enums
                  .WebsocketReconnectStrategy
                  .WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED,
            ),
            currentPublishOptions: harnessPublishOptions,
          );

      expect(request.preferredPublishOptions.single.codec.name, 'vp9');
      expect(request.preferredSubscribeOptions, hasLength(1));
    });

    for (final strategy in [
      sfu_enums.WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_FAST,
      sfu_enums.WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_REJOIN,
      sfu_enums.WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_MIGRATE,
    ]) {
      test('a $strategy reconnect asks for the current publish options and no '
          'subscribe options', () async {
        final details = _details(strategy);
        final request = await _builder(clientPublishOptions: _clientOptions)
            .build(
              capabilities: const {},
              reconnectDetails: details,
              currentPublishOptions: harnessPublishOptions,
            );

        expect(request.reconnectDetails, details);
        expect(request.preferredPublishOptions.single.codec.name, 'vp8');
        expect(request.preferredSubscribeOptions, isEmpty);
      });
    }
  });

  test('a reconnect without a manager asks for no options, not the '
      'client ones', () async {
    final request = await _builder(clientPublishOptions: _clientOptions).build(
      capabilities: const {},
      reconnectDetails: _details(
        sfu_enums.WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_FAST,
      ),
    );

    expect(request.preferredPublishOptions, isEmpty);
    expect(request.preferredSubscribeOptions, isEmpty);
  });

  group('buildReconnectDetails', () {
    final subscription = SfuSubscriptionDetails(
      userId: 'alice',
      sessionId: 'alice-session',
      trackIdPrefix: 'alice-prefix',
      trackType: SfuTrackType.video,
    );

    test('a rejoin names this session as the previous one', () {
      final details = _builder().buildReconnectDetails(
        SfuReconnectionStrategy.rejoin,
        announcedTracks: const [],
        subscriptions: [subscription],
        migratingFromSfuId: 'sfu-1',
        reconnectAttempts: 3,
        reason: 'stuck',
      );

      expect(
        details.strategy,
        sfu_enums
            .WebsocketReconnectStrategy
            .WEBSOCKET_RECONNECT_STRATEGY_REJOIN,
      );
      expect(details.previousSessionId, 'session');
      expect(details.fromSfuId, 'sfu-1');
      expect(details.reconnectAttempt, 3);
      expect(details.reason, 'stuck');
      expect(details.subscriptions.single.userId, 'alice');
      expect(details.subscriptions.single.sessionId, 'alice-session');
    });

    for (final strategy in [
      SfuReconnectionStrategy.fast,
      SfuReconnectionStrategy.migrate,
    ]) {
      test('a $strategy reconnect names no previous session', () {
        final details = _builder().buildReconnectDetails(
          strategy,
          announcedTracks: null,
          subscriptions: const [],
        );

        expect(details.hasPreviousSessionId(), isFalse);
        expect(details.announcedTracks, isEmpty);
      });
    }

    test('announced tracks are carried over', () {
      final details = _builder().buildReconnectDetails(
        SfuReconnectionStrategy.fast,
        announcedTracks: [
          RtcTrackInfo(
            trackId: 'track',
            trackType: SfuTrackType.audio,
            mid: '0',
            layers: null,
            codec: null,
            muted: false,
            publishOptionId: 7,
            dtx: true,
            stereo: false,
            red: true,
          ),
        ],
        subscriptions: const [],
      );

      final track = details.announcedTracks.single;
      expect(track.trackId, 'track');
      expect(track.mid, '0');
      expect(track.publishOptionId, 7);
      expect(track.dtx, isTrue);
      expect(track.red, isTrue);
    });
  });
}
