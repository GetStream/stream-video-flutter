import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';

/// Builds the list of component builders for the stream video components.
Iterable<StreamComponentBuilderExtension<Object>> streamVideoComponentBuilders({
  // ── Call participants ────────────────────────────────────────────────────
  StreamComponentBuilder<StreamParticipantTileProps>? participantTile,
  StreamComponentBuilder<StreamParticipantLabelProps>? participantLabel,
  StreamComponentBuilder<StreamConnectionQualityIndicatorProps>?
  connectionQualityIndicator,
}) {
  final builders = [
    if (participantTile != null)
      StreamComponentBuilderExtension(builder: participantTile),
    if (participantLabel != null)
      StreamComponentBuilderExtension(builder: participantLabel),
    if (connectionQualityIndicator != null)
      StreamComponentBuilderExtension(builder: connectionQualityIndicator),
  ];

  return builders;
}

/// Helper extensions for the factory builders.
extension StreamVideoComponentBuildersExtension on BuildContext {
  /// The builder for the given component type.
  StreamComponentBuilder<T>? videoComponentBuilder<T>() =>
      StreamComponentFactory.of(this).extension<T>();
}
