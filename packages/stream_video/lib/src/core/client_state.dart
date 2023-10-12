import '../call/call.dart';
import '../models/call_cid.dart';
import '../models/user.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import 'connection_state.dart';

abstract class ClientState {
  /// Returns the current user.
  User get currentUser;

  /// Usually it never emits and just holds the user passed to StreamVideo.
  ///
  /// The only exception is the case when the user logs in as a guest.
  /// Guest user is created by the server and returned in the response.
  StateEmitter<User> get user;

  /// Emits StreamVideo connection changes.
  StateEmitter<ConnectionState> get connection;

  /// Sets when a call being joined.
  StateEmitter<Call?> get activeCall;

  /// Emits when a call was created by another user with ringing set as True.
  SharedEmitter<Call> get incomingCall;
}

class MutableClientState implements ClientState {
  MutableClientState(User user)
      : user = MutableStateEmitterImpl(user),
        activeCall = MutableStateEmitterImpl(null),
        incomingCall = MutableSharedEmitterImpl(),
        connection = MutableStateEmitterImpl(
          ConnectionState.disconnected(user.id),
        );

  @override
  final MutableStateEmitter<User> user;

  @override
  final MutableStateEmitter<Call?> activeCall;

  @override
  final MutableSharedEmitter<Call> incomingCall;

  @override
  final MutableStateEmitter<ConnectionState> connection;

  @override
  User get currentUser => user.value;

  Future<void> clear() async {
    activeCall.value = null;
    connection.value = ConnectionState.disconnected(user.value.id);
  }

  StreamCallCid? getActiveCallCid() => activeCall.valueOrNull?.callCid;

  Future<void> setActiveCall(Call? call) async {
    final ongoingCall = activeCall.valueOrNull;
    if (ongoingCall != null && call != null) {
      await ongoingCall.leave();
    }
    activeCall.value = call;
  }
}
