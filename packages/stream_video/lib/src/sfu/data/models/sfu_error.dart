import 'package:equatable/equatable.dart';

import '../../../../protobuf/video/sfu/models/models.pbenum.dart';

class SfuError extends Equatable {
  const SfuError({
    required this.message,
    required this.code,
    required this.shouldRetry,
    required this.reconnectStrategy,
  });

  final String message;
  final SfuErrorCode code;
  final bool shouldRetry;
  final SfuReconnectionStrategy reconnectStrategy;

  @override
  String toString() {
    return 'SfuError{code: $code, message: $message, '
        'shouldRetry: $shouldRetry, reconnectStrategy: $reconnectStrategy}';
  }

  @override
  List<Object> get props => [message, code, shouldRetry, reconnectStrategy];
}

enum SfuErrorCode {
  unspecified,
  publishTrackNotFound,
  publishTracksMismatch,
  publishTrackOutOfOrder,
  publishTrackVideoLayerNotFound,
  liveEnded,
  participantNotFound,
  participantMigratingOut,
  participantMigrationFailed,
  participantMigrating,
  participantReconnectFailed,
  participantMediaTransportFailure,
  participantSignalLost,
  callNotFound,
  callParticipantLimitReached,
  requestValidationFailed,
  unauthenticated,
  permissionDenied,
  tooManyRequests,
  internalServerError,
  sfuShuttingDown,
  sfuFull;

  bool get isJoinErrorCode =>
      this == SfuErrorCode.sfuFull ||
      this == SfuErrorCode.sfuShuttingDown ||
      this == SfuErrorCode.callParticipantLimitReached;

  @override
  String toString() => name;
}

/// How a call reconnects to the SFU.
enum SfuReconnectionStrategy {
  /// No strategy given.
  unspecified,

  /// Leave the call without reconnecting.
  disconnect,

  /// Keep the session and its peer connections: open a new socket to the same
  /// SFU, resume the session, and restart ICE.
  fast,

  /// Start over: new credentials from the coordinator, a new session and new
  /// peer connections.
  rejoin,

  /// Move the session to another SFU, keeping its id.
  migrate;

  @override
  String toString() => name;

  WebsocketReconnectStrategy toDto() {
    switch (this) {
      case SfuReconnectionStrategy.disconnect:
        return WebsocketReconnectStrategy
            .WEBSOCKET_RECONNECT_STRATEGY_DISCONNECT;
      case SfuReconnectionStrategy.fast:
        return WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_FAST;
      case SfuReconnectionStrategy.rejoin:
        return WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_REJOIN;
      case SfuReconnectionStrategy.migrate:
        return WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_MIGRATE;
      default:
        return WebsocketReconnectStrategy
            .WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED;
    }
  }
}
