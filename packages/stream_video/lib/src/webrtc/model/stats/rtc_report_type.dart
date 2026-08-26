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

  /// The report types the SDK actually parses.
  ///
  /// Passed to `getStats` as an allowlist so the platform never builds — and
  /// the platform channel never carries — reports nothing reads. Everything
  /// listed here is consumed by `RtcRawStatsMapper`; the remaining types are
  /// only forwarded verbatim to the SFU, which asks for the unfiltered report.
  static const consumedTypes = <String>[
    'codec',
    'candidate-pair',
    'remote-candidate',
    'local-candidate',
    'remote-inbound-rtp',
    'inbound-rtp',
    'outbound-rtp',
    'track',
    'media-source',
  ];

  final String alias;

  static const propertyName = 'type';

  @override
  String toString() => alias;
}
