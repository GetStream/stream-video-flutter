import 'package:collection/collection.dart';

import '../models/call_participant_state.dart';
import '../models/viewport_visibility.dart';
import 'call_participant_state_sorting.dart';

/// Sorts [participants] with [sort], at the cost of as few tiles on screen as
/// the sort allows.
///
/// [sort] is asked two things, and they are applied differently:
///
///  * What it makes of participants with their tiles on screen — a pin, a
///    screen share, a layout that spotlights whoever is speaking. Those hold
///    whether or not a tile is being watched, so they order everybody.
///  * What it makes of a participant being off screen, which is what
///    [ifInvisibleBy] scores. That earns them a place on the screen, and the
///    place comes from the one tile with the least claim to it: the two trade
///    places, and every other tile stays exactly where it was. Pushing in
///    front of the screen instead would move every tile below down one, which
///    is a whole grid rearranging itself because somebody nobody can see
///    started talking.
///
/// Off-screen participants are ordered among the places they already hold, so
/// the pages behind the first one are in the order the sort wants without any
/// of that reaching the tiles in front of them.
///
/// [participants] is expected in the order it is currently displayed in —
/// which is what "stays where it was" is measured against — and is not
/// modified. Being handed the order it produced last time is also what keeps
/// this cheap enough to run on every update: the sorts are stable and the list
/// is already almost right, so they walk it rather than rebuild it.
List<CallParticipantState> sortParticipants(
  Iterable<CallParticipantState> participants, {
  required Comparator<CallParticipantState> sort,
}) {
  final result = [...participants];
  if (result.length < 2) return result;

  // With every tile on screen there is nothing to place — the sort has nothing
  // to say about anybody being off it — and nothing to say it with. Which is
  // the ordinary case, so it pays for none of the bookkeeping below.
  if (result.every((it) => it.viewportVisibility.isVisible)) {
    mergeSort(result, compare: sort);
    return result;
  }

  final placed = [for (final participant in result) _Placed(participant)];

  // The criteria that do not ask about the viewport order everybody. Stable,
  // so participants they have nothing to say about keep the places they came
  // in with.
  mergeSort(placed, compare: (a, b) => sort(a.onScreen, b.onScreen));

  final offScreen = <_Placed>[];
  final offScreenPlaces = <int>[];
  final onScreenPlaces = <int>[];
  for (var i = 0; i < placed.length; i++) {
    if (placed[i].isOnScreen) {
      onScreenPlaces.add(i);
    } else {
      offScreen.add(placed[i]);
      offScreenPlaces.add(i);
    }
  }

  // The rest of the sort orders the off-screen participants among the places
  // they hold between them.
  mergeSort(offScreen, compare: (a, b) => sort(a.participant, b.participant));
  for (var i = 0; i < offScreenPlaces.length; i++) {
    placed[offScreenPlaces[i]] = offScreen[i];
  }

  // And earns the best of them a place on screen, taken from the tiles with
  // the least claim to one: the last of them, whatever the criteria above made
  // of the rest.
  final claimants = <_Placed>[];
  final claimantPlaces = <int>[];
  final residents = <_Placed>[];
  final residentPlaces = <int>[];

  var place = onScreenPlaces.length - 1;
  for (var i = 0; i < offScreen.length; i++) {
    if (place < 0) break;

    final candidate = offScreen[i];
    // Where the ordering above left them, and where they stay unless they
    // trade places with a resident: a trade only ever moves a candidate ahead
    // of this one, never this one.
    final candidatePlace = offScreenPlaces[i];

    final residentPlace = onScreenPlaces[place];
    final resident = placed[residentPlace];

    // The candidates are in order, so once one has no claim over the tile with
    // the least of it, neither has anybody behind them.
    if (sort(candidate.participant, resident.participant) >= 0) break;

    // Ahead of the resident for a reason that has nothing to do with the
    // viewport: already placed, by the sort above.
    if (sort(candidate.onScreen, resident.onScreen) < 0) continue;

    // Already holding a better place than the one on offer.
    if (candidatePlace < residentPlace) continue;

    claimants.add(candidate);
    claimantPlaces.add(candidatePlace);
    residents.add(resident);
    residentPlaces.add(residentPlace);
    place--;
  }

  // Collected from the least claim upwards; handing the places over the other
  // way round, so that the best claim gets the best of them and the tiles
  // giving them up keep their order in what is left behind.
  claimantPlaces.sort();
  residentPlaces.sort();
  for (var i = 0; i < claimants.length; i++) {
    placed[residentPlaces[i]] = claimants[i];
    placed[claimantPlaces[i]] = residents[residents.length - 1 - i];
  }

  for (var i = 0; i < placed.length; i++) {
    result[i] = placed[i].participant;
  }

  return result;
}

/// A participant and the same participant as a sort sees them with their tile
/// on screen, so that both readings are one field access away rather than a
/// copy per comparison.
class _Placed {
  _Placed(this.participant)
    : onScreen = participant.viewportVisibility.isVisible
          ? participant
          : participant.copyWith(
              viewportVisibility: ViewportVisibility.visible,
            );

  final CallParticipantState participant;

  /// [participant] themselves when their tile is on screen, which is how
  /// [isOnScreen] can be told from it.
  final CallParticipantState onScreen;

  bool get isOnScreen => identical(participant, onScreen);
}
