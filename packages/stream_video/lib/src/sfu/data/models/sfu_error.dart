import 'package:equatable/equatable.dart';

import '../../../../protobuf/video/sfu/models/models.pbenum.dart';

class SfuError with EquatableMixin {
  SfuError({
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
  participantNotFound,
  participantMediaTransportFailure,
  callNotFound,
  requestValidationFailed,
  unauthenticated,
  permissionDenied,
  tooManyRequests,
  internalServerError;

  @override
  String toString() => name;
}

enum SfuReconnectionStrategy {
  unspecified,

  /// Sent after reaching the maximum reconnection attempts, leading to permanent disconnect.
  disconnect,

  /// SDK should maintaining existing publisher/subscriber pc instances
  /// and establish a new WebSocket connection.
  fast,

  /// SDK should drop existing pc instances and creates a fresh WebSocket connection,
  /// ensuring a clean state for the reconnection.
  clean,

  /// SDK should obtain new credentials from the coordinator, drops existing pc instances, and initializes
  /// a completely new WebSocket connection, ensuring a comprehensive reset.
  full,

  /// SDK should migrate to a new SFU instance
  migrate;

  @override
  String toString() => name;
}
