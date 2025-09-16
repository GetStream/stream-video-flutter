import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:sdp_transform/sdp_transform.dart';

import '../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../call_state.dart';
import '../models/models.dart';
import '../sfu/data/models/sfu_audio_sender.dart';
import '../sfu/data/models/sfu_codec.dart';
import '../sfu/data/models/sfu_error.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/data/models/sfu_video_layer_setting.dart';
import '../sfu/data/models/sfu_video_sender.dart';
import '../utils/string.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import 'data/events/sfu_events.dart';
import 'data/models/sfu_participant.dart';

extension CodecX on sfu_models.Codec {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fmtp': fmtp,
      'clock_rate': clockRate,
      'encoding_parameters': encodingParameters,
      'payload_type': payloadType,
    };
  }
}

extension SfuParticipantX on SfuParticipant {
  CallParticipantState toParticipantState(CallState state) {
    final isLocal =
        userId == state.currentUserId && sessionId == state.sessionId;
    final existing = state.callParticipants.firstWhereOrNull(
      (it) => it.userId == userId,
    );

    final existingName = existing?.name ?? '';
    final existingRoles = existing?.roles ?? [];
    final existingImage = existing?.image ?? '';

    return CallParticipantState(
      userId: userId,
      roles: roles.isNotEmpty ? roles : existingRoles,
      name: userName.ifEmpty(() => existingName),
      custom: custom,
      image: userImage.ifEmpty(() => existingImage),
      sessionId: sessionId,
      trackIdPrefix: trackLookupPrefix,
      publishedTracks: {
        for (final track in publishedTracks)
          track: TrackState.base(isLocal: isLocal),
      },
      isLocal: isLocal,
      isOnline: !isLocal,
      isSpeaking: isSpeaking,
      audioLevel: audioLevel,
      isDominantSpeaker: isDominantSpeaker,
      participantSource: participantSource,
    );
  }
}

extension TrackInfoX on sfu_models.TrackInfo {
  Map<String, dynamic> toJson() {
    return {
      'track_id': trackId,
      'track_type': trackType.toString(),
      'layers': layers.map((layer) => layer.toJson()).toList(),
      'mid': mid,
      'dtx': dtx,
      'stereo': stereo,
      'red': red,
      'muted': muted,
      'codec': codec.toJson(),
      'publish_option_id': publishOptionId,
    };
  }
}

extension VideoLayerX on sfu_models.VideoLayer {
  Map<String, dynamic> toJson() {
    return {
      'rid': rid,
      'video_dimension': {
        'width': videoDimension.width,
        'height': videoDimension.height,
      },
      'bitrate': bitrate,
      'fps': fps,
      'quality': quality.toString(),
    };
  }
}

extension SetPublisherRequestX on sfu.SetPublisherRequest {
  Map<String, dynamic> toJson() {
    final parsedSdp = parse(sdp);

    return {
      'sdp': parsedSdp,
      'session_id': sessionId,
      'tracks': tracks.map((track) => track.toJson()).toList(),
    };
  }
}

extension ClientDetailsX on sfu_models.ClientDetails {
  Map<String, dynamic> toJson() {
    return {
      'sdk': sdk.toJson(),
      'os': os.toJson(),
      'browser': browser.toJson(),
      'device': device.toJson(),
    };
  }
}

extension SdkX on sfu_models.Sdk {
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'major': major,
      'minor': minor,
      'patch': patch,
    };
  }
}

extension OSX on sfu_models.OS {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'architecture': architecture,
    };
  }
}

extension BrowserX on sfu_models.Browser {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
    };
  }
}

extension DeviceX on sfu_models.Device {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
    };
  }
}

extension SendAnswerRequestX on sfu.SendAnswerRequest {
  Map<String, dynamic> toJson() {
    final parsedSdp = parse(sdp);
    return {
      'peer_type': peerType.toString(),
      'sdp': parsedSdp,
      'session_id': sessionId,
    };
  }
}

extension ICETrickleX on sfu_models.ICETrickle {
  Map<String, dynamic> toJson() {
    return {
      'peer_type': peerType.toString(),
      'ice_candidate': jsonDecode(iceCandidate),
      'session_id': sessionId,
    };
  }
}

extension ICERestartRequestX on sfu.ICERestartRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'peer_type': peerType.toString(),
    };
  }
}

extension UpdateMuteStatesRequestX on sfu.UpdateMuteStatesRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'mute_states': muteStates.map((state) => state.toJson()).toList(),
    };
  }
}

extension TrackMuteStateX on sfu.TrackMuteState {
  Map<String, dynamic> toJson() {
    return {
      'track_type': trackType.toString(),
      'muted': muted,
    };
  }
}

extension UpdateSubscriptionsRequestX on sfu.UpdateSubscriptionsRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'tracks': tracks.map((sub) => sub.toJson()).toList(),
    };
  }
}

extension TrackSubscriptionDetailsX on sfu.TrackSubscriptionDetails {
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'session_id': sessionId,
      'track_type': trackType.toString(),
      'dimension': dimension.toJson(),
    };
  }
}

extension VideoDimensionX on sfu_models.VideoDimension {
  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
    };
  }
}

extension StartNoiseCancellationRequestX on sfu.StartNoiseCancellationRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
    };
  }
}

extension StopNoiseCancellationRequestX on sfu.StopNoiseCancellationRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
    };
  }
}

extension ReconnectDetailsX on sfu_events.ReconnectDetails {
  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy.toString(),
      'announced_tracks':
          announcedTracks.map((track) => track.toJson()).toList(),
      'subscriptions': subscriptions.map((sub) => sub.toJson()).toList(),
      'reconnect_attempt': reconnectAttempt,
      'from_sfu_id': fromSfuId,
      'previous_session_id': previousSessionId,
      'reason': reason,
    };
  }
}

extension SfuChangePublishQualityEventJsonX on SfuChangePublishQualityEvent {
  Map<String, dynamic> toJson() {
    return {
      'audio_senders': audioSenders.map((sender) => sender.toJson()).toList(),
      'video_senders': videoSenders.map((sender) => sender.toJson()).toList(),
    };
  }
}

extension SfuChangePublishOptionsEventJsonX on SfuChangePublishOptionsEvent {
  Map<String, dynamic> toJson() {
    return {
      'publish_options':
          publishOptions.map((option) => option.toJson()).toList(),
      'reason': reason,
    };
  }
}

extension SfuAudioSenderJsonX on SfuAudioSender {
  Map<String, dynamic> toJson() {
    return {
      'codec': codec.toJson(),
      'track_type': trackType.toString(),
      'publish_option_id': publishOptionId,
    };
  }
}

extension SfuVideoSenderJsonX on SfuVideoSender {
  Map<String, dynamic> toJson() {
    return {
      'codec': codec.toJson(),
      'layers': layers.map((layer) => layer.toJson()).toList(),
      'track_type': trackType.toString(),
      'publish_option_id': publishOptionId,
    };
  }
}

extension SfuPublishOptionsJsonX on SfuPublishOptions {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codec': codec.toJson(),
      'track_type': trackType.toString(),
      'video_dimension': videoDimension?.toJson(),
      'max_spatial_layers': maxSpatialLayers,
      'max_temporal_layers': maxTemporalLayers,
      'bitrate': bitrate,
      'fps': fps,
    };
  }
}

extension SfuCodecJsonX on SfuCodec {
  Map<String, dynamic> toJson() {
    return {
      'payload_type': payloadType,
      'name': name,
      'fmtp_line': fmtpLine,
      'clock_rate': clockRate,
      'encoding_parameters': encodingParameters,
    };
  }
}

extension SfuVideoLayerSettingJsonX on SfuVideoLayerSetting {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'active': active,
      'max_bitrate': maxBitrate,
      'max_framerate': maxFramerate,
      'scale_resolution_down_by': scaleResolutionDownBy,
      'scalability_mode': scalabilityMode,
      'codec': codec.toJson(),
    };
  }
}

extension RtcVideoDimensionJsonX on RtcVideoDimension {
  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
    };
  }
}

extension SfuGoAwayEventJsonX on SfuGoAwayEvent {
  Map<String, dynamic> toJson() {
    return {
      'go_away_reason': goAwayReason.toString(),
    };
  }
}

extension SfuErrorEventJsonX on SfuErrorEvent {
  Map<String, dynamic> toJson() {
    return {
      'error': error.toJson(),
    };
  }
}

extension SfuErrorJsonX on SfuError {
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code.toString(),
      'should_retry': shouldRetry,
      'reconnect_strategy': reconnectStrategy.toString(),
    };
  }
}

extension SfuCallEndedEventJsonX on SfuCallEndedEvent {
  Map<String, dynamic> toJson() {
    return {
      'call_ended_reason': callEndedReason.toString(),
    };
  }
}

extension SfuTrackPublishedEventJsonX on SfuTrackPublishedEvent {
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'session_id': sessionId,
      'track_type': trackType.toString(),
      'participant': {
        'user_id': participant.userId,
        'session_id': participant.sessionId,
        'user_name': participant.userName,
        'user_image': participant.userImage,
        'track_lookup_prefix': participant.trackLookupPrefix,
        'published_tracks': participant.publishedTracks
            .map((track) => track.toString())
            .toList(),
        'is_speaking': participant.isSpeaking,
        'is_dominant_speaker': participant.isDominantSpeaker,
        'audio_level': participant.audioLevel,
        'roles': participant.roles,
      },
    };
  }
}

extension SfuTrackUnpublishedEventJsonX on SfuTrackUnpublishedEvent {
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'session_id': sessionId,
      'track_type': trackType.toString(),
      'participant': {
        'user_id': participant.userId,
        'session_id': participant.sessionId,
        'user_name': participant.userName,
        'user_image': participant.userImage,
        'track_lookup_prefix': participant.trackLookupPrefix,
        'published_tracks': participant.publishedTracks
            .map((track) => track.toString())
            .toList(),
        'is_speaking': participant.isSpeaking,
        'is_dominant_speaker': participant.isDominantSpeaker,
        'audio_level': participant.audioLevel,
        'roles': participant.roles,
      },
    };
  }
}

extension PublishOptionX on sfu_models.PublishOption {
  Map<String, dynamic> toJson() {
    return {
      'track_type': trackType.toString(),
      'codec': codec.toJson(),
      'bitrate': bitrate,
      'fps': fps,
      'max_spatial_layers': maxSpatialLayers,
      'max_temporal_layers': maxTemporalLayers,
      'video_dimension': videoDimension.toJson(),
      'id': id,
    };
  }
}

extension SubscribeOptionX on sfu_models.SubscribeOption {
  Map<String, dynamic> toJson() {
    return {
      'track_type': trackType.toString(),
      'codecs': codecs.map((codec) => codec.toJson()).toList(),
    };
  }
}

extension JoinRequestX on sfu_events.JoinRequest {
  Map<String, dynamic> toJson() {
    final subscriberSdpParsed =
        subscriberSdp.isNotEmpty ? parse(subscriberSdp) : null;
    final publisherSdpParsed =
        publisherSdp.isNotEmpty ? parse(publisherSdp) : null;
    return {
      'token': token,
      'session_id': sessionId,
      'subscriber_sdp': subscriberSdpParsed,
      'client_details': clientDetails.toJson(),
      'reconnect_details': reconnectDetails.toJson(),
      'publisher_sdp': publisherSdpParsed,
      'preferred_publish_options':
          preferredPublishOptions.map((option) => option.toJson()).toList(),
      'preferred_subscribe_options':
          preferredSubscribeOptions.map((option) => option.toJson()).toList(),
      'source': source.toString(),
      if (capabilities.isNotEmpty)
        'capabilities': capabilities.map((c) => c.toString()).toList(),
    };
  }
}
