import 'package:flutter/widgets.dart';

import 'lobby_controller.dart';

/// Exposes the [StreamLobbyController] to the lobby's action widgets.
///
/// `LobbyActions` hands the view a plain list of widgets, so an action cannot
/// be given callbacks through its constructor. It reads the controller from
/// here instead, and rebuilds when the controller notifies.
class StreamLobbyScope extends InheritedNotifier<StreamLobbyController> {
  /// Creates a new instance of [StreamLobbyScope].
  const StreamLobbyScope({
    super.key,
    required StreamLobbyController controller,
    required super.child,
  }) : super(notifier: controller);

  /// The controller of the closest enclosing lobby, or null when there is
  /// none.
  static StreamLobbyController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StreamLobbyScope>()?.notifier;

  /// The controller of the closest enclosing lobby.
  ///
  /// Throws when called outside a `StreamLobbyView`, which is a programming
  /// error: a lobby action is only meaningful inside one.
  static StreamLobbyController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
      controller != null,
      'No StreamLobbyScope found above this widget. Lobby actions read their '
      'state from the controller StreamLobbyView installs, so they can only '
      'be used inside one.',
    );
    return controller!;
  }
}
