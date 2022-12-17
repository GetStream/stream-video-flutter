/// Base class for Exceptions thrown by the LiveKit SDK
abstract class StreamCallException implements Exception {
  const StreamCallException._(this.message);
  final String message;

  @override
  String toString() => 'StreamCall Exception: [$runtimeType] $message';
}

/// An exception occured while attempting to connect.
/// Common reasons:
/// - Invalid token (make sure your token is generated correctly)
/// - Network condition is not good
/// - Server not set up correctly (not responding)
class ConnectException extends StreamCallException {
  ConnectException([super.msg = 'Failed to connect to server']) : super._();
}

/// An internal state of the SDK is not correct and can not continue to execute.
/// This should not occur frequently.
class UnexpectedStateException extends StreamCallException {
  UnexpectedStateException([super.msg = 'Unexpected connection state'])
      : super._();
}

/// Failed to create a local track.
/// Common reasons:
/// - Required permissions not yet granted to the platform.
/// - Constraints(Capture options) rejected by the platform.
class TrackCreateException extends StreamCallException {
  TrackCreateException([super.msg = 'Failed to create track']) : super._();
}

/// Failed to publish a local track.
/// Common reasons:
/// - Token does not have track publish permission.
/// - Network condition is not good.
class TrackPublishException extends StreamCallException {
  TrackPublishException([super.msg = 'Failed to publish track']) : super._();
}

/// A certain time has passed while attempting to execute an operation.
class TimeoutException extends StreamCallException {
  TimeoutException([super.msg = 'Timeout']) : super._();
}
