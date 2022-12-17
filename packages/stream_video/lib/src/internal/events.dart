import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';
import '../../protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator;
import '../../protobuf/video/coordinator/event_v1/event.pb.dart'
    as coordinator_event;
import '../../protobuf/video/sfu/event/events.pbserver.dart' as sfu_events;
import '../../protobuf/video/sfu/models/models.pbserver.dart' as sfu_models;
import '../events.dart';
import '../track/local/local.dart';
import '../track/options.dart';
import '../track/track.dart';

mixin InternalEvent implements StreamCallEvent {}

@internal
class TrackStreamUpdatedEvent with TrackEvent, InternalEvent {
  const TrackStreamUpdatedEvent({
    required this.track,
    required this.stream,
  });
  final Track track;
  final rtc.MediaStream stream;
}

@internal
class LocalTrackOptionsUpdatedEvent with TrackEvent, InternalEvent {
  const LocalTrackOptionsUpdatedEvent({
    required this.track,
    required this.options,
  });
  final LocalTrack track;
  final LocalTrackOptions options;
}

// Used to notify muted state from Track to TrackPublication.
@internal
class InternalTrackMuteUpdatedEvent with TrackEvent, InternalEvent {
  const InternalTrackMuteUpdatedEvent({
    required this.track,
    required this.muted,
    required this.notifyServer,
  });
  final Track track;
  final bool muted;
  final bool notifyServer;

  @override
  String toString() => 'TrackMuteUpdatedEvent(track: $track, muted: $muted)';
}

// ----------------------------------------------------------------------
// Coordinator events
// ----------------------------------------------------------------------
@internal
class CoordinatorHealthCheckEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorHealthCheckEvent({required this.healthcheck});

  final coordinator.WebsocketHealthcheck healthcheck;
}

@internal
class CoordinatorErrorEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorErrorEvent({required this.error});

  final coordinator.WebsocketError error;
}

@internal
class CoordinatorCallCreatedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallCreatedEvent({required this.callCreated});

  final coordinator_event.CallCreated callCreated;
}

@internal
class CoordinatorCallUpdatedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallUpdatedEvent({required this.callUpdated});

  final coordinator_event.CallUpdated callUpdated;
}

@internal
class CoordinatorCallDeletedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallDeletedEvent({required this.callDeleted});

  final coordinator_event.CallDeleted callDeleted;
}

@internal
class CoordinatorCallMembersCreatedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallMembersCreatedEvent({
    required this.callMembersCreated,
  });

  final coordinator_event.CallMembersCreated callMembersCreated;
}

@internal
class CoordinatorCallMembersUpdatedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallMembersUpdatedEvent({
    required this.callMembersUpdated,
  });

  final coordinator_event.CallMembersUpdated callMembersUpdated;
}

@internal
class CoordinatorCallMembersDeletedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallMembersDeletedEvent({
    required this.callMembersDeleted,
  });

  final coordinator_event.CallMembersDeleted callMembersDeleted;
}

@internal
class CoordinatorCallEndedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallEndedEvent({required this.callEnded});

  final coordinator_event.CallEnded callEnded;
}

@internal
class CoordinatorCallAcceptedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallAcceptedEvent({required this.callAccepted});

  final coordinator_event.CallAccepted callAccepted;
}

@internal
class CoordinatorCallRejectedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallRejectedEvent({required this.callRejected});

  final coordinator_event.CallRejected callRejected;
}

@internal
class CoordinatorCallCancelledEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallCancelledEvent({required this.callCancelled});

  final coordinator_event.CallCancelled callCancelled;
}

@internal
class CoordinatorUserUpdatedEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorUserUpdatedEvent({required this.userUpdated});

  final coordinator_event.UserUpdated userUpdated;
}

@internal
class CoordinatorCallCustomEvent with CoordinatorEvent, InternalEvent {
  const CoordinatorCallCustomEvent({required this.callCustom});

  final coordinator_event.CallCustom callCustom;
}

// ----------------------------------------------------------------------
// SFU events
// ----------------------------------------------------------------------

@internal
class SFUJoinResponseEvent with SfuEvent, InternalEvent {
  const SFUJoinResponseEvent({required this.response});

  final sfu_events.JoinResponse response;
}

@internal
class SFUSubscriberOfferEvent with SfuEvent, InternalEvent {
  const SFUSubscriberOfferEvent({required this.offer});

  final sfu_events.SubscriberOffer offer;
}

@internal
class SFUPublisherAnswerEvent with SfuEvent, InternalEvent {
  const SFUPublisherAnswerEvent({required this.answer});

  final sfu_events.PublisherAnswer answer;
}

@internal
class SFUConnectionQualityChangedEvent with SfuEvent, InternalEvent {
  const SFUConnectionQualityChangedEvent({
    required this.connectionQualityChanged,
  });

  final sfu_events.ConnectionQualityChanged connectionQualityChanged;
}

@internal
class SFUAudioLevelChangedEvent with SfuEvent, InternalEvent {
  const SFUAudioLevelChangedEvent({required this.audioLevelChanged});

  final sfu_events.AudioLevelChanged audioLevelChanged;
}

@internal
class SFUIceTrickleEvent with SfuEvent, InternalEvent {
  const SFUIceTrickleEvent({required this.iceTrickle});

  final sfu_models.ICETrickle iceTrickle;
}

@internal
class SFUChangePublishQualityEvent with SfuEvent, InternalEvent {
  const SFUChangePublishQualityEvent({required this.changePublishQuality});

  final sfu_events.ChangePublishQuality changePublishQuality;
}

@internal
class SFUParticipantJoinedEvent with SfuEvent, InternalEvent {
  const SFUParticipantJoinedEvent({required this.participantJoined});

  final sfu_events.ParticipantJoined participantJoined;
}

@internal
class SFUParticipantLeftEvent with SfuEvent, InternalEvent {
  const SFUParticipantLeftEvent({required this.participantLeft});

  final sfu_events.ParticipantLeft participantLeft;
}

@internal
class SFUDominantSpeakerChangedEvent with SfuEvent, InternalEvent {
  const SFUDominantSpeakerChangedEvent({
    required this.dominantSpeakerChanged,
  });

  final sfu_events.DominantSpeakerChanged dominantSpeakerChanged;
}

@internal
class SFUTrackPublishedEvent with SfuEvent, InternalEvent {
  const SFUTrackPublishedEvent({required this.trackPublished});

  final sfu_events.TrackPublished trackPublished;
}

@internal
class SFUTrackUnpublishedEvent with SfuEvent, InternalEvent {
  const SFUTrackUnpublishedEvent({required this.trackUnpublished});

  final sfu_events.TrackUnpublished trackUnpublished;
}

class SFUHealthCheckResponseEvent with SfuEvent, InternalEvent {
  const SFUHealthCheckResponseEvent({required this.healthCheckResponse});

  final sfu_events.HealthCheckResponse healthCheckResponse;
}

class SFUErrorEvent with SfuEvent, InternalEvent {
  const SFUErrorEvent({required this.error});

  final sfu_events.Error error;
}
