part of 'call.dart';

/// Triggers the call's reconnect paths by hand, for checking them on a
/// device.
///
/// Each method does nothing while the call has no SFU session.
extension CallDebug on Call {
  /// Closes the SFU socket the way a missed pong does. The SFU sees the socket
  /// go and keeps the session for a fast reconnect, which the call starts.
  void debugDropSfuSocket() {
    _session?.sfuWS.simulateConnectionLoss();
  }

  /// Handles a rejoin request from the [type] peer connection, as if its state
  /// had turned failed.
  ///
  /// The peer connection itself stays connected. While a join or reconnect
  /// runs, the request waits for it and is then dropped, since the connection
  /// is healthy.
  void debugFailPeerConnection(StreamPeerType type) {
    final session = _session;
    final rtcManager = session?.rtcManager;
    if (session == null || rtcManager == null) return;

    final pc = switch (type) {
      StreamPeerType.publisher => rtcManager.publisher,
      StreamPeerType.subscriber => rtcManager.subscriber,
    };
    if (pc == null) return;

    _connection._onReconnectionNeeded(
      pc,
      SfuReconnectionStrategy.rejoin,
      ReconnectionNeededReason.connectionFailed,
      session: session,
    );
  }

  /// Handles a GoAway as if the SFU had sent one. The SFU knows nothing about
  /// it, so the migration waits for a migration complete that never comes.
  void debugReceiveGoAway() {
    final session = _session;
    if (session == null) return;

    unawaited(
      _connection._onSfuConnectionEvent(
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.migrate),
        session: session,
      ),
    );
  }

  /// Handles an SFU error naming [strategy], as if the SFU had sent one.
  void debugReceiveSfuError(SfuReconnectionStrategy strategy) {
    final session = _session;
    if (session == null) return;

    unawaited(
      _connection._onSfuConnectionEvent(
        SfuErrorEvent(
          error: SfuError(
            message: 'Simulated SFU error',
            code: SfuErrorCode.unspecified,
            shouldRetry: true,
            reconnectStrategy: strategy,
          ),
        ),
        session: session,
      ),
    );
  }
}
