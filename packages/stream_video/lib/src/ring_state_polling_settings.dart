/// Caller-side polling for the outcome of a ring.
///
/// `call.accepted` and `call.rejected` reach the caller only over the
/// coordinator WebSocket, with no redelivery. A caller that misses one keeps
/// ringing until its ring timeout, and then rejects a call the callee may
/// already be sitting in. While a ring goes unanswered for [startAfter], the
/// caller reads the ring state every [interval] until the ring settles or the
/// ring timeout runs out.
class RingStatePollingSettings {
  const RingStatePollingSettings({
    this.enabled = true,
    this.startAfter = const Duration(seconds: 9),
    this.interval = const Duration(seconds: 5),
  });

  /// Turns polling off.
  const RingStatePollingSettings.disabled() : this(enabled: false);

  /// Whether the caller polls the ring state at all.
  final bool enabled;

  /// How long the ring has to go without a ring event before the first poll.
  ///
  /// Defaults to 9 seconds, so that a 30 second ring without a ring event is
  /// read at 9, 14, 19, 24 and 29 seconds. A callee who takes longer than that
  /// to answer is read every [interval] until the answer arrives, even when the
  /// WebSocket is healthy; raise it to poll less.
  ///
  /// Every `call.accepted`, `call.rejected` or `call.missed` event restarts it,
  /// as an event proves the WebSocket is alive.
  final Duration startAfter;

  /// The time between two polls.
  ///
  /// Must be positive: a zero or negative interval turns polling off.
  final Duration interval;
}
