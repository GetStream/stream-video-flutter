import 'package:stream_video/stream_video.dart';

import '../call_participants.dart';

enum ParticipantLayoutMode {
  /// The layout mode is set to grid view.
  grid,

  /// The layout mode is set to spotlight view.
  spotlight,

  pictureInPicture,
}

extension SortingExtension on ParticipantLayoutMode {
  CallParticipantSort<CallParticipantState> get sorting {
    switch (this) {
      case ParticipantLayoutMode.grid:
        return CallParticipantSortingPresets.regular;
      case ParticipantLayoutMode.spotlight:
        return CallParticipantSortingPresets.speaker;
      case ParticipantLayoutMode.pictureInPicture:
        return CallParticipantSortingPresets.speaker;
    }
  }
}
