import '../../../logger/stream_log.dart';

const _tag = 'SV:EventType';

enum EventType {
  healthCheck('health.check'),
  connectionOk('connection.ok'),
  callCreated('call.created'),
  callAccepted('call.accepted'),
  callRejected('call.rejected'),
  callMissed('call.missed'),
  callRing('call.ring'),
  callUpdated('call.updated'),
  callEnded('call.ended'),
  callSessionStarted('call.session_started'),
  callSessionEnded('call.session_ended'),
  callSessionParticipantJoined('call.session_participant_joined'),
  callSessionParticipantLeft('call.session_participant_left'),
  callSessionParticipantCountUpdated('call.session_participant_count_updated'),
  callPermissionRequest('call.permission_request'),
  callPermissionsUpdated('call.permissions_updated'),
  callUserBlocked('call.blocked_user'),
  callUserUnblocked('call.unblocked_user'),
  callRecordingStarted('call.recording_started'),
  callRecordingStopped('call.recording_stopped'),
  callBroadcastingStarted('call.hls_broadcasting_started'),
  callBroadcastingStopped('call.hls_broadcasting_stopped'),
  callBroadcastingFailed('call.hls_broadcasting_failed'),
  callLiveStarted('call.live_started'),
  callMemberAdded('call.member_added'),
  callMemberRemoved('call.member_removed'),
  callMemberUpdated('call.member_updated'),
  callMemberUpdatedPermission('call.member_updated_permission'),
  callNotification('call.notification'),
  callReaction('call.reaction_new'),
  callUserMuted('call.user_muted'),
  callRecordingReady('call.recording_ready'),
  callRecordingFailed('call.recording_failed'),
  callTranscriptionStarted('call.transcription_started'),
  callTranscriptionStopped('call.transcription_stopped'),
  callTranscriptionFailed('call.transcription_failed'),
  callClosedCaption('call.closed_caption'),
  custom('custom'),
  unknown('unknown');

  const EventType(this.alias);

  factory EventType.fromAlias(dynamic alias) {
    return EventType.values.firstWhere(
      (e) => e.alias == alias,
      orElse: () {
        streamLog.w(_tag, () => '[fromAlias] unexpected alias: $alias');
        return EventType.unknown;
      },
    );
  }

  final String alias;
}
