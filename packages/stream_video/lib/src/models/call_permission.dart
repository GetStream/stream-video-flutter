import '../logger/stream_log.dart';

const _tag = 'SV:CallPermission';

enum CallPermission {
  joinCall('join-call'),
  stopRecordCall('stop-record-call'),
  endCall('end-call'),
  muteUsers('mute-users'),
  startBroadcastCall('start-broadcast-call'),
  stopBroadcastCall('stop-broadcast-call'),
  blockUsers('block-users'),
  readCall('read-call'),
  joinEndedCall('join-ended-call'),
  sendVideo('send-video'),
  sendAudio('send-audio'),
  screenshare('screenshare'),
  startRecordCall('start-record-call'),
  updateCallPermissions('update-call-permissions'),
  createCall('create-call'),
  updateCall('update-call'),
  updateCallSettings('update-call-settings'),
  createReaction('create-reaction'),
  joinBackstage('join-backstage'),
  removeCallMember('remove-call-member'),
  updateCallMember('update-call-member'),
  startTranscriptionCall('start-transcription-call'),
  stopTranscriptionCall('stop-transcription-call'),
  pinForEveryone('pin-for-everyone'),
  unknown('unknown');

  const CallPermission(this.alias);

  factory CallPermission.fromAlias(String alias) {
    return CallPermission.values.firstWhere(
      (e) => e.alias == alias,
      orElse: () {
        streamLog.w(_tag, () => '[fromAlias] unexpected alias: $alias');
        return CallPermission.unknown;
      },
    );
  }

  final String alias;

  @override
  String toString() => alias;
}
