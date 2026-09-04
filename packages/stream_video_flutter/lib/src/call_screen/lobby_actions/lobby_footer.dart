import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// The slot between the lobby's controls and its join button.
///
/// Draws whatever [StreamLobbyView.footer] was given, and nothing when it was
/// given none. Use it for whatever a call has to be set up with that the lobby
/// knows nothing about — a shared encryption key, a display name, a consent
/// checkbox — and pair it with [StreamLobbyView.joinEnabled] to keep the join
/// button inert until it is settled.
///
/// The rendering can be replaced app-wide by registering a `lobbyFooter`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory],
/// which also puts a footer in a lobby whose call site passed none. When no
/// builder is registered, [DefaultStreamLobbyFooter] is used.
///
/// {@tool snippet}
///
/// ```dart
/// StreamComponentFactory(
///   builders: StreamComponentBuilders(
///     extensions: [
///       ...streamVideoComponentBuilders(
///         lobbyFooter: (context, props) => const MyConsentNotice(),
///       ),
///     ],
///   ),
///   child: app,
/// )
/// ```
/// {@end-tool}
class StreamLobbyFooter extends StatelessWidget {
  /// Creates a lobby footer.
  StreamLobbyFooter({super.key, Widget? child}) : props = .new(child: child);

  /// The properties that configure this footer.
  final StreamLobbyFooterProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.videoComponentBuilder<StreamLobbyFooterProps>();
    return builder?.call(context, props) ??
        DefaultStreamLobbyFooter(props: props);
  }
}

/// Properties for configuring a [StreamLobbyFooter].
///
/// See also:
///
///  * [StreamLobbyFooter], which uses these properties.
///  * [DefaultStreamLobbyFooter], the default implementation.
@immutable
class StreamLobbyFooterProps {
  /// Creates properties for a lobby footer.
  const StreamLobbyFooterProps({this.child});

  /// What the lobby was asked to draw here. Null draws nothing.
  final Widget? child;

  /// Creates a copy of these properties with the given fields replaced.
  StreamLobbyFooterProps copyWith({Widget? child}) {
    return StreamLobbyFooterProps(child: child ?? this.child);
  }
}

/// The default implementation of [StreamLobbyFooter].
class DefaultStreamLobbyFooter extends StatelessWidget {
  /// Creates the default lobby footer.
  const DefaultStreamLobbyFooter({super.key, required this.props});

  /// The properties that configure this footer.
  final StreamLobbyFooterProps props;

  @override
  Widget build(BuildContext context) => props.child ?? const SizedBox.shrink();
}
