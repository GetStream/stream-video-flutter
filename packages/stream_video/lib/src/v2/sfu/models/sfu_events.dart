import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator;
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart'
    as coordinator_event;
import 'package:stream_video/protobuf/video/sfu/event/events.pbserver.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu_models;
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/track/local/local.dart';
import 'package:stream_video/src/track/options.dart';
import 'package:stream_video/src/track/track.dart';
import 'package:stream_video/src/v2/sfu/models/sfu_models.dart';

abstract class SfuEvent {
  const SfuEvent();
}

@internal
class SfuUnknownEvent extends SfuEvent {
  const SfuUnknownEvent();
}

@internal
class SfuJoinResponseEvent extends SfuEvent {
  const SfuJoinResponseEvent({required this.response});

  final sfu_events.JoinResponse response;
}

@internal
class SfuSubscriberOfferEvent extends SfuEvent {
  const SfuSubscriberOfferEvent({required this.sdp, required this.iceRestart});

  final String sdp;
  final bool iceRestart;
}

@internal
class SfuPublisherAnswerEvent extends SfuEvent {
  const SfuPublisherAnswerEvent({required this.sdp});

  final String sdp;
}

@internal
class SfuConnectionQualityChangedEvent extends SfuEvent {
  const SfuConnectionQualityChangedEvent({
    required this.connectionQualityUpdates,
  });

  final List<SfuConnectionQualityInfo> connectionQualityUpdates;
}

@internal
class SfuAudioLevelChangedEvent extends SfuEvent {
  const SfuAudioLevelChangedEvent({required this.audioLevels});

  final List<SfuAudioLevel> audioLevels;
}

@internal
class SfuIceTrickleEvent extends SfuEvent {
  const SfuIceTrickleEvent({
    required this.sessionId,
    required this.iceCandidate,
  });

  final String sessionId;
  final String iceCandidate;
}

@internal
class SfuChangePublishQualityEvent extends SfuEvent {
  const SfuChangePublishQualityEvent({
    required this.audioSenders,
    required this.videoSenders,
  });

  final List<sfu_events.AudioSender> audioSenders;
  final List<sfu_events.VideoSender> videoSenders;
}

@internal
class SfuParticipantJoinedEvent extends SfuEvent {
  const SfuParticipantJoinedEvent({required this.participantJoined});

  final sfu_events.ParticipantJoined participantJoined;
}

@internal
class SfuParticipantLeftEvent extends SfuEvent {
  const SfuParticipantLeftEvent({required this.participantLeft});

  final sfu_events.ParticipantLeft participantLeft;
}

@internal
class SfuDominantSpeakerChangedEvent extends SfuEvent {
  const SfuDominantSpeakerChangedEvent({
    required this.dominantSpeakerChanged,
  });

  final sfu_events.DominantSpeakerChanged dominantSpeakerChanged;
}

@internal
class SfuTrackPublishedEvent extends SfuEvent {
  const SfuTrackPublishedEvent({required this.trackPublished});

  final sfu_events.TrackPublished trackPublished;
}

@internal
class SfuTrackUnpublishedEvent extends SfuEvent {
  const SfuTrackUnpublishedEvent({required this.trackUnpublished});

  final sfu_events.TrackUnpublished trackUnpublished;
}

class SfuHealthCheckResponseEvent extends SfuEvent {
  const SfuHealthCheckResponseEvent({required this.healthCheckResponse});

  final sfu_events.HealthCheckResponse healthCheckResponse;
}

class SfuErrorEvent extends SfuEvent {
  const SfuErrorEvent({required this.error});

  final sfu_events.Error error;
}
