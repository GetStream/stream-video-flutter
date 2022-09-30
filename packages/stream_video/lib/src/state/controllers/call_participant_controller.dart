import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/models/events/events.dart';

class CallParticipantController {
  final _callParticipantController = BehaviorSubject<CallParticipantEvent>();
  Map<String, CallParticipant> _callParticipants = {};

  get count => _callParticipants.keys.length; //TODO:unique

  void _add(CallParticipant participant) =>
      _callParticipants[participant.id] = participant;

  void _new(Map<String, CallParticipant> participants) =>
      _callParticipants = participants;

  CallParticipant? _remove(CallParticipant participant) =>
      _callParticipants.remove(participant.id);

  void _emit(CallParticipantEvent event) =>
      _callParticipantController.add(event);

  void emitJoined(CallParticipant callParticipant) {
    _add(callParticipant);
    _emit(CallParticipantJoined(_callParticipants));
  }

  void emitRemoved(CallParticipant callParticipant) {
    _remove(callParticipant);
    _emit(CallParticipantRemoved(_callParticipants));
  }

  void emitLeft(CallParticipant callParticipant) {
    _remove(callParticipant);
    _emit(CallParticipantLeft(_callParticipants));
  }

  void emitNew(Map<String, CallParticipant> callParticipants) {
    _new(callParticipants);
    _emit(CallParticipantUpdated(_callParticipants));
  }

  void emitUpdated(CallParticipant callParticipant) {
    _add(callParticipant);
    _emit(CallParticipantUpdated(_callParticipants));
  }

  CallParticipantEvent get callParticipantEvent =>
      _callParticipantController.value;

  Stream<CallParticipantEvent> get _callparticipantsStream =>
      _callParticipantController.stream.distinct();

  StreamSubscription<CallParticipantEvent> _listen(
    FutureOr<void> Function(CallParticipantEvent event) onEvent,
  ) =>
      _callparticipantsStream.listen(onEvent);

  StreamSubscription<CallParticipantEvent> on<E extends CallParticipantEvent>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) =>
      _listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _callParticipantController.close();
}
