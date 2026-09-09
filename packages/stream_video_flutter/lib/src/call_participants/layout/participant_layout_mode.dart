// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/core.dart';
import 'package:stream_video/stream_video.dart';

import '../../l10n/localization_extension.dart';
import '../call_participants.dart';
import 'call_participants_spotlight_view.dart';

/// How the participants of a call are arranged on screen.
enum ParticipantLayoutMode {
  /// Follows the call: the speaker fills the frame in a one-on-one call, and
  /// everybody sits in a grid otherwise.
  ///
  /// The local participant floats over the layout rather than taking a tile of
  /// its own, subject to `enableLocalVideo`.
  auto,

  /// Every participant, including the local one, takes an equal tile in a
  /// grid.
  grid,

  /// The speaker fills the frame, with everybody else in a bar above them.
  speakerTop,

  /// The speaker fills the frame, with everybody else in a bar below them.
  speakerBottom,

  /// The speaker fills the frame, with everybody else in a bar to their left.
  speakerLeft,

  /// The speaker fills the frame, with everybody else in a bar to their right.
  speakerRight,

  /// The speaker fills the frame alone, with the local participant floating
  /// over them and nobody else shown.
  speakerOneToOne,

  /// The layout mode is set to spotlight view.
  @Deprecated(
    'Use ParticipantLayoutMode.speakerBottom instead, which is where the '
    'participants bar already sat. Will be removed in the next major version.',
  )
  spotlight,

  /// The layout mode is set to picture-in-picture view.
  @Deprecated(
    'Use ParticipantLayoutMode.speakerOneToOne instead. Will be removed in '
    'the next major version.',
  )
  pictureInPicture,
}

/// The participant sorting each layout asks for.
extension SortingExtension on ParticipantLayoutMode {
  /// The sorting preset that puts the right participant first for this layout.
  CallParticipantSort<CallParticipantState> get sorting {
    switch (this) {
      case ParticipantLayoutMode.auto:
      case ParticipantLayoutMode.grid:
        return CallParticipantSortingPresets.regular;
      case ParticipantLayoutMode.speakerTop:
      case ParticipantLayoutMode.speakerBottom:
      case ParticipantLayoutMode.speakerLeft:
      case ParticipantLayoutMode.speakerRight:
      case ParticipantLayoutMode.speakerOneToOne:
      case ParticipantLayoutMode.spotlight:
      case ParticipantLayoutMode.pictureInPicture:
        return CallParticipantSortingPresets.speaker;
    }
  }
}

/// How a layout presents itself: where its bar sits, what it is called and
/// which icon stands for it.
extension ParticipantLayoutModeX on ParticipantLayoutMode {
  /// The layouts offered by default, newest naming only.
  ///
  /// [ParticipantLayoutMode.values] still carries the deprecated aliases, which
  /// would show up as duplicate rows in a menu built from it.
  static const List<ParticipantLayoutMode> selectable = [
    ParticipantLayoutMode.auto,
    ParticipantLayoutMode.grid,
    ParticipantLayoutMode.speakerTop,
    ParticipantLayoutMode.speakerBottom,
    ParticipantLayoutMode.speakerLeft,
    ParticipantLayoutMode.speakerRight,
    ParticipantLayoutMode.speakerOneToOne,
  ];

  /// The layout this one is an alias for, or itself.
  ///
  /// Lets the rest of the SDK switch over the current names alone while the
  /// deprecated values are still around.
  ParticipantLayoutMode get canonical => switch (this) {
    ParticipantLayoutMode.spotlight => ParticipantLayoutMode.speakerBottom,
    ParticipantLayoutMode.pictureInPicture =>
      ParticipantLayoutMode.speakerOneToOne,
    _ => this,
  };

  /// Where the participants bar sits, or null for a layout that has no bar.
  ParticipantsBarAlignment? get barAlignment {
    switch (this) {
      case ParticipantLayoutMode.speakerTop:
        return ParticipantsBarAlignment.top;
      case ParticipantLayoutMode.speakerBottom:
      case ParticipantLayoutMode.spotlight:
        return ParticipantsBarAlignment.bottom;
      case ParticipantLayoutMode.speakerLeft:
        return ParticipantsBarAlignment.left;
      case ParticipantLayoutMode.speakerRight:
        return ParticipantsBarAlignment.right;
      case ParticipantLayoutMode.auto:
      case ParticipantLayoutMode.grid:
      case ParticipantLayoutMode.speakerOneToOne:
      case ParticipantLayoutMode.pictureInPicture:
        return null;
    }
  }

  /// Whether this layout spotlights a single participant.
  ///
  /// True for every speaker layout, including the one that shows nobody else.
  bool get isSpeakerLayout => switch (canonical) {
    ParticipantLayoutMode.speakerTop ||
    ParticipantLayoutMode.speakerBottom ||
    ParticipantLayoutMode.speakerLeft ||
    ParticipantLayoutMode.speakerRight ||
    ParticipantLayoutMode.speakerOneToOne => true,
    _ => false,
  };

  /// The icon standing for this layout in a menu and on its button.
  IconData icon(BuildContext context) {
    final icons = context.streamIcons;
    switch (canonical) {
      case ParticipantLayoutMode.auto:
        return icons.gridDefaultFill;
      case ParticipantLayoutMode.grid:
        return icons.gridFill;
      case ParticipantLayoutMode.speakerTop:
        return icons.speakerTopFill;
      case ParticipantLayoutMode.speakerBottom:
        return icons.speakerBottomFill;
      case ParticipantLayoutMode.speakerLeft:
        return icons.speakerLeftFill;
      case ParticipantLayoutMode.speakerRight:
        return icons.speakerRightFill;
      case ParticipantLayoutMode.speakerOneToOne:
        return icons.pipFill;
      case ParticipantLayoutMode.spotlight:
      case ParticipantLayoutMode.pictureInPicture:
        throw StateError('canonical never returns a deprecated value');
    }
  }

  /// The name of this layout, in the app's language.
  String label(BuildContext context) {
    final translations = context.translations;
    switch (canonical) {
      case ParticipantLayoutMode.auto:
        return translations.layoutDefault;
      case ParticipantLayoutMode.grid:
        return translations.layoutGrid;
      case ParticipantLayoutMode.speakerTop:
        return translations.layoutSpeakerTop;
      case ParticipantLayoutMode.speakerBottom:
        return translations.layoutSpeakerBottom;
      case ParticipantLayoutMode.speakerLeft:
        return translations.layoutSpeakerLeft;
      case ParticipantLayoutMode.speakerRight:
        return translations.layoutSpeakerRight;
      case ParticipantLayoutMode.speakerOneToOne:
        return translations.layoutSpeakerOneToOne;
      case ParticipantLayoutMode.spotlight:
      case ParticipantLayoutMode.pictureInPicture:
        throw StateError('canonical never returns a deprecated value');
    }
  }
}
