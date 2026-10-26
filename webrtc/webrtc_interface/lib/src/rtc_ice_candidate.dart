class RTCIceCandidate {
  RTCIceCandidate(this.candidate, this.sdpMid, this.sdpMLineIndex);
  final String? candidate;
  final String? sdpMid;
  final int? sdpMLineIndex;
  dynamic toMap() {
    return {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMLineIndex': sdpMLineIndex
    };
  }
}
