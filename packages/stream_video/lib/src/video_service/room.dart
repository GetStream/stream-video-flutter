import 'package:collection/collection.dart';
import 'package:livekit_client/livekit_client.dart' hide Participant;
import 'package:stream_video/src/models/aliases.dart';
import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/video_service/room_participant.dart';
import 'package:stream_video/src/video_service/video_connection_status.dart';

class VideoRoom {
  VideoRoom({required Room room}) : _room = room;
  final Room _room;

  final Map<String, CallParticipant> _participants = {};

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

  List<RoomParticipant> get allParticipants => [
        RoomParticipant(localParticipant!),
        ..._room.participants.entries
            .map((e) => RoomParticipant(e.value))
            .toList()
      ];

  StreamLocalParticipant? get localParticipant => _room.localParticipant;

  VideoConnectionStatus get connectionStatus => _room.connectionState.mapped;

  void enableAudio() => localParticipant!.setMicrophoneEnabled(true);

  void enableVideo() => localParticipant!.setCameraEnabled(true);

  void disableAudio() => localParticipant!.setMicrophoneEnabled(false);

  void disableVideo() => localParticipant!.setCameraEnabled(false);
}
