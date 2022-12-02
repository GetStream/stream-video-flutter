import 'package:collection/collection.dart';
import 'package:stream_video/src/core/utils/rx_controller.dart';
import 'package:stream_video/src/models/call_participant.dart';

/// A controller for the list of participants in a call.
class CallParticipantsController<T extends CallParticipant>
    extends RxController<List<T>> {
  /// Creates a new instance of [CallParticipantsController].
  CallParticipantsController() : super(seedValue: const []);

  /// Returns the local participant.
  LocalCallParticipant? get local {
    final participants = [...value];
    return participants.firstWhereOrNull((it) => it.isLocal)
        as LocalCallParticipant?;
  }

  /// Returns all the remote participants in the call.
  List<CallParticipant> get remote {
    final participants = [...value];
    return participants.where((it) => !it.isLocal).toList();
  }

  /// Creates a new stream of the local participant.
  Stream<LocalCallParticipant?> get localStream => stream.map((_) => local);

  /// Creates a new stream of the remote participants.
  Stream<List<CallParticipant>> get remoteStream => stream.map((_) => remote);

  /// Adds a new participant to the list of participants.
  void add(T participant) {
    value = [...value, participant];
  }

  /// Adds a list of participants to the list of participants.
  void addAll(Iterable<T> participants) {
    value = [...value, ...participants];
  }

  /// Removes a participant from the list of participants.
  void remove(T participant) {
    final participants = [...value];
    value = participants.where((it) => it != participant).toList();
  }

  /// Removes a participant from the list of participants by their [id].
  void removeById(String id) {
    final participants = [...value];
    value = participants.where((it) => it.id != id).toList();
  }

  /// Removes a participant from the list of participants by their [sessionId].
  void removeBySessionId(String sessionId) {
    final participants = [...value];
    value = participants.where((it) => it.sessionId != sessionId).toList();
  }

  /// Returns the participant with the given [id].
  T? getById(String id) {
    final participants = [...value];
    return participants.firstWhereOrNull((it) => it.id == id);
  }

  /// Returns the participant with the given [sessionId].
  T? getBySessionId(String sessionId) {
    final participants = [...value];
    return participants.firstWhereOrNull((it) => it.sessionId == sessionId);
  }

  /// Updates a participant in the list of participants.
  void update(T participant) {
    final participants = [...value];
    value = participants.map((it) {
      if (it.id == participant.id) {
        return participant;
      }
      return it;
    }).toList();
  }

  /// Upserts a participant in the list of participants.
  void upsert(T participant) {
    final participants = [...value];
    final index = participants.indexWhere((it) => it.id == participant.id);
    if (index == -1) {
      value = [...participants, participant];
    } else {
      value = [...participants]..[index] = participant;
    }
  }

  /// Clears the list of participants.
  void clear() {
    value = const [];
  }
}
