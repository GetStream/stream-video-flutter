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
/// modified.
List<CallParticipantState> sortParticipants(
  Iterable<CallParticipantState> participants, {
  required Comparator<CallParticipantState> sort,
}) {
  final result = [...participants];
  if (result.length < 2) return result;

  // What the sort makes of a participant with their tile on screen, which is
  // the same participant unless the sort has something to say about them being
  // off it.
  CallParticipantState asIfOnScreen(CallParticipantState participant) {
    if (participant.viewportVisibility.isVisible) return participant;
    return participant.copyWith(
      viewportVisibility: ViewportVisibility.visible,
    );
  }

  final onScreen = <String, CallParticipantState>{
    for (final participant in result)
      participant.uniqueParticipantKey: asIfOnScreen(participant),
  };

  int sortAsIfOnScreen(CallParticipantState a, CallParticipantState b) {
    return sort(
      onScreen[a.uniqueParticipantKey]!,
      onScreen[b.uniqueParticipantKey]!,
    );
  }

  // The criteria that do not ask about the viewport order everybody. Stable,
  // so participants they have nothing to say about keep the places they came
  // in with.
  mergeSort(result, compare: sortAsIfOnScreen);

  final offScreenPlaces = <int>[];
  final onScreenPlaces = <int>[];
  for (var i = 0; i < result.length; i++) {
    if (result[i].viewportVisibility.isVisible) {
      onScreenPlaces.add(i);
    } else {
      offScreenPlaces.add(i);
    }
  }

  // The rest of the sort orders the off-screen participants among the places
  // they hold between them.
  final offScreen = [for (final place in offScreenPlaces) result[place]];
  mergeSort(offScreen, compare: sort);
  for (var i = 0; i < offScreenPlaces.length; i++) {
    result[offScreenPlaces[i]] = offScreen[i];
  }

  // And earns the best of them a place on screen, taken from the tiles with
  // the least claim to one: the last of them, whatever the criteria above made
  // of the rest.
  final claimants = <CallParticipantState>[];
  final claimantPlaces = <int>[];
  final residents = <CallParticipantState>[];
  final residentPlaces = <int>[];

  var place = onScreenPlaces.length - 1;
  for (final candidate in offScreen) {
    if (place < 0) break;

    final residentPlace = onScreenPlaces[place];
    final resident = result[residentPlace];

    // The candidates are in order, so once one has no claim over the tile with
    // the least of it, neither has anybody behind them.
    if (sort(candidate, resident) >= 0) break;

    // Ahead of the resident for a reason that has nothing to do with the
    // viewport: already placed, by the sort above.
    if (sortAsIfOnScreen(candidate, resident) < 0) continue;

    final candidatePlace = result.indexWhere(
      (it) => it.uniqueParticipantKey == candidate.uniqueParticipantKey,
    );

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
    result[residentPlaces[i]] = claimants[i];
    result[claimantPlaces[i]] = residents[residents.length - 1 - i];
  }

  return result;
}
