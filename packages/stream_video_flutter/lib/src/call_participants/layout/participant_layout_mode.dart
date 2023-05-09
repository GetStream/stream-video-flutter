import 'package:stream_video/stream_video.dart';

enum ParticipantLayoutMode {
  /// The layout mode is set to grid view.
  grid,

  /// The layout mode is set to spotlight view.
  spotlight;
}

extension SortingExtension on ParticipantLayoutMode {
  Comparator<CallParticipantState> get sorting {
    switch (this) {
      case ParticipantLayoutMode.grid:
        return CallParticipantSortingPresets.regular;
      case ParticipantLayoutMode.spotlight:
        return CallParticipantSortingPresets.speaker;
    }
  }
}
