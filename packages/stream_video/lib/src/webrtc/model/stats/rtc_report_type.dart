enum RtcReportType {
  certificate('certificate'),
  codec('codec'),
  candidatePair('candidate-pair'),
  remoteCandidate('remote-candidate'),
  localCandidate('local-candidate'),
  remoteInboundRtp('remote-inbound-rtp'),
  inboundRtp('inbound-rtp'),
  outboundRtp('outbound-rtp'),
  track('track'),
  mediaSource('media-source'),
  stream('stream'),
  peerConnection('peer-connection'),
  transport('transport'),
  unknown('unknown');

  const RtcReportType(this.alias);

  factory RtcReportType.fromAlias(dynamic alias) {
    return RtcReportType.values.firstWhere(
      (e) => e.alias == alias,
      orElse: () => RtcReportType.unknown,
    );
  }

  final String alias;

  static const propertyName = 'type';

  @override
  String toString() => alias;
}
