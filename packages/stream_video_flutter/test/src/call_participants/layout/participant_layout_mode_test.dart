// The deprecated aliases are part of what these pin.
// ignore_for_file: deprecated_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  group('canonical', () {
    test('maps the deprecated aliases onto their replacement', () {
      expect(
        ParticipantLayoutMode.spotlight.canonical,
        ParticipantLayoutMode.speakerTop,
      );
      expect(
        ParticipantLayoutMode.pictureInPicture.canonical,
        ParticipantLayoutMode.speakerOneToOne,
      );
    });

    test('leaves every selectable layout alone', () {
      for (final mode in ParticipantLayoutModeX.selectable) {
        expect(mode.canonical, mode, reason: '$mode');
      }
    });
  });

  group('selectable', () {
    test('is every layout except the deprecated aliases', () {
      expect(
        ParticipantLayoutModeX.selectable,
        ParticipantLayoutMode.values
            .where((mode) => mode.canonical == mode)
            .toList(),
      );
    });
  });

  group('barAlignment', () {
    // The bar takes the edge opposite the speaker, so the name of the layout
    // is where the *speaker* sits — which is what the menu's icons draw.
    test('puts the bar opposite the speaker', () {
      expect(
        ParticipantLayoutMode.speakerTop.barAlignment,
        ParticipantsBarAlignment.bottom,
      );
      expect(
        ParticipantLayoutMode.speakerBottom.barAlignment,
        ParticipantsBarAlignment.top,
      );
      expect(
        ParticipantLayoutMode.speakerLeft.barAlignment,
        ParticipantsBarAlignment.right,
      );
      expect(
        ParticipantLayoutMode.speakerRight.barAlignment,
        ParticipantsBarAlignment.left,
      );
    });

    test('is null for the layouts with no bar', () {
      for (final mode in [
        ParticipantLayoutMode.auto,
        ParticipantLayoutMode.grid,
        ParticipantLayoutMode.speakerOneToOne,
        ParticipantLayoutMode.pictureInPicture,
      ]) {
        expect(mode.barAlignment, isNull, reason: '$mode');
      }
    });

    test('agrees with the layout each alias stands for', () {
      for (final mode in [
        ParticipantLayoutMode.spotlight,
        ParticipantLayoutMode.pictureInPicture,
      ]) {
        expect(mode.barAlignment, mode.canonical.barAlignment, reason: '$mode');
      }
    });
  });

  group('isSpeakerLayout', () {
    test('is true for the five speaker layouts and both aliases', () {
      for (final mode in [
        ParticipantLayoutMode.speakerTop,
        ParticipantLayoutMode.speakerBottom,
        ParticipantLayoutMode.speakerLeft,
        ParticipantLayoutMode.speakerRight,
        ParticipantLayoutMode.speakerOneToOne,
        ParticipantLayoutMode.spotlight,
        ParticipantLayoutMode.pictureInPicture,
      ]) {
        expect(mode.isSpeakerLayout, isTrue, reason: '$mode');
      }
    });

    test('is false for auto and grid', () {
      expect(ParticipantLayoutMode.auto.isSpeakerLayout, isFalse);
      expect(ParticipantLayoutMode.grid.isSpeakerLayout, isFalse);
    });
  });

  group('sorting', () {
    test('sorts by speaker for every layout that spotlights one', () {
      for (final mode in ParticipantLayoutMode.values.where(
        (mode) => mode.isSpeakerLayout,
      )) {
        expect(
          mode.sorting,
          CallParticipantSortingPresets.speaker,
          reason: '$mode',
        );
      }
    });

    test('sorts regularly for auto and grid', () {
      for (final mode in [
        ParticipantLayoutMode.auto,
        ParticipantLayoutMode.grid,
      ]) {
        expect(
          mode.sorting,
          CallParticipantSortingPresets.regular,
          reason: '$mode',
        );
      }
    });
  });
}
