import 'package:collection/collection.dart';

import '../../stream_video.dart' show DisconnectReason, StreamVideoOptions;
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

  /// Emits a list of active calls.
  StateEmitter<List<Call>> get activeCalls;

  /// Emits an active call.
  /// Will only emit if options.allowMultipleActiveCalls is set to false, use activeCalls otherwise.
  StateEmitter<Call?> get activeCall;

  /// Emits when a call was created by another user with ringing set as True.
  StateEmitter<Call?> get incomingCall;

  /// Emits when a call was created by current user with ringing set as True.
  StateEmitter<Call?> get outgoingCall;

  /// Sets the call as a current outgoing call.
  Future<void> setOutgoingCall(Call? call);

  /// Set the active call. Will end the currently active call if `options.allowMultipleActiveCalls` is `false.
  /// When `allowMultipleActiveCalls` is `true` calling this with `call: null` will have no effect.
  /// Otherwise the call is added to the list of active calls.
  Future<void> setActiveCall(Call? call);

  /// Removes the call from the list of active calls.
  /// It won't `leave` the call, just removes it from the list.
  Future<void> removeActiveCall(Call call);
}

class MutableClientState implements ClientState {
  MutableClientState(User user, this.options)
      : user = MutableStateEmitterImpl(user),
        activeCalls = MutableStateEmitterImpl([]),
        activeCall = MutableStateEmitterImpl(null),
        incomingCall = MutableStateEmitterImpl(null),
        outgoingCall = MutableStateEmitterImpl(null),
        connection = MutableStateEmitterImpl(
          ConnectionState.disconnected(user.id),
        );

  final StreamVideoOptions options;

  @override
  final MutableStateEmitter<User> user;

  @override
  final MutableStateEmitter<List<Call>> activeCalls;

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
    activeCalls.value = [];
    outgoingCall.value = null;
    connection.value = ConnectionState.disconnected(user.value.id);
  }

  Call? getActiveCall() {
    if (options.allowMultipleActiveCalls) {
      throw Exception(
        'Multiple active calls are enabled, use getActiveCalls instead',
      );
    }

    return activeCalls.value.firstOrNull;
  }

  List<Call> getActiveCalls() => activeCalls.value;
  Call? getOutgoingCall() => outgoingCall.valueOrNull;

  @override
  Future<void> setActiveCall(Call? call) async {
    if (!options.allowMultipleActiveCalls) {
      final currentlyActiveCall = activeCalls.value.firstOrNull;
      if (currentlyActiveCall != null) {
        await currentlyActiveCall.leave(reason: DisconnectReason.replaced());
      }

      activeCall.value = call;
      activeCalls.value = call == null ? [] : [call];
    } else if (call != null) {
      activeCalls.value = [...activeCalls.value, call];
    }
  }

  @override
  Future<void> removeActiveCall(Call call) async {
    if (!options.allowMultipleActiveCalls &&
        activeCall.hasValue &&
        activeCall.value?.callCid == call.callCid) {
      activeCall.value = null;
    }

    activeCalls.value = [
      ...activeCalls.value.where((it) => it.callCid != call.callCid),
    ];
  }

  @override
  Future<void> setOutgoingCall(Call? call) async {
    outgoingCall.value = call;
  }
}
