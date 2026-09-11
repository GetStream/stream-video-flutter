import 'package:stream_core/stream_core.dart' show CloseCode;

export 'health/network_monitor.dart';

/// The WebSocket close codes this SDK sends that are not already standard.
///
/// RFC 6455 reserves 4000–4999 for the application, so these sit alongside
/// [CloseCode.normalClosure] and its siblings rather than restating them —
/// close a socket with a standard code by naming it on [CloseCode] directly.
abstract final class StreamVideoCloseCode {
  /// The SFU connection is unhealthy: nothing has arrived from the SFU for
  /// `connectionCheckTimeout`.
  static const connectionUnhealthy = CloseCode(4001);

  /// This socket is being replaced, because a new one is established or about
  /// to be.
  ///
  /// Deliberately not [CloseCode.normalClosure]: that would have the SFU
  /// release the resources of the participant we are about to reconnect.
  static const disposeOldSocket = CloseCode(4002);
}
