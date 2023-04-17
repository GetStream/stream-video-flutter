import '../../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../models/sfu_audio_level.dart';
import '../models/sfu_audio_sender.dart';
import '../models/sfu_call_state.dart';
import '../models/sfu_codec.dart';
import '../models/sfu_connection_quality.dart';
import '../models/sfu_error.dart';
import '../models/sfu_model_mapper_extensions.dart';
import '../models/sfu_models.dart';
import '../models/sfu_participant.dart';
import '../models/sfu_track_type.dart';
import '../models/sfu_video_sender.dart';
import 'sfu_events.dart';

/// TODO
extension SfuEventMapper on sfu_events.SfuEvent {
  /// TODO
  SfuEvent toDomain() {
    final eventType = whichEventPayload();
    switch (eventType) {
      case sfu_events.SfuEvent_EventPayload.subscriberOffer:
        final payload = subscriberOffer;
        return SfuSubscriberOfferEvent(
          sdp: payload.sdp,
          iceRestart: payload.iceRestart,
        );

      case sfu_events.SfuEvent_EventPayload.publisherAnswer:
        final payload = publisherAnswer;
        return SfuPublisherAnswerEvent(sdp: payload.sdp);

      case sfu_events.SfuEvent_EventPayload.connectionQualityChanged:
        final payload = connectionQualityChanged;
        final updates = payload.connectionQualityUpdates.map((it) {
          return SfuConnectionQualityInfo(
            userId: it.userId,
            sessionId: it.sessionId,
            connectionQuality: it.connectionQuality.toDomain(),
          );
        }).toList();
        return SfuConnectionQualityChangedEvent(
          connectionQualityUpdates: updates,
        );

      case sfu_events.SfuEvent_EventPayload.audioLevelChanged:
        final payload = audioLevelChanged;
        final levels = payload.audioLevels.map((it) {
          return SfuAudioLevel(
            userId: it.userId,
            sessionId: it.sessionId,
            level: it.level,
            isSpeaking: it.isSpeaking,
          );
        }).toList();
        return SfuAudioLevelChangedEvent(
          audioLevels: levels,
        );

      case sfu_events.SfuEvent_EventPayload.iceTrickle:
        final payload = iceTrickle;
        return SfuIceTrickleEvent(
          sessionId: payload.sessionId,
          peerType: payload.peerType.toDomain(),
          iceCandidate: payload.iceCandidate,
        );

      case sfu_events.SfuEvent_EventPayload.changePublishQuality:
        final payload = changePublishQuality;
        return SfuChangePublishQualityEvent(
          audioSenders: payload.audioSenders
              .map(
                (it) => it.toDomain(),
              )
              .toList(),
          videoSenders: payload.videoSenders
              .map(
                (it) => it.toDomain(),
              )
              .toList(),
        );

      case sfu_events.SfuEvent_EventPayload.joinResponse:
        return SfuJoinResponseEvent(
          callState: joinResponse.callState.toDomain(),
        );
      case sfu_events.SfuEvent_EventPayload.participantJoined:
        return SfuParticipantJoinedEvent(
          callCid: participantJoined.callCid,
          participant: participantJoined.participant.toDomain(),
        );
      case sfu_events.SfuEvent_EventPayload.participantLeft:
        return SfuParticipantLeftEvent(
          callCid: participantLeft.callCid,
          participant: participantLeft.participant.toDomain(),
        );
      case sfu_events.SfuEvent_EventPayload.dominantSpeakerChanged:
        return SfuDominantSpeakerChangedEvent(
          userId: dominantSpeakerChanged.userId,
          sessionId: dominantSpeakerChanged.sessionId,
        );
      case sfu_events.SfuEvent_EventPayload.trackPublished:
        return SfuTrackPublishedEvent(
          userId: trackPublished.userId,
          sessionId: trackPublished.sessionId,
          trackType: trackPublished.type.toDomain(),
        );
      case sfu_events.SfuEvent_EventPayload.trackUnpublished:
        return SfuTrackUnpublishedEvent(
          userId: trackUnpublished.userId,
          sessionId: trackUnpublished.sessionId,
          trackType: trackUnpublished.type.toDomain(),
        );
      case sfu_events.SfuEvent_EventPayload.healthCheckResponse:
        return SfuHealthCheckResponseEvent();
      case sfu_events.SfuEvent_EventPayload.error:
        return SfuErrorEvent(
          error: SfuError(
            code: error.error.code.toDomain(),
            message: error.error.message,
          ),
        );
      default:
        return SfuUnknownEvent();
    }
  }
}

/// TODO
extension SfuCallStateExtension on sfu_models.CallState {
  SfuCallState toDomain() {
    return SfuCallState(
      participants: participants.map((it) => it.toDomain()).toList(),
    );
  }
}

/// TODO
extension SfuParticipantExtension on sfu_models.Participant {
  SfuParticipant toDomain() {
    print('toDomain: audioLevel -> $audioLevel');
    return SfuParticipant(
      userId: userId,
      userName: name,
      userImage: image,
      sessionId: sessionId,
      publishedTracks: publishedTracks
          .map(
            (track) => track.toDomain(),
          )
          .toList(),
      joinedAt: joinedAt.toDateTime(),
      trackLookupPrefix: trackLookupPrefix,
      connectionQuality: connectionQuality.toDomain(),
      isSpeaking: isSpeaking,
      isDominantSpeaker: isDominantSpeaker,
      audioLevel: audioLevel,
    );
  }
}

/// TODO
extension SfuConnectionQualityExtension on sfu_models.ConnectionQuality {
  SfuConnectionQuality toDomain() {
    switch (this) {
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_POOR:
        return SfuConnectionQuality.poor;
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_GOOD:
        return SfuConnectionQuality.good;
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_EXCELLENT:
        return SfuConnectionQuality.excellent;
      case sfu_models.ConnectionQuality.CONNECTION_QUALITY_UNSPECIFIED:
        return SfuConnectionQuality.unspecified;
      default:
        throw StateError('unexpected quality: $this');
    }
  }
}

/// TODO
extension SfuTrackTypeExtension on sfu_models.TrackType {
  SfuTrackType toDomain() {
    switch (this) {
      case sfu_models.TrackType.TRACK_TYPE_AUDIO:
        return SfuTrackType.audio;
      case sfu_models.TrackType.TRACK_TYPE_VIDEO:
        return SfuTrackType.video;
      case sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE:
        return SfuTrackType.screenShare;
      case sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO:
        return SfuTrackType.screenShareAudio;
      case sfu_models.TrackType.TRACK_TYPE_UNSPECIFIED:
        return SfuTrackType.unspecified;
      default:
        throw StateError('unexpected track type: $this');
    }
  }
}

/// TODO
extension SfuErrorCodeExtension on sfu_models.ErrorCode {
  SfuErrorCode toDomain() {
    switch (this) {
      case sfu_models.ErrorCode.ERROR_CODE_PUBLISH_TRACK_NOT_FOUND:
        return SfuErrorCode.publishTrackNotFound;
      case sfu_models.ErrorCode.ERROR_CODE_PUBLISH_TRACKS_MISMATCH:
        return SfuErrorCode.publishTracksMismatch;
      case sfu_models.ErrorCode.ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER:
        return SfuErrorCode.publishTrackOutOfOrder;
      case sfu_models.ErrorCode.ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND:
        return SfuErrorCode.publishTrackVideoLayerNotFound;
      case sfu_models.ErrorCode.ERROR_CODE_PARTICIPANT_NOT_FOUND:
        return SfuErrorCode.participantNotFound;
      case sfu_models.ErrorCode.ERROR_CODE_CALL_NOT_FOUND:
        return SfuErrorCode.callNotFound;
      case sfu_models.ErrorCode.ERROR_CODE_INTERNAL_SERVER_ERROR:
        return SfuErrorCode.internalServerError;
      case sfu_models.ErrorCode.ERROR_CODE_UNSPECIFIED:
        return SfuErrorCode.unspecified;
      default:
        throw StateError('unexpected error code: $this');
    }
  }
}

/// TODO
extension SfuAudioSenderExtension on sfu_events.AudioSender {
  SfuAudioSender toDomain() {
    return SfuAudioSender(
      mediaRequest: SfuAudioMediaRequest(
        channelCount: mediaRequest.channelCount,
      ),
      codec: codec.toDomain(),
    );
  }
}

/// TODO
extension SfuVideoSenderExtension on sfu_events.VideoSender {
  SfuVideoSender toDomain() {
    return SfuVideoSender(
      mediaRequest: SfuVideoMediaRequest(
        idealHeight: mediaRequest.idealHeight,
        idealWidth: mediaRequest.idealWidth,
        idealFrameRate: mediaRequest.idealFrameRate,
      ),
      codec: codec.toDomain(),
    );
  }
}

/// TODO
extension SfuCodecExtension on sfu_models.Codec {
  SfuCodec toDomain() {
    return SfuCodec(
      payloadType: payloadType,
      name: name,
      fmtpLine: fmtpLine,
      clockRate: clockRate,
      encodingParameters: encodingParameters,
      feedbacks: feedbacks,
    );
  }
}
