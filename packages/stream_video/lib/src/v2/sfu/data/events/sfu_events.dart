import 'package:meta/meta.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_audio_level.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_audio_sender.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_error.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_models.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_video_sender.dart';

abstract class SfuEvent {
  const SfuEvent();
}

@internal
class SfuUnknownEvent extends SfuEvent {
  const SfuUnknownEvent();
}

@internal
class SfuJoinResponseEvent extends SfuEvent {
  const SfuJoinResponseEvent({required this.callState});

  final SfuCallState callState;
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

  final List<SfuAudioSender> audioSenders;
  final List<SfuVideoSender> videoSenders;
}

@internal
class SfuParticipantJoinedEvent extends SfuEvent {
  const SfuParticipantJoinedEvent({
    required this.callCid,
    required this.participant,
  });

  final String callCid;
  final SfuParticipant participant;
}

@internal
class SfuParticipantLeftEvent extends SfuEvent {
  const SfuParticipantLeftEvent({
    required this.callCid,
    required this.participant,
  });

  final String callCid;
  final SfuParticipant participant;
}

@internal
class SfuDominantSpeakerChangedEvent extends SfuEvent {
  const SfuDominantSpeakerChangedEvent({
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;
}

@internal
class SfuTrackPublishedEvent extends SfuEvent {
  const SfuTrackPublishedEvent({
    required this.userId,
    required this.sessionId,
    required this.trackType,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
}

@internal
class SfuTrackUnpublishedEvent extends SfuEvent {
  const SfuTrackUnpublishedEvent({
    required this.userId,
    required this.sessionId,
    required this.trackType,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
}

class SfuHealthCheckResponseEvent extends SfuEvent {}

class SfuErrorEvent extends SfuEvent {
  const SfuErrorEvent({required this.error});

  final SfuError error;
}
