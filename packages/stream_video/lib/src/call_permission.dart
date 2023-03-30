enum CallPermission {
  joinCall('join-call'),
  stopRecordCall('stop-record-call'),
  stopTranscribeCall('start-transcription-call'),
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
  startTranscribeCall('start-transcription-call'),
  updateCallPermissions('update-call-permissions'),
  createCall('create-call'),
  updateCall('update-call'),
  updateCallSettings('update-call-settings'),
  unknown('unknown');

  const CallPermission(this.alias);

  factory CallPermission.fromAlias(String alias) {
    return CallPermission.values.firstWhere(
      (e) => e.alias == alias,
      orElse: () => CallPermission.unknown,
    );
  }

  final String alias;

  @override
  String toString() => alias;
}
