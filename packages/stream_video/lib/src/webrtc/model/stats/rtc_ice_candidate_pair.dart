// {
//   id: RTCIceCandidatePair_LwmpU2ZS_1/278Ntr,
//   type: candidate-pair,
//   timestamp: 1679425535359288.0,
//   transportId: RTCTransport_0_1,
//   requestsSent: 10,
//   localCandidateId: RTCIceCandidate_LwmpU2ZS,
//   bytesSent: 0,
//   bytesDiscardedOnSend: 0,
//   priority: 9114193830717947902,
//   requestsReceived: 0,
//   writable: false,
//   remoteCandidateId: RTCIceCandidate_1/278Ntr,
//   bytesReceived: 0,
//   packetsReceived: 0,
//   responsesSent: 0,
//   packetsDiscardedOnSend: 0,
//   nominated: false,
//   packetsSent: 0,
//   totalRoundTripTime: 0.0,
//   responsesReceived: 0,
//   state: in-progress,
//   consentRequestsSent: 0
// }

class RtcIceCandidatePair {
  const RtcIceCandidatePair({
    this.id,
    this.type,
    this.timestamp,
    this.transportId,
    this.requestsSent,
    this.localCandidateId,
    this.bytesSent,
    this.bytesDiscardedOnSend,
    this.priority,
    this.requestsReceived,
    this.writable,
    this.remoteCandidateId,
    this.bytesReceived,
    this.packetsReceived,
    this.responsesSent,
    this.packetsDiscardedOnSend,
    this.nominated,
    this.packetsSent,
    this.totalRoundTripTime,
    this.responsesReceived,
    this.state,
    this.consentRequestsSent,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? transportId;
  final int? requestsSent;
  final String? localCandidateId;
  final int? bytesSent;
  final int? bytesDiscardedOnSend;
  final int? priority;
  final int? requestsReceived;
  final bool? writable;
  final String? remoteCandidateId;
  final int? bytesReceived;
  final int? packetsReceived;
  final int? responsesSent;
  final int? packetsDiscardedOnSend;
  final bool? nominated;
  final int? packetsSent;
  final double? totalRoundTripTime;
  final int? responsesReceived;
  final String? state;
  final int? consentRequestsSent;

  static RtcIceCandidatePair? fromJson(dynamic value) {
    if (value is Map) {
      return RtcIceCandidatePair(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        requestsSent: value['requestsSent'],
        localCandidateId: value['localCandidateId'],
        bytesSent: value['bytesSent'],
        bytesDiscardedOnSend: value['bytesDiscardedOnSend'],
        priority: value['priority'],
        requestsReceived: value['requestsReceived'],
        writable: value['writable'],
        remoteCandidateId: value['remoteCandidateId'],
        bytesReceived: value['bytesReceived'],
        packetsReceived: value['packetsReceived'],
        responsesSent: value['responsesSent'],
        packetsDiscardedOnSend: value['packetsDiscardedOnSend'],
        nominated: value['nominated'],
        packetsSent: value['packetsSent'],
        totalRoundTripTime: value['totalRoundTripTime'],
        responsesReceived: value['responsesReceived'],
        state: value['state'],
        consentRequestsSent: value['consentRequestsSent'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCIceCandidatePair{id: $id, type: $type, timestamp: $timestamp, '
        'transportId: $transportId, requestsSent: $requestsSent, '
        'localCandidateId: $localCandidateId, bytesSent: $bytesSent, '
        'bytesDiscardedOnSend: $bytesDiscardedOnSend, priority: $priority, '
        'requestsReceived: $requestsReceived, writable: $writable, '
        'remoteCandidateId: $remoteCandidateId, bytesReceived: $bytesReceived, '
        'packetsReceived: $packetsReceived, responsesSent: $responsesSent, '
        'packetsDiscardedOnSend: $packetsDiscardedOnSend, '
        'nominated: $nominated, packetsSent: $packetsSent, '
        'totalRoundTripTime: $totalRoundTripTime, '
        'responsesReceived: $responsesReceived, state: $state, '
        'consentRequestsSent: $consentRequestsSent}';
  }
}
