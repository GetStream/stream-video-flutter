import '../call/call.dart';
import '../models/user.dart';
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
  StateEmitter<Call?> get incomingCall;

  /// Emits when a call was created by current user with ringing set as True.
  StateEmitter<Call?> get outgoingCall;

  Future<void> setOutgoingCall(Call? call);
  Future<void> setActiveCall(Call? call);
}

class MutableClientState implements ClientState {
  MutableClientState(User user)
      : user = MutableStateEmitterImpl(user),
        activeCall = MutableStateEmitterImpl(null),
        incomingCall = MutableStateEmitterImpl(null),
        outgoingCall = MutableStateEmitterImpl(null),
        connection = MutableStateEmitterImpl(
          ConnectionState.disconnected(user.id),
        );

  @override
  final MutableStateEmitter<User> user;

  @override
  final MutableStateEmitter<Call?> activeCall;

  @override
  final MutableStateEmitter<Call?> incomingCall;

  @override
  final MutableStateEmitter<Call?> outgoingCall;

  @override
  final MutableStateEmitter<ConnectionState> connection;

  @override
  User get currentUser => user.value;

  Future<void> clear() async {
    activeCall.value = null;
    outgoingCall.value = null;
    connection.value = ConnectionState.disconnected(user.value.id);
  }

  Call? getActiveCall() => activeCall.valueOrNull;
  Call? getOutgoingCall() => outgoingCall.valueOrNull;

  @override
  Future<void> setActiveCall(Call? call) async {
    final currentlyActiveCall = activeCall.valueOrNull;
    if (currentlyActiveCall != null && call != null) {
      await currentlyActiveCall.leave();
    }

    activeCall.value = call;
  }

  @override
  Future<void> setOutgoingCall(Call? call) async {
    outgoingCall.value = call;
  }
}
