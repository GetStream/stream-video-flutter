import 'package:meta/meta.dart';

/// Which call shares the iOS broadcast. Process-wide, as the app has one
/// broadcast extension.
///
/// The broadcast belongs to the call that showed the picker last. One that
/// starts without a request, such as from Control Center, belongs to the
/// client's active call.
@internal
class IosBroadcastOwner {
  IosBroadcastOwner._();

  static final IosBroadcastOwner instance = IosBroadcastOwner._();

  Object? _requester;
  bool _isActive = false;

  /// Whether the broadcast is running, as the last start or stop event said.
  bool get isActive => _isActive;

  /// Whether a call showed the picker and the broadcast has not stopped
  /// since.
  bool get hasRequest => _requester != null;

  /// Whether [call] showed the picker last.
  bool isRequestedBy(Object call) => identical(_requester, call);

  /// Records that [call] showed the picker.
  void request(Object call) => _requester = call;

  /// Drops the request of [call], if it made the last one.
  void release(Object call) {
    if (identical(_requester, call)) _requester = null;
  }

  void onStarted() => _isActive = true;

  void onStopped() {
    _isActive = false;
    _isUnclaimed = false;
    _requester = null;
  }

  bool _isUnclaimed = false;

  /// Keeps a broadcast that no call could take for the next call that joins.
  void markUnclaimed() => _isUnclaimed = true;

  /// Whether a running broadcast was waiting for a call. Only the first
  /// caller gets true.
  bool claim() {
    final unclaimed = _isUnclaimed && _isActive;
    _isUnclaimed = false;
    return unclaimed;
  }

  @visibleForTesting
  void reset() {
    _requester = null;
    _isActive = false;
    _isUnclaimed = false;
  }
}
