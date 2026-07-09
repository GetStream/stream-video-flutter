library;

import '../sfu/data/models/sfu_error.dart';

enum ClientEventStage {
  joinInitiated,
  coordinatorWs,
  mediaDevicePermission,
  coordinatorJoin,
  wsJoin,
  peerConnectionConnect,
  firstVideoFrame,
  firstAudioFrame;

  String get wireValue => switch (this) {
    ClientEventStage.joinInitiated => 'JoinInitiated',
    ClientEventStage.coordinatorWs => 'CoordinatorWS',
    ClientEventStage.mediaDevicePermission => 'MediaDevicePermission',
    ClientEventStage.coordinatorJoin => 'CoordinatorJoin',
    ClientEventStage.wsJoin => 'WSJoin',
    ClientEventStage.peerConnectionConnect => 'PeerConnectionConnect',
    ClientEventStage.firstVideoFrame => 'FirstVideoFrame',
    ClientEventStage.firstAudioFrame => 'FirstAudioFrame',
  };

  bool get carriesStageId => this != ClientEventStage.joinInitiated;
}

enum ClientEventType {
  initiated,
  completed;

  String get wireValue => name;
}

enum ClientEventOutcome {
  success,
  failure;

  String get wireValue => name;
}

enum ClientEventPeerConnectionRole {
  publish,
  subscribe;

  String get wireValue => name;
}

enum ClientEventIceState {
  connected('CONNECTED'),
  failed('FAILED'),
  notConnected('NOT_CONNECTED');

  const ClientEventIceState(this.wireValue);

  final String wireValue;
}

/// A resolved failure: the standard [code] plus human-readable [reason] text
/// sent as `retry_failure_code` / `retry_failure_reason`.
class ClientEventFailure {
  const ClientEventFailure(this.code, this.reason);

  const ClientEventFailure.ice([
    String reason = 'ICE connectivity checks failed',
  ]) : this(ClientEventStandardCode.iceConnectivityFailed, reason);

  const ClientEventFailure.dtls([
    String reason = 'DTLS handshake failed',
  ]) : this(ClientEventStandardCode.dtlsConnectivityFailed, reason);

  const ClientEventFailure.clientAborted([
    String reason = 'Aborted: user left during retry',
  ]) : this(ClientEventStandardCode.clientAborted, reason);

  const ClientEventFailure.backendLeave([
    String reason = 'Backend leave during join',
  ]) : this(ClientEventStandardCode.backendLeave, reason);

  const ClientEventFailure.requestTimeout([
    String reason = 'Request timed out',
  ]) : this(ClientEventStandardCode.requestTimeout, reason);

  final ClientEventStandardCode code;
  final String reason;
}

enum ClientEventStandardCode {
  clientAborted('CLIENT_ABORTED'),
  backendLeave('BACKEND_LEAVE'),
  requestTimeout('REQUEST_TIMEOUT'),
  networkOffline('NETWORK_OFFLINE'),
  iceConnectivityFailed('ICE_CONNECTIVITY_FAILED'),
  dtlsConnectivityFailed('DTLS_CONNECTIVITY_FAILED'),
  serverError('SERVER_ERROR'),
  sfuError('SFU_ERROR'),
  sfuGoAway('SFU_GO_AWAY');

  const ClientEventStandardCode(this.wireValue);

  final String wireValue;
}

enum JoinReason {
  firstAttempt,
  networkAvailable,
  migration,
  fullRejoin;

  /// Whether this reason should mint a new `join_attempt_id`.
  bool get mintsNewAttempt => switch (this) {
    JoinReason.firstAttempt => true,
    JoinReason.migration => true,
    JoinReason.fullRejoin => true,
    JoinReason.networkAvailable => false,
  };

  String get wireValue => switch (this) {
    JoinReason.firstAttempt => 'first-attempt',
    JoinReason.networkAvailable => 'network-available',
    JoinReason.migration => 'migration',
    JoinReason.fullRejoin => 'full-rejoin',
  };
}

extension SfuReconnectionStrategyJoinReason on SfuReconnectionStrategy {
  JoinReason? get joinReason => switch (this) {
    SfuReconnectionStrategy.rejoin => JoinReason.fullRejoin,
    SfuReconnectionStrategy.migrate => JoinReason.migration,
    SfuReconnectionStrategy.fast => null,
    SfuReconnectionStrategy.disconnect => null,
    SfuReconnectionStrategy.unspecified => null,
  };
}
