import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/models/call_participant_pin.dart';
import 'package:stream_video/src/models/call_participant_state.dart';
import 'package:stream_video/src/models/call_track_state.dart';
import 'package:stream_video/src/models/viewport_visibility.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/sorting/call_participant_sorting_presets.dart';
import 'package:stream_video/src/sorting/sort_participants.dart';

// What a participant earns by being off screen costs the screen one tile, not
// a rearrangement: they trade places with the tile that has the least claim to
// one. The criteria that hold whether or not a tile is being watched — a pin,
// a screen share, a layout built around the speaker — still order everybody.

void main() {
  CallParticipantState participant(
    String id, {
    bool dominantSpeaker = false,
    bool speaking = false,
    bool video = true,
    bool audio = true,
    bool screenShare = false,
    DateTime? pinnedAt,
    bool onScreen = true,
  }) {
    return CallParticipantState(
      name: id,
      userId: id,
      sessionId: id,
      custom: const {},
      roles: const [],
      trackIdPrefix: id,
      publishedTracks: {
        if (video) SfuTrackType.video: TrackState.remote(),
        if (audio) SfuTrackType.audio: TrackState.remote(),
        if (screenShare) SfuTrackType.screenShare: TrackState.remote(),
      },
      isDominantSpeaker: dominantSpeaker,
      isSpeaking: speaking,
      pin: pinnedAt == null
          ? null
          : CallParticipantPin(isLocalPin: true, pinnedAt: pinnedAt),
      viewportVisibility: onScreen
          ? ViewportVisibility.visible
          : ViewportVisibility.hidden,
    );
  }

  List<String> sorted(
    List<CallParticipantState> participants, {
    Comparator<CallParticipantState>? sort,
  }) {
    return sortParticipants(
      participants,
      sort: sort ?? CallParticipantSortingPresets.regular,
    ).map((it) => it.userId).toList();
  }

  group('a place on screen', () {
    test('costs the tile with the least claim to one, and only that tile', () {
      // Six tiles on screen, two off it, and one of those starts talking.
      final participants = [
        participant('a'),
        participant('b'),
        participant('c'),
        participant('d'),
        participant('e'),
        participant('f'),
        participant('g', onScreen: false),
        participant(
          'h',
          onScreen: false,
          dominantSpeaker: true,
          speaking: true,
        ),
      ];

      // 'h' takes 'f''s place — the last one on screen — and 'f' takes the
      // place 'h' held. Every other tile is where it was.
      expect(sorted(participants), ['a', 'b', 'c', 'd', 'e', 'h', 'f', 'g']);
    });

    test('is not taken by an off-screen participant who is already ahead', () {
      final participants = [
        participant('a'),
        participant('b'),
        participant(
          'c',
          onScreen: false,
          dominantSpeaker: true,
          speaking: true,
        ),
        participant('d'),
      ];

      expect(sorted(participants), ['a', 'b', 'c', 'd']);
    });

    test('is not taken by an off-screen participant with no claim to one', () {
      final participants = [
        participant('a'),
        participant('b'),
        participant('c'),
        participant('d', onScreen: false),
      ];

      expect(sorted(participants), ['a', 'b', 'c', 'd']);
    });

    test('is not taken from a tile on screen by whoever is speaking on it', () {
      final participants = [
        participant('a'),
        participant('b', dominantSpeaker: true, speaking: true),
        participant('c'),
        participant('d', onScreen: false),
      ];

      expect(sorted(participants), ['a', 'b', 'c', 'd']);
    });

    test('goes to the best claim when several are waiting', () {
      final participants = [
        participant('a'),
        participant('b'),
        participant('c', onScreen: false, video: false, audio: false),
        participant('d', onScreen: false, speaking: true),
        participant('e', onScreen: false, dominantSpeaker: true),
      ];

      // Both tiles on screen change hands, the better claim taking the better
      // of them, and the participant publishing nothing stays last.
      expect(sorted(participants), ['e', 'd', 'a', 'b', 'c']);
    });
  });

  group('off screen', () {
    test('participants are ordered among the places they hold', () {
      final participants = [
        participant('a'),
        participant('b', onScreen: false, video: false, audio: false),
        participant('c', onScreen: false),
        participant('d'),
      ];

      // 'b' and 'c' swap: neither of their places is on screen, and 'c' has
      // more to show. The tiles on screen do not notice.
      expect(sorted(participants), ['a', 'c', 'b', 'd']);
    });
  });

  group('criteria that do not ask about the viewport', () {
    test('a pin reorders the screen', () {
      final participants = [
        participant('a'),
        participant('b'),
        participant('c', pinnedAt: DateTime(2026)),
        participant('d'),
      ];

      expect(sorted(participants), ['c', 'a', 'b', 'd']);
    });

    test('a screen share reorders the screen', () {
      final participants = [
        participant('a'),
        participant('b'),
        participant('c', screenShare: true),
      ];

      expect(sorted(participants), ['c', 'a', 'b']);
    });

    test('the speaker preset spotlights a speaker who is on screen', () {
      final participants = [
        participant('a'),
        participant('b'),
        participant('c', dominantSpeaker: true, speaking: true),
      ];

      expect(
        sorted(participants, sort: CallParticipantSortingPresets.speaker),
        ['c', 'a', 'b'],
      );
    });
  });

  group('settling', () {
    test('a promotion does not start a carousel', () {
      const pageSize = 4;

      var order = [
        participant('a'),
        participant('b'),
        participant('c'),
        participant('d'),
        participant(
          'e',
          onScreen: false,
          dominantSpeaker: true,
          speaking: true,
        ),
        participant('f', onScreen: false),
      ];

      // Each pass sorts, then reports back which tiles the first page holds,
      // the way the viewport would.
      List<String> pass() {
        order = sortParticipants(
          order,
          sort: CallParticipantSortingPresets.regular,
        );
        order = [
          for (var i = 0; i < order.length; i++)
            order[i].copyWith(
              viewportVisibility: i < pageSize
                  ? ViewportVisibility.visible
                  : ViewportVisibility.hidden,
            ),
        ];

        return order.map((it) => it.userId).toList();
      }

      // 'e' takes 'd''s place on the first page, and nobody moves after that:
      // 'd' is off screen but has nothing to claim a place back with, and 'e'
      // is on screen, where what they are doing no longer sorts them.
      expect(pass(), ['a', 'b', 'c', 'e', 'd', 'f']);
      expect(pass(), ['a', 'b', 'c', 'e', 'd', 'f']);
      expect(pass(), ['a', 'b', 'c', 'e', 'd', 'f']);
    });
  });
}
