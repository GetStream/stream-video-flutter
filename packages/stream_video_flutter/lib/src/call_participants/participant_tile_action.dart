import 'package:flutter/widgets.dart';
import 'package:stream_video/stream_video.dart';

/// A single entry in a participant tile's overflow menu.
///
/// The SDK ships no actions of its own: a tile renders exactly what it is
/// given, and hides its overflow button entirely when the list is empty. What
/// an action does is up to the integrator — pinning, muting, blocking and
/// removing all live on [Call], and anything else an app wants to offer works
/// just as well.
///
/// {@tool snippet}
///
/// ```dart
/// StreamParticipantTile(
///   call: call,
///   participant: participant,
///   actionsBuilder: (context, participant) => [
///     StreamParticipantTileAction(
///       icon: context.streamIcons.pin,
///       label: participant.isPinned ? 'Unpin' : 'Pin',
///       onPressed: () => call.setParticipantPinnedLocally(
///         sessionId: participant.sessionId,
///         pinned: !participant.isPinned,
///       ),
///     ),
///     StreamParticipantTileAction(
///       icon: context.streamIcons.userRemove,
///       label: 'Remove',
///       isDestructive: true,
///       onPressed: () => call.removeMembers([participant.userId]),
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamParticipantTileActionsBuilder], for actions that depend on the
///    participant they are shown for.
@immutable
class StreamParticipantTileAction {
  /// Creates a participant tile action.
  const StreamParticipantTileAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.enabled = true,
  });

  /// The icon shown before [label].
  final IconData icon;

  /// The text describing the action.
  final String label;

  /// Called when the action is selected.
  final VoidCallback onPressed;

  /// Whether the action is presented as destructive.
  ///
  /// Destructive actions are colored apart and sorted below the rest.
  final bool isDestructive;

  /// Whether the action can be selected.
  ///
  /// A disabled action is still listed, so the menu does not change shape as
  /// state changes; it just cannot be chosen.
  final bool enabled;

  /// Whether this action presents the same entry as [other].
  ///
  /// [onPressed] is deliberately left out. Actions are usually built inline, so
  /// the callback is a fresh closure on every build and would make no two
  /// actions ever equal — which is the opposite of what callers comparing
  /// action lists want to know, namely whether the menu still offers the same
  /// entries.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreamParticipantTileAction &&
        other.icon == icon &&
        other.label == label &&
        other.isDestructive == isDestructive &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(icon, label, isDestructive, enabled);
}

/// Builds the overflow menu actions for [participant].
///
/// Called during build, so the actions can reflect the participant's current
/// state — pinned or not, muted or not — and the app's own permissions.
typedef StreamParticipantTileActionsBuilder =
    List<StreamParticipantTileAction> Function(
      BuildContext context,
      CallParticipantState participant,
    );
