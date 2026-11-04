import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../globals.dart';
import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/models/models.pbenum.dart';
import '../../models/call_client_publish_options.dart';
import '../../sfu/data/models/sfu_client_capability.dart';
import '../../sfu/data/models/sfu_error.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_publish_options.dart';
import '../../sfu/data/models/sfu_subscription_details.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/peer_connection_factory.dart';

/// Builds the join request a session sends to the SFU, for a first join and
/// for every kind of reconnect.
@internal
class SfuJoinRequestBuilder {
  SfuJoinRequestBuilder({
    required this.sessionId,
    required this.sfuToken,
    required this.pcFactory,
    this.clientPublishOptions,
  });

  final String sessionId;
  final String sfuToken;

  /// Makes the generic subscriber and publisher SDPs the request carries.
  final StreamPeerConnectionFactory pcFactory;

  /// The codecs the app prefers, asked for on a first join only.
  final ClientPublishOptions? clientPublishOptions;

  /// The join request for [reconnectDetails], or for a first join when it is
  /// `null` or has no strategy.
  ///
  /// A reconnect asks for [currentPublishOptions] and no subscribe options; a
  /// first join asks for the options in [clientPublishOptions].
  Future<sfu_events.JoinRequest> build({
    sfu_events.ReconnectDetails? reconnectDetails,
    required Set<SfuClientCapability> capabilities,
    String? unifiedSessionId,
    List<SfuPublishOptions>? currentPublishOptions,
  }) async {
    final subscriberSdp = await pcFactory.getGenericSdp(
      rtc.TransceiverDirection.RecvOnly,
    );
    final publisherSdp = await pcFactory.getGenericSdp(
      rtc.TransceiverDirection.SendOnly,
    );

    final isReconnecting =
        reconnectDetails != null &&
        reconnectDetails.strategy !=
            WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED;

    return sfu_events.JoinRequest(
      clientDetails: clientDetails,
      token: sfuToken,
      sessionId: sessionId,
      subscriberSdp: subscriberSdp,
      publisherSdp: publisherSdp,
      reconnectDetails: reconnectDetails,
      preferredPublishOptions: isReconnecting
          ? currentPublishOptions?.map((o) => o.toDTO())
          : clientPublishOptions?.getPreferredPublishOptions(),
      preferredSubscribeOptions: isReconnecting
          ? null
          : clientPublishOptions?.getPreferredSubscriberOptions(),
      capabilities: capabilities.map((c) => c.toDTO()).toList(),
      source:
          sfu_models.ParticipantSource.PARTICIPANT_SOURCE_WEBRTC_UNSPECIFIED,
      unifiedSessionId: unifiedSessionId,
    );
  }

  /// The reconnect details for [strategy]. A rejoin names this session as
  /// the previous one.
  sfu_events.ReconnectDetails buildReconnectDetails(
    SfuReconnectionStrategy strategy, {
    required List<RtcTrackInfo>? announcedTracks,
    required List<SfuSubscriptionDetails> subscriptions,
    String? migratingFromSfuId,
    int? reconnectAttempts,
    String? reason,
  }) {
    return sfu_events.ReconnectDetails(
      strategy: strategy.toDto(),
      announcedTracks: announcedTracks?.toDTO(),
      subscriptions: subscriptions.toDTO(),
      previousSessionId: strategy == SfuReconnectionStrategy.rejoin
          ? sessionId
          : null,
      fromSfuId: migratingFromSfuId,
      reconnectAttempt: reconnectAttempts,
      reason: reason,
    );
  }
}

/// The preferences of [ClientPublishOptions] as the SFU takes them.
extension _ClientPublishOptionsMapper on ClientPublishOptions {
  List<sfu_models.PublishOption>? getPreferredPublishOptions() {
    if (preferredCodec == null) return null;

    return [
      sfu_models.PublishOption(
        codec: sfu_models.Codec(
          name: preferredCodec?.name,
          fmtp: fmtpLine,
        ),
        bitrate: preferredBitrate,
        maxSpatialLayers: maxSimulcastLayers,
        trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
      ),
    ];
  }

  List<sfu_models.SubscribeOption>? getPreferredSubscriberOptions() {
    if (subscriberCodec == null) return null;

    return [
      sfu_models.SubscribeOption(
        codecs: [
          sfu_models.Codec(
            name: subscriberCodec?.name,
            fmtp: subscriberFmtpLine,
          ),
        ],
        trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
      ),
    ];
  }
}
