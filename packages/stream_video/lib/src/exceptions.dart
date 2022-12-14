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
  ConnectException([String msg = 'Failed to connect to server']) : super._(msg);
}

/// An internal state of the SDK is not correct and can not continue to execute.
/// This should not occur frequently.
class UnexpectedStateException extends StreamCallException {
  UnexpectedStateException([String msg = 'Unexpected connection state'])
      : super._(msg);
}

/// Failed to create a local track.
/// Common reasons:
/// - Required permissions not yet granted to the platform.
/// - Constraints(Capture options) rejected by the platform.
class TrackCreateException extends StreamCallException {
  TrackCreateException([String msg = 'Failed to create track']) : super._(msg);
}

/// Failed to publish a local track.
/// Common reasons:
/// - Token does not have track publish permission.
/// - Network condition is not good.
class TrackPublishException extends StreamCallException {
  TrackPublishException([String msg = 'Failed to publish track'])
      : super._(msg);
}

/// A certain time has passed while attempting to execute an operation.
class TimeoutException extends StreamCallException {
  TimeoutException([String msg = 'Timeout']) : super._(msg);
}
