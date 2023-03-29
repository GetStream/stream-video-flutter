import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../webrtc/peer_type.dart';
import '../models/sfu_audio_level.dart';
import '../models/sfu_audio_sender.dart';
import '../models/sfu_call_state.dart';
import '../models/sfu_error.dart';
import '../models/sfu_models.dart';
import '../models/sfu_participant.dart';
import '../models/sfu_track_type.dart';
import '../models/sfu_video_sender.dart';

abstract class SfuEvent extends Equatable {
  const SfuEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

@internal
class SfuUnknownEvent extends SfuEvent {
  const SfuUnknownEvent();
}

@internal
class SfuJoinResponseEvent extends SfuEvent {
  const SfuJoinResponseEvent({required this.callState});

  final SfuCallState callState;

  @override
  List<Object> get props => [callState];
}

@internal
class SfuSubscriberOfferEvent extends SfuEvent {
  const SfuSubscriberOfferEvent({required this.sdp, required this.iceRestart});

  final String sdp;
  final bool iceRestart;

  @override
  List<Object> get props => [iceRestart, sdp];
}

@internal
class SfuPublisherAnswerEvent extends SfuEvent {
  const SfuPublisherAnswerEvent({required this.sdp});

  final String sdp;

  @override
  List<Object> get props => [sdp];
}

@internal
class SfuConnectionQualityChangedEvent extends SfuEvent {
  const SfuConnectionQualityChangedEvent({
    required this.connectionQualityUpdates,
  });

  final List<SfuConnectionQualityInfo> connectionQualityUpdates;

  @override
  List<Object> get props => [connectionQualityUpdates];
}

@internal
class SfuAudioLevelChangedEvent extends SfuEvent {
  const SfuAudioLevelChangedEvent({required this.audioLevels});

  final List<SfuAudioLevel> audioLevels;

  @override
  List<Object> get props => [audioLevels];
}

@internal
class SfuIceTrickleEvent extends SfuEvent {
  const SfuIceTrickleEvent({
    required this.sessionId,
    required this.peerType,
    required this.iceCandidate,
  });

  final String sessionId;
  final StreamPeerType peerType;
  final String iceCandidate;

  @override
  List<Object> get props => [sessionId, peerType, iceCandidate];
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

  @override
  List<Object> get props => [callCid, participant];
}

@internal
class SfuParticipantLeftEvent extends SfuEvent {
  const SfuParticipantLeftEvent({
    required this.callCid,
    required this.participant,
  });

  final String callCid;
  final SfuParticipant participant;

  @override
  List<Object> get props => [callCid, participant];
}

@internal
class SfuDominantSpeakerChangedEvent extends SfuEvent {
  const SfuDominantSpeakerChangedEvent({
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;

  @override
  List<Object> get props => [userId, sessionId];
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

  @override
  List<Object> get props => [userId, sessionId, trackType];
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

  @override
  List<Object> get props => [userId, sessionId, trackType];
}

class SfuHealthCheckResponseEvent extends SfuEvent {}

class SfuErrorEvent extends SfuEvent {
  const SfuErrorEvent({required this.error});

  final SfuError error;

  @override
  List<Object> get props => [error];
}
