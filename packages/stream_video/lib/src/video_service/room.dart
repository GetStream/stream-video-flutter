import 'package:livekit_client/livekit_client.dart' hide Participant;
import 'package:stream_video/src/models/aliases.dart';

import 'package:stream_video/protobuf/video_models/models.pb.dart';
import 'package:stream_video/src/video_service/video_connection_status.dart';

class VideoRoom {
  VideoRoom({required Room room}) : _room = room;
  final Room? _room;

  final Map<String, Participant> participants = {};

  factory VideoRoom.create({required Room room}) => VideoRoom(room: room);

  Future<void>? disconnect() => _room?.disconnect();

  void add(Participant participant) => participants[participant.userId];

  Participant? remove(Participant participant) =>
      participants.remove(participant.userId);

  List<MapEntry<String, RemoteParticipant>>? get remoteParticipants =>
      _room?.participants.entries.toList();

  LocalParticipant? get localParticipant => _room?.localParticipant;

  VideoConnectionStatus? get connectionStatus => _room?.connectionState.mapped;
  StreamEventsListener<StreamRoomEvent>? get createListener =>
      _room?.createListener();
}
