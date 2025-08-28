enum SfuParticipantSource {
  rtmp,
  whip,
  sip,
  rtsp,
  srt,
  webrtc;

  @override
  String toString() {
    return name;
  }
}
