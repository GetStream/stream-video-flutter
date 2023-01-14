import 'package:meta/meta.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_audio_level.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_audio_sender.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_error.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_models.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_video_sender.dart';

import '../../../webrtc/peer_type.dart';

/// TODO remove V2 suffix after finishing refactoring.
abstract class SfuEventV2 {
  const SfuEventV2();
}

@internal
class SfuUnknownEvent extends SfuEventV2 {
  const SfuUnknownEvent();
}

@internal
class SfuJoinResponseEvent extends SfuEventV2 {
  const SfuJoinResponseEvent({required this.callState});

  final SfuCallState callState;
}

@internal
class SfuSubscriberOfferEvent extends SfuEventV2 {
  const SfuSubscriberOfferEvent({required this.sdp, required this.iceRestart});

  final String sdp;
  final bool iceRestart;
}

@internal
class SfuPublisherAnswerEvent extends SfuEventV2 {
  const SfuPublisherAnswerEvent({required this.sdp});

  final String sdp;
}

@internal
class SfuConnectionQualityChangedEvent extends SfuEventV2 {
  const SfuConnectionQualityChangedEvent({
    required this.connectionQualityUpdates,
  });

  final List<SfuConnectionQualityInfo> connectionQualityUpdates;
}

@internal
class SfuAudioLevelChangedEvent extends SfuEventV2 {
  const SfuAudioLevelChangedEvent({required this.audioLevels});

  final List<SfuAudioLevel> audioLevels;
}

@internal
class SfuIceTrickleEvent extends SfuEventV2 {
  const SfuIceTrickleEvent({
    required this.sessionId,
    required this.peerType,
    required this.iceCandidate,
  });

  final String sessionId;
  final StreamPeerType peerType;
  final String iceCandidate;
}

@internal
class SfuChangePublishQualityEvent extends SfuEventV2 {
  const SfuChangePublishQualityEvent({
    required this.audioSenders,
    required this.videoSenders,
  });

  final List<SfuAudioSender> audioSenders;
  final List<SfuVideoSender> videoSenders;
}

@internal
class SfuParticipantJoinedEvent extends SfuEventV2 {
  const SfuParticipantJoinedEvent({
    required this.callCid,
    required this.participant,
  });

  final String callCid;
  final SfuParticipant participant;
}

@internal
class SfuParticipantLeftEvent extends SfuEventV2 {
  const SfuParticipantLeftEvent({
    required this.callCid,
    required this.participant,
  });

  final String callCid;
  final SfuParticipant participant;
}

@internal
class SfuDominantSpeakerChangedEvent extends SfuEventV2 {
  const SfuDominantSpeakerChangedEvent({
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;
}

@internal
class SfuTrackPublishedEvent extends SfuEventV2 {
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
class SfuTrackUnpublishedEvent extends SfuEventV2 {
  const SfuTrackUnpublishedEvent({
    required this.userId,
    required this.sessionId,
    required this.trackType,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
}

class SfuHealthCheckResponseEvent extends SfuEventV2 {}

class SfuErrorEvent extends SfuEventV2 {
  const SfuErrorEvent({required this.error});

  final SfuError error;
}
