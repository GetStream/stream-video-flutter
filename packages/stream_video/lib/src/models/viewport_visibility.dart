/// The visibility of a widget in the viewport.
enum ViewportVisibility {
  /// Unknown, not yet determined.
  unknown,

  /// Visible in the viewport.
  visible,

  /// Hidden from the viewport.
  hidden;

  /// Returns the [ViewportVisibility] for the given [visibleFraction].
  static ViewportVisibility fromVisibleFraction(double visibleFraction) {
    // We mark the visibility as visible if the visible fraction is greater
    // than 0.3 i;e. 30% of the widget is visible.
    if (visibleFraction > 0.3) return ViewportVisibility.visible;
    return ViewportVisibility.hidden;
  }

  bool get isUnknown => this == ViewportVisibility.unknown;

  bool get isVisible => this == ViewportVisibility.visible;

  bool get isHidden => this == ViewportVisibility.hidden;
}
