import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// The heading above the lobby's preview: an icon, a title and a line below
/// it.
///
/// The rendering can be replaced app-wide by registering a `lobbyHeader`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory].
/// When no builder is registered, [DefaultStreamLobbyHeader] is used.
///
/// {@tool snippet}
///
/// ```dart
/// StreamComponentFactory(
///   builders: StreamComponentBuilders(
///     extensions: [
///       ...streamVideoComponentBuilders(
///         lobbyHeader: (context, props) => MyBrandedHeader(props: props),
///       ),
///     ],
///   ),
///   child: app,
/// )
/// ```
/// {@end-tool}
class StreamLobbyHeader extends StatelessWidget {
  /// Creates a lobby header.
  StreamLobbyHeader({super.key, Widget? title, Widget? subtitle})
    : props = .new(title: title, subtitle: subtitle);

  /// The properties that configure this header.
  final StreamLobbyHeaderProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.videoComponentBuilder<StreamLobbyHeaderProps>();
    return builder?.call(context, props) ??
        DefaultStreamLobbyHeader(props: props);
  }
}

/// Properties for configuring a [StreamLobbyHeader].
///
/// See also:
///
///  * [StreamLobbyHeader], which uses these properties.
///  * [DefaultStreamLobbyHeader], the default implementation.
@immutable
class StreamLobbyHeaderProps {
  /// Creates properties for a lobby header.
  const StreamLobbyHeaderProps({this.title, this.subtitle});

  /// The heading. Null draws a localized default.
  final Widget? title;

  /// An optional line below the heading. Nothing is drawn when null.
  final Widget? subtitle;

  /// Creates a copy of these properties with the given fields replaced.
  StreamLobbyHeaderProps copyWith({Widget? title, Widget? subtitle}) {
    return StreamLobbyHeaderProps(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

/// The default implementation of [StreamLobbyHeader].
class DefaultStreamLobbyHeader extends StatelessWidget {
  /// Creates the default lobby header.
  const DefaultStreamLobbyHeader({super.key, required this.props});

  /// The properties that configure this header.
  final StreamLobbyHeaderProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final translations = context.translations;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing.sm,
      children: [
        Icon(
          context.streamIcons.language,
          color: colorScheme.accentPrimary,
          size: 32,
        ),
        props.title ??
            Text(translations.lobbyTitle, style: textTheme.headingMd),
        // No default: the design has a single line under the icon, so a
        // subtitle is drawn only where a call site asks for one.
        ?props.subtitle,
      ],
    );
  }
}
