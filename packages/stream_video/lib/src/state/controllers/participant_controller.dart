import 'dart:async';

import 'package:protobuf/protobuf.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/models/events/events.dart';
import 'package:stream_video/src/video_service/room.dart';

import '../../../protobuf/video_events/events.pb.dart';

class ParticipantController {
  final _participantInvitedController = BehaviorSubject<ParticipantEvent>();
  VideoRoom? _room;
  set room(VideoRoom room) => _room = room;

  VideoRoom get room => _room!;

  void emit(ParticipantEvent event) => _participantInvitedController.add(event);

  emitJoined(ParticipantJoined payload) => emit(ParticipantJoinEvent(payload));

  //onJoined()=> room.addParticipant()

  emitInvited(ParticipantInvited payload) =>
      emit(ParticipantInvitedEvent(payload));

  emitUpdated(ParticipantUpdated payload) =>
      emit(ParticipantUpdatedEvent(payload));

  emitDeleted(ParticipantDeleted payload) =>
      emit(ParticipantDeletedEvent(payload));

  emitLeft(ParticipantLeft payload) => emit(ParticipantLeftEvent(payload));

  ParticipantEvent get participantEvent => _participantInvitedController.value;

  Stream<ParticipantEvent> get participantEventStream =>
      _participantInvitedController.stream.distinct();

  StreamSubscription<ParticipantEvent> listen(
          FutureOr<void> Function(ParticipantEvent event) onEvent) =>
      participantEventStream.listen(onEvent);

  StreamSubscription<ParticipantEvent> on<E extends ParticipantEvent>(
          FutureOr<void> Function(E) then,
          {bool Function(E)? filter}) =>
      listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _participantInvitedController.close();
}
