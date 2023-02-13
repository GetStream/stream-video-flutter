import 'package:flutter/material.dart';

/// Contains icons for active and inactive states accordingly.
class StreamIconToggle {
  /// Creates a new instance of [StreamIconToggle].
  const StreamIconToggle({
    required this.active,
    required this.inactive,
  });

  /// Icon for active state.
  final IconData active;

  /// Icon for inactive state.
  final IconData inactive;
}
