import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart'
    as sfu_models;
import 'package:stream_video/src/v2/sfu/models/sfu_events.dart';
import 'package:stream_video/src/v2/sfu/models/sfu_models.dart';

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
        return SfuConnectionQualityChangedEvent(
          connectionQualityUpdates: payload.connectionQualityUpdates.map((it) {
            return SfuConnectionQualityInfo(
              userId: it.userId,
              sessionId: it.sessionId,
              connectionQuality: it.connectionQuality.toDomain(),
            );
          }).toList(),
        );

      case sfu_events.SfuEvent_EventPayload.audioLevelChanged:
        final payload = audioLevelChanged;
        return SfuAudioLevelChangedEvent(
          audioLevels: payload.audioLevels.map((it) {
            return SfuAudioLevel(
              userId: it.userId,
              sessionId: it.sessionId,
              level: it.level,
              isSpeaking: it.isSpeaking,
            );
          }).toList(),
        );

      case sfu_events.SfuEvent_EventPayload.iceTrickle:
        final payload = iceTrickle;
        return SfuIceTrickleEvent(
          sessionId: payload.sessionId,
          iceCandidate: payload.iceCandidate,
        );

      case sfu_events.SfuEvent_EventPayload.changePublishQuality:
        final payload = changePublishQuality;
        return SfuChangePublishQualityEvent(
          audioSenders: payload.audioSenders,
          videoSenders: payload.videoSenders,
        );

      case sfu_events.SfuEvent_EventPayload.joinResponse:
        return SfuJoinResponseEvent(response: joinResponse);
      case sfu_events.SfuEvent_EventPayload.participantJoined:
        return SfuParticipantJoinedEvent(
          participantJoined: participantJoined,
        );
      case sfu_events.SfuEvent_EventPayload.participantLeft:
        return SfuParticipantLeftEvent(
          participantLeft: participantLeft,
        );
      case sfu_events.SfuEvent_EventPayload.dominantSpeakerChanged:
        return SfuDominantSpeakerChangedEvent(
          dominantSpeakerChanged: dominantSpeakerChanged,
        );
      case sfu_events.SfuEvent_EventPayload.trackPublished:
        return SfuTrackPublishedEvent(trackPublished: trackPublished);
      case sfu_events.SfuEvent_EventPayload.trackUnpublished:
        return SfuTrackUnpublishedEvent(
          trackUnpublished: trackUnpublished,
        );
      case sfu_events.SfuEvent_EventPayload.healthCheckResponse:
        return SfuHealthCheckResponseEvent(
          healthCheckResponse: healthCheckResponse,
        );
      case sfu_events.SfuEvent_EventPayload.error:
        return SfuErrorEvent(error: error);
      default:
        return SfuUnknownEvent();
    }
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
