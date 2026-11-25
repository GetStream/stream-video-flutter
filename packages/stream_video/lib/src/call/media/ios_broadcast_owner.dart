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

  void onStopped() {
    _requester = null;
  }

  @visibleForTesting
  void reset() {
    _requester = null;
  }
}
