import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

final random = Random();

Iterable<CallParticipantState> generateParticipants(
  int count, {
  bool screenShare = false,
}) sync* {
  if (count > participants.length) {
    throw ArgumentError.value(
      count,
      'count',
      'Cannot generate more than ${participants.length} participants',
    );
  }

  var dominantSpeakerSessionId = '';

  Iterable<CallParticipantState> generate(int count) sync* {
    // Ensure at least one local participant is generated.
    final localIndex = random.nextInt(count);

    int? screenShareIndex;
    // Ensure at least one participant is sharing their screen and it's
    // not the local participant.
    //
    // P.S: We do not support screen sharing for local participants.
    if (screenShare) {
      do {
        screenShareIndex = random.nextInt(count);
      } while (screenShareIndex == localIndex);
    }

    var hasPinnedParticipant = false;
    var maxAudioLevel = 0.0;

    final participantList = participants.entries;
    for (var i = 0; i < count; i++) {
      final participant = participantList.elementAt(i);

      final name = participant.key;
      final image = participant.value;
      final userId = '${i + 1}';
      final sessionId = '${i + 1}';
      final role = i == 0 ? 'admin' : 'participant';
      final trackIdPrefix = 'track_${i + 1}';
      final connectionQuality = SfuConnectionQuality
          .values[random.nextInt(SfuConnectionQuality.values.length)];

      final isSpeaking = random.nextDouble() < 0.3;

      var audioLevel = 0.0;
      if (isSpeaking) {
        audioLevel = random.nextDouble();
        if (audioLevel > maxAudioLevel) {
          maxAudioLevel = audioLevel;
          dominantSpeakerSessionId = sessionId;
        }
      }

      const viewportVisibility = ViewportVisibility.visible(
        size: Size(100, 100),
      );

      var isPinned = false;
      if (!hasPinnedParticipant && random.nextDouble() < 0.1) {
        isPinned = true;
        hasPinnedParticipant = true;
      }

      final isLocal = i == localIndex;

      final publishedTracks = <SfuTrackType, TrackState>{};
      if (isSpeaking) {
        final trackState = TrackState.base(isLocal: isLocal);
        publishedTracks[SfuTrackType.audio] = trackState;
      }

      if (i == screenShareIndex) {
        final trackState = TrackState.base(isLocal: isLocal);
        publishedTracks[SfuTrackType.screenShare] = trackState;
      }

      yield CallParticipantState(
        name: name,
        image: image,
        userId: userId,
        sessionId: sessionId,
        role: role,
        trackIdPrefix: trackIdPrefix,
        publishedTracks: publishedTracks,
        connectionQuality: connectionQuality,
        isSpeaking: isSpeaking,
        audioLevel: audioLevel,
        viewportVisibility: viewportVisibility,
        isPinned: isPinned,
        isLocal: isLocal,
      );
    }
  }

  yield* generate(count).map(
    (participant) {
      if (participant.sessionId == dominantSpeakerSessionId) {
        return participant.copyWith(isDominantSpeaker: true);
      }

      return participant;
    },
  );
}

/// List of 49 random participants with profile pic.
const participants = {
  'Niamh Ortiz': 'https://randomuser.me/api/portraits/women/28.jpg',
  'Ola Alvarado': 'https://randomuser.me/api/portraits/women/31.jpg',
  'Quinn Cervantes': 'https://randomuser.me/api/portraits/men/10.jpg',
  'Viola Rivas': 'https://randomuser.me/api/portraits/women/72.jpg',
  'Lucas Murillo': 'https://randomuser.me/api/portraits/men/82.jpg',
  'Thando Howell': 'https://randomuser.me/api/portraits/women/89.jpg',
  'Zara Blevins': 'https://randomuser.me/api/portraits/women/66.jpg',
  'Charlie Erickson': 'https://randomuser.me/api/portraits/men/21.jpg',
  'Addison Morris': 'https://randomuser.me/api/portraits/women/14.jpg',
  'Blaise Sloan': 'https://randomuser.me/api/portraits/men/59.jpg',
  'Iris Cole': 'https://randomuser.me/api/portraits/women/3.jpg',
  'Lila Serrano': 'https://randomuser.me/api/portraits/women/50.jpg',
  'Kavya Singh': 'https://randomuser.me/api/portraits/women/84.jpg',
  'Yosra Coffey': 'https://randomuser.me/api/portraits/women/78.jpg',
  'Cillian Vargas': 'https://randomuser.me/api/portraits/men/72.jpg',
  'Maeve Houston': 'https://randomuser.me/api/portraits/women/67.jpg',
  'Maya Bass': 'https://randomuser.me/api/portraits/women/60.jpg',
  'Everly Fleming': 'https://randomuser.me/api/portraits/women/37.jpg',
  'Ngoc Petty': 'https://randomuser.me/api/portraits/women/11.jpg',
  'Gia Cantrell': 'https://randomuser.me/api/portraits/women/54.jpg',
  'Harper Owen': 'https://randomuser.me/api/portraits/women/30.jpg',
  'Sasha Miranda': 'https://randomuser.me/api/portraits/women/91.jpg',
  'Asher Kumar': 'https://randomuser.me/api/portraits/men/85.jpg',
  'Tahlia Edwards': 'https://randomuser.me/api/portraits/women/42.jpg',
  'Vihaan Khan': 'https://randomuser.me/api/portraits/men/49.jpg',
  'Camila Conrad': 'https://randomuser.me/api/portraits/women/35.jpg',
  'Maksim Cabrera': 'https://randomuser.me/api/portraits/men/33.jpg',
  'Greyson Santana': 'https://randomuser.me/api/portraits/men/9.jpg',
  'Phoenix Burgess': 'https://randomuser.me/api/portraits/women/63.jpg',
  'Thalia Hensley': 'https://randomuser.me/api/portraits/women/20.jpg',
  'Rohit Patel': 'https://randomuser.me/api/portraits/men/70.jpg',
  'Anika Mcbride': 'https://randomuser.me/api/portraits/women/22.jpg',
  'Poppy Davis': 'https://randomuser.me/api/portraits/women/90.jpg',
  'Leo Ho': 'https://randomuser.me/api/portraits/men/54.jpg',
  'Juniper Dillon': 'https://randomuser.me/api/portraits/women/6.jpg',
  'Odette Hess': 'https://randomuser.me/api/portraits/women/16.jpg',
  'Kai Collins': 'https://randomuser.me/api/portraits/men/61.jpg',
  'Fionn Collier': 'https://randomuser.me/api/portraits/men/80.jpg',
  'Aiden Wu': 'https://randomuser.me/api/portraits/men/76.jpg',
  'Elise Jimenez': 'https://randomuser.me/api/portraits/women/51.jpg',
  'Yelena Howe': 'https://randomuser.me/api/portraits/women/33.jpg',
  'Noelle Bartlett': 'https://randomuser.me/api/portraits/women/90.jpg',
  'Landon Acevedo': 'https://randomuser.me/api/portraits/men/17.jpg',
  'Declan Valenzuela': 'https://randomuser.me/api/portraits/men/36.jpg',
  'Nolan Suarez': 'https://randomuser.me/api/portraits/men/49.jpg',
  'Harper Crawford': 'https://randomuser.me/api/portraits/women/40.jpg',
  'Ophelia Baldwin': 'https://randomuser.me/api/portraits/women/85.jpg',
  'Alexis Wu': 'https://randomuser.me/api/portraits/women/12.jpg',
  'Jasper Medina': 'https://randomuser.me/api/portraits/men/69.jpg',
};
