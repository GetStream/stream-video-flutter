import 'package:flutter/widgets.dart';

import 'lobby_controller.dart';

/// Exposes the [StreamLobbyController] to the lobby's action widgets.
///
/// `StreamLobbyActions` hands the view a plain list of widgets, so an action cannot
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
    // Thrown rather than asserted, so the explanation survives a release
    // build: an assert is compiled out there, leaving `controller!` to fail
    // as a bare null-check with nothing to say why.
    if (controller == null) {
      throw FlutterError.fromParts([
        ErrorSummary('No StreamLobbyScope found above this widget.'),
        ErrorDescription(
          'Lobby actions read their state from the controller '
          'StreamLobbyView installs, so they can only be used inside one.',
        ),
        context.describeElement('The widget that asked for it was'),
      ]);
    }

    return controller;
  }
}
