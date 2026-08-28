import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'call_participants_grid_theme.g.theme.dart';

/// Applies a grid theme to descendant `CallParticipantsGridView` widgets.
///
/// See also:
///
///  * [StreamCallParticipantsGridThemeData], which describes the theme.
class StreamCallParticipantsGridTheme extends InheritedTheme {
  /// Creates a participants grid theme.
  const StreamCallParticipantsGridTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The grid theme data for descendant widgets.
  final StreamCallParticipantsGridThemeData data;

  /// Returns the [StreamCallParticipantsGridThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamCallParticipantsGridTheme] ancestor
  /// take precedence over the global values from
  /// [StreamVideoTheme.callParticipantsGridTheme].
  static StreamCallParticipantsGridThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallParticipantsGridTheme>();
    return StreamVideoTheme.of(
      context,
    ).callParticipantsGridTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamCallParticipantsGridTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamCallParticipantsGridTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing how participant tiles are spaced in a grid.
///
/// Unlike the tile's own theme this carries its properties directly rather than
/// through a nested style: they are layout values with no reuse elsewhere.
///
/// See also:
///
///  * [StreamCallParticipantsGridTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamCallParticipantsGridThemeData
    with _$StreamCallParticipantsGridThemeData {
  /// Creates participants grid theme data.
  const StreamCallParticipantsGridThemeData({
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });

  /// The inset around the grid.
  ///
  /// Defaults to `spacing.xs` on every side.
  final EdgeInsetsGeometry? padding;

  /// The gap between tiles along the main axis.
  ///
  /// Defaults to `spacing.xs`.
  final double? mainAxisSpacing;

  /// The gap between tiles along the cross axis.
  ///
  /// Defaults to `spacing.xs`.
  final double? crossAxisSpacing;

  /// Linearly interpolate between two theme data objects.
  static StreamCallParticipantsGridThemeData? lerp(
    StreamCallParticipantsGridThemeData? a,
    StreamCallParticipantsGridThemeData? b,
    double t,
  ) => _$StreamCallParticipantsGridThemeData.lerp(a, b, t);
}
