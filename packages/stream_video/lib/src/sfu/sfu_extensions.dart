import 'package:collection/collection.dart';

import '../../stream_video.dart';
import 'data/models/sfu_participant.dart';

extension SfuParticipantX on SfuParticipant {
  CallParticipantState toParticipantState(CallState state) {
    final isLocal = userId == state.currentUserId;
    final existing = state.callParticipants.firstWhereOrNull(
      (it) => it.userId == userId,
    );

    final existingName = existing?.name ?? '';
    final existingRoles = existing?.roles ?? [];
    final existingImage = existing?.image ?? '';

    return CallParticipantState(
      userId: userId,
      roles: roles.isNotEmpty ? roles : existingRoles,
      name: userName.ifEmpty(() => existingName),
      custom: custom,
      image: userImage.ifEmpty(() => existingImage),
      sessionId: sessionId,
      trackIdPrefix: trackLookupPrefix,
      publishedTracks: {
        for (final track in publishedTracks)
          track: TrackState.base(isLocal: isLocal),
      },
      isLocal: isLocal,
      isOnline: !isLocal,
      isSpeaking: isSpeaking,
      audioLevel: audioLevel,
      isDominantSpeaker: isDominantSpeaker,
    );
  }
}
