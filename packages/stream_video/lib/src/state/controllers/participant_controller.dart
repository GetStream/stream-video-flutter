import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video_events/events.pb.dart';
import 'package:stream_video/src/models/events/events.dart';
import 'package:stream_video/src/video_service/room.dart';
import 'package:stream_video/src/video_service/webrtc_stats.dart';

class ParticipantController {
  StreamSubscription<ParticipantEvent> onParticipantJoined(
      Function(ParticipantJoinEvent) handle) {
    return on<ParticipantJoinEvent>((event) => handle(event));
  }

  late final StreamSubscription<StatsEvent>? listener;

  final _participantInvitedController = BehaviorSubject<ParticipantEvent>();
  VideoRoom? _room;
  set currentRoom(
    VideoRoom room,
  ) {
    // listener?.cancel();
    _room = room;
    _room!.registerPeer();
  }



  VideoRoom get currentRoom => _room!;

  void emit(ParticipantEvent event) => _participantInvitedController.add(event);

  emitJoined(ParticipantJoined payload) => emit(ParticipantJoinEvent(payload));


  emitInvited(ParticipantInvited payload) =>
      emit(ParticipantInvitedEvent(payload));

  emitUpdated(ParticipantUpdated payload) =>
      emit(ParticipantUpdatedEvent(payload));

  emitDeleted(ParticipantDeleted payload) =>
      emit(ParticipantDeletedEvent(payload));

  emitLeft(ParticipantLeft payload) => emit(ParticipantLeftEvent(payload));

  ParticipantEvent get participantEvent => _participantInvitedController.value;

  Stream<StatsEvent> get statsStream => _room!.statsStream;

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

  Future<void> dispose() async => Future.wait([
        _participantInvitedController.close(),
      ]);
}
