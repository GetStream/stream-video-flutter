import 'package:flutter/foundation.dart';

import '../../stream_video_flutter.dart';

/// Default style values for [StreamCallButtonBadge].
///
/// The badge sits on a call control, which is itself often over video, so the
/// design system gives it the warning severity rather than the shared error
/// one: red on a red control disappears, and the error badge's dark border
/// loses its edge over moving footage in either mode.
///
/// Deliberately not exported.
@internal
class StreamCallButtonBadgeStyleDefaults extends StreamCallButtonBadgeStyle {
  /// Creates the badge's defaults.
  const StreamCallButtonBadgeStyleDefaults();

  @override
  StreamErrorBadgeStyle get badgeStyle => StreamErrorBadgeStyle.warning;

  @override
  StreamErrorBadgeSize get size => StreamErrorBadgeSize.sm;

  @override
  bool get showBorder => false;

  @override
  double get alignmentOffset => 4;
}
