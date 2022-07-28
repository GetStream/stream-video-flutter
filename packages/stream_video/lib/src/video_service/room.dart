import 'package:livekit_client/livekit_client.dart' hide Participant;
import 'package:stream_video/src/models/aliases.dart';
import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/video_service/room_participant.dart';
import 'package:stream_video/src/video_service/video_connection_status.dart';

class VideoRoom {
  VideoRoom({required Room room}) : _room = room;
  final Room _room;

  final Map<String, CallParticipant> _participants = {};

  factory VideoRoom.create({required Room room}) => VideoRoom(room: room);

  void muteAudio() {
    localParticipant!.setMicrophoneEnabled(false);
  }

    void unMuteAudio() {
    localParticipant!.setMicrophoneEnabled(true);
  }

  Future<void> disconnect() => _room.disconnect();

  void add(CallParticipant participant) =>
      _participants[participant.id] = participant;

  CallParticipant? remove(CallParticipant participant) =>
      _participants.remove(participant.id);

  List<CallParticipant> get onlineParticipants => _participants.entries
      .map((entry) => entry.value)
      .where((element) => element.isOnline == true)
      .toList();

  List<CallParticipant> get offlineParticipants => _participants.entries
      .map((entry) => entry.value)
      .where((element) => element.isOnline == false)
      .toList();

  Map<String, StreamRemoteParticipant> get _remoteParticipants =>
      Map.fromEntries(_room.participants.entries);
  // _room.participants.entries.toList();

  Map<String, RoomParticipant> get roomParticipants =>
      Map.fromEntries(_remoteParticipants.entries
          .map((e) => MapEntry(e.key, RoomParticipant(e.value))));

  Map<String, RoomParticipant> get allParticipants {
    roomParticipants[localParticipant!.sid] =
        RoomParticipant(localParticipant!);
    return roomParticipants;
  }

  LocalParticipant? get localParticipant => _room.localParticipant;

  VideoConnectionStatus get connectionStatus => _room.connectionState.mapped;
//   StreamEventsListener<StreamRoomEvent> createListener() =>
//       _room.createListener();

//   void addListener(void Function() onChange) => _room.addListener(onChange);

//   void removeListener(void Function() onChange) =>
//       _room.removeListener(onChange);
}
