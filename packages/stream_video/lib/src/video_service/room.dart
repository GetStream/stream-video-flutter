import 'dart:async';

import 'package:livekit_client/livekit_client.dart' hide Participant;
import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/video_service/video_connection_status.dart';
import 'package:stream_video/src/video_service/webrtc_stats.dart';
import 'package:stream_video/stream_video.dart';

class VideoRoom {
  VideoRoom({
    required Room room,
    required this.callId,
    required this.callType,
    required StreamVideoClient client,
  })  : _room = room,
        _stats = WebRTCStats(room: room, client: client);
  final Room _room;

  final String callId;
  final StreamCallType callType;

  final WebRTCStats _stats;

  // Stream<StatsEvent> get statsStream => _stats.statsStream;

  // StreamSubscription<StatsEvent> onStatEvent(Function(StatsEvent) handle) {
  //   return on<StatsEvent>((event) => handle(event));
  // }

  void registerPeer() {
    final subscriberPeerConnection = _room.engine.subscriber?.pc;
    final publisherPeerConnection = _room.engine.publisher?.pc;
    if (subscriberPeerConnection != null && publisherPeerConnection != null) {
      _stats.addConnections(
        publisherPc: publisherPeerConnection,
        subscriberPc: subscriberPeerConnection,
        callId: callId,
        callType: callType,
      );
    }

    //TODO: fix two timers bug

    // final publisherPeerConnection = _room.engine.publisher?.pc;
    // if (publisherPeerConnection != null) {
    //   _stats.addConnection(
    //     pc: publisherPeerConnection,
    //     peerId: 'publisher',
    //   );
    // }
  }

  // StreamSubscription<StatsEvent> listen(
  //         FutureOr<void> Function(StatsEvent event) onEvent) =>
  //     statsStream.listen(onEvent);

  // StreamSubscription<StatsEvent> on<E extends StatsEvent>(
  //         FutureOr<void> Function(E) then,
  //         {bool Function(E)? filter}) =>
  //     listen((event) async {
  //       // event must be E
  //       if (event is! E) return;
  //       // filter must be true (if filter is used)
  //       if (filter != null && !filter(event)) return;
  //       // cast to E
  //       await then(event);
  //     });

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
