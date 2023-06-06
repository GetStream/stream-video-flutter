import 'dart:developer';

import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:uuid/uuid.dart';

class AudioRepository {
  AudioRepository(this._streamVideo);

  final StreamVideo _streamVideo;
  Call? room;

  Future<CallMetadata> createAudioRoom({
    required String title,
    required String description,
  }) async {
    room = _streamVideo.makeCall(
      type: "audio_room",
      id: const Uuid().v4(),
    );
    await room!.getOrCreateCall();
    await room!.update(
      custom: {
        'name': title,
        'description': description,
        "flutterAudioRoomCall": true,
      },
    );
    final result = await room!.goLive();
    if (result.isSuccess) {
      return result.getDataOrNull()!;
    } else {
      final error = result.getErrorOrNull();
      log('[createAudioRoom] failed with error $error');
      throw Exception('Unable to create room');
    }
  }

  Future<List<QueriedCall>> queryCalls() async {
    final result = await _streamVideo.queryCalls(
      filterConditions: {
        "custom.flutterAudioRoomCall": true,
      },
    );

    if (result.isSuccess) {
      return result.getDataOrNull()?.calls ?? [];
    } else {
      final error = result.getErrorOrNull();
      log('[queryCalls] failed with error $error');
      throw Exception('No rooms found');
    }
  }

  Future<void> requestSpeakingPermission() async {
    if (room != null) {
      await room!.requestPermissions([CallPermission.sendAudio]);
    } else {
      throw Exception('There are no active rooms');
    }
  }
}
