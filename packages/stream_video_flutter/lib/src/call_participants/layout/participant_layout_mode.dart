// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/core.dart';
import 'package:stream_video/stream_video.dart';

import '../../l10n/localization_extension.dart';
import '../call_participants.dart';
import 'call_participants_spotlight_view.dart';

/// How the participants of a call are arranged on screen.
enum ParticipantLayoutMode {
  /// Follows the call: the speaker takes the frame in a one-on-one call, and
  /// everybody sits in a grid otherwise.
  ///
  /// In a one-on-one call the local participant floats over the speaker. In a
  /// group call they float on mobile and take a grid tile on desktop.
  /// `enableFloatingSelfView` overrides either default.
  auto,

  /// Every participant, including the local one, takes a tile in a grid.
  grid,

  /// The speaker takes the top of the frame, with everybody else in a bar
  /// below them.
  speakerTop,

  /// The speaker takes the bottom of the frame, with everybody else in a bar
  /// above them.
  speakerBottom,

  /// The speaker takes the left of the frame, with everybody else in a bar to
  /// their right.
  speakerLeft,

  /// The speaker takes the right of the frame, with everybody else in a bar to
  /// their left.
  speakerRight,

  /// The speaker takes the whole frame, with the local participant floating
  /// over them and nobody else shown.
  ///
  /// The self-view floats on every platform unless `enableFloatingSelfView`
  /// is false.
  speakerOneToOne,

  /// Alias for [ParticipantLayoutMode.speakerTop].
  @Deprecated(
    'Use ParticipantLayoutMode.speakerTop instead. Will be removed in the '
    'next major version.',
  )
  spotlight,

  /// Alias for [ParticipantLayoutMode.speakerOneToOne].
  @Deprecated(
    'Use ParticipantLayoutMode.speakerOneToOne instead, which spotlights the '
    'speaker alone rather than drawing a grid. Will be removed in the next '
    'major version.',
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
  /// Every layout the SDK renders, in menu order, without the deprecated
  /// aliases.
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
  /// Lets the rest of the SDK switch over the current names alone.
  ParticipantLayoutMode get canonical => switch (this) {
    ParticipantLayoutMode.spotlight => ParticipantLayoutMode.speakerTop,
    ParticipantLayoutMode.pictureInPicture =>
      ParticipantLayoutMode.speakerOneToOne,
    _ => this,
  };

  /// Where the participants bar sits, or null for a layout that has no bar.
  ///
  /// The bar takes the edge opposite the speaker, so
  /// [ParticipantLayoutMode.speakerTop] puts it along the bottom.
  ParticipantsBarAlignment? get barAlignment {
    switch (this) {
      case ParticipantLayoutMode.speakerTop:
      case ParticipantLayoutMode.spotlight:
        return ParticipantsBarAlignment.bottom;
      case ParticipantLayoutMode.speakerBottom:
        return ParticipantsBarAlignment.top;
      case ParticipantLayoutMode.speakerLeft:
        return ParticipantsBarAlignment.right;
      case ParticipantLayoutMode.speakerRight:
        return ParticipantsBarAlignment.left;
      case ParticipantLayoutMode.auto:
      case ParticipantLayoutMode.grid:
      case ParticipantLayoutMode.speakerOneToOne:
      case ParticipantLayoutMode.pictureInPicture:
        return null;
    }
  }

  /// Whether this layout always spotlights a single participant.
  ///
  /// False for [ParticipantLayoutMode.auto], which decides per call.
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
