import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_events/events.pbserver.dart';
import 'package:stream_video/src/models/events/events.dart';
import 'package:stream_video/src/video_service/room.dart';

class ParticipantController {
  final _participantInvitedController = BehaviorSubject<ParticipantEvent>();
  VideoRoom? _room;
  set currentRoom(
    VideoRoom room,
  ) {
    _room = room;
    _room!.registerPeer();
  }

  VideoRoom get currentRoom => _room!;

  void _emit(ParticipantEvent event) =>
      _participantInvitedController.add(event);

  emitJoined(ParticipantJoined payload) => _emit(ParticipantJoinEvent(payload));

  emitLeft(ParticipantLeft payload) => _emit(ParticipantLeftEvent(payload));

  Stream<ParticipantEvent> get participantEventStream =>
      _participantInvitedController.stream.distinct();

  StreamSubscription<ParticipantEvent> _listen(
    FutureOr<void> Function(ParticipantEvent event) onEvent,
  ) =>
      participantEventStream.listen(onEvent);

  StreamSubscription<ParticipantEvent> on<E extends ParticipantEvent>(
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

  Future<void> dispose() async => Future.wait([
        _participantInvitedController.close(),
      ]);
}
