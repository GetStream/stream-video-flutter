import '../../../logger/stream_log.dart';

const _tag = 'SV:EventType';

enum EventType {
  healthCheck('health.check'),
  connectionOk('connection.ok'),
  callCreated('call.created'),
  callAccepted('call.accepted'),
  callRejected('call.rejected'),
  callUpdated('call.updated'),
  callEnded('call.ended'),
  callPermissionRequest('call.permission_request'),
  callPermissionsUpdated('call.permissions_updated'),
  callUserBlocked('call.blocked_user'),
  callUserUnblocked('call.unblocked_user'),
  callRecordingStarted('call.recording_started'),
  callRecordingStopped('call.recording_stopped'),
  callBroadcastingStarted('call.broadcasting_started'),
  callBroadcastingStopped('call.broadcasting_stopped'),
  callReaction('call.reaction_new'),
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
