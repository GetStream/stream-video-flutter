import 'package:collection/collection.dart';

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
import 'data/models/sfu_connection_info.dart';
import 'data/models/sfu_model_mapper_extensions.dart';
import 'data/models/sfu_participant.dart';

extension CodecX on sfu_models.Codec {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fmtp': fmtp,
      'clockRate': clockRate,
      'encodingParameters': encodingParameters,
      'payloadType': payloadType,
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
      'trackId': trackId,
      'trackType': trackType.value,
      'layers': layers.map((layer) => layer.toJson()).toList(),
      'mid': mid,
      'dtx': dtx,
      'stereo': stereo,
      'red': red,
      'muted': muted,
      'codec': codec.toJson(),
      'publishOptionId': publishOptionId,
    };
  }
}

extension VideoLayerX on sfu_models.VideoLayer {
  Map<String, dynamic> toJson() {
    return {
      'rid': rid,
      'videoDimension': {
        'width': videoDimension.width,
        'height': videoDimension.height,
      },
      'bitrate': bitrate,
      'fps': fps,
      'quality': quality.value,
    };
  }
}

extension SetPublisherRequestX on sfu.SetPublisherRequest {
  Map<String, dynamic> toJson() {
    return {
      'sdp': sdp,
      'sessionId': sessionId,
      'tracks': tracks.map((track) => track.toJson()).toList(),
    };
  }
}

extension ClientDetailsX on sfu_models.ClientDetails {
  Map<String, dynamic> toJson() {
    return {
      if (hasSdk()) 'sdk': sdk.toJson(),
      if (hasOs()) 'os': os.toJson(),
      if (hasBrowser()) 'browser': browser.toJson(),
      if (hasDevice()) 'device': device.toJson(),
    };
  }
}

extension SdkX on sfu_models.Sdk {
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
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
    return {
      'peerType': peerType.value,
      'sdp': sdp,
      'sessionId': sessionId,
    };
  }
}

extension ICETrickleX on sfu_models.ICETrickle {
  Map<String, dynamic> toJson() {
    return {
      'peerType': peerType.value,
      'iceCandidate': iceCandidate,
      'sessionId': sessionId,
    };
  }
}

extension ICERestartRequestX on sfu.ICERestartRequest {
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'peerType': peerType.value,
    };
  }
}

extension UpdateMuteStatesRequestX on sfu.UpdateMuteStatesRequest {
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'muteStates': muteStates.map((state) => state.toJson()).toList(),
    };
  }
}

extension TrackMuteStateX on sfu.TrackMuteState {
  Map<String, dynamic> toJson() {
    return {
      'trackType': trackType.value,
      'muted': muted,
    };
  }
}

extension UpdateSubscriptionsRequestX on sfu.UpdateSubscriptionsRequest {
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'tracks': tracks.map((sub) => sub.toJson()).toList(),
    };
  }
}

extension TrackSubscriptionDetailsX on sfu.TrackSubscriptionDetails {
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'trackType': trackType.value,
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
      'sessionId': sessionId,
    };
  }
}

extension StopNoiseCancellationRequestX on sfu.StopNoiseCancellationRequest {
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
    };
  }
}

extension ReconnectDetailsX on sfu_events.ReconnectDetails {
  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy.value,
      'announcedTracks': announcedTracks
          .map((track) => track.toJson())
          .toList(),
      'subscriptions': subscriptions.map((sub) => sub.toJson()).toList(),
      'reconnectAttempt': reconnectAttempt,
      'fromSfuId': fromSfuId,
      'previousSessionId': previousSessionId,
      'reason': reason,
    };
  }
}

extension SfuChangePublishQualityEventJsonX on SfuChangePublishQualityEvent {
  Map<String, dynamic> toJson() {
    return {
      'audioSenders': audioSenders.map((sender) => sender.toJson()).toList(),
      'videoSenders': videoSenders.map((sender) => sender.toJson()).toList(),
    };
  }
}

extension SfuChangePublishOptionsEventJsonX on SfuChangePublishOptionsEvent {
  Map<String, dynamic> toJson() {
    return {
      'publishOptions': publishOptions
          .map((option) => option.toJson())
          .toList(),
      'reason': reason,
    };
  }
}

extension SfuAudioSenderJsonX on SfuAudioSender {
  Map<String, dynamic> toJson() {
    return {
      'codec': codec.toJson(),
      'trackType': trackType.toDTO().value,
      'publishOptionId': publishOptionId,
    };
  }
}

extension SfuVideoSenderJsonX on SfuVideoSender {
  Map<String, dynamic> toJson() {
    return {
      'codec': codec.toJson(),
      'layers': layers.map((layer) => layer.toJson()).toList(),
      'trackType': trackType.toDTO().value,
      'publishOptionId': publishOptionId,
    };
  }
}

extension SfuPublishOptionsJsonX on SfuPublishOptions {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codec': codec.toJson(),
      'trackType': trackType.toDTO().value,
      'videoDimension': videoDimension?.toJson(),
      'maxSpatialLayers': maxSpatialLayers,
      'maxTemporalLayers': maxTemporalLayers,
      'useSingleLayer': useSingleLayer,
      'bitrate': bitrate,
      'fps': fps,
    };
  }
}

extension SfuCodecJsonX on SfuCodec {
  Map<String, dynamic> toJson() {
    return {
      'payloadType': payloadType,
      'name': name,
      'fmtp': fmtpLine,
      'clockRate': clockRate,
      'encodingParameters': encodingParameters,
    };
  }
}

extension SfuVideoLayerSettingJsonX on SfuVideoLayerSetting {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'active': active,
      'maxBitrate': maxBitrate,
      'maxFramerate': maxFramerate,
      'scaleResolutionDownBy': scaleResolutionDownBy,
      'scalabilityMode': scalabilityMode,
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
      'goAwayReason': goAwayReason.toString(),
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
      'shouldRetry': shouldRetry,
      'reconnectStrategy': reconnectStrategy.toDto().value,
    };
  }
}

extension SfuCallEndedEventJsonX on SfuCallEndedEvent {
  Map<String, dynamic> toJson() {
    return {
      'callEndedReason': callEndedReason.toString(),
    };
  }
}

extension SfuConnectionQualityChangedEventJsonX
    on SfuConnectionQualityChangedEvent {
  Map<String, dynamic> toJson() {
    return {
      'connectionQualityUpdates': connectionQualityUpdates
          .map((codec) => codec.toJson())
          .toList(),
    };
  }
}

extension SfuConnectionQualityInfoJsonX on SfuConnectionQualityInfo {
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'connectionQuality': connectionQuality.index,
    };
  }
}

extension SfuTrackPublishedEventJsonX on SfuTrackPublishedEvent {
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'trackType': trackType.toDTO().value,
      'participant': {
        'userId': participant.userId,
        'sessionId': participant.sessionId,
        'trackLookupPrefix': participant.trackLookupPrefix,
        'publishedTracks': participant.publishedTracks
            .map((track) => track.toString())
            .toList(),
        'isSpeaking': participant.isSpeaking,
        'isDominantSpeaker': participant.isDominantSpeaker,
        'audioLevel': participant.audioLevel,
        'roles': participant.roles,
      },
    };
  }
}

extension SfuTrackUnpublishedEventJsonX on SfuTrackUnpublishedEvent {
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'trackType': trackType.toDTO().value,
      'participant': {
        'userId': participant.userId,
        'sessionId': participant.sessionId,
        'trackLookupPrefix': participant.trackLookupPrefix,
        'publishedTracks': participant.publishedTracks
            .map((track) => track.toString())
            .toList(),
        'isSpeaking': participant.isSpeaking,
        'isDominantSpeaker': participant.isDominantSpeaker,
        'audioLevel': participant.audioLevel,
        'roles': participant.roles,
      },
    };
  }
}

extension PublishOptionX on sfu_models.PublishOption {
  Map<String, dynamic> toJson() {
    return {
      'trackType': trackType.value,
      'codec': codec.toJson(),
      'bitrate': bitrate,
      'fps': fps,
      'maxSpatialLayers': maxSpatialLayers,
      'maxTemporalLayers': maxTemporalLayers,
      'videoDimension': videoDimension.toJson(),
      'id': id,
    };
  }
}

extension SubscribeOptionX on sfu_models.SubscribeOption {
  Map<String, dynamic> toJson() {
    return {
      'trackType': trackType.value,
      'codecs': codecs.map((codec) => codec.toJson()).toList(),
    };
  }
}

extension JoinRequestX on sfu_events.JoinRequest {
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'sessionId': sessionId,
      'unifiedSessionId': unifiedSessionId,
      'subscriberSdp': subscriberSdp,
      'publisherSdp': publisherSdp,
      'clientDetails': clientDetails.toJson(),
      'reconnectDetails': reconnectDetails.toJson(),
      'preferredPublishOptions': preferredPublishOptions
          .map((option) => option.toJson())
          .toList(),
      'preferredSubscribeOptions': preferredSubscribeOptions
          .map((option) => option.toJson())
          .toList(),
      'source': source.toString(),
      if (capabilities.isNotEmpty)
        'capabilities': capabilities.map((c) => c.toString()).toList(),
    };
  }
}
