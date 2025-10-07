import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../errors/video_error.dart';
import '../../../logger/stream_logger.dart';
import '../../../webrtc/peer_type.dart';
import '../models/sfu_audio_level.dart';
import '../models/sfu_audio_sender.dart';
import '../models/sfu_call_ended_reason.dart';
import '../models/sfu_call_grants.dart';
import '../models/sfu_call_state.dart';
import '../models/sfu_connection_info.dart';
import '../models/sfu_error.dart';
import '../models/sfu_goaway_reason.dart';
import '../models/sfu_inbound_video_state.dart';
import '../models/sfu_participant.dart';
import '../models/sfu_pin.dart';
import '../models/sfu_publish_options.dart';
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
  const SfuJoinResponseEvent({
    required this.callState,
    this.isReconnected = false,
    this.fastReconnectDeadline = Duration.zero,
    this.publishOptions = const [],
  });

  final SfuCallState callState;
  final bool isReconnected;
  final Duration fastReconnectDeadline;
  final List<SfuPublishOptions> publishOptions;

  @override
  List<Object> get props => [callState, isReconnected, fastReconnectDeadline];
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
class SfuChangePublishOptionsEvent extends SfuEvent {
  const SfuChangePublishOptionsEvent({
    required this.publishOptions,
    this.reason,
  });

  final List<SfuPublishOptions> publishOptions;
  final String? reason;
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
class SfuParticipantUpdatedEvent extends SfuEvent {
  const SfuParticipantUpdatedEvent({
    required this.callCid,
    required this.participant,
  });

  final String callCid;
  final SfuParticipant participant;

  @override
  List<Object> get props => [callCid, participant];
}

@internal
class SfuParticipantMigrationCompleteEvent extends SfuEvent {
  const SfuParticipantMigrationCompleteEvent();

  @override
  List<Object> get props => [];
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
class SfuPinsUpdatedEvent extends SfuEvent {
  const SfuPinsUpdatedEvent({
    required this.pins,
  });

  final List<SfuPin> pins;

  @override
  List<Object> get props => [pins];
}

@internal
class SfuTrackPublishedEvent extends SfuEvent {
  const SfuTrackPublishedEvent({
    required this.userId,
    required this.sessionId,
    required this.trackType,
    required this.participant,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
  final SfuParticipant participant;

  @override
  List<Object> get props => [userId, sessionId, trackType, participant];
}

@internal
class SfuTrackUnpublishedEvent extends SfuEvent {
  const SfuTrackUnpublishedEvent({
    required this.userId,
    required this.sessionId,
    required this.trackType,
    required this.participant,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
  final SfuParticipant participant;

  @override
  List<Object> get props => [userId, sessionId, trackType, participant];
}

class SfuHealthCheckResponseEvent extends SfuEvent {
  const SfuHealthCheckResponseEvent(this.participantCount);

  final SfuParticipantCount participantCount;

  @override
  List<Object> get props => [participantCount];
}

class SfuCallGrantsUpdated extends SfuEvent {
  const SfuCallGrantsUpdated({
    required this.currentGrants,
    required this.message,
  });

  final SfuCallGrants currentGrants;
  final String message;

  @override
  List<Object> get props => [currentGrants, message];
}

class SfuInboundStateNotificationEvent extends SfuEvent {
  const SfuInboundStateNotificationEvent({
    required this.inboundVideoStates,
  });

  final List<SfuInboundVideoState> inboundVideoStates;

  @override
  List<Object> get props => [inboundVideoStates];

  @override
  String toString() {
    return 'SfuInboundStateNotificationEvent{inboundVideoStates: $inboundVideoStates}';
  }
}

class SfuErrorEvent extends SfuEvent {
  const SfuErrorEvent({required this.error});

  final SfuError error;

  @override
  List<Object> get props => [error];
}

abstract class SfuSocketEvent extends SfuEvent {
  const SfuSocketEvent();
}

class SfuSocketConnected extends SfuSocketEvent {
  const SfuSocketConnected({
    required this.sessionId,
    required this.url,
  });

  final String sessionId;
  final String url;

  @override
  List<Object?> get props => [sessionId, url];
}

class SfuGoAwayEvent extends SfuSocketEvent {
  const SfuGoAwayEvent({
    required this.goAwayReason,
  });

  final SfuGoAwayReason goAwayReason;

  @override
  List<Object?> get props => [goAwayReason];
}

class SfuCallEndedEvent extends SfuSocketEvent {
  const SfuCallEndedEvent({
    required this.callEndedReason,
  });

  final SfuCallEndedReason callEndedReason;

  @override
  List<Object?> get props => [callEndedReason];
}

class SfuSocketDisconnected extends SfuSocketEvent {
  const SfuSocketDisconnected({
    required this.sessionId,
    required this.url,
    required this.reason,
  });

  final String sessionId;
  final String url;
  final DisconnectionReason reason;

  @override
  List<Object?> get props => [sessionId, url, reason];
}

class SfuSocketFailed extends SfuSocketEvent {
  const SfuSocketFailed({
    required this.sessionId,
    required this.url,
    required this.error,
  });

  final String sessionId;
  final String url;
  final VideoError error;

  @override
  List<Object?> get props => [sessionId, url, error];
}

class DisconnectionReason with EquatableMixin {
  DisconnectionReason({
    this.closeCode,
    this.closeReason,
  });

  final int? closeCode;
  final String? closeReason;

  @override
  String toString() {
    return 'DisconnectionReason{code: $closeCode, reason: $closeReason}';
  }

  @override
  List<Object?> get props => [closeCode, closeReason];
}

extension LogPriority on SfuEvent {
  Priority get logPriority {
    if (this is SfuSocketFailed) {
      return Priority.error;
    } else if (this is SfuSocketDisconnected) {
      return Priority.warning;
    } else {
      return Priority.verbose;
    }
  }
}
